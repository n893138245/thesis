#import "AWSFMDatabase.h"
#import "AWSFMDatabaseAdditions.h"
#import "TargetConditionals.h"
#import "AWSFMDatabase+Private.h"
@interface AWSFMDatabase (PrivateStuff)
- (AWSFMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;
@end
@implementation AWSFMDatabase (AWSFMDatabaseAdditions)
#define RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(type, sel)             \
va_list args;                                                        \
va_start(args, query);                                               \
AWSFMResultSet *resultSet = [self executeQuery:query withArgumentsInArray:0x00 orDictionary:0x00 orVAList:args];   \
va_end(args);                                                        \
if (![resultSet next]) { return (type)0; }                           \
type ret = [resultSet sel:0];                                        \
[resultSet close];                                                   \
[resultSet setParentDB:nil];                                         \
return ret;
- (NSString*)stringForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSString *, stringForColumnIndex);
}
- (int)intForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(int, intForColumnIndex);
}
- (long)longForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(long, longForColumnIndex);
}
- (BOOL)boolForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(BOOL, boolForColumnIndex);
}
- (double)doubleForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(double, doubleForColumnIndex);
}
- (NSData*)dataForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSData *, dataForColumnIndex);
}
- (NSDate*)dateForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSDate *, dateForColumnIndex);
}
- (BOOL)tableExists:(NSString*)tableName {
    tableName = [tableName lowercaseString];
    AWSFMResultSet *rs = [self executeQuery:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = ?", tableName];
    BOOL returnBool = [rs next];
    [rs close];
    return returnBool;
}
- (AWSFMResultSet*)getSchema {
    AWSFMResultSet *rs = [self executeQuery:@"SELECT type, name, tbl_name, rootpage, sql FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type != 'meta' AND name NOT LIKE 'sqlite_%' ORDER BY tbl_name, type DESC, name"];
    return rs;
}
- (AWSFMResultSet*)getTableSchema:(NSString*)tableName {
    AWSFMResultSet *rs = [self executeQuery:[NSString stringWithFormat: @"pragma table_info('%@')", tableName]];
    return rs;
}
- (BOOL)columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName {
    BOOL returnBool = NO;
    tableName  = [tableName lowercaseString];
    columnName = [columnName lowercaseString];
    AWSFMResultSet *rs = [self getTableSchema:tableName];
    while ([rs next]) {
        if ([[[rs stringForColumn:@"name"] lowercaseString] isEqualToString:columnName]) {
            returnBool = YES;
            break;
        }
    }
    [rs close];
    return returnBool;
}
- (uint32_t)applicationID {
#if SQLITE_VERSION_NUMBER >= 3007017
    uint32_t r = 0;
    AWSFMResultSet *rs = [self executeQuery:@"pragma application_id"];
    if ([rs next]) {
        r = (uint32_t)[rs longLongIntForColumnIndex:0];
    }
    [rs close];
#endif
    return r;
}
- (void)setApplicationID:(uint32_t)appID {
#if SQLITE_VERSION_NUMBER >= 3007017
    NSString *query = [NSString stringWithFormat:@"pragma application_id=%d", appID];
    AWSFMResultSet *rs = [self executeQuery:query];
    [rs next];
    [rs close];
#endif
}
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString*)applicationIDString {
    NSString *s = NSFileTypeForHFSTypeCode([self applicationID]);
    assert([s length] == 6);
    s = [s substringWithRange:NSMakeRange(1, 4)];
    return s;
}
- (void)setApplicationIDString:(NSString*)s {
    if ([s length] != 4) {
        NSLog(@"setApplicationIDString: string passed is not exactly 4 chars long. (was %ld)", [s length]);
    }
    [self setApplicationID:NSHFSTypeCodeFromFileType([NSString stringWithFormat:@"'%@'", s])];
}
#endif
- (uint32_t)userVersion {
    uint32_t r = 0;
    AWSFMResultSet *rs = [self executeQuery:@"pragma user_version"];
    if ([rs next]) {
        r = (uint32_t)[rs longLongIntForColumnIndex:0];
    }
    [rs close];
    return r;
}
- (void)setUserVersion:(uint32_t)version {
    NSString *query = [NSString stringWithFormat:@"pragma user_version = %d", version];
    AWSFMResultSet *rs = [self executeQuery:query];
    [rs next];
    [rs close];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName __attribute__ ((deprecated)) {
    return [self columnExists:columnName inTableWithName:tableName];
}
#pragma clang diagnostic pop
- (BOOL)validateSQL:(NSString*)sql error:(NSError**)error {
    sqlite3_stmt *pStmt = NULL;
    BOOL validationSucceeded = YES;
    int rc = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &pStmt, 0);
    if (rc != SQLITE_OK) {
        validationSucceeded = NO;
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:[self lastErrorCode]
                                     userInfo:[NSDictionary dictionaryWithObject:[self lastErrorMessage]
                                                                          forKey:NSLocalizedDescriptionKey]];
        }
    }
    sqlite3_finalize(pStmt);
    return validationSucceeded;
}
@end