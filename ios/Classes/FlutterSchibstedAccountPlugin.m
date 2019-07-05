#import "FlutterSchibstedAccountPlugin.h"
#import <flutter_schibsted_account/flutter_schibsted_account-Swift.h>

@implementation FlutterSchibstedAccountPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSchibstedAccountPlugin registerWithRegistrar:registrar];
}
@end
