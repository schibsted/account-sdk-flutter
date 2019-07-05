import Flutter
import UIKit

public class SwiftSchibstedAccountPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "schibsted_account_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftSchibstedAccountPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}


