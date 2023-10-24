#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>
#define FBENCRYPT_ALGORITHM kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE kCCKeySizeAES256
@interface NSData (NSData_AES)
+ (NSData *)generateIv;
+ (NSData *)encryptData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
+ (NSData *)decryptData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
+ (NSData *)cryptOperation:(CCOperation)op
                      Data:(NSData *)data
                       key:(NSData *)key
                        iv:(NSData *)iv;
@end