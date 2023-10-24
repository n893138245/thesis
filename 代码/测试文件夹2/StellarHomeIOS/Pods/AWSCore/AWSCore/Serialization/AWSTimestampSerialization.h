#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSTimestampSerializationErrorDomain;
typedef NS_ENUM(NSInteger, AWSTimestampSerializationError) {
    AWSTimestampParserError
};
@interface AWSTimestampSerialization: NSObject
+ (nullable NSString *)serializeTimestamp:(NSDictionary *)rules
                                    value:(NSDate *)value
                                    error:(NSError *__autoreleasing *)error;
+ (nullable NSDate *)parseTimestamp:(id)value;
@end
@interface AWSJSONTimestampSerialization: AWSTimestampSerialization
@end
@interface AWSXMLTimestampSerialization: AWSTimestampSerialization
@end
@interface AWSQueryTimestampSerialization: AWSTimestampSerialization
@end
@interface AWSEC2TimestampSerialization: AWSTimestampSerialization
@end
NS_ASSUME_NONNULL_END