#import <Foundation/Foundation.h>
#import "AWSFMResultSet.h"
#import "AWSFMDatabasePool.h"
#if ! __has_feature(objc_arc)
    #define AWSFMDBAutorelease(__v) ([__v autorelease]);
    #define AWSFMDBReturnAutoreleased AWSFMDBAutorelease
    #define AWSFMDBRetain(__v) ([__v retain]);
    #define AWSFMDBReturnRetained AWSFMDBRetain
    #define AWSFMDBRelease(__v) ([__v release]);
    #define AWSFMDBDispatchQueueRelease(__v) (dispatch_release(__v));
#else
    #define AWSFMDBAutorelease(__v)
    #define AWSFMDBReturnAutoreleased(__v) (__v)
    #define AWSFMDBRetain(__v)
    #define AWSFMDBReturnRetained(__v) (__v)
    #define AWSFMDBRelease(__v)
    #if OS_OBJECT_USE_OBJC
        #define AWSFMDBDispatchQueueRelease(__v)
    #else
        #define AWSFMDBDispatchQueueRelease(__v) (dispatch_release(__v));
    #endif
#endif
#if !__has_feature(objc_instancetype)
    #define instancetype id
#endif
typedef int(^AWSFMDBExecuteStatementsCallbackBlock)(NSDictionary *resultsDictionary);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
@interface AWSFMDatabase : NSObject  {
    NSString*           _databasePath;
    BOOL                _logsErrors;
    BOOL                _crashOnErrors;
    BOOL                _traceExecution;
    BOOL                _checkedOut;
    BOOL                _shouldCacheStatements;
    BOOL                _isExecutingStatement;
    BOOL                _inTransaction;
    NSTimeInterval      _maxBusyRetryTimeInterval;
    NSTimeInterval      _startBusyRetryTime;
    NSMutableDictionary *_cachedStatements;
    NSMutableSet        *_openResultSets;
    NSMutableSet        *_openFunctions;
    NSDateFormatter     *_dateFormat;
}
@property (atomic, assign) BOOL traceExecution;
@property (atomic, assign) BOOL checkedOut;
@property (atomic, assign) BOOL crashOnErrors;
@property (atomic, assign) BOOL logsErrors;
@property (atomic, retain) NSMutableDictionary *cachedStatements;
+ (instancetype)databaseWithPath:(NSString*)inPath;
- (instancetype)initWithPath:(NSString*)inPath;
- (BOOL)open;
- (BOOL)openWithFlags:(int)flags;
- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName;
- (BOOL)close;
- (BOOL)goodConnection;
- (BOOL)executeUpdate:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ...;
- (BOOL)update:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ... __attribute__ ((deprecated));
- (BOOL)executeUpdate:(NSString*)sql, ...;
- (BOOL)executeUpdateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withVAList: (va_list)args;
- (BOOL)executeStatements:(NSString *)sql;
- (BOOL)executeStatements:(NSString *)sql withResultBlock:(AWSFMDBExecuteStatementsCallbackBlock)block;
- (long long int)lastInsertRowId;
- (int)changes;
- (AWSFMResultSet *)executeQuery:(NSString*)sql, ...;
- (AWSFMResultSet *)executeQueryWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);
- (AWSFMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
- (AWSFMResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;
- (AWSFMResultSet *)executeQuery:(NSString*)sql withVAList: (va_list)args;
- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;
- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)inTransaction;
- (void)clearCachedStatements;
- (void)closeOpenResultSets;
- (BOOL)hasOpenResultSets;
- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;
- (BOOL)setKey:(NSString*)key;
- (BOOL)rekey:(NSString*)key;
- (BOOL)setKeyWithData:(NSData *)keyData;
- (BOOL)rekeyWithData:(NSData *)keyData;
- (NSString *)databasePath;
- (void*)sqliteHandle;
- (NSString*)lastErrorMessage;
- (int)lastErrorCode;
- (BOOL)hadError;
- (NSError*)lastError;
- (void)setMaxBusyRetryTimeInterval:(NSTimeInterval)timeoutInSeconds;
- (NSTimeInterval)maxBusyRetryTimeInterval;
- (BOOL)startSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (BOOL)releaseSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (BOOL)rollbackToSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (NSError*)inSavePoint:(void (^)(BOOL *rollback))block;
+ (BOOL)isSQLiteThreadSafe;
+ (NSString*)sqliteLibVersion;
+ (NSString*)AWSFMDBUserVersion;
+ (SInt32)AWSFMDBVersion;
- (void)makeFunctionNamed:(NSString*)name maximumArguments:(int)count withBlock:(void (^)(void *context, int argc, void **argv))block;
+ (NSDateFormatter *)storeableDateFormat:(NSString *)format;
- (BOOL)hasDateFormatter;
- (void)setDateFormat:(NSDateFormatter *)format;
- (NSDate *)dateFromString:(NSString *)s;
- (NSString *)stringFromDate:(NSDate *)date;
@end
@interface AWSFMStatement : NSObject {
    NSString *_query;
    long _useCount;
    BOOL _inUse;
}
@property (atomic, assign) long useCount;
@property (atomic, retain) NSString *query;
@property (atomic, assign) void *statement;
@property (atomic, assign) BOOL inUse;
- (void)close;
- (void)reset;
@end
#pragma clang diagnostic pop