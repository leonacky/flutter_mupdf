
import 'flutter_mupdf_platform_interface.dart';

class FlutterMupdf {
  Future<String?> getPlatformVersion() {
    return FlutterMupdfPlatform.instance.getPlatformVersion();
  }
}
