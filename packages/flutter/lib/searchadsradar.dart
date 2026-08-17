
import 'searchadsradar_platform_interface.dart';

class Searchadsradar {
  Future<String?> getPlatformVersion() {
    return SearchadsradarPlatform.instance.getPlatformVersion();
  }
}
