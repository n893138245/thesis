#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
@class DDLogFileInfo;
NS_ASSUME_NONNULL_BEGIN
extern unsigned long long const kDDDefaultLogMaxFileSize;
extern NSTimeInterval     const kDDDefaultLogRollingFrequency;
extern NSUInteger         const kDDDefaultLogMaxNumLogFiles;
extern unsigned long long const kDDDefaultLogFilesDiskQuota;
#pragma mark -
@protocol DDLogFileManager <NSObject>
@required
@property (readwrite, assign, atomic) NSUInteger maximumNumberOfLogFiles;
@property (readwrite, assign, atomic) unsigned long long logFilesDiskQuota;
@property (nonatomic, readonly, copy) NSString *logsDirectory;
@property (nonatomic, readonly, strong) NSArray<NSString *> *unsortedLogFilePaths;
@property (nonatomic, readonly, strong) NSArray<NSString *> *unsortedLogFileNames;
@property (nonatomic, readonly, strong) NSArray<DDLogFileInfo *> *unsortedLogFileInfos;
@property (nonatomic, readonly, strong) NSArray<NSString *> *sortedLogFilePaths;
@property (nonatomic, readonly, strong) NSArray<NSString *> *sortedLogFileNames;
@property (nonatomic, readonly, strong) NSArray<DDLogFileInfo *> *sortedLogFileInfos;
- (nullable NSString *)createNewLogFileWithError:(NSError **)error;
@optional
- (nullable NSString *)createNewLogFile __attribute__((deprecated("Use -createNewLogFileWithError:"))) NS_SWIFT_UNAVAILABLE("Use -createNewLogFileWithError:");
- (void)didArchiveLogFile:(NSString *)logFilePath wasRolled:(BOOL)wasRolled NS_SWIFT_NAME(didArchiveLogFile(atPath:wasRolled:));
- (void)didArchiveLogFile:(NSString *)logFilePath NS_SWIFT_NAME(didArchiveLogFile(atPath:)) __attribute__((deprecated("Use -didArchiveLogFile:wasRolled:")));
- (void)didRollAndArchiveLogFile:(NSString *)logFilePath NS_SWIFT_NAME(didRollAndArchiveLogFile(atPath:)) __attribute__((deprecated("Use -didArchiveLogFile:wasRolled:")));
@end
#pragma mark -
@interface DDLogFileManagerDefault : NSObject <DDLogFileManager>
- (instancetype)init;
- (instancetype)initWithLogsDirectory:(nullable NSString *)logsDirectory NS_DESIGNATED_INITIALIZER;
#if TARGET_OS_IPHONE
- (instancetype)initWithLogsDirectory:(nullable NSString *)logsDirectory
           defaultFileProtectionLevel:(NSFileProtectionType)fileProtectionLevel;
#endif
@property (readonly, copy) NSString *newLogFileName;
- (BOOL)isLogFile:(NSString *)fileName NS_SWIFT_NAME(isLogFile(withName:));
@property (readonly, copy, nullable) NSString *logFileHeader;
@end
#pragma mark -
@interface DDLogFileFormatterDefault : NSObject <DDLogFormatter>
- (instancetype)init;
- (instancetype)initWithDateFormatter:(nullable NSDateFormatter *)dateFormatter NS_DESIGNATED_INITIALIZER;
@end
#pragma mark -
@interface DDFileLogger : DDAbstractLogger <DDLogger>
- (instancetype)init;
- (instancetype)initWithLogFileManager:(id <DDLogFileManager>)logFileManager;
- (instancetype)initWithLogFileManager:(id <DDLogFileManager>)logFileManager
                       completionQueue:(nullable dispatch_queue_t)dispatchQueue NS_DESIGNATED_INITIALIZER;
- (void)willLogMessage __attribute__((deprecated("Use -willLogMessage:"))) NS_REQUIRES_SUPER;
- (void)didLogMessage __attribute__((deprecated("Use -didLogMessage:"))) NS_REQUIRES_SUPER;
- (void)willLogMessage:(DDLogFileInfo *)logFileInfo NS_REQUIRES_SUPER;
- (void)didLogMessage:(DDLogFileInfo *)logFileInfo NS_REQUIRES_SUPER;
- (void)flush NS_REQUIRES_SUPER;
- (BOOL)shouldArchiveRecentLogFileInfo:(DDLogFileInfo *)recentLogFileInfo;
@property (readwrite, assign) unsigned long long maximumFileSize;
@property (readwrite, assign) NSTimeInterval rollingFrequency;
@property (readwrite, assign, atomic) BOOL doNotReuseLogFiles;
@property (strong, nonatomic, readonly) id <DDLogFileManager> logFileManager;
@property (nonatomic, readwrite, assign) BOOL automaticallyAppendNewlineForCustomFormatters;
- (void)rollLogFileWithCompletionBlock:(nullable void (^)(void))completionBlock
    NS_SWIFT_NAME(rollLogFile(withCompletion:));
- (void)rollLogFile __attribute__((deprecated("Use -rollLogFileWithCompletionBlock:")));
@property (nonatomic, nullable, readonly, strong) DDLogFileInfo *currentLogFileInfo;
@end
#pragma mark -
@interface DDLogFileInfo : NSObject
@property (strong, nonatomic, readonly) NSString *filePath;
@property (strong, nonatomic, readonly) NSString *fileName;
@property (strong, nonatomic, readonly) NSDictionary<NSFileAttributeKey, id> *fileAttributes;
@property (strong, nonatomic, nullable, readonly) NSDate *creationDate;
@property (strong, nonatomic, nullable, readonly) NSDate *modificationDate;
@property (nonatomic, readonly) unsigned long long fileSize;
@property (nonatomic, readonly) NSTimeInterval age;
@property (nonatomic, readwrite) BOOL isArchived;
+ (nullable instancetype)logFileWithPath:(nullable NSString *)filePath NS_SWIFT_UNAVAILABLE("Use init(filePath:)");
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFilePath:(NSString *)filePath NS_DESIGNATED_INITIALIZER;
- (void)reset;
- (void)renameFile:(NSString *)newFileName NS_SWIFT_NAME(renameFile(to:));
- (BOOL)hasExtendedAttributeWithName:(NSString *)attrName;
- (void)addExtendedAttributeWithName:(NSString *)attrName;
- (void)removeExtendedAttributeWithName:(NSString *)attrName;
- (NSComparisonResult)reverseCompareByCreationDate:(DDLogFileInfo *)another;
- (NSComparisonResult)reverseCompareByModificationDate:(DDLogFileInfo *)another;
@end
NS_ASSUME_NONNULL_END