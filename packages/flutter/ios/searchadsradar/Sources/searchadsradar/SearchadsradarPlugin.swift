import Flutter
import UIKit

public class SearchadsradarPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "searchadsradar", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SearchadsradarPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "configure":
      guard let args = call.arguments as? [String: Any],
            let apiKey = args["apiKey"] as? String else {
        result(FlutterError(
          code: "bad_args", message: "configure requires apiKey", details: nil))
        return
      }
      // Wrapper identity BEFORE configure — folded into every event's sdkVersion.
      SARKitCore.setWrapperInfo(
        platform: "flutter",
        version: args["wrapperVersion"] as? String ?? "0.0.0")
      SARKit.configure(
        apiKey: apiKey,
        serverURL: args["serverURL"] as? String,
        debug: args["debug"] as? Bool ?? false)
      result(nil)

    case "identify":
      guard let args = call.arguments as? [String: Any],
            let userId = args["userId"] as? String else {
        result(FlutterError(
          code: "bad_args", message: "identify requires userId", details: nil))
        return
      }
      SARKit.identify(userId)
      result(nil)

    case "track":
      guard let args = call.arguments as? [String: Any],
            let name = args["name"] as? String else {
        result(FlutterError(
          code: "bad_args", message: "track requires name", details: nil))
        return
      }
      let raw = args["properties"] as? [String: Any] ?? [:]
      SARKit.track(name, properties: raw.mapValues(Self.normalized))
      result(nil)

    case "reset":
      SARKit.reset()
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Channel values arrive as NSNumber; AnyCodable matches Int before Bool,
  /// so an unnormalized Dart `true` would hit the wire as `1`. Restore the
  /// intended Swift type before handing values to SARKit.
  static func normalized(_ value: Any) -> Any {
    guard let number = value as? NSNumber else { return value }
    if CFGetTypeID(number) == CFBooleanGetTypeID() {
      return number.boolValue
    }
    switch String(cString: number.objCType) {
    case "f", "d":
      return number.doubleValue
    default:
      return number.intValue
    }
  }
}
