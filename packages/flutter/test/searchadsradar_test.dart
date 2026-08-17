import 'package:flutter_test/flutter_test.dart';
import 'package:searchadsradar/searchadsradar.dart';
import 'package:searchadsradar/searchadsradar_platform_interface.dart';
import 'package:searchadsradar/searchadsradar_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSearchadsradarPlatform
    with MockPlatformInterfaceMixin
    implements SearchadsradarPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SearchadsradarPlatform initialPlatform = SearchadsradarPlatform.instance;

  test('$MethodChannelSearchadsradar is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSearchadsradar>());
  });

  test('getPlatformVersion', () async {
    Searchadsradar searchadsradarPlugin = Searchadsradar();
    MockSearchadsradarPlatform fakePlatform = MockSearchadsradarPlatform();
    SearchadsradarPlatform.instance = fakePlatform;

    expect(await searchadsradarPlugin.getPlatformVersion(), '42');
  });
}
