#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>
@interface MOBFData : NSObject
+ (NSString *)stringByData:(NSData *)data;
+ (NSData *)hmacSha1Data:(NSData *)data forKey:(NSData *)key;
+ (NSData *)hmacMd5Data:(NSData *)data forKey:(NSData *)key;
+ (NSData *)md5Data:(NSData *)data;
+ (NSData *)aes128EncryptData:(NSData *)data
                          key:(NSString *)key
                     encoding:(NSStringEncoding)encoding;
+ (NSData *)aes128DecryptData:(NSData *)data
                          key:(NSString *)key
                     encoding:(NSStringEncoding)encoding;
+ (NSData *)aes128EncryptData:(NSData *)data
                          key:(NSData *)key
                      options:(CCOptions)options;
+ (NSData *)aes128DecryptData:(NSData *)data
                          key:(NSData *)key
                      options:(CCOptions)options;
+ (NSData *)compressDataUsingGZip:(NSData *)data;
+ (NSData *)uncompressDataUsingGZip:(NSData *)data;
+ (NSString *)stringByMD5Data:(NSData *)data;
+ (NSString *)stringByBase64EncodeData:(NSData *)data;
+ (uLong)valueByCRC32Data:(NSData *)data;
+ (NSString *)stringByCRC32Data:(NSData *)data;
+ (NSString *)hexStringByData:(NSData *)data;
+ (void)writeInt32:(int32_t)value toData:(NSMutableData *)data;
+ (void)writeInt16:(int16_t)value toData:(NSMutableData *)data;
+ (int16_t)readInt16FromData:(NSData *)data offset:(NSInteger)offset;
+ (int32_t)readInt32FromData:(NSData *)data offset:(NSInteger)offset;
@end