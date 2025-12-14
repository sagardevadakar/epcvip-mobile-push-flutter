import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ui/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Background Handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Background Msg: ${message.data}");
}

/// Debug Overlay Log Storage
class DebugLogger {
  static final List<String> logs = [];

  static void add(String msg) {
    final timestamp = DateTime.now().toIso8601String();
    logs.add("[$timestamp] $msg");
    debugPrint("[DEBUG] $msg");
  }
}

/// MAIN
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  runApp(MyApp(initialMessage: initialMessage));
}

/// MAIN APP
class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const MyApp({super.key, this.initialMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String permissionStatus = "NOT_REQUESTED";
  String? apnsToken;
  String? fcmToken;
  String? backendResponse;
  String? lastNotification;
  bool showDebugPanel = false;

  @override
  void initState() {
    super.initState();
    _initFCMPermission();
    _listenToMessages();

    if (widget.initialMessage != null) {
      DebugLogger.add("App launched by tapping notification");
      _openURLFromMessage(widget.initialMessage!);
    }
  }

  /// REQUEST PERMISSION
  Future<void> _initFCMPermission() async {
    DebugLogger.add("Requesting notification permissions...");

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    permissionStatus = settings.authorizationStatus.toString();
    DebugLogger.add("Permission result: $permissionStatus");

    setState(() {});

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _getFCMToken();
    } else {
      DebugLogger.add("User denied notification permission.");
    }
  }

  /// GET FCM + APNs TOKEN
  Future<void> _getFCMToken() async {
    DebugLogger.add("Fetching APNs + FCM token...");

    if (Platform.isIOS && !kIsWeb) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      if (iosInfo.isPhysicalDevice == false) {
        DebugLogger.add("❌ Simulator detected → APNs token not available.");
        apnsToken = "SIMULATOR — NOT AVAILABLE";
        fcmToken = "SIMULATOR — NOT AVAILABLE";
        setState(() {});
        return;
      }
    }

    try {
      apnsToken = await _messaging.getAPNSToken();
      DebugLogger.add("APNs Token: $apnsToken");

      fcmToken = await _messaging.getToken();
      DebugLogger.add("FCM Token: $fcmToken");

      if (fcmToken != null) {
        await _sendTokenToBackend(fcmToken!);
      }

      _messaging.onTokenRefresh.listen((newToken) async {
        DebugLogger.add("FCM Token Refreshed: $newToken");
        fcmToken = newToken;
        setState(() {});
        await _sendTokenToBackend(newToken);
      });
    } catch (e, st) {
      DebugLogger.add("⚠️ Error getting FCM/APNs token: $e\n$st");
      setState(() {});
    }
  }

  /// SEND TOKEN TO BACKEND
  Future<void> _sendTokenToBackend(String token) async {
    DebugLogger.add("Sending token to backend...");

    if (token.contains("SIMULATOR")) {
      backendResponse = "Skipped on Simulator";
      DebugLogger.add("Backend skipped on Simulator.");
      setState(() {});
      return;
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      Map<String, dynamic> metadata = {};
      String platform = "";

      if (Platform.isAndroid) {
        platform = "Android";
        final android = await deviceInfo.androidInfo;
        metadata = {
          "brand": android.brand,
          "manufacturer": android.manufacturer,
          "model": android.model,
          "sdk": android.version.sdkInt,
          "device": android.device,
        };
      } else if (Platform.isIOS) {
        platform = "iOS";
        final ios = await deviceInfo.iosInfo;
        metadata = {
          "name": ios.name,
          "systemName": ios.systemName,
          "systemVersion": ios.systemVersion,
          "model": ios.model,
          "machine": ios.utsname.machine,
        };
      }

      final response = await http.post(
        Uri.parse("https://bde477e36ca9.ngrok-free.app/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": "sagar8devadakar@gmail.com",
          "device_token": token,
          "platform": platform,
          "metadata": metadata,
        }),
      );

      backendResponse =
          "Status: ${response.statusCode}, Body: ${response.body}";
      DebugLogger.add("Backend Response: $backendResponse");
      setState(() {});
    } catch (e) {
      backendResponse = "Error: $e";
      DebugLogger.add("Backend error: $e");
      setState(() {});
    }
  }

  /// FOREGROUND + BACKGROUND LISTENERS
  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      lastNotification =
          "Title: ${message.notification?.title}, Body: ${message.notification?.body}";
      DebugLogger.add("Foreground Notification: $lastNotification");
      setState(() {});

      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${message.notification?.title ?? ''}\n${message.notification?.body ?? ''}",
            ),
            action: SnackBarAction(
              label: "OPEN",
              onPressed: () => _openURLFromMessage(message),
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      lastNotification =
          "Opened App → ${message.notification?.title}, ${message.notification?.body}";
      DebugLogger.add(lastNotification!);
      setState(() {});
      _openURLFromMessage(message);
    });
  }

  /// OPEN URL FROM MESSAGE
  Future<void> _openURLFromMessage(RemoteMessage message) async {
    String url =
        (message.data['url'] ?? "https://www.redarrowloans.net/").toString();

    if (url.isEmpty) return;

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  /// DEBUG PANEL WIDGET
  Widget _debugButton() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.black87,
        child: const Icon(Icons.bug_report, color: Colors.white),
        onPressed: () {
          setState(() => showDebugPanel = !showDebugPanel);
        },
      ),
    );
  }

  Widget _debugPanel() {
    if (!showDebugPanel) return const SizedBox.shrink();

    return Positioned(
      right: 10,
      top: 50,
      child: Draggable(
        feedback: _panel(),
        child: _panel(),
        childWhenDragging: Container(),
      ),
    );
  }

  Widget _panel() {
    return Container(
      width: 300,
      height: 450,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("🔍 DEBUG PANEL", style: TextStyle(fontSize: 16)),
              const Divider(color: Colors.white30),

              Text("Permission: $permissionStatus"),
              Text("APNs Token: $apnsToken"),
              Text("FCM Token: $fcmToken"),
              Text("Backend Response:\n$backendResponse"),
              Text("Last Notification:\n$lastNotification"),

              const SizedBox(height: 10),
              const Text("Logs:", style: TextStyle(fontWeight: FontWeight.bold)),
              ...DebugLogger.logs.map((e) => Text(e)),
            ],
          ),
        ),
      ),
    );
  }

  /// UI ROOT
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Red Arrow Loans",
      home: Stack(
        children: [
          const HomePage(),
          _debugButton(),
          _debugPanel(),
        ],
      ),
    );
  }
}
