import Flutter
import UIKit

public class SwiftFlutterApnsToolPlugin: NSObject, FlutterPlugin {
    
    var _deviceToken: Data? = nil
    var _getDeviceTokenClosure: ((Data?, Error?) -> Void)? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_apns_tool", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterApnsToolPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "requestNotificationsPermission" {
            let arguments = call.arguments as! [String: Any]
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                var options: UNAuthorizationOptions = []
                if let sound = arguments["sound"] as? Bool, sound {
                    options.insert(.sound)
                }
                if let alert = arguments["alert"] as? Bool, alert {
                    options.insert(.alert)
                }
                if let badge = arguments["badge"] as? Bool, badge {
                    options.insert(.badge)
                }
                center.requestAuthorization(options: options) { (_, error) in
                    guard error == nil else {
                        result("Request is failed")
                        return
                    }
                    UIApplication.shared.registerForRemoteNotifications()
                    result("Request is successful")
                }
            } else {
                var types: UIUserNotificationType = []
                if let sound = arguments["sound"] as? Bool, sound {
                    types.insert(.sound)
                }
                if let alert = arguments["alert"] as? Bool, alert {
                    types.insert(.alert)
                }
                if let badge = arguments["badge"] as? Bool, badge {
                    types.insert(.badge)
                }
                let settings = UIUserNotificationSettings(types: types, categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
                result("Request is successful")
            }
        } else if call.method == "getDeviceToken" {
            if let deviceToken = _deviceToken {
                result(deviceToken)
            } else {
                _getDeviceTokenClosure = { deviceToken, error in
                    guard let deviceToken = deviceToken, error == nil else {
                        result(error.debugDescription)
                        return
                    }
                    result(deviceToken)
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}

extension SwiftFlutterApnsToolPlugin: UIApplicationDelegate {
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        _deviceToken = deviceToken
        _getDeviceTokenClosure?(deviceToken, nil)
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        _getDeviceTokenClosure?(nil, error)
    }
}
