#import <Foundation/Foundation.h>
#import "AWSTimestampSerialization.h"
#import "AWSCategory.h"
NSString *const AWSTimestampSerializationErrorDomain = @"com.amazonaws.AWSTimestampSerializationErrorDomain";
@implementation AWSTimestampSerialization
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSTimestampSerializationErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (nullable NSDate *)parseTimestamp:(id)value{
    NSDate *timeStampDate;
    if ([value isKindOfClass:[NSString class]]) {
        timeStampDate = [NSDate aws_dateFromString:value];
        if (!timeStampDate) {
            timeStampDate = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        timeStampDate = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    } else if ([value isKindOfClass:[NSDate class]]) {
        timeStampDate = value;
    }
    return timeStampDate;
}
+ (nullable NSString *)serializeTimestamp:(NSDictionary *)rules value:(id)value error:(NSError *__autoreleasing *)error {
    if (!value || ![rules[@"type"] isEqualToString:@"timestamp"]) {
        return nil;
    } else {
        NSString *timestampStr;
        NSDate *timeStampDate = [self parseTimestamp:value];
        if (timeStampDate == nil) {
            [self failWithCode:AWSTimestampParserError
                   description:[NSString stringWithFormat:@"the timestamp value is invalid:%@",value]
                         error:error];
        } else {
            if ([rules[@"timestampFormat"] isEqualToString:@"iso8601"]) {
                timestampStr = [timeStampDate aws_stringValue:AWSDateISO8601DateFormat1];
            } else if ([rules[@"timestampFormat"] isEqualToString:@"unixTimestamp"]) {
                timestampStr = [NSString stringWithFormat:@"%.lf",[timeStampDate timeIntervalSince1970]];
            } else if ([rules[@"timestampFormat"] isEqualToString:@"rfc822"]) {
                timestampStr = [timeStampDate aws_stringValue: AWSDateRFC822DateFormat1];
            }
        }
        return timestampStr;
    }
}
@end
@implementation AWSJSONTimestampSerialization
+ (nullable NSString *)serializeTimestamp:(NSDictionary *)rules value:(id)value error:(NSError *__autoreleasing *)error {
    NSString *timestampStr = [super serializeTimestamp:rules value:value error:error];
    if (!timestampStr.length){
        NSDate *timeStampDate = [self parseTimestamp:value];
        timestampStr = [NSString stringWithFormat:@"%.lf",[timeStampDate timeIntervalSince1970]];
    }
    return timestampStr;
}
@end
@implementation AWSXMLTimestampSerialization
+ (nullable NSString *)serializeTimestamp:(NSDictionary *)rules value:(id)value error:(NSError *__autoreleasing *)error {
    NSString *timestampStr = [super serializeTimestamp:rules value:value error:error];
    if (!timestampStr.length){
        NSDate *timeStampDate = [self parseTimestamp:value];
        timestampStr = [timeStampDate aws_stringValue: AWSDateRFC822DateFormat1];
    }
    return timestampStr;
}
@end
@implementation AWSQueryTimestampSerialization
+ (nullable NSString *)serializeTimestamp:(NSDictionary *)rules value:(id)value error:(NSError *__autoreleasing *)error {
    NSString *timestampStr = [super serializeTimestamp:rules value:value error:error];
    if (!timestampStr.length){
        NSDate *timeStampDate = [self parseTimestamp:value];
        timestampStr = [timeStampDate aws_stringValue: AWSDateISO8601DateFormat1];
    }
    return timestampStr;
}
@end
@implementation AWSEC2TimestampSerialization
+ (nullable NSString *)serializeTimestamp:(NSDictionary *)rules value:(id)value error:(NSError *__autoreleasing *)error {
    NSString *timestampStr = [super serializeTimestamp:rules value:value error:error];
    if (!timestampStr.length){
        NSDate *timeStampDate = [self parseTimestamp:value];
        timestampStr = [timeStampDate aws_stringValue: AWSDateISO8601DateFormat1];
    }
    return timestampStr;
}
@end