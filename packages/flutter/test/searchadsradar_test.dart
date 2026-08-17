import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchadsradar/searchadsradar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('searchadsradar');
  final log = <MethodCall>[];

  setUp(() {
    log.clear();
    SearchAdsRadar.debugForceSupported = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      return null;
    });
  });

  tearDown(() {
    SearchAdsRadar.debugForceSupported = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('configure sends apiKey, serverURL, debug and wrapperVersion', () async {
    await SearchAdsRadar.configure(
        apiKey: 'sar_live_x', serverURL: 'https://example.com', debug: true);
    expect(log, hasLength(1));
    expect(log.single.method, 'configure');
    final args = Map<String, Object?>.from(log.single.arguments as Map);
    expect(args['apiKey'], 'sar_live_x');
    expect(args['serverURL'], 'https://example.com');
    expect(args['debug'], true);
    expect(args['wrapperVersion'], SearchAdsRadar.wrapperVersion);
  });

  test('wrapperVersion matches pubspec.yaml version', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match =
        RegExp(r'^version:\s*(\S+)', multiLine: true).firstMatch(pubspec)!;
    expect(SearchAdsRadar.wrapperVersion, match.group(1));
  });

  test('identify sends userId', () async {
    await SearchAdsRadar.identify('user-42');
    expect(log.single.method, 'identify');
    expect((log.single.arguments as Map)['userId'], 'user-42');
  });

  test('track keeps JSON scalars and drops everything else', () async {
    await SearchAdsRadar.track('signup', {
      's': 'str',
      'i': 3,
      'd': 1.5,
      'b': true,
      'n': null,
      'list': [1, 2],
      'map': {'nested': true},
      'time': DateTime(2026),
    });
    expect(log.single.method, 'track');
    final args = Map<String, Object?>.from(log.single.arguments as Map);
    expect(args['name'], 'signup');
    final props = Map<String, Object?>.from(args['properties'] as Map);
    expect(props, {'s': 'str', 'i': 3, 'd': 1.5, 'b': true, 'n': null});
  });

  test('reset sends no arguments', () async {
    await SearchAdsRadar.reset();
    expect(log.single.method, 'reset');
  });

  test('unsupported platform never touches the channel', () async {
    SearchAdsRadar.debugForceSupported = false;
    await SearchAdsRadar.configure(apiKey: 'k');
    await SearchAdsRadar.identify('u');
    await SearchAdsRadar.track('e');
    await SearchAdsRadar.reset();
    expect(log, isEmpty);
  });
}
