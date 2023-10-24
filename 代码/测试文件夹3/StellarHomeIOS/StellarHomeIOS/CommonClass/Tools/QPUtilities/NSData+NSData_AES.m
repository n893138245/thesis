#import "NSData+NSData_AES.h"
@implementation NSData (NSData_AES)
+ (NSData *)encryptData:(NSData *)data key:(NSData *)key iv:(NSData *)iv {
  return [NSData cryptOperation:kCCEncrypt Data:data key:key iv:iv];
}
+ (NSData *)decryptData:(NSData *)data key:(NSData *)key iv:(NSData *)iv {
  return [NSData cryptOperation:kCCDecrypt Data:data key:key iv:iv];
}
+ (NSData *)cryptOperation:(CCOperation)op
                      Data:(NSData *)data
                       key:(NSData *)key
                        iv:(NSData *)iv {
  NSData *result = nil;
  size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
  void *buffer = malloc(bufferSize);
  size_t cryptedSize = 0;
  CCCryptorStatus cryptStatus =
      CCCrypt(op, FBENCRYPT_ALGORITHM, kCCOptionPKCS7Padding, key.bytes,
              FBENCRYPT_KEY_SIZE, iv.bytes, data.bytes, data.length, buffer,
              bufferSize, &cryptedSize);
  if (cryptStatus == kCCSuccess) {
    result = [NSData dataWithBytesNoCopy:buffer length:cryptedSize];
  } else {
    free(buffer);
    NSLog(@"[ERROR] failed to crypt, operation = %u| CCCryptoStatus: %d", op,
          cryptStatus);
  }
  return result;
}
+ (NSData *)generateIv {
  unsigned char cIv[FBENCRYPT_BLOCK_SIZE];
  for (int i = 0; i < FBENCRYPT_BLOCK_SIZE; i++) {
    cIv[i] = (unsigned char)(arc4random() % 256);
  }
  return [NSData dataWithBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
}
@end