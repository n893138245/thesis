#import <Foundation/Foundation.h>
#define ALICLOUDCRASH_VERSION @"1.2.0"
NS_ASSUME_NONNULL_BEGIN
@interface AlicloudCrashProvider : NSObject
- (void)autoInitWithAppVersion:(NSString *)appVersion
                       channel:(NSString *)channel
                          nick:(NSString *)nick;
- (void)initWithAppKey:(NSString *)appKey
                secret:(NSString *)secret
            appVersion:(NSString *)appVersion
               channel:(NSString *)channel
                  nick:(NSString *)nick;
+ (void)configCustomInfoWithKey:(NSString *)key value:(NSString *)value;
+ (void)setCrashCallBack:(NSDictionary * (^)(NSString * type))crashReporterAdditionalInformationCallBack;
+ (void)reportCustomError:(NSError *)error;
@end
NS_ASSUME_NONNULL_END