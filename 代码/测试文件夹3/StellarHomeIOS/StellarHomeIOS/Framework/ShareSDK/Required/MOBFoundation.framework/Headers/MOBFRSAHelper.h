#import <Foundation/Foundation.h>
#import "MOBFRSAKey.h"
@interface MOBFRSAHelper : NSObject
@property (nonatomic, readonly) MOBFRSAKey *key;
- (instancetype)initWithKeySize:(int)keySize;
- (instancetype)initWithKeySize:(int)keySize
                      publicKey:(NSString *)publicKey
                     privateKey:(NSString *)privateKey
                        modulus:(NSString *)modulus;
- (NSData *)encryptWithData:(NSData *)data;
- (NSData *)decryptWithData:(NSData *)data;
@end