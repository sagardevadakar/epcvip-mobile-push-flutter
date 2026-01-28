import 'dart:developer';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import '../debug_logger.dart';



class AppsFlyerService {
  static final AppsFlyerService _instance = AppsFlyerService._internal();
  factory AppsFlyerService() => _instance;

  late AppsflyerSdk _appsflyerSdk;

  AppsFlyerService._internal();

  void _afLog(String message) {
    log(
        message,
        name: 'AppsFlyer',
    );
    // Debug Overlay
    DebugLogger.add('[AppsFlyer] $message');
  }

  /// MUST be async to safely initialize AppsFlyer
  Future<void> init() async {
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: "52jA6Aaoj8jD38oezcFVEo",
      appId: "6756265852", // Numeric App Store ID
      showDebug: true, // ✅ OK for TestFlight, set FALSE for production
    );

    _appsflyerSdk = AppsflyerSdk(options);

    /// IMPORTANT: await is REQUIRED
    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    _registerCallbacks();
  }

  void _registerCallbacks() {
    /// 🔹 Deferred Deep Link (first install)
    _appsflyerSdk.onDeepLinking((DeepLinkResult result) {
      _afLog("AppsFlyer DeepLink status: ${result.status}");

      if (result.status == Status.FOUND) {
        final deepLink = result.deepLink;

        _afLog("Deferred DeepLink raw data: ${deepLink?.clickEvent}");

        // ✅ Safely read custom parameters
        final campaign = deepLink?.getStringValue("campaign");
        final emailHash = deepLink?.getStringValue("email_hash");
        final mobileHash = deepLink?.getStringValue("mobile_hash");

        _afLog("Campaign: $campaign");
        _afLog("Email Hash Value: $emailHash");
        _afLog("Mobile Hash Value: $mobileHash");

        /// 🚨 DO NOT AUTO-NAVIGATE HERE
        /// ✔ Store values
        /// ✔ Send analytics
        /// ✔ Apply logic AFTER onboarding
      }
    });

    /// 🔹 Install attribution (first app launch only)
    _appsflyerSdk.onInstallConversionData((data) {
      _afLog("AppsFlyer Install Conversion Data: $data");
    });

    /// 🔹 App open attribution (re-engagement)
    _appsflyerSdk.onAppOpenAttribution((data) {
      _afLog("AppsFlyer App Open Attribution: $data");
    });
  }
}
