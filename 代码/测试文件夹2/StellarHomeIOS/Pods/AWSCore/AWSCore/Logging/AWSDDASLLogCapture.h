#import "AWSDDASLLogger.h"
@protocol AWSDDLogger;
@interface AWSDDASLLogCapture : NSObject
+ (void)start;
+ (void)stop;
@property (class) AWSDDLogLevel captureLevel;
@end