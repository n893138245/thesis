#import "AWSFMDatabasePool.h"
#import "AWSFMDatabase.h"
#import "AWSFMDatabase+Private.h"
@interface AWSFMDatabasePool()
- (void)pushDatabaseBackInPool:(AWSFMDatabase*)db;
- (AWSFMDatabase*)db;
@end
@implementation AWSFMDatabasePool
@synthesize path=_path;
@synthesize delegate=_delegate;
@synthesize maximumNumberOfDatabasesToCreate=_maximumNumberOfDatabasesToCreate;
@synthesize openFlags=_openFlags;
+ (instancetype)databasePoolWithPath:(NSString*)aPath {
    return AWSFMDBReturnAutoreleased([[self alloc] initWithPath:aPath]);
}
+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags {
    return AWSFMDBReturnAutoreleased([[self alloc] initWithPath:aPath flags:openFlags]);
}
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags {
    self = [super init];
    if (self != nil) {
        _path               = [aPath copy];
        _lockQueue          = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
        _databaseInPool     = AWSFMDBReturnRetained([NSMutableArray array]);
        _databaseOutPool    = AWSFMDBReturnRetained([NSMutableArray array]);
        _openFlags          = openFlags;
    }
    return self;
}
- (instancetype)initWithPath:(NSString*)aPath
{
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
}
- (instancetype)init {
    return [self initWithPath:nil];
}
- (void)dealloc {
    _delegate = 0x00;
    AWSFMDBRelease(_path);
    AWSFMDBRelease(_databaseInPool);
    AWSFMDBRelease(_databaseOutPool);
    if (_lockQueue) {
        AWSFMDBDispatchQueueRelease(_lockQueue);
        _lockQueue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}
- (void)executeLocked:(void (^)(void))aBlock {
    dispatch_sync(_lockQueue, aBlock);
}
- (void)pushDatabaseBackInPool:(AWSFMDatabase*)db {
    if (!db) { 
        return;
    }
    [self executeLocked:^() {
        if ([self->_databaseInPool containsObject:db]) {
            [[NSException exceptionWithName:@"Database already in pool" reason:@"The FMDatabase being put back into the pool is already present in the pool" userInfo:nil] raise];
        }
        [self->_databaseInPool addObject:db];
        [self->_databaseOutPool removeObject:db];
    }];
}
- (AWSFMDatabase*)db {
    __block AWSFMDatabase *db;
    [self executeLocked:^() {
        db = [self->_databaseInPool lastObject];
        BOOL shouldNotifyDelegate = NO;
        if (db) {
            [self->_databaseOutPool addObject:db];
            [self->_databaseInPool removeLastObject];
        }
        else {
            if (self->_maximumNumberOfDatabasesToCreate) {
                NSUInteger currentCount = [self->_databaseOutPool count] + [self->_databaseInPool count];
                if (currentCount >= self->_maximumNumberOfDatabasesToCreate) {
                    NSLog(@"Maximum number of databases (%ld) has already been reached!", (long)currentCount);
                    return;
                }
            }
            db = [AWSFMDatabase databaseWithPath:self->_path];
            shouldNotifyDelegate = YES;
        }
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [db openWithFlags:self->_openFlags];
#else
        BOOL success = [db open];
#endif
        if (success) {
            if ([self->_delegate respondsToSelector:@selector(databasePool:shouldAddDatabaseToPool:)] && ![self->_delegate databasePool:self shouldAddDatabaseToPool:db]) {
                [db close];
                db = 0x00;
            }
            else {
                if (![self->_databaseOutPool containsObject:db]) {
                    [self->_databaseOutPool addObject:db];
                    if (shouldNotifyDelegate && [self->_delegate respondsToSelector:@selector(databasePool:didAddDatabase:)]) {
                        [self->_delegate databasePool:self didAddDatabase:db];
                    }
                }
            }
        }
        else {
            NSLog(@"Could not open up the database at path %@", self->_path);
            db = 0x00;
        }
    }];
    return db;
}
- (NSUInteger)countOfCheckedInDatabases {
    __block NSUInteger count;
    [self executeLocked:^() {
        count = [self->_databaseInPool count];
    }];
    return count;
}
- (NSUInteger)countOfCheckedOutDatabases {
    __block NSUInteger count;
    [self executeLocked:^() {
        count = [self->_databaseOutPool count];
    }];
    return count;
}
- (NSUInteger)countOfOpenDatabases {
    __block NSUInteger count;
    [self executeLocked:^() {
        count = [self->_databaseOutPool count] + [self->_databaseInPool count];
    }];
    return count;
}
- (void)releaseAllDatabases {
    [self executeLocked:^() {
        [self->_databaseOutPool removeAllObjects];
        [self->_databaseInPool removeAllObjects];
    }];
}
- (void)inDatabase:(void (^)(AWSFMDatabase *db))block {
    AWSFMDatabase *db = [self db];
    block(db);
    [self pushDatabaseBackInPool:db];
}
- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(AWSFMDatabase *db, BOOL *rollback))block {
    BOOL shouldRollback = NO;
    AWSFMDatabase *db = [self db];
    if (useDeferred) {
        [db beginDeferredTransaction];
    }
    else {
        [db beginTransaction];
    }
    block(db, &shouldRollback);
    if (shouldRollback) {
        [db rollback];
    }
    else {
        [db commit];
    }
    [self pushDatabaseBackInPool:db];
}
- (void)inDeferredTransaction:(void (^)(AWSFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}
- (void)inTransaction:(void (^)(AWSFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}
- (NSError*)inSavePoint:(void (^)(AWSFMDatabase *db, BOOL *rollback))block {
    NSError *err = 0x00;
#if SQLITE_VERSION_NUMBER >= 3007000
    static unsigned long savePointIdx = 0;
    NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
    BOOL shouldRollback = NO;
    AWSFMDatabase *db = [self db];
    if (![db startSavePointWithName:name error:&err]) {
        [self pushDatabaseBackInPool:db];
        return err;
    }
    block(db, &shouldRollback);
    if (shouldRollback) {
        [db rollbackToSavePointWithName:name error:&err];
    }
    [db releaseSavePointWithName:name error:&err];
    [self pushDatabaseBackInPool:db];
#endif
    return err;
}
@end