#ifndef EMASSecurityModeManager_h
#define EMASSecurityModeManager_h
#import "EMASSecurityModeCommon.h"
@interface EMASSecurityModeManager : NSObject
+ (instancetype)sharedInstance;
- (void)registerSDKComponentAndStartCheck:(NSString *)sdkId
                               sdkVersion:(NSString *)sdkVersion
                                   appKey:(NSString *)appKey
                                appSecret:(NSString *)appSecret
                        sdkCrashThreshold:(NSUInteger)crashTimesThreshold
                                onSuccess:(SDKCheckSuccessHandler)successHandler
                                  onCrash:(SDKCheckCrashHandler)crashHandler;
@end
#endif 