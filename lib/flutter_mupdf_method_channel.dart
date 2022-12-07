import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_mupdf_platform_interface.dart';

/// An implementation of [FlutterMupdfPlatform] that uses method channels.
class MethodChannelFlutterMupdf extends FlutterMupdfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_mupdf');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
