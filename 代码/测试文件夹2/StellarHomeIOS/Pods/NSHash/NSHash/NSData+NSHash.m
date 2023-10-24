#import "NSData+NSHash.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSData (NSHash_AdditionalHashingAlgorithms)
- (nonnull NSData*) MD5 {
	unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
	unsigned char output[outputLength];
	CC_MD5(self.bytes, (unsigned int) self.length, output);
	return [NSData dataWithBytes:output length:outputLength];
}
- (nonnull NSString*) MD5String {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    CC_MD5(self.bytes, (unsigned int) self.length, output);
    return [self toHexString:output length:outputLength];
}
- (nonnull NSData*) SHA1 {
	unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
	unsigned char output[outputLength];
	CC_SHA1(self.bytes, (unsigned int) self.length, output);
	return [NSData dataWithBytes:output length:outputLength];
}
- (nonnull NSString*) SHA1String {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    CC_SHA1(self.bytes, (unsigned int) self.length, output);
    return [self toHexString:output length:outputLength];
}
- (nonnull NSData*) SHA256 {
	unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
	unsigned char output[outputLength];
	CC_SHA256(self.bytes, (unsigned int) self.length, output);
	return [NSData dataWithBytes:output length:outputLength];
}
- (nonnull NSString*) SHA256String {
	unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
	unsigned char output[outputLength];
	CC_SHA256(self.bytes, (unsigned int) self.length, output);
	return [self toHexString:output length:outputLength];
}
- (nonnull NSData*) SHA512 {
	unsigned int outputLength = CC_SHA512_DIGEST_LENGTH;
	unsigned char output[outputLength];
	CC_SHA512(self.bytes, (unsigned int) self.length, output);
	return [NSData dataWithBytes:output length:outputLength];
}
- (nonnull NSString*) SHA512String {
	unsigned int outputLength = CC_SHA512_DIGEST_LENGTH;
	unsigned char output[outputLength];
	CC_SHA512(self.bytes, (unsigned int) self.length, output);
	return [self toHexString:output length:outputLength];
}
- (nonnull NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return [hash copy];
}
@end