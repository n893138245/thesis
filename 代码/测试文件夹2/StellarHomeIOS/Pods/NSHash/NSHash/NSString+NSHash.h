#import <Foundation/Foundation.h>
@interface NSString (NSHash_AdditionalHashingAlgorithms)
- (nonnull NSString*) MD5;
- (nonnull NSData*) MD5Data;
- (nonnull NSString*) SHA1;
- (nonnull NSData*) SHA1Data;
- (nonnull NSString*) SHA256;
- (nonnull NSData*) SHA256Data;
- (nonnull NSString*) SHA512;
- (nonnull NSData*) SHA512Data;
@end