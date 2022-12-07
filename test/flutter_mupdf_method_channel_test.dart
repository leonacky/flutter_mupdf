import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mupdf/flutter_mupdf_method_channel.dart';

void main() {
  MethodChannelFlutterMupdf platform = MethodChannelFlutterMupdf();
  const MethodChannel channel = MethodChannel('flutter_mupdf');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
