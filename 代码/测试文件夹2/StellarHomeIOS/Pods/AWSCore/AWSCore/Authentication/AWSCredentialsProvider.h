#import <Foundation/Foundation.h>
#import "AWSServiceEnum.h"
#import "AWSIdentityProvider.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoCredentialsProviderErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoCredentialsProviderErrorType) {
    AWSCognitoCredentialsProviderErrorUnknown,
    AWSCognitoCredentialsProviderIdentityIdIsNil,
    AWSCognitoCredentialsProviderInvalidConfiguration,
    AWSCognitoCredentialsProviderInvalidCognitoIdentityToken,
    AWSCognitoCredentialsProviderCredentialsRefreshTimeout,
};
@class AWSTask<__covariant ResultType>;
@class AWSCancellationTokenSource;
@interface AWSCredentials : NSObject
@property (nonatomic, strong, readonly) NSString *accessKey;
@property (nonatomic, strong, readonly) NSString *secretKey;
@property (nonatomic, strong, readonly, nullable) NSString *sessionKey;
@property (nonatomic, strong, readonly, nullable) NSDate *expiration;
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey
                       sessionKey:(nullable NSString *)sessionKey
                       expiration:(nullable NSDate *)expiration;
@end
@protocol AWSCredentialsProvider <NSObject>
- (AWSTask<AWSCredentials *> *)credentials;
- (void)invalidateCachedTemporaryCredentials;
@end
@interface AWSStaticCredentialsProvider : NSObject <AWSCredentialsProvider>
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey;
@end
@interface AWSBasicSessionCredentialsProvider: NSObject <AWSCredentialsProvider>
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey
                     sessionToken:(NSString *)sessionToken;
@end
@interface AWSAnonymousCredentialsProvider : NSObject <AWSCredentialsProvider>
@end
@interface AWSWebIdentityCredentialsProvider : NSObject <AWSCredentialsProvider>
@property (nonatomic, strong) NSString *webIdentityToken;
@property (nonatomic, strong) NSString *roleArn;
@property (nonatomic, strong) NSString *roleSessionName;
@property (nonatomic, strong) NSString *providerId;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                        providerId:(nullable NSString *)providerId
                           roleArn:(NSString *)roleArn
                   roleSessionName:(NSString *)roleSessionName
                  webIdentityToken:(NSString *)webIdentityToken;
@end
@interface AWSCognitoCredentialsProvider : NSObject <AWSCredentialsProvider>
@property (nonatomic, strong, readonly) id<AWSCognitoCredentialsProviderHelper> identityProvider;
@property (nonatomic, strong, readonly, nullable) NSString *identityId;
@property (nonatomic, strong, readonly) NSString *identityPoolId;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
         identityPoolConfiguration:(AWSServiceConfiguration *)configuration;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
           identityProviderManager:(nullable id<AWSIdentityProviderManager>)identityProviderManager;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                  identityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                     unauthRoleArn:(nullable NSString *)unauthRoleArn
                       authRoleArn:(nullable NSString *)authRoleArn
                  identityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                     unauthRoleArn:(nullable NSString *)unauthRoleArn
                       authRoleArn:(nullable NSString *)authRoleArn
           identityProviderManager:(nullable id<AWSIdentityProviderManager>)identityProviderManager;
- (AWSTask<NSString *> *)getIdentityId;
- (void)clearKeychain;
- (void)clearCredentials;
- (void)setIdentityProviderManagerOnce:(id<AWSIdentityProviderManager>)identityProviderManager;
@end
NS_ASSUME_NONNULL_END