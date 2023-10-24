#import "NBRegExMatcher.h"
#import "NBPhoneNumberDesc.h"
#import "NBRegularExpressionCache.h"
#import "NBPhoneNumberUtil.h"
@interface NBPhoneNumberUtil()
- (NSRegularExpression *)entireRegularExpressionWithPattern:(NSString *)regexPattern
                                                    options:(NSRegularExpressionOptions)options
                                                      error:(NSError **)error;
@end
@implementation NBRegExMatcher
- (BOOL)matchNationalNumber:(NSString *)string
            phoneNumberDesc:(NBPhoneNumberDesc *)numberDesc
          allowsPrefixMatch:(BOOL)allowsPrefixMatch {
  NSString *nationalNumberPattern = numberDesc.nationalNumberPattern;
  if (nationalNumberPattern.length == 0) {
    return NO;
  }
  NSRegularExpression *regEx =
      [[NBPhoneNumberUtil sharedInstance] entireRegularExpressionWithPattern:nationalNumberPattern
                                                                     options:kNilOptions
                                                                       error:nil];
  if (regEx == nil) {
    NSAssert(true, @"Regular expression shouldn't be nil");
    return NO;
  }
  NSRange wholeStringRange = NSMakeRange(0, string.length);
  NSRegularExpression *prefixRegEx =
    [[NBRegularExpressionCache sharedInstance] regularExpressionForPattern:nationalNumberPattern
                                                                     error:NULL];
  if (prefixRegEx == nil) {
    NSAssert(true, @"Regular expression shouldn't be nil");
    return NO;
  }
  NSTextCheckingResult *prefixResult = [prefixRegEx firstMatchInString:string
                                                               options:NSMatchingAnchored
                                                                 range:wholeStringRange];
  if (prefixResult.numberOfRanges <= 0) {
    return NO;
  } else {
    NSTextCheckingResult *exactResult = [regEx firstMatchInString:string
                                                     options:NSMatchingAnchored
                                                       range:wholeStringRange];
    return (allowsPrefixMatch || exactResult.numberOfRanges > 0);
  }
}
@end