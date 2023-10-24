#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
NS_ASSUME_NONNULL_BEGIN
@interface DDAbstractDatabaseLogger : DDAbstractLogger {
@protected
    NSUInteger _saveThreshold;
    NSTimeInterval _saveInterval;
    NSTimeInterval _maxAge;
    NSTimeInterval _deleteInterval;
    BOOL _deleteOnEverySave;
    NSInteger _saveTimerSuspended;
    NSUInteger _unsavedCount;
    dispatch_time_t _unsavedTime;
    dispatch_source_t _saveTimer;
    dispatch_time_t _lastDeleteTime;
    dispatch_source_t _deleteTimer;
}
@property (assign, readwrite) NSUInteger saveThreshold;
@property (assign, readwrite) NSTimeInterval saveInterval;
@property (assign, readwrite) NSTimeInterval maxAge;
@property (assign, readwrite) NSTimeInterval deleteInterval;
@property (assign, readwrite) BOOL deleteOnEverySave;
- (void)savePendingLogEntries;
- (void)deleteOldLogEntries;
@end
NS_ASSUME_NONNULL_END