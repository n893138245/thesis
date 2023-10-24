#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIDevice (YYAdd)
#pragma mark - Device Information
+ (double)systemVersion;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isSimulator;
@property (nonatomic, readonly) BOOL isJailbroken;
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
@property (nullable, nonatomic, readonly) NSString *machineModel;
@property (nullable, nonatomic, readonly) NSString *machineModelName;
@property (nonatomic, readonly) NSDate *systemUptime;
#pragma mark - Network Information
@property (nullable, nonatomic, readonly) NSString *ipAddressWIFI;
@property (nullable, nonatomic, readonly) NSString *ipAddressCell;
typedef NS_OPTIONS(NSUInteger, YYNetworkTrafficType) {
    YYNetworkTrafficTypeWWANSent     = 1 << 0,
    YYNetworkTrafficTypeWWANReceived = 1 << 1,
    YYNetworkTrafficTypeWIFISent     = 1 << 2,
    YYNetworkTrafficTypeWIFIReceived = 1 << 3,
    YYNetworkTrafficTypeAWDLSent     = 1 << 4,
    YYNetworkTrafficTypeAWDLReceived = 1 << 5,
    YYNetworkTrafficTypeWWAN = YYNetworkTrafficTypeWWANSent | YYNetworkTrafficTypeWWANReceived,
    YYNetworkTrafficTypeWIFI = YYNetworkTrafficTypeWIFISent | YYNetworkTrafficTypeWIFIReceived,
    YYNetworkTrafficTypeAWDL = YYNetworkTrafficTypeAWDLSent | YYNetworkTrafficTypeAWDLReceived,
    YYNetworkTrafficTypeALL = YYNetworkTrafficTypeWWAN |
                              YYNetworkTrafficTypeWIFI |
                              YYNetworkTrafficTypeAWDL,
};
- (uint64_t)getNetworkTrafficBytes:(YYNetworkTrafficType)types;
#pragma mark - Disk Space
@property (nonatomic, readonly) int64_t diskSpace;
@property (nonatomic, readonly) int64_t diskSpaceFree;
@property (nonatomic, readonly) int64_t diskSpaceUsed;
#pragma mark - Memory Information
@property (nonatomic, readonly) int64_t memoryTotal;
@property (nonatomic, readonly) int64_t memoryUsed;
@property (nonatomic, readonly) int64_t memoryFree;
@property (nonatomic, readonly) int64_t memoryActive;
@property (nonatomic, readonly) int64_t memoryInactive;
@property (nonatomic, readonly) int64_t memoryWired;
@property (nonatomic, readonly) int64_t memoryPurgable;
#pragma mark - CPU Information
@property (nonatomic, readonly) NSUInteger cpuCount;
@property (nonatomic, readonly) float cpuUsage;
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;
@end
NS_ASSUME_NONNULL_END
#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif
#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif
#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif
#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif
#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif