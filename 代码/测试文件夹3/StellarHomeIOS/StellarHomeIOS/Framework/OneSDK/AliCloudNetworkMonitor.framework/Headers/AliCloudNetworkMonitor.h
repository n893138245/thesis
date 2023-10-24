#import <Foundation/Foundation.h>
#import <AliHAProtocol/AliHAProtocol.h>
NS_ASSUME_NONNULL_BEGIN
static NSString *const ALICLOUD_NETWORKMONITOR_IOS_SDK_VERSION = @"1.0.0";
@interface AliCloudNetworkMonitor : NSObject <AliHAPluginProtocol>
+ (void)turnOnDebug;
- (instancetype)initWithAppKey:(NSString *)appKey
       secret:(NSString *)secret
   appVersion:(NSString *)appVersion
      channel:(NSString *)channel
         nick:(NSString *)nick;
@end
NS_ASSUME_NONNULL_END