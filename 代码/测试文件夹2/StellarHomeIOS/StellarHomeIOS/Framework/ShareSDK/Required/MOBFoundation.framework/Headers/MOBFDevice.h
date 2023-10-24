#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
extern NSString *kMOBFReachabilityChangedNotification;
typedef NS_ENUM(NSUInteger, MOBFNetworkType)
{
    MOBFNetworkTypeNone         = 0,
    MOBFNetworkTypeCellular     = 2,
    MOBFNetworkTypeWifi         = 1,
    MOBFNetworkTypeCellular2G   = 3,
    MOBFNetworkTypeCellular3G   = 4,
    MOBFNetworkTypeCellular4G   = 5,
};
typedef NS_ENUM(NSUInteger, MOBFIPVersion)
{
    MOBFIPVersion4 = 0,
    MOBFIPVersion6 = 1,
};
@interface MOBFDevice : NSObject
+ (CTTelephonyNetworkInfo *)networkInfo;
+ (NSString *)macAddress;
+ (NSString *)deviceModel;
+ (MOBFNetworkType)currentNetworkType;
+ (NSString *)currentNetworkTypeStr;
+ (NSString *)carrier;
+ (NSString *)carrierName;
+ (NSString *)mobileCountryCode;
+ (NSString *)mobileNetworkCode;
+ (NSInteger)versionCompare:(NSString *)other;
+ (BOOL)hasJailBroken;
+ (NSArray *)runningProcesses;
+ (BOOL)isPad;
+ (NSString *)duid;
+ (CGSize)nativeScreenSize;
+ (NSString *)ssid;
+ (NSString *)bssid;
+ (NSString *)currentLanguage;
+ (NSString *)ipAddress:(MOBFIPVersion)ver;
+ (NSString *)idfv;
+ (double)physicalMemory;
+ (long long)diskSpace;
+ (NSString *)cpuType;
+ (int)wifiLevel;
+ (NSString *)currentDataNetworkType;
@end