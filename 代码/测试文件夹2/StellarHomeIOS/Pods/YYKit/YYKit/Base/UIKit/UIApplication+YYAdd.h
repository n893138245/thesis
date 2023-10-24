#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIApplication (YYAdd)
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;
@property (nullable, nonatomic, readonly) NSString *appBundleName;
@property (nullable, nonatomic, readonly) NSString *appBundleID;
@property (nullable, nonatomic, readonly) NSString *appVersion;
@property (nullable, nonatomic, readonly) NSString *appBuildVersion;
@property (nonatomic, readonly) BOOL isPirated;
@property (nonatomic, readonly) BOOL isBeingDebugged;
@property (nonatomic, readonly) int64_t memoryUsage;
@property (nonatomic, readonly) float cpuUsage;
- (void)incrementNetworkActivityCount;
- (void)decrementNetworkActivityCount;
+ (BOOL)isAppExtension;
+ (nullable UIApplication *)sharedExtensionApplication;
@end
NS_ASSUME_NONNULL_END