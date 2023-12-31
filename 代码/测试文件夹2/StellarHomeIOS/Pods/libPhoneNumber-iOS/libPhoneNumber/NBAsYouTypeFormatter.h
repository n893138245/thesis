#import <Foundation/Foundation.h>
@class NBAsYouTypeFormatter;
@interface NBAsYouTypeFormatter : NSObject
- (instancetype)initWithRegionCode:(NSString *)regionCode;
- (instancetype)initWithRegionCode:(NSString *)regionCode bundle:(NSBundle *)bundle;
- (NSString *)inputString:(NSString *)string;
- (NSString *)inputStringAndRememberPosition:(NSString *)string;
- (NSString *)inputDigit:(NSString *)nextChar;
- (NSString *)inputDigitAndRememberPosition:(NSString *)nextChar;
- (NSString *)removeLastDigit;
- (NSString *)removeLastDigitAndRememberPosition;
- (NSInteger)getRememberedPosition;
- (void)clear;
@property(nonatomic, assign, readonly) BOOL isSuccessfulFormatting;
@end