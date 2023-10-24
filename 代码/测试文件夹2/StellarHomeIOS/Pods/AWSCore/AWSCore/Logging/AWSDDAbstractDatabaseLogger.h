#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
@interface AWSDDAbstractDatabaseLogger : AWSDDAbstractLogger {
@protected
    NSUInteger _saveThreshold;
    NSTimeInterval _saveInterval;
    NSTimeInterval _maxAge;
    NSTimeInterval _deleteInterval;
    BOOL _deleteOnEverySave;
    BOOL _saveTimerSuspended;
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