#ifndef TBRestZlibUtils_h
#define TBRestZlibUtils_h
#import <Foundation/Foundation.h>
#include <zlib.h>
@interface TBRestZlibUtils : NSObject
+ (NSData *)gzipInflate:(NSData *)data;
+ (NSData *)gzipDeflate:(NSData *)data;
@end
#endif