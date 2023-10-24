#import <Foundation/Foundation.h>
@interface NBNumberFormat : NSObject
 @property(nonatomic, strong) NSString *pattern;
 @property(nonatomic, strong) NSString *format;
 @property(nonatomic, strong) NSArray *leadingDigitsPatterns;
 @property(nonatomic, strong) NSString *nationalPrefixFormattingRule;
 @property(nonatomic, assign) BOOL nationalPrefixOptionalWhenFormatting;
 @property(nonatomic, strong) NSString *domesticCarrierCodeFormattingRule;
- (instancetype)initWithPattern:(NSString *)pattern
                               withFormat:(NSString *)format
                withLeadingDigitsPatterns:(NSArray *)leadingDigitsPatterns
         withNationalPrefixFormattingRule:(NSString *)nationalPrefixFormattingRule
                           whenFormatting:(BOOL)nationalPrefixOptionalWhenFormatting
    withDomesticCarrierCodeFormattingRule:(NSString *)domesticCarrierCodeFormattingRule;
- (instancetype)initWithEntry:(NSArray *)entry;
@end