#import "AWSCognitoRecord.h"
#import "AWSCognitoSyncModel.h"
@interface AWSCognitoUtil : NSObject
+ (NSDate *)millisSinceEpochToDate:(NSNumber *)millisSinceEpoch;
+ (NSDate *)secondsSinceEpochToDate:(NSNumber *)secondsSinceEpoch;
+ (long long)getTimeMillisForDate:(NSDate *)date;
+ (NSError *)errorRemoteDataStorageFailed:(NSString *)failureReason;
+ (NSError *)errorInvalidDataValue:(NSString *)failureReason key:(NSString *)key value:(id)value;
+ (NSError *)errorUserDataSizeLimitExceeded:(NSString *)failureReason;
+ (NSError *)errorLocalDataStorageFailed:(NSString *)failureReason;
+ (NSError *)errorIllegalArgument:(NSString *)failureReason;
+ (id)retrieveValue:(AWSCognitoRecordValue *)value;
+ (BOOL)isValidRecordValueType:(AWSCognitoRecordValueType)type;
+ (NSString *) pushPlatformString:(AWSCognitoSyncPlatform) pushPlatform;
+ (AWSCognitoSyncPlatform) pushPlatform;
+ (NSString *) deviceIdKey:(AWSCognitoSyncPlatform) pushPlatformString;
+ (NSString *) deviceIdentityKey:(AWSCognitoSyncPlatform) pushPlatformString;
@end