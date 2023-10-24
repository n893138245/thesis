#import <Foundation/Foundation.h>
#include <mach/mach.h>
@interface TBCrashReporterUtility : NSObject
+ (NSData *)gzipData:(NSData *)theData;
+ (NSString *)base64forData:(NSData *)theData;
+ (NSString *)getUserPage;
+ (NSString *)getBackTrace;
+ (NSDictionary *)dataToDic:(NSData*)data forkey:(NSString*)key;
+ (NSDictionary *)mergeDictionary:(NSDictionary *)dictLeft dictRight:(NSDictionary *)dictRight;
@end