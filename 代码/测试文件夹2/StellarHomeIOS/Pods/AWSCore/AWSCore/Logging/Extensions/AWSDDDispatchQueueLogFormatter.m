#import "AWSDDDispatchQueueLogFormatter.h"
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@interface AWSDDDispatchQueueLogFormatter () {
    AWSDDDispatchQueueLogFormatterMode _mode;
    NSString *_dateFormatterKey;
    int32_t _atomicLoggerCount;
    NSDateFormatter *_threadUnsafeDateFormatter; 
    OSSpinLock _lock;
    NSUInteger _minQueueLength;           
    NSUInteger _maxQueueLength;           
    NSMutableDictionary *_replacements;   
}
@end
@implementation AWSDDDispatchQueueLogFormatter
- (instancetype)init {
    if ((self = [super init])) {
        _mode = AWSDDDispatchQueueLogFormatterModeShareble;
        Class cls = [self class];
        Class superClass = class_getSuperclass(cls);
        SEL configMethodName = @selector(configureDateFormatter:);
        Method configMethod = class_getInstanceMethod(cls, configMethodName);
        while (class_getInstanceMethod(superClass, configMethodName) == configMethod) {
            cls = superClass;
            superClass = class_getSuperclass(cls);
        }
        _dateFormatterKey = [NSString stringWithFormat:@"%s_NSDateFormatter", class_getName(cls)];
        _atomicLoggerCount = 0;
        _threadUnsafeDateFormatter = nil;
        _minQueueLength = 0;
        _maxQueueLength = 0;
        _lock = OS_SPINLOCK_INIT;
        _replacements = [[NSMutableDictionary alloc] init];
        _replacements[@"com.apple.main-thread"] = @"main";
    }
    return self;
}
- (instancetype)initWithMode:(AWSDDDispatchQueueLogFormatterMode)mode {
    if ((self = [self init])) {
        _mode = mode;
    }
    return self;
}
#pragma mark Configuration
@synthesize minQueueLength = _minQueueLength;
@synthesize maxQueueLength = _maxQueueLength;
- (NSString *)replacementStringForQueueLabel:(NSString *)longLabel {
    NSString *result = nil;
    OSSpinLockLock(&_lock);
    {
        result = _replacements[longLabel];
    }
    OSSpinLockUnlock(&_lock);
    return result;
}
- (void)setReplacementString:(NSString *)shortLabel forQueueLabel:(NSString *)longLabel {
    OSSpinLockLock(&_lock);
    {
        if (shortLabel) {
            _replacements[longLabel] = shortLabel;
        } else {
            [_replacements removeObjectForKey:longLabel];
        }
    }
    OSSpinLockUnlock(&_lock);
}
#pragma mark AWSDDLogFormatter
- (NSDateFormatter *)createDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [self configureDateFormatter:formatter];
    return formatter;
}
- (void)configureDateFormatter:(NSDateFormatter *)dateFormatter {
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *calendarIdentifier = nil;
#if defined(__IPHONE_8_0) || defined(__MAC_10_10)
    calendarIdentifier = NSCalendarIdentifierGregorian;
#else
    calendarIdentifier = NSGregorianCalendar;
#endif
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier]];
}
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = nil;
    if (_mode == AWSDDDispatchQueueLogFormatterModeNonShareble) {
        dateFormatter = _threadUnsafeDateFormatter;
        if (dateFormatter == nil) {
            dateFormatter = [self createDateFormatter];
            _threadUnsafeDateFormatter = dateFormatter;
        }
    } else {
        NSString *key = _dateFormatterKey;
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        dateFormatter = threadDictionary[key];
        if (dateFormatter == nil) {
            dateFormatter = [self createDateFormatter];
            threadDictionary[key] = dateFormatter;
        }
    }
    return [dateFormatter stringFromDate:date];
}
- (NSString *)queueThreadLabelForLogMessage:(AWSDDLogMessage *)logMessage {
    NSUInteger minQueueLength = self.minQueueLength;
    NSUInteger maxQueueLength = self.maxQueueLength;
    NSString *queueThreadLabel = nil;
    BOOL useQueueLabel = YES;
    BOOL useThreadName = NO;
    if (logMessage->_queueLabel) {
        NSArray *names = @[
            @"com.apple.root.low-priority",
            @"com.apple.root.default-priority",
            @"com.apple.root.high-priority",
            @"com.apple.root.low-overcommit-priority",
            @"com.apple.root.default-overcommit-priority",
            @"com.apple.root.high-overcommit-priority"
        ];
        for (NSString * name in names) {
            if ([logMessage->_queueLabel isEqualToString:name]) {
                useQueueLabel = NO;
                useThreadName = [logMessage->_threadName length] > 0;
                break;
            }
        }
    } else {
        useQueueLabel = NO;
        useThreadName = [logMessage->_threadName length] > 0;
    }
    if (useQueueLabel || useThreadName) {
        NSString *fullLabel;
        NSString *abrvLabel;
        if (useQueueLabel) {
            fullLabel = logMessage->_queueLabel;
        } else {
            fullLabel = logMessage->_threadName;
        }
        OSSpinLockLock(&_lock);
        {
            abrvLabel = _replacements[fullLabel];
        }
        OSSpinLockUnlock(&_lock);
        if (abrvLabel) {
            queueThreadLabel = abrvLabel;
        } else {
            queueThreadLabel = fullLabel;
        }
    } else {
        queueThreadLabel = logMessage->_threadID;
    }
    NSUInteger labelLength = [queueThreadLabel length];
    if ((maxQueueLength > 0) && (labelLength > maxQueueLength)) {
        return [queueThreadLabel substringToIndex:maxQueueLength];
    } else if (labelLength < minQueueLength) {
        NSUInteger numSpaces = minQueueLength - labelLength;
        char spaces[numSpaces + 1];
        memset(spaces, ' ', numSpaces);
        spaces[numSpaces] = '\0';
        return [NSString stringWithFormat:@"%@%s", queueThreadLabel, spaces];
    } else {
        return queueThreadLabel;
    }
}
- (NSString *)formatLogMessage:(AWSDDLogMessage *)logMessage {
    NSString *timestamp = [self stringFromDate:(logMessage->_timestamp)];
    NSString *queueThreadLabel = [self queueThreadLabelForLogMessage:logMessage];
    return [NSString stringWithFormat:@"%@ [%@] %@", timestamp, queueThreadLabel, logMessage->_message];
}
- (void)didAddToLogger:(id <AWSDDLogger>  __attribute__((unused)))logger {
    int32_t count = 0;
    count = OSAtomicIncrement32(&_atomicLoggerCount);
    NSAssert(count <= 1 || _mode == AWSDDDispatchQueueLogFormatterModeShareble, @"Can't reuse formatter with multiple loggers in non-shareable mode.");
}
- (void)willRemoveFromLogger:(id <AWSDDLogger> __attribute__((unused)))logger {
    OSAtomicDecrement32(&_atomicLoggerCount);
}
@end