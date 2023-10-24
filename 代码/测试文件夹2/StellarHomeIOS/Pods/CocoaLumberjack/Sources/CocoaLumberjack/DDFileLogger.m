#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
#import <sys/xattr.h>
#import "DDFileLogger+Internal.h"
#ifndef DD_NSLOG_LEVEL
    #define DD_NSLOG_LEVEL 2
#endif
#define NSLogError(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(DD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)
#if TARGET_OS_IPHONE
BOOL doesAppRunInBackground(void);
#endif
unsigned long long const kDDDefaultLogMaxFileSize      = 1024 * 1024;      
NSTimeInterval     const kDDDefaultLogRollingFrequency = 60 * 60 * 24;     
NSUInteger         const kDDDefaultLogMaxNumLogFiles   = 5;                
unsigned long long const kDDDefaultLogFilesDiskQuota   = 20 * 1024 * 1024; 
NSTimeInterval     const kDDRollingLeeway              = 1.0;              
#pragma mark -
@interface DDLogFileManagerDefault () {
    NSDateFormatter *_fileDateFormatter;
    NSUInteger _maximumNumberOfLogFiles;
    unsigned long long _logFilesDiskQuota;
    NSString *_logsDirectory;
#if TARGET_OS_IPHONE
    NSFileProtectionType _defaultFileProtectionLevel;
#endif
}
@end
@implementation DDLogFileManagerDefault
@synthesize maximumNumberOfLogFiles = _maximumNumberOfLogFiles;
@synthesize logFilesDiskQuota = _logFilesDiskQuota;
- (instancetype)init {
    return [self initWithLogsDirectory:nil];
}
- (instancetype)initWithLogsDirectory:(nullable NSString *)aLogsDirectory {
    if ((self = [super init])) {
        _maximumNumberOfLogFiles = kDDDefaultLogMaxNumLogFiles;
        _logFilesDiskQuota = kDDDefaultLogFilesDiskQuota;
        _fileDateFormatter = [[NSDateFormatter alloc] init];
        [_fileDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [_fileDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [_fileDateFormatter setDateFormat: @"yyyy'-'MM'-'dd'--'HH'-'mm'-'ss'-'SSS'"];
        if (aLogsDirectory.length > 0) {
            _logsDirectory = [aLogsDirectory copy];
        } else {
            _logsDirectory = [[self defaultLogsDirectory] copy];
        }
        NSLogVerbose(@"DDFileLogManagerDefault: logsDirectory:\n%@", [self logsDirectory]);
        NSLogVerbose(@"DDFileLogManagerDefault: sortedLogFileNames:\n%@", [self sortedLogFileNames]);
    }
    return self;
}
#if TARGET_OS_IPHONE
- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory
           defaultFileProtectionLevel:(NSFileProtectionType)fileProtectionLevel {
    if ((self = [self initWithLogsDirectory:logsDirectory])) {
        if ([fileProtectionLevel isEqualToString:NSFileProtectionNone] ||
            [fileProtectionLevel isEqualToString:NSFileProtectionComplete] ||
            [fileProtectionLevel isEqualToString:NSFileProtectionCompleteUnlessOpen] ||
            [fileProtectionLevel isEqualToString:NSFileProtectionCompleteUntilFirstUserAuthentication]) {
            _defaultFileProtectionLevel = fileProtectionLevel;
        }
    }
    return self;
}
#endif
- (void)deleteOldFilesForConfigurationChange {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [self deleteOldLogFiles];
        }
    });
}
- (void)setLogFilesDiskQuota:(unsigned long long)logFilesDiskQuota {
    if (_logFilesDiskQuota != logFilesDiskQuota) {
        _logFilesDiskQuota = logFilesDiskQuota;
        NSLogInfo(@"DDFileLogManagerDefault: Responding to configuration change: logFilesDiskQuota");
        [self deleteOldFilesForConfigurationChange];
    }
}
- (void)setMaximumNumberOfLogFiles:(NSUInteger)maximumNumberOfLogFiles {
    if (_maximumNumberOfLogFiles != maximumNumberOfLogFiles) {
        _maximumNumberOfLogFiles = maximumNumberOfLogFiles;
        NSLogInfo(@"DDFileLogManagerDefault: Responding to configuration change: maximumNumberOfLogFiles");
        [self deleteOldFilesForConfigurationChange];
    }
}
#if TARGET_OS_IPHONE
- (NSFileProtectionType)logFileProtection {
    if (_defaultFileProtectionLevel.length > 0) {
        return _defaultFileProtectionLevel;
    } else if (doesAppRunInBackground()) {
        return NSFileProtectionCompleteUntilFirstUserAuthentication;
    } else {
        return NSFileProtectionCompleteUnlessOpen;
    }
}
#endif
#pragma mark File Deleting
- (void)deleteOldLogFiles {
    NSLogVerbose(@"DDLogFileManagerDefault: deleteOldLogFiles");
    NSArray *sortedLogFileInfos = [self sortedLogFileInfos];
    NSUInteger firstIndexToDelete = NSNotFound;
    const unsigned long long diskQuota = self.logFilesDiskQuota;
    const NSUInteger maxNumLogFiles = self.maximumNumberOfLogFiles;
    if (diskQuota) {
        unsigned long long used = 0;
        for (NSUInteger i = 0; i < sortedLogFileInfos.count; i++) {
            DDLogFileInfo *info = sortedLogFileInfos[i];
            used += info.fileSize;
            if (used > diskQuota) {
                firstIndexToDelete = i;
                break;
            }
        }
    }
    if (maxNumLogFiles) {
        if (firstIndexToDelete == NSNotFound) {
            firstIndexToDelete = maxNumLogFiles;
        } else {
            firstIndexToDelete = MIN(firstIndexToDelete, maxNumLogFiles);
        }
    }
    if (firstIndexToDelete == 0) {
        if (sortedLogFileInfos.count > 0) {
            DDLogFileInfo *logFileInfo = sortedLogFileInfos[0];
            if (!logFileInfo.isArchived) {
                ++firstIndexToDelete;
            }
        }
    }
    if (firstIndexToDelete != NSNotFound) {
        for (NSUInteger i = firstIndexToDelete; i < sortedLogFileInfos.count; i++) {
            DDLogFileInfo *logFileInfo = sortedLogFileInfos[i];
            NSError *error = nil;
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:&error];
            if (success) {
                NSLogInfo(@"DDLogFileManagerDefault: Deleting file: %@", logFileInfo.fileName);
            } else {
                NSLogError(@"DDLogFileManagerDefault: Error deleting file %@", error);
            }
        }
    }
}
#pragma mark Log Files
- (NSString *)defaultLogsDirectory {
#if TARGET_OS_IPHONE
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
#else
    NSString *appName = [[NSProcessInfo processInfo] processName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    NSString *logsDirectory = [[basePath stringByAppendingPathComponent:@"Logs"] stringByAppendingPathComponent:appName];
#endif
    return logsDirectory;
}
- (NSString *)logsDirectory {
    NSAssert(_logsDirectory.length > 0, @"Directory must be set.");
    NSError *err = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_logsDirectory
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&err];
    if (success == NO) {
        NSLogError(@"DDFileLogManagerDefault: Error creating logsDirectory: %@", err);
    }
    return _logsDirectory;
}
- (BOOL)isLogFile:(NSString *)fileName {
    NSString *appName = [self applicationName];
    BOOL hasProperPrefix = [fileName hasPrefix:[appName stringByAppendingString:@" "]];
    BOOL hasProperSuffix = [fileName hasSuffix:@".log"];
    return (hasProperPrefix && hasProperSuffix);
}
- (NSDateFormatter *)logFileDateFormatter {
    return _fileDateFormatter;
}
- (NSArray *)unsortedLogFilePaths {
    NSString *logsDirectory = [self logsDirectory];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logsDirectory error:nil];
    NSMutableArray *unsortedLogFilePaths = [NSMutableArray arrayWithCapacity:[fileNames count]];
    for (NSString *fileName in fileNames) {
#if TARGET_IPHONE_SIMULATOR
        NSString *theFileName = [fileName stringByReplacingOccurrencesOfString:@".archived"
                                                                    withString:@""];
        if ([self isLogFile:theFileName])
#else
        if ([self isLogFile:fileName])
#endif
        {
            NSString *filePath = [logsDirectory stringByAppendingPathComponent:fileName];
            [unsortedLogFilePaths addObject:filePath];
        }
    }
    return unsortedLogFilePaths;
}
- (NSArray *)unsortedLogFileNames {
    NSArray *unsortedLogFilePaths = [self unsortedLogFilePaths];
    NSMutableArray *unsortedLogFileNames = [NSMutableArray arrayWithCapacity:[unsortedLogFilePaths count]];
    for (NSString *filePath in unsortedLogFilePaths) {
        [unsortedLogFileNames addObject:[filePath lastPathComponent]];
    }
    return unsortedLogFileNames;
}
- (NSArray *)unsortedLogFileInfos {
    NSArray *unsortedLogFilePaths = [self unsortedLogFilePaths];
    NSMutableArray *unsortedLogFileInfos = [NSMutableArray arrayWithCapacity:[unsortedLogFilePaths count]];
    for (NSString *filePath in unsortedLogFilePaths) {
        DDLogFileInfo *logFileInfo = [[DDLogFileInfo alloc] initWithFilePath:filePath];
        [unsortedLogFileInfos addObject:logFileInfo];
    }
    return unsortedLogFileInfos;
}
- (NSArray *)sortedLogFilePaths {
    NSArray *sortedLogFileInfos = [self sortedLogFileInfos];
    NSMutableArray *sortedLogFilePaths = [NSMutableArray arrayWithCapacity:[sortedLogFileInfos count]];
    for (DDLogFileInfo *logFileInfo in sortedLogFileInfos) {
        [sortedLogFilePaths addObject:[logFileInfo filePath]];
    }
    return sortedLogFilePaths;
}
- (NSArray *)sortedLogFileNames {
    NSArray *sortedLogFileInfos = [self sortedLogFileInfos];
    NSMutableArray *sortedLogFileNames = [NSMutableArray arrayWithCapacity:[sortedLogFileInfos count]];
    for (DDLogFileInfo *logFileInfo in sortedLogFileInfos) {
        [sortedLogFileNames addObject:[logFileInfo fileName]];
    }
    return sortedLogFileNames;
}
- (NSArray *)sortedLogFileInfos {
    return [[self unsortedLogFileInfos] sortedArrayUsingComparator:^NSComparisonResult(DDLogFileInfo *obj1,
                                                                                       DDLogFileInfo *obj2) {
        NSDate *date1 = [NSDate new];
        NSDate *date2 = [NSDate new];
        NSArray<NSString *> *arrayComponent = [[obj1 fileName] componentsSeparatedByString:@" "];
        if (arrayComponent.count > 0) {
            NSString *stringDate = arrayComponent.lastObject;
            stringDate = [stringDate stringByReplacingOccurrencesOfString:@".log" withString:@""];
#if TARGET_IPHONE_SIMULATOR
            stringDate = [stringDate stringByReplacingOccurrencesOfString:@".archived" withString:@""];
#endif
            date1 = [[self logFileDateFormatter] dateFromString:stringDate] ?: [obj1 creationDate];
        }
        arrayComponent = [[obj2 fileName] componentsSeparatedByString:@" "];
        if (arrayComponent.count > 0) {
            NSString *stringDate = arrayComponent.lastObject;
            stringDate = [stringDate stringByReplacingOccurrencesOfString:@".log" withString:@""];
#if TARGET_IPHONE_SIMULATOR
            stringDate = [stringDate stringByReplacingOccurrencesOfString:@".archived" withString:@""];
#endif
            date2 = [[self logFileDateFormatter] dateFromString:stringDate] ?: [obj2 creationDate];
        }
        return [date2 compare:date1 ?: [NSDate new]];
    }];
}
#pragma mark Creation
- (NSString *)newLogFileName {
    NSString *appName = [self applicationName];
    NSDateFormatter *dateFormatter = [self logFileDateFormatter];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@ %@.log", appName, formattedDate];
}
- (nullable NSString *)logFileHeader {
    return nil;
}
- (NSData *)logFileHeaderData {
    NSString *fileHeaderStr = [self logFileHeader];
    if (fileHeaderStr.length == 0) {
        return nil;
    }
    if (![fileHeaderStr hasSuffix:@"\n"]) {
        fileHeaderStr = [fileHeaderStr stringByAppendingString:@"\n"];
    }
    return [fileHeaderStr dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)createNewLogFileWithError:(NSError *__autoreleasing  _Nullable *)error {
    static NSUInteger MAX_ALLOWED_ERROR = 5;
    NSString *fileName = [self newLogFileName];
    NSString *logsDirectory = [self logsDirectory];
    NSData *fileHeader = [self logFileHeaderData];
    if (fileHeader == nil) {
        fileHeader = [NSData new];
    }
    NSUInteger attempt = 1;
    NSUInteger criticalErrors = 0;
    NSError *lastCriticalError;
    do {
        if (criticalErrors >= MAX_ALLOWED_ERROR) {
            NSLogError(@"DDLogFileManagerDefault: Bailing file creation, encountered %ld errors.",
                        (unsigned long)criticalErrors);
            *error = lastCriticalError;
            return nil;
        }
        NSString *actualFileName = fileName;
        if (attempt > 1) {
            NSString *extension = [actualFileName pathExtension];
            actualFileName = [actualFileName stringByDeletingPathExtension];
            actualFileName = [actualFileName stringByAppendingFormat:@" %lu", (unsigned long)attempt];
            if (extension.length) {
                actualFileName = [actualFileName stringByAppendingPathExtension:extension];
            }
        }
        NSString *filePath = [logsDirectory stringByAppendingPathComponent:actualFileName];
        NSError *currentError = nil;
        BOOL success = [fileHeader writeToFile:filePath options:NSDataWritingAtomic error:&currentError];
#if TARGET_OS_IPHONE
        if (success) {
            NSDictionary *attributes = @{NSFileProtectionKey: [self logFileProtection]};
            success = [[NSFileManager defaultManager] setAttributes:attributes
                                                       ofItemAtPath:filePath
                                                              error:&currentError];
        }
#endif
        if (success) {
            NSLogVerbose(@"DDLogFileManagerDefault: Created new log file: %@", actualFileName);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self deleteOldLogFiles];
            });
            return filePath;
        } else if (currentError.code == NSFileWriteFileExistsError) {
            attempt++;
            continue;
        } else {
            NSLogError(@"DDLogFileManagerDefault: Critical error while creating log file: %@", currentError);
            criticalErrors++;
            lastCriticalError = currentError;
            continue;
        }
        return filePath;
    } while (YES);
}
#pragma mark Utility
- (NSString *)applicationName {
    static NSString *_appName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        if (_appName.length == 0) {
            _appName = [[NSProcessInfo processInfo] processName];
        }
        if (_appName.length == 0) {
            _appName = @"";
        }
    });
    return _appName;
}
@end
#pragma mark -
@interface DDLogFileFormatterDefault () {
    NSDateFormatter *_dateFormatter;
}
@end
@implementation DDLogFileFormatterDefault
- (instancetype)init {
    return [self initWithDateFormatter:nil];
}
- (instancetype)initWithDateFormatter:(nullable NSDateFormatter *)aDateFormatter {
    if ((self = [super init])) {
        if (aDateFormatter) {
            _dateFormatter = aDateFormatter;
        } else {
            _dateFormatter = [[NSDateFormatter alloc] init];
            [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; 
            [_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
            [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [_dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        }
    }
    return self;
}
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *dateAndTime = [_dateFormatter stringFromDate:logMessage->_timestamp];
    return [NSString stringWithFormat:@"%@  %@", dateAndTime, logMessage->_message];
}
@end
#pragma mark -
@interface DDFileLogger () {
    id <DDLogFileManager> _logFileManager;
    DDLogFileInfo *_currentLogFileInfo;
    NSFileHandle *_currentLogFileHandle;
    dispatch_source_t _currentLogFileVnode;
    NSTimeInterval _rollingFrequency;
    dispatch_source_t _rollingTimer;
    unsigned long long _maximumFileSize;
    dispatch_queue_t _completionQueue;
}
@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation DDFileLogger
#pragma clang diagnostic pop
- (instancetype)init {
    DDLogFileManagerDefault *defaultLogFileManager = [[DDLogFileManagerDefault alloc] init];
    return [self initWithLogFileManager:defaultLogFileManager completionQueue:nil];
}
- (instancetype)initWithLogFileManager:(id<DDLogFileManager>)logFileManager {
    return [self initWithLogFileManager:logFileManager completionQueue:nil];
}
- (instancetype)initWithLogFileManager:(id <DDLogFileManager>)aLogFileManager
                       completionQueue:(nullable dispatch_queue_t)dispatchQueue {
    if ((self = [super init])) {
        _completionQueue = dispatchQueue ?: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _maximumFileSize = kDDDefaultLogMaxFileSize;
        _rollingFrequency = kDDDefaultLogRollingFrequency;
        _automaticallyAppendNewlineForCustomFormatters = YES;
        _logFileManager = aLogFileManager;
        _logFormatter = [DDLogFileFormatterDefault new];
    }
    return self;
}
- (void)lt_cleanup {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
        __autoreleasing NSError *error;
        BOOL synchronized = [_currentLogFileHandle synchronizeAndReturnError:&error];
        if (!synchronized) {
            NSLogError(@"DDFileLogger: Failed to synchronize file: %@", error);
        }
        BOOL closed = [_currentLogFileHandle closeAndReturnError:&error];
        if (!closed) {
            NSLogError(@"DDFileLogger: Failed to close file: %@", error);
        }
    } else {
        [_currentLogFileHandle synchronizeFile];
        [_currentLogFileHandle closeFile];
    }
    if (_currentLogFileVnode) {
        dispatch_source_cancel(_currentLogFileVnode);
        _currentLogFileVnode = NULL;
    }
    if (_rollingTimer) {
        dispatch_source_cancel(_rollingTimer);
        _rollingTimer = NULL;
    }
}
- (void)dealloc {
    if (self.isOnInternalLoggerQueue) {
        [self lt_cleanup];
    } else {
        dispatch_sync(self.loggerQueue, ^{
            [self lt_cleanup];
        });
    }
}
#pragma mark Properties
- (unsigned long long)maximumFileSize {
    __block unsigned long long result;
    dispatch_block_t block = ^{
        result = self->_maximumFileSize;
    };
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, block);
    });
    return result;
}
- (void)setMaximumFileSize:(unsigned long long)newMaximumFileSize {
    dispatch_block_t block = ^{
        @autoreleasepool {
            self->_maximumFileSize = newMaximumFileSize;
            [self lt_maybeRollLogFileDueToSize];
        }
    };
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(self.loggerQueue, block);
    });
}
- (NSTimeInterval)rollingFrequency {
    __block NSTimeInterval result;
    dispatch_block_t block = ^{
        result = self->_rollingFrequency;
    };
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, block);
    });
    return result;
}
- (void)setRollingFrequency:(NSTimeInterval)newRollingFrequency {
    dispatch_block_t block = ^{
        @autoreleasepool {
            self->_rollingFrequency = newRollingFrequency;
            [self lt_maybeRollLogFileDueToAge];
        }
    };
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(self.loggerQueue, block);
    });
}
#pragma mark File Rolling
- (void)lt_scheduleTimerToRollLogFileDueToAge {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    if (_rollingTimer) {
        dispatch_source_cancel(_rollingTimer);
        _rollingTimer = NULL;
    }
    if (_currentLogFileInfo == nil || _rollingFrequency <= 0.0) {
        return;
    }
    NSDate *logFileCreationDate = [_currentLogFileInfo creationDate];
    NSTimeInterval frequency = MIN(_rollingFrequency, DBL_MAX - [logFileCreationDate timeIntervalSinceReferenceDate]);
    NSDate *logFileRollingDate = [logFileCreationDate dateByAddingTimeInterval:frequency];
    NSLogVerbose(@"DDFileLogger: scheduleTimerToRollLogFileDueToAge");
    NSLogVerbose(@"DDFileLogger: logFileCreationDate    : %@", logFileCreationDate);
    NSLogVerbose(@"DDFileLogger: actual rollingFrequency: %f", frequency);
    NSLogVerbose(@"DDFileLogger: logFileRollingDate     : %@", logFileRollingDate);
    _rollingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _loggerQueue);
    __weak __auto_type weakSelf = self;
    dispatch_source_set_event_handler(_rollingTimer, ^{ @autoreleasepool {
        [weakSelf lt_maybeRollLogFileDueToAge];
    } });
    #if !OS_OBJECT_USE_OBJC
    dispatch_source_t theRollingTimer = _rollingTimer;
    dispatch_source_set_cancel_handler(_rollingTimer, ^{
        dispatch_release(theRollingTimer);
    });
    #endif
    static NSTimeInterval const kDDMaxTimerDelay = LLONG_MAX / NSEC_PER_SEC;
    int64_t delay = (int64_t)(MIN([logFileRollingDate timeIntervalSinceNow], kDDMaxTimerDelay) * (NSTimeInterval) NSEC_PER_SEC);
    dispatch_time_t fireTime = dispatch_time(DISPATCH_TIME_NOW, delay);
    dispatch_source_set_timer(_rollingTimer, fireTime, DISPATCH_TIME_FOREVER, (uint64_t)kDDRollingLeeway * NSEC_PER_SEC);
    if (@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *))
        dispatch_activate(_rollingTimer);
    else
        dispatch_resume(_rollingTimer);
}
- (void)rollLogFile {
    [self rollLogFileWithCompletionBlock:nil];
}
- (void)rollLogFileWithCompletionBlock:(nullable void (^)(void))completionBlock {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self lt_rollLogFileNow];
            if (completionBlock) {
                dispatch_async(self->_completionQueue, ^{
                    completionBlock();
                });
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)lt_rollLogFileNow {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    NSLogVerbose(@"DDFileLogger: rollLogFileNow");
    if (_currentLogFileHandle == nil) {
        return;
    }
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
        __autoreleasing NSError *error;
        BOOL synchronized = [_currentLogFileHandle synchronizeAndReturnError:&error];
        if (!synchronized) {
            NSLogError(@"DDFileLogger: Failed to synchronize file: %@", error);
        }
        BOOL closed = [_currentLogFileHandle closeAndReturnError:&error];
        if (!closed) {
            NSLogError(@"DDFileLogger: Failed to close file: %@", error);
        }
    } else {
        [_currentLogFileHandle synchronizeFile];
        [_currentLogFileHandle closeFile];
    }
    _currentLogFileHandle = nil;
    _currentLogFileInfo.isArchived = YES;
    const BOOL logFileManagerRespondsToNewArchiveSelector = [_logFileManager respondsToSelector:@selector(didArchiveLogFile:wasRolled:)];
    const BOOL logFileManagerRespondsToSelector = (logFileManagerRespondsToNewArchiveSelector
                                                   || [_logFileManager respondsToSelector:@selector(didRollAndArchiveLogFile:)]);
    NSString *archivedFilePath = (logFileManagerRespondsToSelector) ? [_currentLogFileInfo.filePath copy] : nil;
    _currentLogFileInfo = nil;
    if (logFileManagerRespondsToSelector) {
        dispatch_block_t block;
        if (logFileManagerRespondsToNewArchiveSelector) {
            block = ^{
                [self->_logFileManager didArchiveLogFile:archivedFilePath wasRolled:YES];
            };
        } else {
            block = ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [self->_logFileManager didRollAndArchiveLogFile:archivedFilePath];
#pragma clang diagnostic pop
            };
        }
        dispatch_async(_completionQueue, block);
    }
    if (_currentLogFileVnode) {
        dispatch_source_cancel(_currentLogFileVnode);
        _currentLogFileVnode = nil;
    }
    if (_rollingTimer) {
        dispatch_source_cancel(_rollingTimer);
        _rollingTimer = nil;
    }
}
- (void)lt_maybeRollLogFileDueToAge {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    if (_rollingFrequency > 0.0 && (_currentLogFileInfo.age + kDDRollingLeeway) >= _rollingFrequency) {
        NSLogVerbose(@"DDFileLogger: Rolling log file due to age...");
        [self lt_rollLogFileNow];
    } else {
        [self lt_scheduleTimerToRollLogFileDueToAge];
    }
}
- (void)lt_maybeRollLogFileDueToSize {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    if (_maximumFileSize > 0) {
        unsigned long long fileSize;
        if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
            __autoreleasing NSError *error;
            BOOL succeed = [_currentLogFileHandle getOffset:&fileSize error:&error];
            if (!succeed) {
                NSLogError(@"DDFileLogger: Failed to get offset: %@", error);
                return;
            }
        } else {
            fileSize = [_currentLogFileHandle offsetInFile];
        }
        if (fileSize >= _maximumFileSize) {
            NSLogVerbose(@"DDFileLogger: Rolling log file due to size (%qu)...", fileSize);
            [self lt_rollLogFileNow];
        }
    }
}
#pragma mark File Logging
- (BOOL)lt_shouldLogFileBeArchived:(DDLogFileInfo *)mostRecentLogFileInfo {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    if ([self shouldArchiveRecentLogFileInfo:mostRecentLogFileInfo]) {
        return YES;
    } else if (_maximumFileSize > 0 && mostRecentLogFileInfo.fileSize >= _maximumFileSize) {
        return YES;
    } else if (_rollingFrequency > 0.0 && mostRecentLogFileInfo.age >= _rollingFrequency) {
        return YES;
    }
#if TARGET_OS_IPHONE
    if (doesAppRunInBackground()) {
        NSFileProtectionType key = mostRecentLogFileInfo.fileAttributes[NSFileProtectionKey];
        BOOL isUntilFirstAuth = [key isEqualToString:NSFileProtectionCompleteUntilFirstUserAuthentication];
        BOOL isNone = [key isEqualToString:NSFileProtectionNone];
        if (key != nil && !isUntilFirstAuth && !isNone) {
            return YES;
        }
    }
#endif
    return NO;
}
- (DDLogFileInfo *)currentLogFileInfo {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    __block DDLogFileInfo *info = nil;
    dispatch_block_t block = ^{
        info = [self lt_currentLogFileInfo];
    };
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self->_loggerQueue, block);
    });
    return info;
}
- (DDLogFileInfo *)lt_currentLogFileInfo {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    DDLogFileInfo *newCurrentLogFile = _currentLogFileInfo;
    BOOL isResuming = newCurrentLogFile == nil;
    if (isResuming) {
        NSArray *sortedLogFileInfos = [_logFileManager sortedLogFileInfos];
        newCurrentLogFile = sortedLogFileInfos.firstObject;
    }
    if (newCurrentLogFile != nil && [self lt_shouldUseLogFile:newCurrentLogFile isResuming:isResuming]) {
        if (isResuming) {
            NSLogVerbose(@"DDFileLogger: Resuming logging with file %@", newCurrentLogFile.fileName);
        }
        _currentLogFileInfo = newCurrentLogFile;
    } else {
        NSString *currentLogFilePath;
        if ([_logFileManager respondsToSelector:@selector(createNewLogFileWithError:)]) {
            __autoreleasing NSError *error;
            currentLogFilePath = [_logFileManager createNewLogFileWithError:&error];
            if (!currentLogFilePath) {
                NSLogError(@"DDFileLogger: Failed to create new log file: %@", error);
            }
        } else {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            NSAssert([_logFileManager respondsToSelector:@selector(createNewLogFile)],
                     @"Invalid log file manager! Responds neither to `-createNewLogFileWithError:` nor `-createNewLogFile`!");
            currentLogFilePath = [_logFileManager createNewLogFile];
            #pragma clang diagnostic pop
        }
        _currentLogFileInfo = [DDLogFileInfo logFileWithPath:currentLogFilePath];
    }
    return _currentLogFileInfo;
}
- (BOOL)lt_shouldUseLogFile:(nonnull DDLogFileInfo *)logFileInfo isResuming:(BOOL)isResuming {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    NSParameterAssert(logFileInfo);
    if (logFileInfo.isArchived) {
        return NO;
    }
    if (isResuming && (_doNotReuseLogFiles || [self lt_shouldLogFileBeArchived:logFileInfo])) {
        logFileInfo.isArchived = YES;
        const BOOL logFileManagerRespondsToNewArchiveSelector = [_logFileManager respondsToSelector:@selector(didArchiveLogFile:wasRolled:)];
        if (logFileManagerRespondsToNewArchiveSelector || [_logFileManager respondsToSelector:@selector(didArchiveLogFile:)]) {
            NSString *archivedFilePath = [logFileInfo.filePath copy];
            dispatch_block_t block;
            if (logFileManagerRespondsToNewArchiveSelector) {
                block = ^{
                    [self->_logFileManager didArchiveLogFile:archivedFilePath wasRolled:NO];
                };
            } else {
                block = ^{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [self->_logFileManager didArchiveLogFile:archivedFilePath];
    #pragma clang diagnostic pop
                };
            }
            dispatch_async(_completionQueue, block);
        }
        return NO;
    }
    return YES;
}
- (void)lt_monitorCurrentLogFileForExternalChanges {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    NSAssert(_currentLogFileHandle, @"Can not monitor without handle.");
    _currentLogFileVnode = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                                  (uintptr_t)[_currentLogFileHandle fileDescriptor],
                                                  DISPATCH_VNODE_DELETE | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE,
                                                  _loggerQueue);
    __weak __auto_type weakSelf = self;
    dispatch_source_set_event_handler(_currentLogFileVnode, ^{ @autoreleasepool {
        NSLogInfo(@"DDFileLogger: Current logfile was moved. Rolling it and creating a new one");
        [weakSelf lt_rollLogFileNow];
    } });
