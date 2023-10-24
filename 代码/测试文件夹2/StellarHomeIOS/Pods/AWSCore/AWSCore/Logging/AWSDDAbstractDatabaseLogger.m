#import "AWSDDAbstractDatabaseLogger.h"
#import <math.h>
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@interface AWSDDAbstractDatabaseLogger ()
- (void)destroySaveTimer;
- (void)destroyDeleteTimer;
@end
#pragma mark -
@implementation AWSDDAbstractDatabaseLogger
- (instancetype)init {
    if ((self = [super init])) {
        _saveThreshold = 500;
        _saveInterval = 60;           
        _maxAge = (60 * 60 * 24 * 7); 
        _deleteInterval = (60 * 5);   
    }
    return self;
}
- (void)dealloc {
    [self destroySaveTimer];
    [self destroyDeleteTimer];
}
#pragma mark Override Me
- (BOOL)db_log:(AWSDDLogMessage *)logMessage {
    return NO;
}
- (void)db_save {
}
- (void)db_delete {
}
- (void)db_saveAndDelete {
}
#pragma mark Private API
- (void)performSaveAndSuspendSaveTimer {
    if (_unsavedCount > 0) {
        if (_deleteOnEverySave) {
            [self db_saveAndDelete];
        } else {
            [self db_save];
        }
    }
    _unsavedCount = 0;
    _unsavedTime = 0;
    if (_saveTimer && !_saveTimerSuspended) {
        dispatch_suspend(_saveTimer);
        _saveTimerSuspended = YES;
    }
}
- (void)performDelete {
    if (_maxAge > 0.0) {
        [self db_delete];
        _lastDeleteTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    }
}
#pragma mark Timers
- (void)destroySaveTimer {
    if (_saveTimer) {
        dispatch_source_cancel(_saveTimer);
        if (_saveTimerSuspended) {
            dispatch_resume(_saveTimer);
            _saveTimerSuspended = NO;
        }
        #if !OS_OBJECT_USE_OBJC
        dispatch_release(_saveTimer);
        #endif
        _saveTimer = NULL;
    }
}
- (void)updateAndResumeSaveTimer {
    if ((_saveTimer != NULL) && (_saveInterval > 0.0) && (_unsavedTime > 0.0)) {
        uint64_t interval = (uint64_t)(_saveInterval * (NSTimeInterval) NSEC_PER_SEC);
        dispatch_time_t startTime = dispatch_time(_unsavedTime, interval);
        dispatch_source_set_timer(_saveTimer, startTime, interval, 1ull * NSEC_PER_SEC);
        if (_saveTimerSuspended) {
            dispatch_resume(_saveTimer);
            _saveTimerSuspended = NO;
        }
    }
}
- (void)createSuspendedSaveTimer {
    if ((_saveTimer == NULL) && (_saveInterval > 0.0)) {
        _saveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.loggerQueue);
        dispatch_source_set_event_handler(_saveTimer, ^{ @autoreleasepool {
                                                            [self performSaveAndSuspendSaveTimer];
                                                        } });
        _saveTimerSuspended = YES;
    }
}
- (void)destroyDeleteTimer {
    if (_deleteTimer) {
        dispatch_source_cancel(_deleteTimer);
        #if !OS_OBJECT_USE_OBJC
        dispatch_release(_deleteTimer);
        #endif
        _deleteTimer = NULL;
    }
}
- (void)updateDeleteTimer {
    if ((_deleteTimer != NULL) && (_deleteInterval > 0.0) && (_maxAge > 0.0)) {
        uint64_t interval = (uint64_t)(_deleteInterval * (NSTimeInterval) NSEC_PER_SEC);
        dispatch_time_t startTime;
        if (_lastDeleteTime > 0) {
            startTime = dispatch_time(_lastDeleteTime, interval);
        } else {
            startTime = dispatch_time(DISPATCH_TIME_NOW, interval);
        }
        dispatch_source_set_timer(_deleteTimer, startTime, interval, 1ull * NSEC_PER_SEC);
    }
}
- (void)createAndStartDeleteTimer {
    if ((_deleteTimer == NULL) && (_deleteInterval > 0.0) && (_maxAge > 0.0)) {
        _deleteTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.loggerQueue);
        if (_deleteTimer != NULL) {
            dispatch_source_set_event_handler(_deleteTimer, ^{ @autoreleasepool {
                                                                  [self performDelete];
                                                              } });
            [self updateDeleteTimer];
            if (_deleteTimer != NULL) {
                dispatch_resume(_deleteTimer);
            }
        }
    }
}
#pragma mark Configuration
- (NSUInteger)saveThreshold {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    __block NSUInteger result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, ^{
            result = self->_saveThreshold;
        });
    });
    return result;
}
- (void)setSaveThreshold:(NSUInteger)threshold {
    dispatch_block_t block = ^{
        @autoreleasepool {
            if (self->_saveThreshold != threshold) {
                self->_saveThreshold = threshold;
                if ((self->_unsavedCount >= self->_saveThreshold) && (self->_saveThreshold > 0)) {
                    [self performSaveAndSuspendSaveTimer];
                }
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (NSTimeInterval)saveInterval {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    __block NSTimeInterval result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, ^{
            result = self->_saveInterval;
        });
    });
    return result;
}
- (void)setSaveInterval:(NSTimeInterval)interval {
    dispatch_block_t block = ^{
        @autoreleasepool {
            if ( islessgreater(self->_saveInterval, interval)) {
                self->_saveInterval = interval;
                if (self->_saveInterval > 0.0) {
                    if (self->_saveTimer == NULL) {
                        [self createSuspendedSaveTimer];
                        [self updateAndResumeSaveTimer];
                    } else {
                        [self updateAndResumeSaveTimer];
                    }
                } else if (self->_saveTimer) {
                    [self destroySaveTimer];
                }
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (NSTimeInterval)maxAge {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    __block NSTimeInterval result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, ^{
            result = self->_maxAge;
        });
    });
    return result;
}
- (void)setMaxAge:(NSTimeInterval)interval {
    dispatch_block_t block = ^{
        @autoreleasepool {
            if ( islessgreater(self->_maxAge, interval)) {
                NSTimeInterval oldMaxAge = self->_maxAge;
                NSTimeInterval newMaxAge = interval;
                self->_maxAge = interval;
                BOOL shouldDeleteNow = NO;
                if (oldMaxAge > 0.0) {
                    if (newMaxAge <= 0.0) {
                        [self destroyDeleteTimer];
                    } else if (oldMaxAge > newMaxAge) {
                        shouldDeleteNow = YES;
                    }
                } else if (newMaxAge > 0.0) {
                    shouldDeleteNow = YES;
                }
                if (shouldDeleteNow) {
                    [self performDelete];
                    if (self->_deleteTimer) {
                        [self updateDeleteTimer];
                    } else {
                        [self createAndStartDeleteTimer];
                    }
                }
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (NSTimeInterval)deleteInterval {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    __block NSTimeInterval result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, ^{
            result = self->_deleteInterval;
        });
    });
    return result;
}
- (void)setDeleteInterval:(NSTimeInterval)interval {
    dispatch_block_t block = ^{
        @autoreleasepool {
            if ( islessgreater(self->_deleteInterval, interval)) {
                self->_deleteInterval = interval;
                if (self->_deleteInterval > 0.0) {
                    if (self->_deleteTimer == NULL) {
                        [self createAndStartDeleteTimer];
                    } else {
                        [self updateDeleteTimer];
                    }
                } else if (self->_deleteTimer) {
                    [self destroyDeleteTimer];
                }
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (BOOL)deleteOnEverySave {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    __block BOOL result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, ^{
            result = self->_deleteOnEverySave;
        });
    });
    return result;
}
- (void)setDeleteOnEverySave:(BOOL)flag {
    dispatch_block_t block = ^{
        self->_deleteOnEverySave = flag;
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
#pragma mark Public API
- (void)savePendingLogEntries {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self performSaveAndSuspendSaveTimer];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_async(self.loggerQueue, block);
    }
}
- (void)deleteOldLogEntries {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self performDelete];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_async(self.loggerQueue, block);
    }
}
#pragma mark AWSDDLogger
- (void)didAddLogger {
    [self createSuspendedSaveTimer];
    [self createAndStartDeleteTimer];
}
- (void)willRemoveLogger {
    [self performSaveAndSuspendSaveTimer];
    [self destroySaveTimer];
    [self destroyDeleteTimer];
}
- (void)logMessage:(AWSDDLogMessage *)logMessage {
    if ([self db_log:logMessage]) {
        BOOL firstUnsavedEntry = (++_unsavedCount == 1);
        if ((_unsavedCount >= _saveThreshold) && (_saveThreshold > 0)) {
            [self performSaveAndSuspendSaveTimer];
        } else if (firstUnsavedEntry) {
            _unsavedTime = dispatch_time(DISPATCH_TIME_NOW, 0);
            [self updateAndResumeSaveTimer];
        }
    }
}
- (void)flush {
    [self performSaveAndSuspendSaveTimer];
}
@end