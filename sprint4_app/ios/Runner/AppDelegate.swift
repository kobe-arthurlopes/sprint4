import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    var methodChannelType: MethodChannelType?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)
        let controller = windowScene?.windows.first?.rootViewController as? FlutterViewController
      
        if let controller {
            self.methodChannelType = .imageLabeling
            self.methodChannelType?.setMethodCallHandler(binaryMessenger: controller.binaryMessenger)
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