#if !OS_OBJECT_USE_OBJC
    dispatch_source_t vnode = _currentLogFileVnode;
    dispatch_source_set_cancel_handler(_currentLogFileVnode, ^{
        dispatch_release(vnode);
    });
#endif
    if (@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)) {
        dispatch_activate(_currentLogFileVnode);
    } else {
        dispatch_resume(_currentLogFileVnode);
    }
}
- (NSFileHandle *)lt_currentLogFileHandle {
    NSAssert([self isOnInternalLoggerQueue], @"lt_ methods should be on logger queue.");
    if (!_currentLogFileHandle) {
        NSString *logFilePath = [[self lt_currentLogFileInfo] filePath];
        _currentLogFileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
            __autoreleasing NSError *error;
            BOOL succeed = [_currentLogFileHandle seekToEndReturningOffset:nil error:&error];
            if (!succeed) {
                NSLogError(@"DDFileLogger: Failed to seek to end of file: %@", error);
            }
        } else {
            [_currentLogFileHandle seekToEndOfFile];
        }
        if (_currentLogFileHandle) {
            [self lt_scheduleTimerToRollLogFileDueToAge];
            [self lt_monitorCurrentLogFileForExternalChanges];
        }
    }
    return _currentLogFileHandle;
}
#pragma mark DDLogger Protocol
static int exception_count = 0;
- (void)logMessage:(DDLogMessage *)logMessage {
    NSData *data = [self lt_dataForMessage:logMessage];
    if (data.length == 0) {
        return;
    }
    [self lt_logData:data];
}
- (void)willLogMessage:(DDLogFileInfo *)logFileInfo {}
- (void)didLogMessage:(DDLogFileInfo *)logFileInfo {
    [self lt_maybeRollLogFileDueToSize];
}
- (BOOL)shouldArchiveRecentLogFileInfo:(__unused DDLogFileInfo *)recentLogFileInfo {
    return NO;
}
- (void)willRemoveLogger {
    [self lt_rollLogFileNow];
}
- (void)flush {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self lt_flush];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_sync(globalLoggingQueue, ^{
            dispatch_sync(self.loggerQueue, block);
        });
    }
}
- (void)lt_flush {
    NSAssert([self isOnInternalLoggerQueue], @"flush should only be executed on internal queue.");
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
        __autoreleasing NSError *error;
        BOOL succeed = [_currentLogFileHandle synchronizeAndReturnError:&error];
        if (!succeed) {
            NSLogError(@"DDFileLogger: Failed to synchronize file: %@", error);
        }
    } else {
        [_currentLogFileHandle synchronizeFile];
    }
}
- (DDLoggerName)loggerName {
    return DDLoggerNameFile;
}
@end
@implementation DDFileLogger (Internal)
- (void)logData:(NSData *)data {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self lt_logData:data];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_sync(globalLoggingQueue, ^{
            dispatch_sync(self.loggerQueue, block);
        });
    }
}
- (void)lt_deprecationCatchAll {}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(willLogMessage) || aSelector == @selector(didLogMessage)) {
        return [self methodSignatureForSelector:@selector(lt_deprecationCatchAll)];
    }
    return [super methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector != @selector(lt_deprecationCatchAll)) {
        [super forwardInvocation:anInvocation];
    }
}
- (void)lt_logData:(NSData *)data {
    static BOOL implementsDeprecatedWillLog = NO;
    static BOOL implementsDeprecatedDidLog = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        implementsDeprecatedWillLog = [self respondsToSelector:@selector(willLogMessage)];
        implementsDeprecatedDidLog = [self respondsToSelector:@selector(didLogMessage)];
    });
    NSAssert([self isOnInternalLoggerQueue], @"logMessage should only be executed on internal queue.");
    if (data.length == 0) {
        return;
    }
    @try {
        if (implementsDeprecatedWillLog) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self willLogMessage];
