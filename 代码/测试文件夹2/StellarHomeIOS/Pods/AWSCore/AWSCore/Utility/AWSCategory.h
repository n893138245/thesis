#import <Foundation/Foundation.h>
#import "AWSServiceEnum.h"
FOUNDATION_EXPORT NSString *const AWSDateRFC822DateFormat1;
FOUNDATION_EXPORT NSString *const AWSDateISO8601DateFormat1;
FOUNDATION_EXPORT NSString *const AWSDateISO8601DateFormat2;
FOUNDATION_EXPORT NSString *const AWSDateISO8601DateFormat3;
FOUNDATION_EXPORT NSString *const AWSDateShortDateFormat1;
FOUNDATION_EXPORT NSString *const AWSDateShortDateFormat2;
@interface NSDate (AWS)
+ (NSDate *)aws_clockSkewFixedDate;
+ (NSDate *)aws_dateFromString:(NSString *)string;
+ (NSDate *)aws_dateFromString:(NSString *)string format:(NSString *)dateFormat;
- (NSString *)aws_stringValue:(NSString *)dateFormat;
+ (void)aws_setRuntimeClockSkew:(NSTimeInterval)clockskew;
+ (NSTimeInterval)aws_getRuntimeClockSkew;
@end
@interface NSDictionary (AWS)
- (NSDictionary *)aws_removeNullValues;
- (id)aws_objectForCaseInsensitiveKey:(id)aKey;
@end
@interface NSJSONSerialization (AWS)
+ (NSData *)aws_dataWithJSONObject:(id)obj
                           options:(NSJSONWritingOptions)opt
                             error:(NSError **)error;
@end
@interface NSNumber (AWS)
+ (NSNumber *)aws_numberFromString:(NSString *)string;
@end
@interface NSObject (AWS)
- (NSDictionary *)aws_properties;
- (void)aws_copyPropertiesFromObject:(NSObject *)object;
@end
@interface NSString (AWS)
+ (NSString *)aws_base64md5FromData:(NSData *)data;
- (BOOL)aws_isBase64Data;
- (NSString *)aws_stringWithURLEncoding;
- (NSString *)aws_stringWithURLEncodingPath;
- (NSString *)aws_stringWithURLEncodingPathWithoutPriorDecoding;
- (NSString *)aws_md5String DEPRECATED_MSG_ATTRIBUTE("This method will be removed in an upcoming version of the SDK.");
- (NSString *)aws_md5StringLittleEndian DEPRECATED_MSG_ATTRIBUTE("This method will be removed in an upcoming version of the SDK.");
- (BOOL)aws_isVirtualHostedStyleCompliant;
- (AWSRegionType)aws_regionTypeValue;
@end
@interface NSFileManager (AWS)
- (BOOL)aws_atomicallyCopyItemAtURL:(NSURL *)sourceURL
                              toURL:(NSURL *)destinationURL
                     backupItemName:(NSString *)backupItemName
                              error:(NSError **)outError;
@end