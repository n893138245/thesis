#import <Foundation/Foundation.h>
#import "NBPhoneNumberDefines.h"
@class NBPhoneMetaData;
@interface NBMetadataHelper : NSObject
+ (BOOL)hasValue:(NSString *)string;
+ (NSDictionary *)CCode2CNMap;
- (NSArray *)getAllMetadata;
- (NBPhoneMetaData *)getMetadataForNonGeographicalRegion:(NSNumber *)countryCallingCode;
- (NBPhoneMetaData *)getMetadataForRegion:(NSString *)regionCode;
+ (NSArray *)regionCodeFromCountryCode:(NSNumber *)countryCodeNumber;
+ (NSString *)countryCodeFromRegionCode:(NSString *)regionCode;
#if SHORT_NUMBER_SUPPORT
- (NBPhoneMetaData *)shortNumberMetadataForRegion:(NSString *)regionCode;
#endif 
@end