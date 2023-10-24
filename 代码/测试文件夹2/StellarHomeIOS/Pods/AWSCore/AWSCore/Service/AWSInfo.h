#import <Foundation/Foundation.h>
#import "AWSServiceEnum.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSInfoDefault;
@class AWSServiceInfo;
@class AWSCognitoCredentialsProvider;
@class AWSServiceConfiguration;
@interface AWSInfo : NSObject
@property (nonatomic, readonly) NSDictionary <NSString *, id> *rootInfoDictionary;
+ (instancetype)defaultAWSInfo;
+ (void)configureDefaultAWSInfo:(NSDictionary<NSString *, id> *)config;
+ (void)configureIdentityPoolService:(nullable AWSServiceConfiguration *)config;
- (nullable AWSServiceInfo *)serviceInfo:(NSString *)serviceName
                                  forKey:(NSString *)key;
- (nullable AWSServiceInfo *)defaultServiceInfo:(NSString *)serviceName;
@end
@interface AWSServiceInfo : NSObject
@property (nonatomic, readonly) AWSCognitoCredentialsProvider *cognitoCredentialsProvider;
@property (nonatomic, readonly) AWSRegionType region;
@property (nonatomic, readonly) NSDictionary <NSString *, id> *infoDictionary;
@end
NS_ASSUME_NONNULL_END