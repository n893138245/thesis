#import <Foundation/Foundation.h>
@interface NBPhoneNumberDesc : NSObject
 @property(nonatomic, strong, readonly) NSString *nationalNumberPattern;
 @property(nonatomic, strong, readonly) NSString *possibleNumberPattern;
 @property(nonatomic, strong, readonly) NSArray<NSNumber *> *possibleLength;
 @property(nonatomic, strong, readonly) NSArray<NSNumber *> *possibleLengthLocalOnly;
 @property(nonatomic, strong, readonly) NSString *exampleNumber;
 @property(nonatomic, strong, readonly) NSData *nationalNumberMatcherData;
 @property(nonatomic, strong, readonly) NSData *possibleNumberMatcherData;
- (instancetype)initWithEntry:(NSArray *)entry;
@end