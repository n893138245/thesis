#import <Foundation/Foundation.h>
#ifndef libPhoneNumber_NBPhoneNumberDefines_h
#define libPhoneNumber_NBPhoneNumberDefines_h
#define NB_YES [NSNumber numberWithBool:YES]
#define NB_NO [NSNumber numberWithBool:NO]
#pragma mark - Enum -
typedef NS_ENUM(NSInteger, NBEPhoneNumberFormat) {
  NBEPhoneNumberFormatE164 = 0,
  NBEPhoneNumberFormatINTERNATIONAL = 1,
  NBEPhoneNumberFormatNATIONAL = 2,
  NBEPhoneNumberFormatRFC3966 = 3
};
typedef NS_ENUM(NSInteger, NBEPhoneNumberType) {
  NBEPhoneNumberTypeFIXED_LINE = 0,
  NBEPhoneNumberTypeMOBILE = 1,
  NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE = 2,
  NBEPhoneNumberTypeTOLL_FREE = 3,
  NBEPhoneNumberTypePREMIUM_RATE = 4,
  NBEPhoneNumberTypeSHARED_COST = 5,
  NBEPhoneNumberTypeVOIP = 6,
  NBEPhoneNumberTypePERSONAL_NUMBER = 7,
  NBEPhoneNumberTypePAGER = 8,
  NBEPhoneNumberTypeUAN = 9,
  NBEPhoneNumberTypeVOICEMAIL = 10,
  NBEPhoneNumberTypeUNKNOWN = -1
};
typedef NS_ENUM(NSInteger, NBEMatchType) {
  NBEMatchTypeNOT_A_NUMBER = 0,
  NBEMatchTypeNO_MATCH = 1,
  NBEMatchTypeSHORT_NSN_MATCH = 2,
  NBEMatchTypeNSN_MATCH = 3,
  NBEMatchTypeEXACT_MATCH = 4
};
typedef NS_ENUM(NSInteger, NBEValidationResult) {
  NBEValidationResultINVALID_LENGTH = -1,
  NBEValidationResultUNKNOWN = 0,
  NBEValidationResultIS_POSSIBLE = 1,
  NBEValidationResultINVALID_COUNTRY_CODE = 2,
  NBEValidationResultTOO_SHORT = 3,
  NBEValidationResultTOO_LONG = 4,
  NBEValidationResultIS_POSSIBLE_LOCAL_ONLY = 5
};
typedef NS_ENUM(NSInteger, NBECountryCodeSource) {
  NBECountryCodeSourceFROM_NUMBER_WITH_PLUS_SIGN = 1,
  NBECountryCodeSourceFROM_NUMBER_WITH_IDD = 5,
  NBECountryCodeSourceFROM_NUMBER_WITHOUT_PLUS_SIGN = 10,
  NBECountryCodeSourceFROM_DEFAULT_COUNTRY = 20
};
extern NSString* const NB_UNKNOWN_REGION;
extern NSString* const NB_NON_BREAKING_SPACE;
extern NSString* const NB_PLUS_CHARS;
extern NSString* const NB_VALID_DIGITS_STRING;
extern NSString* const NB_REGION_CODE_FOR_NON_GEO_ENTITY;
#endif