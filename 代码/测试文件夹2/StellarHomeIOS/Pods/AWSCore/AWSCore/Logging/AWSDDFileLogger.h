#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
@class AWSDDLogFileInfo;
extern unsigned long long const kAWSDDDefaultLogMaxFileSize;
extern NSTimeInterval     const kAWSDDDefaultLogRollingFrequency;
extern NSUInteger         const kAWSDDDefaultLogMaxNumLogFiles;
extern unsigned long long const kAWSDDDefaultLogFilesDiskQuota;
#pragma mark -
@protocol AWSDDLogFileManager <NSObject>
@required
@property (readwrite, assign, atomic) NSUInteger maximumNumberOfLogFiles;
@property (readwrite, assign, atomic) unsigned long long logFilesDiskQuota;
@property (nonatomic, readonly, copy) NSString *logsDirectory;
@property (nonatomic, readonly, strong) NSArray<NSString *> *unsortedLogFilePaths;
@property (nonatomic, readonly, strong) NSArray<NSString *> *unsortedLogFileNames;
@property (nonatomic, readonly, strong) NSArray<AWSDDLogFileInfo *> *unsortedLogFileInfos;
@property (nonatomic, readonly, strong) NSArray<NSString *> *sortedLogFilePaths;
@property (nonatomic, readonly, strong) NSArray<NSString *> *sortedLogFileNames;
@property (nonatomic, readonly, strong) NSArray<AWSDDLogFileInfo *> *sortedLogFileInfos;
- (NSString *)createNewLogFile;
@optional
- (void)didArchiveLogFile:(NSString *)logFilePath NS_SWIFT_NAME(didArchiveLogFile(atPath:));
- (void)didRollAndArchiveLogFile:(NSString *)logFilePath NS_SWIFT_NAME(didRollAndArchiveLogFile(atPath:));
@end
#pragma mark -
@interface AWSDDLogFileManagerDefault : NSObject <AWSDDLogFileManager>
- (instancetype)init;
- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory NS_DESIGNATED_INITIALIZER;
#if TARGET_OS_IPHONE
- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory defaultFileProtectionLevel:(NSString *)fileProtectionLevel;
#endif
@property (readonly, copy) NSString *newLogFileName;
- (BOOL)isLogFile:(NSString *)fileName NS_SWIFT_NAME(isLogFile(withName:));
@end
#pragma mark -
@interface AWSDDLogFileFormatterDefault : NSObject <AWSDDLogFormatter>
- (instancetype)init;
- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter NS_DESIGNATED_INITIALIZER;
@end
#pragma mark -
@interface AWSDDFileLogger : AWSDDAbstractLogger <AWSDDLogger> {
	AWSDDLogFileInfo *_currentLogFileInfo;
}
- (instancetype)init;
- (instancetype)initWithLogFileManager:(id <AWSDDLogFileManager>)logFileManager NS_DESIGNATED_INITIALIZER;
- (void)willLogMessage NS_REQUIRES_SUPER;
- (void)didLogMessage NS_REQUIRES_SUPER;
- (BOOL)shouldArchiveRecentLogFileInfo:(AWSDDLogFileInfo *)recentLogFileInfo;
@property (readwrite, assign) unsigned long long maximumFileSize;
@property (readwrite, assign) NSTimeInterval rollingFrequency;
@property (readwrite, assign, atomic) BOOL doNotReuseLogFiles;
@property (strong, nonatomic, readonly) id <AWSDDLogFileManager> logFileManager;
@property (nonatomic, readwrite, assign) BOOL automaticallyAppendNewlineForCustomFormatters;
- (void)rollLogFileWithCompletionBlock:(void (^)(void))completionBlock NS_SWIFT_NAME(rollLogFile(withCompletion:));
- (void)rollLogFile __attribute((deprecated));
@property (nonatomic, readonly, strong) AWSDDLogFileInfo *currentLogFileInfo;
@end
#pragma mark -
@interface AWSDDLogFileInfo : NSObject
@property (strong, nonatomic, readonly) NSString *filePath;
@property (strong, nonatomic, readonly) NSString *fileName;
#if FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
@property (strong, nonatomic, readonly) NSDictionary<NSFileAttributeKey, id> *fileAttributes;
#else
@property (strong, nonatomic, readonly) NSDictionary<NSString *, id> *fileAttributes;
#endif
@property (strong, nonatomic, readonly) NSDate *creationDate;
@property (strong, nonatomic, readonly) NSDate *modificationDate;
@property (nonatomic, readonly) unsigned long long fileSize;
@property (nonatomic, readonly) NSTimeInterval age;
@property (nonatomic, readwrite) BOOL isArchived;
+ (instancetype)logFileWithPath:(NSString *)filePath NS_SWIFT_UNAVAILABLE("Use init(filePath:)");
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFilePath:(NSString *)filePath NS_DESIGNATED_INITIALIZER;
- (void)reset;
- (void)renameFile:(NSString *)newFileName NS_SWIFT_NAME(renameFile(to:));
#if TARGET_IPHONE_SIMULATOR
- (BOOL)hasExtensionAttributeWithName:(NSString *)attrName;
- (void)addExtensionAttributeWithName:(NSString *)attrName;
- (void)removeExtensionAttributeWithName:(NSString *)attrName;
#else 
- (BOOL)hasExtendedAttributeWithName:(NSString *)attrName;
- (void)addExtendedAttributeWithName:(NSString *)attrName;
- (void)removeExtendedAttributeWithName:(NSString *)attrName;
#endif 
- (NSComparisonResult)reverseCompareByCreationDate:(AWSDDLogFileInfo *)another;
- (NSComparisonResult)reverseCompareByModificationDate:(AWSDDLogFileInfo *)another;
@end