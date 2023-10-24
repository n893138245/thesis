#import <Foundation/Foundation.h>
@interface NSData (CRC32)
+ (NSString *)CRC32:(NSData *)input;
- (NSString *)CRC32;
- (uint32_t)CRC32Value;
@end