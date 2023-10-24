#import <Foundation/Foundation.h>
#define ALICLOUDAPM_VERSION @"1.1.1"
NS_ASSUME_NONNULL_BEGIN
@interface AlicloudAPMProvider : NSObject
- (void)autoInitWithAppVersion:(NSString *)appVersion
                       channel:(NSString *)channel
                          nick:(NSString *)nick;
- (void)initWithAppKey:(NSString *)appKey
                secret:(NSString *)secret
            appVersion:(NSString *)appVersion
               channel:(NSString *)channel
                  nick:(NSString *)nick;
- (void)initWithAppKey:(NSString *)appKey
                secret:(NSString *)secret
         rsaSecret:(NSString *)rsaSecret
            appVersion:(NSString *)appVersion
               channel:(NSString *)channel
                  nick:(NSString *)nick;
@end
NS_ASSUME_NONNULL_END