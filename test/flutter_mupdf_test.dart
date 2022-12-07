import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mupdf/flutter_mupdf.dart';
import 'package:flutter_mupdf/flutter_mupdf_platform_interface.dart';
import 'package:flutter_mupdf/flutter_mupdf_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMupdfPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMupdfPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMupdfPlatform initialPlatform = FlutterMupdfPlatform.instance;

  test('$MethodChannelFlutterMupdf is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMupdf>());
  });

  test('getPlatformVersion', () async {
    FlutterMupdf flutterMupdfPlugin = FlutterMupdf();
    MockFlutterMupdfPlatform fakePlatform = MockFlutterMupdfPlatform();
    FlutterMupdfPlatform.instance = fakePlatform;

    expect(await flutterMupdfPlugin.getPlatformVersion(), '42');
  });
}
