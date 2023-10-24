#import "AWSCognitoRecord.h"
@interface AWSCognitoRecordMetadata()
@property (nonatomic, strong) NSDate *lastModified;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
@interface AWSCognitoRecord()
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (AWSCognitoRecord *)copyForFlush;
@end
@interface AWSCognitoRecordValue()
@property (nonatomic, assign) AWSCognitoRecordValueType type;
@property (nonatomic, strong) NSObject *stringValue;
- (instancetype)initWithString:(NSString *)value
                          type:(AWSCognitoRecordValueType)type;
- (NSString *)toJsonString;
- (instancetype)initWithJson:(NSString *)json
                        type:(AWSCognitoRecordValueType)type;
@end