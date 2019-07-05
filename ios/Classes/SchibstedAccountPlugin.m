#import "SchibstedAccountPlugin.h"
#import <schibsted_account_sdk/schibsted_account_sdk-Swift.h>

@implementation SchibstedAccountPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSchibstedAccountPlugin registerWithRegistrar:registrar];
}
@end
