#import <CocoaLumberjack/DDASLLogger.h>
@protocol DDLogger;
NS_ASSUME_NONNULL_BEGIN
API_DEPRECATED("Use DDOSLogger instead", macosx(10.4,10.12), ios(2.0,10.0), watchos(2.0,3.0), tvos(9.0,10.0))
@interface DDASLLogCapture : NSObject
+ (void)start;
+ (void)stop;
@property (class) DDLogLevel captureLevel;
@end
NS_ASSUME_NONNULL_END