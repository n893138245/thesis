#import <Foundation/Foundation.h>
#define ALICLOUDHAUTIL_VERSION @"1.0.1"
NS_ASSUME_NONNULL_BEGIN
@interface AlicloudHAProvider : NSObject
+ (void)start;
+ (void)updateNick:(NSString *)nick;
+ (void)updateAppVersion:(NSString *)appVersion;
@end
NS_ASSUME_NONNULL_END