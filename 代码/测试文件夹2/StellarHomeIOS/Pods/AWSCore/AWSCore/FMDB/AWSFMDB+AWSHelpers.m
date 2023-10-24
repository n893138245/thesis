#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AWSFMDB+AWSHelpers.h"
@implementation AWSFMDatabaseQueue (AWSHelpers)
+ (instancetype)serialDatabaseQueueWithPath:(NSString*)aPath {
    int flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX;
    return [AWSFMDatabaseQueue databaseQueueWithPath:aPath
                                               flags:flags];
}
@end
@implementation AWSFMDatabasePool (AWSHelpers)
+ (instancetype)serialDatabasePoolWithPath:(NSString*)aPath {
    int flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX;
    return [AWSFMDatabasePool databasePoolWithPath:aPath
                                             flags:flags];
}
@end