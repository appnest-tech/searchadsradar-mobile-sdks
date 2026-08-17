import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// First-party Apple Search Ads attribution for Flutter apps (iOS 16+).
///
/// All methods are safe no-ops on Android and web — SearchAdsRadar is an
/// Apple Search Ads product. Purchases are captured by the native StoreKit 2
/// observer; note that same-device purchases surface at the *next* app launch
/// and consumables are not captured (see the package README).
class SearchAdsRadar {
  SearchAdsRadar._();

  static const MethodChannel _channel = MethodChannel('searchadsradar');

  /// Keep identical to pubspec.yaml `version:` — enforced by a unit test.
  static const String wrapperVersion = '1.0.0';

  /// Test hook: unit tests run on the host, where [Platform.isIOS] is false.
  @visibleForTesting
  static bool debugForceSupported = false;

  static bool get _supported =>
      debugForceSupported || (!kIsWeb && Platform.isIOS);

  /// Call once at app launch, before the first user interaction.
  static Future<void> configure({
    required String apiKey,
    String? serverURL,
    bool debug = false,
  }) async {
    if (!_supported) return;
    await _channel.invokeMethod<void>('configure', <String, Object?>{
      'apiKey': apiKey,
      'serverURL': serverURL,
      'debug': debug,
      'wrapperVersion': wrapperVersion,
    });
  }

  /// Link this device to your server-side user id (login/signup).
  static Future<void> identify(String userId) async {
    if (!_supported) return;
    await _channel
        .invokeMethod<void>('identify', <String, Object?>{'userId': userId});
  }

  /// Track a custom event. Property values must be JSON scalars
  /// (String/num/bool/null); anything else is dropped with a debug log.
  static Future<void> track(String name,
      [Map<String, Object?> properties = const {}]) async {
    if (!_supported) return;
    final filtered = <String, Object?>{};
    properties.forEach((key, value) {
      if (value == null || value is String || value is num || value is bool) {
        filtered[key] = value;
      } else if (kDebugMode) {
        debugPrint(
            '[SearchAdsRadar] Dropped non-scalar property "$key" (${value.runtimeType})');
      }
    });
    await _channel.invokeMethod<void>('track', <String, Object?>{
      'name': name,
      'properties': filtered,
    });
  }

  /// Clear user identity. Call on logout.
  static Future<void> reset() async {
    if (!_supported) return;
    await _channel.invokeMethod<void>('reset');
  }
}
