#import <Foundation/Foundation.h>
#import "NBPhoneNumberDefines.h"
@interface NBPhoneNumber : NSObject<NSCopying, NSCoding>
 @property(nonatomic, strong, readwrite) NSNumber *countryCode;
 @property(nonatomic, strong, readwrite) NSNumber *nationalNumber;
 @property(nonatomic, strong, readwrite) NSString *extension;
 @property(nonatomic, assign, readwrite) BOOL italianLeadingZero;
 @property(nonatomic, strong, readwrite) NSNumber *numberOfLeadingZeros;
 @property(nonatomic, strong, readwrite) NSString *rawInput;
 @property(nonatomic, strong, readwrite) NSNumber *countryCodeSource;
 @property(nonatomic, strong, readwrite) NSString *preferredDomesticCarrierCode;
- (void)clearCountryCodeSource;
- (NBECountryCodeSource)getCountryCodeSourceOrDefault;
@end