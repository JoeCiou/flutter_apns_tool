#import "FlutterApnsToolPlugin.h"
#import <flutter_apns_tool/flutter_apns_tool-Swift.h>

@implementation FlutterApnsToolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterApnsToolPlugin registerWithRegistrar:registrar];
}
@end
