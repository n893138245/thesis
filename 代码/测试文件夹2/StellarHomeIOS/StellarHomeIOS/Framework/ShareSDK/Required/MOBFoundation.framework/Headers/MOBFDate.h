#import <Foundation/Foundation.h>
@interface MOBFDate : NSObject
+ (NSInteger)fullYearByDate:(NSDate *)date;
+ (NSInteger)monthByDate:(NSDate *)date;
+ (NSInteger)dayByDate:(NSDate *)date;
+ (NSInteger)hourByDate:(NSDate *)date;
+ (NSInteger)minuteByDate:(NSDate *)date;
+ (NSInteger)secondByDate:(NSDate *)date;
+ (NSString *)stringByDate:(NSDate *)date
                withFormat:(NSString *)format;
+ (NSDate *)dateWithFormat:(NSString *)format
                dateString:(NSString *)dateString;
+ (NSDate *)dateWithFormat:(NSString *)format
                dateString:(NSString *)dateString
                    locale:(NSLocale *)locale;
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                    date:(NSInteger)date
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;
+ (NSTimeInterval)zeroTimeInterval;
@end