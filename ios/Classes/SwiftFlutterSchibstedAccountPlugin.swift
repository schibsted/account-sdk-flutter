import Flutter
import UIKit

public class SwiftFlutterSchibstedAccountPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_schibsted_account", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSchibstedAccountPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
