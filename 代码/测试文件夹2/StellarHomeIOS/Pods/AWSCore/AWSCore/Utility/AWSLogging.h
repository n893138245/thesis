#import <Foundation/Foundation.h>
#define AWSLogFormat @"%@ line:%d | %s | "
#define AWSLogError(fmt, ...)    [[AWSLogger defaultLogger] log:AWSLogLevelError format:(AWSLogFormat fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__]
#define AWSLogWarn(fmt, ...)    [[AWSLogger defaultLogger] log:AWSLogLevelWarn format:(AWSLogFormat fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__]
#define AWSLogInfo(fmt, ...)    [[AWSLogger defaultLogger] log:AWSLogLevelInfo format:(AWSLogFormat fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__]
#define AWSLogDebug(fmt, ...)    [[AWSLogger defaultLogger] log:AWSLogLevelDebug format:(AWSLogFormat fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__]
#define AWSLogVerbose(fmt, ...)    [[AWSLogger defaultLogger] log:AWSLogLevelVerbose format:(AWSLogFormat fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__]
typedef NS_ENUM(NSInteger, AWSLogLevel) {
    AWSLogLevelUnknown = -1,
    AWSLogLevelNone = 0,
    AWSLogLevelError = 1,
    AWSLogLevelWarn = 2,
    AWSLogLevelInfo = 3,
    AWSLogLevelDebug = 4,
    AWSLogLevelVerbose = 5
};
__attribute__((deprecated("use AWSDDLog instead")))
@interface AWSLogger : NSObject
@property (atomic, assign) AWSLogLevel logLevel;
+ (instancetype)defaultLogger;
- (void)log:(AWSLogLevel)logLevel
     format:(NSString *)fmt, ... NS_FORMAT_FUNCTION(2, 3);
@end