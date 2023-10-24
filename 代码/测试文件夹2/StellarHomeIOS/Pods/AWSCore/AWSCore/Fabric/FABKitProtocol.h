#import <Foundation/Foundation.h>
@protocol FABKit <NSObject>
@required
+ (NSString *)bundleIdentifier;
+ (NSString *)kitDisplayVersion;
@optional
+ (NSString *)kitBuildVersion;
+ (void)initializeIfNeeded;
@end