import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register Native Video Controller Factory
    let controller = window?.rootViewController as! FlutterViewController
    let factory = NativeVideoControllerFactory(messenger: controller.binaryMessenger)
    registrar(forPlugin: "NativeVideoController")?.register(
      factory,
      withId: "native_video_controller"
    )
    
    print("🎬 AppDelegate: Native Video Controller registered successfully")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
