import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Universal Links (AppsFlyer OneLink)
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {

    // Forward link to Flutter plugins (AppsFlyer, app_links, etc.)
    super.application(
      application,
      continue: userActivity,
      restorationHandler: restorationHandler
    )

    // 🚨 CRITICAL:
    // Returning FALSE prevents Safari re-opening / Open button loop
    return false
  }

  // ✅ URI scheme fallback (af_force_deeplink=true case)
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    // Forward to Flutter
    super.application(app, open: url, options: options)

    // URI schemes are fully handled by the app
    return true
  }
}

