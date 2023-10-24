#import "AWSDDMultiFormatter.h"
#if TARGET_OS_IOS
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else                                         
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif
#elif TARGET_OS_WATCH || TARGET_OS_TV
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080     
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else                                         
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif
#endif
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@interface AWSDDMultiFormatter () {
    dispatch_queue_t _queue;
    NSMutableArray *_formatters;
}
- (AWSDDLogMessage *)logMessageForLine:(NSString *)line originalMessage:(AWSDDLogMessage *)message;
@end
@implementation AWSDDMultiFormatter
- (instancetype)init {
    self = [super init];
    if (self) {
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
        _queue = dispatch_queue_create("cocoa.lumberjack.multiformatter", DISPATCH_QUEUE_CONCURRENT);
#else
        _queue = dispatch_queue_create("cocoa.lumberjack.multiformatter", NULL);
#endif
        _formatters = [NSMutableArray new];
    }
    return self;
}
#if NEEDS_DISPATCH_RETAIN_RELEASE
- (void)dealloc {
    dispatch_release(_queue);
}
#endif
#pragma mark Processing
- (NSString *)formatLogMessage:(AWSDDLogMessage *)logMessage {
    __block NSString *line = logMessage->_message;
    dispatch_sync(_queue, ^{
        for (id<AWSDDLogFormatter> formatter in self->_formatters) {
            AWSDDLogMessage *message = [self logMessageForLine:line originalMessage:logMessage];
            line = [formatter formatLogMessage:message];
            if (!line) {
                break;
            }
        }
    });
    return line;
}
- (AWSDDLogMessage *)logMessageForLine:(NSString *)line originalMessage:(AWSDDLogMessage *)message {
    AWSDDLogMessage *newMessage = [message copy];
    newMessage->_message = line;
    return newMessage;
}
#pragma mark Formatters
- (NSArray *)formatters {
    __block NSArray *formatters;
    dispatch_sync(_queue, ^{
        formatters = [self->_formatters copy];
    });
    return formatters;
}
- (void)addFormatter:(id<AWSDDLogFormatter>)formatter {
    dispatch_barrier_async(_queue, ^{
        [self->_formatters addObject:formatter];
    });
}
- (void)removeFormatter:(id<AWSDDLogFormatter>)formatter {
    dispatch_barrier_async(_queue, ^{
        [self->_formatters removeObject:formatter];
    });
}
- (void)removeAllFormatters {
    dispatch_barrier_async(_queue, ^{
        [self->_formatters removeAllObjects];
    });
}
- (BOOL)isFormattingWithFormatter:(id<AWSDDLogFormatter>)formatter {
    __block BOOL hasFormatter;
    dispatch_sync(_queue, ^{
        hasFormatter = [self->_formatters containsObject:formatter];
    });
    return hasFormatter;
}
@end