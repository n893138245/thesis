#import <Foundation/Foundation.h>
@interface MOBFApplication : NSObject
+ (NSString *)name;
+ (NSString *)bundleId;
+ (NSString *)buildVersion;
+ (NSString *)shortVersion;
+ (NSString *)version __deprecated_msg("use [buildVersion] method instead");
+ (BOOL)enabledATS;
+ (uint64_t)elapsedTime;
+ (BOOL)canOpenUrl:(NSURL *)url;
+ (void)openUrl:(NSURL *)url;
@end