#pragma clang diagnostic pop
        } else {
            [self willLogMessage:_currentLogFileInfo];
        }
        NSFileHandle *handle = [self lt_currentLogFileHandle];
        if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
            __autoreleasing NSError *error;
            BOOL sought = [handle seekToEndReturningOffset:nil error:&error];
            if (!sought) {
                NSLogError(@"DDFileLogger: Failed to seek to end of file: %@", error);
            }
            BOOL written =  [handle writeData:data error:&error];
            if (!written) {
                NSLogError(@"DDFileLogger: Failed to write data: %@", error);
            }
        } else {
            [handle seekToEndOfFile];
            [handle writeData:data];
        }
        if (implementsDeprecatedDidLog) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self didLogMessage];
#pragma clang diagnostic pop
        } else {
            [self didLogMessage:_currentLogFileInfo];
        }
    } @catch (NSException *exception) {
        exception_count++;
        if (exception_count <= 10) {
            NSLogError(@"DDFileLogger.logMessage: %@", exception);
            if (exception_count == 10) {
                NSLogError(@"DDFileLogger.logMessage: Too many exceptions -- will not log any more of them.");
            }
        }
    }
}
- (NSData *)lt_dataForMessage:(DDLogMessage *)logMessage {
    NSAssert([self isOnInternalLoggerQueue], @"logMessage should only be executed on internal queue.");
    NSString *message = logMessage->_message;
    BOOL isFormatted = NO;
    if (_logFormatter != nil) {
        message = [_logFormatter formatLogMessage:logMessage];
        isFormatted = message != logMessage->_message;
    }
    if (message.length == 0) {
        return nil;
    }
    BOOL shouldFormat = !isFormatted || _automaticallyAppendNewlineForCustomFormatters;
    if (shouldFormat && ![message hasSuffix:@"\n"]) {
        message = [message stringByAppendingString:@"\n"];
    }
    return [message dataUsingEncoding:NSUTF8StringEncoding];
}
@end
#pragma mark -
static NSString * const kDDXAttrArchivedName = @"lumberjack.log.archived";
@interface DDLogFileInfo () {
    __strong NSString *_filePath;
    __strong NSString *_fileName;
    __strong NSDictionary *_fileAttributes;
    __strong NSDate *_creationDate;
    __strong NSDate *_modificationDate;
    unsigned long long _fileSize;
}
#if TARGET_IPHONE_SIMULATOR
- (BOOL)_hasExtensionAttributeWithName:(NSString *)attrName;
- (void)_removeExtensionAttributeWithName:(NSString *)attrName;
#endif
@end
@implementation DDLogFileInfo
@synthesize filePath;
@dynamic fileName;
@dynamic fileAttributes;
@dynamic creationDate;
@dynamic modificationDate;
@dynamic fileSize;
@dynamic age;
@dynamic isArchived;
#pragma mark Lifecycle
+ (instancetype)logFileWithPath:(NSString *)aFilePath {
    if (!aFilePath) return nil;
    return [[self alloc] initWithFilePath:aFilePath];
}
- (instancetype)initWithFilePath:(NSString *)aFilePath {
    NSParameterAssert(aFilePath);
    if ((self = [super init])) {
        filePath = [aFilePath copy];
    }
    return self;
}
#pragma mark Standard Info
- (NSDictionary *)fileAttributes {
    if (_fileAttributes == nil && filePath != nil) {
        NSError *error = nil;
        _fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        if (error) {
            NSLogError(@"DDLogFileInfo: Failed to read file attributes: %@", error);
        }
    }
    return _fileAttributes ?: @{};
}
- (NSString *)fileName {
    if (_fileName == nil) {
        _fileName = [filePath lastPathComponent];
    }
    return _fileName;
}
- (NSDate *)modificationDate {
    if (_modificationDate == nil) {
        _modificationDate = self.fileAttributes[NSFileModificationDate];
    }
    return _modificationDate;
}
- (NSDate *)creationDate {
    if (_creationDate == nil) {
        _creationDate = self.fileAttributes[NSFileCreationDate];
    }
    return _creationDate;
}
- (unsigned long long)fileSize {
    if (_fileSize == 0) {
        _fileSize = [self.fileAttributes[NSFileSize] unsignedLongLongValue];
    }
    return _fileSize;
}
- (NSTimeInterval)age {
    return -[[self creationDate] timeIntervalSinceNow];
}
- (NSString *)description {
    return [@{ @"filePath": self.filePath ? : @"",
               @"fileName": self.fileName ? : @"",
               @"fileAttributes": self.fileAttributes ? : @"",
               @"creationDate": self.creationDate ? : @"",
               @"modificationDate": self.modificationDate ? : @"",
               @"fileSize": @(self.fileSize),
               @"age": @(self.age),
               @"isArchived": @(self.isArchived) } description];
}
#pragma mark Archiving
- (BOOL)isArchived {
    return [self hasExtendedAttributeWithName:kDDXAttrArchivedName];
}
- (void)setIsArchived:(BOOL)flag {
    if (flag) {
        [self addExtendedAttributeWithName:kDDXAttrArchivedName];
    } else {
        [self removeExtendedAttributeWithName:kDDXAttrArchivedName];
    }
}
#pragma mark Changes
- (void)reset {
    _fileName = nil;
    _fileAttributes = nil;
    _creationDate = nil;
    _modificationDate = nil;
}
- (void)renameFile:(NSString *)newFileName {
    if (![newFileName isEqualToString:[self fileName]]) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString *fileDir = [filePath stringByDeletingLastPathComponent];
        NSString *newFilePath = [fileDir stringByAppendingPathComponent:newFileName];
#if defined(DEBUG) && (!defined(TARGET_IPHONE_SIMULATOR) || !TARGET_IPHONE_SIMULATOR)
        BOOL directory = NO;
        [fileManager fileExistsAtPath:fileDir isDirectory:&directory];
        NSAssert(directory, @"Containing directory must exist.");
#endif
        NSError *error = nil;
        BOOL success = [fileManager removeItemAtPath:newFilePath error:&error];
        if (!success && error.code != NSFileNoSuchFileError) {
            NSLogError(@"DDLogFileInfo: Error deleting archive (%@): %@", self.fileName, error);
        }
        success = [fileManager moveItemAtPath:filePath toPath:newFilePath error:&error];
#if TARGET_IPHONE_SIMULATOR
        if (!success && error.code != NSFileNoSuchFileError)
#else
        if (!success)
#endif
        {
            NSLogError(@"DDLogFileInfo: Error renaming file (%@): %@", self.fileName, error);
        }
        filePath = newFilePath;
        [self reset];
    }
}
#pragma mark Attribute Management
#if TARGET_IPHONE_SIMULATOR
static NSString * const kDDExtensionSeparator = @".";
static NSString *_xattrToExtensionName(NSString *attrName) {
    static NSDictionary<NSString *, NSString *>* _xattrToExtensionNameMap;
    static dispatch_once_t _token;
    dispatch_once(&_token, ^{
        _xattrToExtensionNameMap = @{ kDDXAttrArchivedName: @"archived" };
    });
    return [_xattrToExtensionNameMap objectForKey:attrName];
}
- (BOOL)_hasExtensionAttributeWithName:(NSString *)attrName {
    NSArray *components = [[self fileName] componentsSeparatedByString:kDDExtensionSeparator];
    for (NSUInteger i = 1; i < components.count; i++) {
        NSString *attr = components[i];
        if ([attrName isEqualToString:attr]) {
            return YES;
        }
    }
    return NO;
}
- (void)_removeExtensionAttributeWithName:(NSString *)attrName {
    if ([attrName length] == 0) {
        return;
    }
    NSArray *components = [[self fileName] componentsSeparatedByString:kDDExtensionSeparator];
    NSUInteger count = [components count];
    NSUInteger estimatedNewLength = [[self fileName] length];
    NSMutableString *newFileName = [NSMutableString stringWithCapacity:estimatedNewLength];
    if (count > 0) {
        [newFileName appendString:components.firstObject];
    }
    BOOL found = NO;
    NSUInteger i;
    for (i = 1; i < count; i++) {
        NSString *attr = components[i];
        if ([attrName isEqualToString:attr]) {
            found = YES;
        } else {
            [newFileName appendString:kDDExtensionSeparator];
            [newFileName appendString:attr];
        }
    }
    if (found) {
        [self renameFile:newFileName];
    }
}
#endif 
- (BOOL)hasExtendedAttributeWithName:(NSString *)attrName {
    const char *path = [filePath fileSystemRepresentation];
    const char *name = [attrName UTF8String];
    BOOL hasExtendedAttribute = NO;
    char buffer[1];
    ssize_t result = getxattr(path, name, buffer, 1, 0, 0);
    if (result > 0 && buffer[0] == '\1') {
        hasExtendedAttribute = YES;
    }
    else if (result >= 0) {
        hasExtendedAttribute = YES;
        [self addExtendedAttributeWithName:attrName];
    }
#if TARGET_IPHONE_SIMULATOR
    else if ([self _hasExtensionAttributeWithName:_xattrToExtensionName(attrName)]) {
        hasExtendedAttribute = YES;
        [self addExtendedAttributeWithName:attrName];
    }
#endif
    return hasExtendedAttribute;
}
- (void)addExtendedAttributeWithName:(NSString *)attrName {
    const char *path = [filePath fileSystemRepresentation];
    const char *name = [attrName UTF8String];
    int result = setxattr(path, name, "\1", 1, 0, 0);
    if (result < 0) {
        if (errno != ENOENT) {
            NSLogError(@"DDLogFileInfo: setxattr(%@, %@): error = %s",
                       attrName,
                       filePath,
                       strerror(errno));
        } else {
            NSLogDebug(@"DDLogFileInfo: File does not exist in setxattr(%@, %@): error = %s",
                       attrName,
                       filePath,
                       strerror(errno));
        }
    }
#if TARGET_IPHONE_SIMULATOR
    else {
        [self _removeExtensionAttributeWithName:_xattrToExtensionName(attrName)];
    }
#endif
}
- (void)removeExtendedAttributeWithName:(NSString *)attrName {
    const char *path = [filePath fileSystemRepresentation];
    const char *name = [attrName UTF8String];
    int result = removexattr(path, name, 0);
    if (result < 0 && errno != ENOATTR) {
        NSLogError(@"DDLogFileInfo: removexattr(%@, %@): error = %s",
                   attrName,
                   self.fileName,
                   strerror(errno));
    }
#if TARGET_IPHONE_SIMULATOR
    [self _removeExtensionAttributeWithName:_xattrToExtensionName(attrName)];
#endif
}
#pragma mark Comparisons
- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        DDLogFileInfo *another = (DDLogFileInfo *)object;
        return [filePath isEqualToString:[another filePath]];
    }
    return NO;
}
- (NSUInteger)hash {
    return [filePath hash];
}
- (NSComparisonResult)reverseCompareByCreationDate:(DDLogFileInfo *)another {
    __auto_type us = [self creationDate];
    __auto_type them = [another creationDate];
    return [them compare:us];
}
- (NSComparisonResult)reverseCompareByModificationDate:(DDLogFileInfo *)another {
    __auto_type us = [self modificationDate];
    __auto_type them = [another modificationDate];
    return [them compare:us];
}
@end
#if TARGET_OS_IPHONE
BOOL doesAppRunInBackground() {
    BOOL answer = NO;
    NSArray *backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
    for (NSString *mode in backgroundModes) {
        if (mode.length > 0) {
            answer = YES;
            break;
        }
    }
    return answer;
}
#endif