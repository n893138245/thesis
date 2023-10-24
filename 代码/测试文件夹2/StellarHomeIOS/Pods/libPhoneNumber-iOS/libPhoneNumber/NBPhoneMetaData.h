#import <Foundation/Foundation.h>
@class NBPhoneNumberDesc, NBNumberFormat;
@interface NBPhoneMetaData : NSObject
 @property(nonatomic, strong) NBPhoneNumberDesc *generalDesc;
 @property(nonatomic, strong) NBPhoneNumberDesc *fixedLine;
 @property(nonatomic, strong) NBPhoneNumberDesc *mobile;
 @property(nonatomic, strong) NBPhoneNumberDesc *tollFree;
 @property(nonatomic, strong) NBPhoneNumberDesc *premiumRate;
 @property(nonatomic, strong) NBPhoneNumberDesc *sharedCost;
 @property(nonatomic, strong) NBPhoneNumberDesc *personalNumber;
 @property(nonatomic, strong) NBPhoneNumberDesc *voip;
 @property(nonatomic, strong) NBPhoneNumberDesc *pager;
 @property(nonatomic, strong) NBPhoneNumberDesc *uan;
 @property(nonatomic, strong) NBPhoneNumberDesc *emergency;
 @property(nonatomic, strong) NBPhoneNumberDesc *voicemail;
 @property(nonatomic, strong) NBPhoneNumberDesc *noInternationalDialling;
 @property(nonatomic, strong) NSString *codeID;
 @property(nonatomic, strong) NSNumber *countryCode;
 @property(nonatomic, strong) NSString *internationalPrefix;
 @property(nonatomic, strong) NSString *preferredInternationalPrefix;
 @property(nonatomic, strong) NSString *nationalPrefix;
 @property(nonatomic, strong) NSString *preferredExtnPrefix;
 @property(nonatomic, strong) NSString *nationalPrefixForParsing;
 @property(nonatomic, strong) NSString *nationalPrefixTransformRule;
 @property(nonatomic, assign) BOOL sameMobileAndFixedLinePattern;
 @property(nonatomic, strong) NSArray<NBNumberFormat *> *numberFormats;
 @property(nonatomic, strong) NSArray<NBNumberFormat *> *intlNumberFormats;
 @property(nonatomic, assign) BOOL mainCountryForCode;
 @property(nonatomic, strong) NSString *leadingDigits;
 @property(nonatomic, assign) BOOL leadingZeroPossible;
#if SHORT_NUMBER_SUPPORT
 @property (nonatomic, strong) NBPhoneNumberDesc *shortCode;
 @property (nonatomic, strong) NBPhoneNumberDesc *standardRate;
 @property (nonatomic, strong) NBPhoneNumberDesc *carrierSpecific;
 @property (nonatomic, strong) NBPhoneNumberDesc *smsServices;
#endif 
- (instancetype)initWithEntry:(NSArray *)entry;
@end