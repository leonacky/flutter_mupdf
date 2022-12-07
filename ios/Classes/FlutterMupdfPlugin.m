#import "FlutterMupdfPlugin.h"
#if __has_include(<flutter_mupdf/flutter_mupdf-Swift.h>)
#import <flutter_mupdf/flutter_mupdf-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_mupdf-Swift.h"
#endif

@implementation FlutterMupdfPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMupdfPlugin registerWithRegistrar:registrar];
}
@end
