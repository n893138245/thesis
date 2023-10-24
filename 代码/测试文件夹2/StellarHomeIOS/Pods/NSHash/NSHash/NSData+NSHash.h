#import <Foundation/Foundation.h>
@interface NSData (NSHash_AdditionalHashingAlgorithms)
- (nonnull NSData*) MD5;
- (nonnull NSString*) MD5String;
- (nonnull NSData*) SHA1;
- (nonnull NSString*) SHA1String;
- (nonnull NSData*) SHA256;
- (nonnull NSString*) SHA256String;
- (nonnull NSData*) SHA512;
- (nonnull NSString*) SHA512String;
@end