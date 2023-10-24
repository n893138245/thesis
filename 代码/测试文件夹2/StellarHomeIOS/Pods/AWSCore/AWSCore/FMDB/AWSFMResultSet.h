#import <Foundation/Foundation.h>
#ifndef __has_feature      
#define __has_feature(x) 0 
#endif
#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif
@class AWSFMDatabase;
@class AWSFMStatement;
@interface AWSFMResultSet : NSObject {
    AWSFMDatabase          *_parentDB;
    AWSFMStatement         *_statement;
    NSString            *_query;
    NSMutableDictionary *_columnNameToIndexMap;
}
@property (atomic, retain) NSString *query;
@property (readonly) NSMutableDictionary *columnNameToIndexMap;
@property (atomic, retain) AWSFMStatement *statement;
+ (instancetype)resultSetWithStatement:(AWSFMStatement *)statement usingParentDatabase:(AWSFMDatabase*)aDB;
- (void)close;
- (void)setParentDB:(AWSFMDatabase *)newDb;
- (BOOL)next;
- (BOOL)nextWithError:(NSError **)outErr;
- (BOOL)hasAnotherRow;
- (int)columnCount;
- (int)columnIndexForName:(NSString*)columnName;
- (NSString*)columnNameForIndex:(int)columnIdx;
- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;
- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;
- (long long int)longLongIntForColumn:(NSString*)columnName;
- (long long int)longLongIntForColumnIndex:(int)columnIdx;
- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName;
- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx;
- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;
- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;
- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;
- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;
- (NSData*)dataForColumn:(NSString*)columnName;
- (NSData*)dataForColumnIndex:(int)columnIdx;
- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName;
- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx;
- (id)objectForColumnName:(NSString*)columnName;
- (id)objectForColumnIndex:(int)columnIdx;
- (id)objectForKeyedSubscript:(NSString *)columnName;
- (id)objectAtIndexedSubscript:(int)columnIdx;
- (NSData*)dataNoCopyForColumn:(NSString*)columnName NS_RETURNS_NOT_RETAINED;
- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx NS_RETURNS_NOT_RETAINED;
- (BOOL)columnIndexIsNull:(int)columnIdx;
- (BOOL)columnIsNull:(NSString*)columnName;
- (NSDictionary*)resultDictionary;
- (NSDictionary*)resultDict  __attribute__ ((deprecated));
- (void)kvcMagic:(id)object;
@end