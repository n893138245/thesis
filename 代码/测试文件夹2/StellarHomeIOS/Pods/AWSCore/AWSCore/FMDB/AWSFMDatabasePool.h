#import <Foundation/Foundation.h>
@class AWSFMDatabase;
@interface AWSFMDatabasePool : NSObject {
    NSString            *_path;
    dispatch_queue_t    _lockQueue;
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    __unsafe_unretained id _delegate;
    NSUInteger          _maximumNumberOfDatabasesToCreate;
    int                 _openFlags;
}
@property (atomic, retain) NSString *path;
@property (atomic, assign) id delegate;
@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;
@property (atomic, readonly) int openFlags;
+ (instancetype)databasePoolWithPath:(NSString*)aPath;
+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;
- (NSUInteger)countOfCheckedInDatabases;
- (NSUInteger)countOfCheckedOutDatabases;
- (NSUInteger)countOfOpenDatabases;
- (void)releaseAllDatabases;
- (void)inDatabase:(void (^)(AWSFMDatabase *db))block;
- (void)inTransaction:(void (^)(AWSFMDatabase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(AWSFMDatabase *db, BOOL *rollback))block;
- (NSError*)inSavePoint:(void (^)(AWSFMDatabase *db, BOOL *rollback))block;
@end
@interface NSObject (AWSFMDatabasePoolDelegate)
- (BOOL)databasePool:(AWSFMDatabasePool*)pool shouldAddDatabaseToPool:(AWSFMDatabase*)database;
- (void)databasePool:(AWSFMDatabasePool*)pool didAddDatabase:(AWSFMDatabase*)database;
@end