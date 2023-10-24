#import <Foundation/Foundation.h>
@interface NSData (NSData_Conversion)
#pragma mark - String Conversion
- (NSString *)hexadecimalString;
+ (NSData *)dataFromHexString:(NSString *)string;
@end