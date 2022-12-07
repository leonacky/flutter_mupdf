import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_mupdf_method_channel.dart';

abstract class FlutterMupdfPlatform extends PlatformInterface {
  /// Constructs a FlutterMupdfPlatform.
  FlutterMupdfPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMupdfPlatform _instance = MethodChannelFlutterMupdf();

  /// The default instance of [FlutterMupdfPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMupdf].
  static FlutterMupdfPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMupdfPlatform] when
  /// they register themselves.
  static set instance(FlutterMupdfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
