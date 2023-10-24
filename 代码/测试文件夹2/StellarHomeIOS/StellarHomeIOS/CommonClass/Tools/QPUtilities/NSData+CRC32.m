#import "NSData+CRC32.h"
#import "zlib.h"
@implementation NSData (CRC32)
+ (NSString *)CRC32:(NSData *)input {
  uLong crcValue = crc32(0L, NULL, 0L);
  crcValue = crc32(crcValue, (const Bytef *)input.bytes, (uInt)(input.length));
  return [NSString stringWithFormat:@"%lx", crcValue];
}
- (NSString *)CRC32 {
  return [NSData CRC32:self];
}
- (uint32_t)CRC32Value {
  uLong crc = crc32(0L, Z_NULL, 0);
  crc = crc32(crc, [self bytes], (uInt)[self length]);
  return (uint32_t)crc;
}
@end