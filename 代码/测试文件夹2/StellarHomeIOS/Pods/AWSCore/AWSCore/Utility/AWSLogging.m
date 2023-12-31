#import "AWSLogging.h"
#import "AWSService.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation AWSLogger
- (instancetype)init {
    if (self = [super init]) {
        _logLevel = AWSLogLevelDebug;
    }
    return self;
}
+ (instancetype)defaultLogger {
    static AWSLogger *_defaultLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLogger = [AWSLogger new];
    });
    return _defaultLogger;
}
- (void)log:(AWSLogLevel)logLevel format:(NSString *)fmt, ... NS_FORMAT_FUNCTION(2, 3) {
    if(self.logLevel >= logLevel) {
        va_list args;
        va_start(args, fmt);
        NSLog(@"AWSiOSSDK v%@ [%@] %@", AWSiOSSDKVersion, [self logLevelLabel:logLevel], [[NSString alloc] initWithFormat:fmt arguments:args]);
        va_end(args);
    }
}
- (NSString *)logLevelLabel:(AWSLogLevel)logLevel {
    switch (logLevel) {
        case AWSLogLevelError:
            return @"Error";
        case AWSLogLevelWarn:
            return @"Warn";
        case AWSLogLevelInfo:
            return @"Info";
        case AWSLogLevelDebug:
            return @"Debug";
        case AWSLogLevelVerbose:
            return @"Verbose";
        case AWSLogLevelUnknown:
        case AWSLogLevelNone:
        default:
            return @"?";
    }
}
@end
#pragma clang diagnostic pop