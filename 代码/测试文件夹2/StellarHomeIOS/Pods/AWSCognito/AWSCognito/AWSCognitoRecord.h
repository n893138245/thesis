#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, AWSCognitoRecordValueType) {
    AWSCognitoRecordValueTypeUnknown,
    AWSCognitoRecordValueTypeString,
    AWSCognitoRecordValueTypeDeleted,
};
@interface AWSCognitoRecordValue : NSObject
@property (nonatomic, readonly) AWSCognitoRecordValueType type;
- (instancetype)initWithString:(NSString *)value;
- (NSString *)string;
@end
@interface AWSCognitoRecordMetadata : NSObject
@property (nonatomic, readonly) NSString *recordId;
@property (nonatomic, readonly) NSDate *lastModified;
@property (nonatomic, strong) NSString *lastModifiedBy;
@property (nonatomic, readonly, getter = isDirty) BOOL dirty;
@property (nonatomic, assign) int64_t dirtyCount;
@property (nonatomic, assign) int64_t syncCount;
- (instancetype)initWithId:(NSString *)recordId;
- (BOOL)isEqualMetadata:(id)object;
@end
@interface AWSCognitoRecord : AWSCognitoRecordMetadata
@property (nonatomic, strong) AWSCognitoRecordValue *data;
- (instancetype)initWithId:(NSString *)recordId
                      data:(AWSCognitoRecordValue *)data;
- (BOOL)isDeleted;
@end