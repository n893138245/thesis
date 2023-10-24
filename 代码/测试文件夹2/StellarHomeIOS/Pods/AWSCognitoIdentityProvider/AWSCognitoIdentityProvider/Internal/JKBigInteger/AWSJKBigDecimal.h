#import <Foundation/Foundation.h>
#import "AWSJKBigInteger.h"
@interface AWSJKBigDecimal : NSObject <NSSecureCoding>
@property(nonatomic, retain)AWSJKBigInteger *bigInteger;
@property(nonatomic, assign)NSUInteger figure;
+ (id)decimalWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (id)add:(AWSJKBigDecimal *)bigDecimal;
- (id)subtract:(AWSJKBigDecimal *)bigDecimal;
- (id)multiply:(AWSJKBigDecimal *)bigDecimal;
- (id)divide:(AWSJKBigDecimal *)bigDecimal;
- (id)remainder:(AWSJKBigDecimal *)bigInteger;
- (NSComparisonResult) compare:(AWSJKBigDecimal *)other;
- (id)pow:(unsigned int)exponent;
- (id)negate;
- (id)abs;
- (NSString *)stringValue;
- (NSString *)description;
@end