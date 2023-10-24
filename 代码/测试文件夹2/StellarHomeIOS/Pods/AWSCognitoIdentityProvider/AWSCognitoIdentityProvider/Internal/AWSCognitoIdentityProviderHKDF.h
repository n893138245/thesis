#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AWSCognitoIdentityProviderHKDF : NSObject
+ (NSData*)deriveKeyWithInputKeyingMaterial:(NSData*)ikm salt:(NSData*)salt info:(NSData*)info outputLength:(NSUInteger)outputLength;
@end
NS_ASSUME_NONNULL_END