#import "AWSDDOSLogger.h"
#import <os/log.h>
@implementation AWSDDOSLogger
static AWSDDOSLogger *sharedInstance;
+ (instancetype)sharedInstance {
    static dispatch_once_t AWSDDOSLoggerOnceToken;
    dispatch_once(&AWSDDOSLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (sharedInstance != nil) {
        return nil;
    }
    if (self = [super init]) {
        return self;
    }
    return nil;
}
- (void)logMessage:(AWSDDLogMessage *)logMessage {
    if ([logMessage->_fileName isEqualToString:@"AWSDDASLLogCapture"]) {
        return;
    }
    NSString * message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;
    if (message) {
        const char *msg = [message UTF8String];
        switch (logMessage->_flag) {
            case AWSDDLogFlagError     :
                os_log_error(OS_LOG_DEFAULT, "%{public}s", msg);
                break;
            case AWSDDLogFlagWarning   :
            case AWSDDLogFlagInfo      :
                os_log_info(OS_LOG_DEFAULT, "%{public}s", msg);
                break;
            case AWSDDLogFlagDebug     :
            case AWSDDLogFlagVerbose   :
            default                 :
                os_log_debug(OS_LOG_DEFAULT, "%{public}s", msg);
                break;
        }
    }
}
- (NSString *)loggerName {
    return @"cocoa.lumberjack.osLogger";
}
@end