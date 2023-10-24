#import <Foundation/Foundation.h>
@interface AliHASecurity : NSObject
@property (nonatomic, copy, readonly) NSString *rsaPublicKey;
+ (instancetype)sharedInstance;
- (void)initWithRSAPublicKey:(NSString *)key;
- (NSString *)RSADecryptString:(NSString *)string;
- (NSString *)RSAEncryptString:(NSString *)string;
@end