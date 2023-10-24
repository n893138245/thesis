#import <Foundation/Foundation.h>
@class AWSFMDatabase;
@interface AWSFMDatabaseQueue : NSObject {
    NSString            *_path;
    dispatch_queue_t    _queue;
    AWSFMDatabase          *_db;
    int                 _openFlags;
}
@property (atomic, retain) NSString *path;
@property (atomic, readonly) int openFlags;
+ (instancetype)databaseQueueWithPath:(NSString*)aPath;
+ (instancetype)databaseQueueWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags vfs:(NSString *)vfsName;
+ (Class)databaseClass;
- (void)close;
- (void)inDatabase:(void (^)(AWSFMDatabase *db))block;
- (void)inTransaction:(void (^)(AWSFMDatabase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(AWSFMDatabase *db, BOOL *rollback))block;
- (NSError*)inSavePoint:(void (^)(AWSFMDatabase *db, BOOL *rollback))block;
@end