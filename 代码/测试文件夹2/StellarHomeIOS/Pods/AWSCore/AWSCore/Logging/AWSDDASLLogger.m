#import "AWSDDASLLogger.h"
#import <asl.h>
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
const char* const kAWSDDASLKeyAWSDDLog = "AWSDDLog";
const char* const kAWSDDASLAWSDDLogValue = "1";
@interface AWSDDASLLogger () {
    aslclient _client;
}
@end
@implementation AWSDDASLLogger
static AWSDDASLLogger *sharedInstance;
+ (instancetype)sharedInstance {
    static dispatch_once_t AWSDDASLLoggerOnceToken;
    dispatch_once(&AWSDDASLLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (sharedInstance != nil) {
        return nil;
    }
    if ((self = [super init])) {
        _client = asl_open(NULL, "com.apple.console", 0);
    }
    return self;
}
- (void)logMessage:(AWSDDLogMessage *)logMessage {
    if ([logMessage->_fileName isEqualToString:@"AWSDDASLLogCapture"]) {
        return;
    }
    NSString * message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;
    if (message) {
        const char *msg = [message UTF8String];
        size_t aslLogLevel;
        switch (logMessage->_flag) {
            case AWSDDLogFlagError     : aslLogLevel = ASL_LEVEL_CRIT;     break;
            case AWSDDLogFlagWarning   : aslLogLevel = ASL_LEVEL_ERR;      break;
            case AWSDDLogFlagInfo      : aslLogLevel = ASL_LEVEL_WARNING;  break; 
            case AWSDDLogFlagDebug     :
            case AWSDDLogFlagVerbose   :
            default                 : aslLogLevel = ASL_LEVEL_NOTICE;   break;
        }
        static char const *const level_strings[] = { "0", "1", "2", "3", "4", "5", "6", "7" };
        uid_t const readUID = geteuid();
        char readUIDString[16];
#ifndef NS_BLOCK_ASSERTIONS
        size_t l = snprintf(readUIDString, sizeof(readUIDString), "%d", readUID);
#else
        snprintf(readUIDString, sizeof(readUIDString), "%d", readUID);
#endif
        NSAssert(l < sizeof(readUIDString),
                 @"Formatted euid is too long.");
        NSAssert(aslLogLevel < (sizeof(level_strings) / sizeof(level_strings[0])),
                 @"Unhandled ASL log level.");
        aslmsg m = asl_new(ASL_TYPE_MSG);
        if (m != NULL) {
            if (asl_set(m, ASL_KEY_LEVEL, level_strings[aslLogLevel]) == 0 &&
                asl_set(m, ASL_KEY_MSG, msg) == 0 &&
                asl_set(m, ASL_KEY_READ_UID, readUIDString) == 0 &&
                asl_set(m, kAWSDDASLKeyAWSDDLog, kAWSDDASLAWSDDLogValue) == 0) {
                asl_send(_client, m);
            }
            asl_free(m);
        }
    }
}
- (NSString *)loggerName {
    return @"cocoa.lumberjack.aslLogger";
}
@end