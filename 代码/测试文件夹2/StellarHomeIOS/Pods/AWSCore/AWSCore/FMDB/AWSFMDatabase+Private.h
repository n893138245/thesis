#ifndef deleteme2_FMDatabase_Private_h
#define deleteme2_FMDatabase_Private_h
#import <sqlite3.h>
@class AWSFMDatabase;
@class AWSFMStatement;
@interface AWSFMDatabase (Private)
@property (nonatomic, assign, readonly) sqlite3 *db;
@end
@interface AWSFMStatement (Private)
@property (nonatomic, assign) sqlite3_stmt *statement;
@end
#endif