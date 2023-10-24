#import <Foundation/Foundation.h>
@interface MOBFString : NSObject
+ (NSString *)urlEncodeString:(NSString *)string forEncoding:(NSStringEncoding)encoding;
+ (NSString *)urlDecodeString:(NSString *)string forEncoding:(NSStringEncoding)encoding;
+ (NSString *)sha1String:(NSString *)string;
+ (NSString *)md5String:(NSString *)string;
+ (NSString *)guidString;
+ (NSData *)dataByHMACSha1String:(NSString *)string forKey:(NSString *)key;
+ (NSData *)dataByHMACMd5String:(NSString *)string forKey:(NSString *)key;
+ (NSData *)dataByBase64DecodeString:(NSString *)string;
+ (NSString *)stringByBase64DecodeString:(NSString *)string;
+ (BOOL)containsURLByString:(NSString *)string;
+ (NSDictionary *)parseURLParametersString:(NSString *)string;
+ (NSData *)dataByHexString:(NSString *)string;
+ (NSInteger)convertVersion:(NSString *)ver;
@end