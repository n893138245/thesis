#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface DCAOpenWiFiJudge : NSObject
+ (BOOL)isWiFiEnabled;
+ (NSString *)ssid;
+ (void) getWifiList;
+ (NSString*) getWifiSsid;
@end
NS_ASSUME_NONNULL_END