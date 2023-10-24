#import <Foundation/Foundation.h>
@class NBPhoneNumberDesc;
@interface NBRegExMatcher : NSObject
- (BOOL)matchNationalNumber:(NSString *)string
            phoneNumberDesc:(NBPhoneNumberDesc *)numberDesc
          allowsPrefixMatch:(BOOL)allowsPrefixMatch;
@end