#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#define ALICLOUD_NETWOEK_STATUS_NOTIFY @"AlicloudNetworkStatusChangeNotify"
typedef enum {
    AlicloudNotReachable = 0,
    AlicloudReachableViaWiFi,
    AlicloudReachableVia2G,
    AlicloudReachableVia3G,
    AlicloudReachableVia4G
} AlicloudNetworkStatus;
@interface AlicloudReachabilityManager : NSObject
+ (AlicloudReachabilityManager *)shareInstance;
+ (AlicloudReachabilityManager *)shareInstanceWithNetInfo:(CTTelephonyNetworkInfo *)netInfo;
- (AlicloudNetworkStatus)currentNetworkStatus;
- (AlicloudNetworkStatus)preNetworkStatus;
- (BOOL)checkInternetConnection;
- (BOOL)isReachableViaWifi;
- (BOOL)isReachableViaWWAN;
@end