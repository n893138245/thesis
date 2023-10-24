#import <Foundation/Foundation.h>
#import "AWSServiceEnum.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoIdentityIdChangedNotification;
FOUNDATION_EXPORT NSString *const AWSCognitoNotificationPreviousId;
FOUNDATION_EXPORT NSString *const AWSCognitoNotificationNewId;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderApple;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderDigits;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderFacebook;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderGoogle;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderLoginWithAmazon;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderTwitter;
FOUNDATION_EXPORT NSString *const AWSIdentityProviderAmazonCognitoIdentity;
FOUNDATION_EXPORT NSString *const AWSCognitoCredentialsProviderHelperErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoCredentialsProviderHelperErrorType) {
    AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil,
    AWSCognitoCredentialsProviderHelperErrorTypeTokenRefreshTimeout,
};
@class AWSTask<__covariant ResultType>;
@protocol AWSIdentityProvider <NSObject>
@property (nonatomic, readonly) NSString *identityProviderName;
- (AWSTask<NSString *> *)token;
@end
@protocol AWSIdentityProviderManager <NSObject>
- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins;
@optional
@property (nonatomic, readonly) NSString *customRoleArn;
@end
@protocol AWSCognitoCredentialsProviderHelper <AWSIdentityProvider, AWSIdentityProviderManager>
@property (nonatomic, strong, readonly) NSString *identityPoolId;
@property (nonatomic, strong, nullable) NSString *identityId;
@property (nonatomic, strong, readonly, nullable) id<AWSIdentityProviderManager> identityProviderManager;
- (AWSTask<NSString *> *)getIdentityId;
- (BOOL)isAuthenticated;
- (void)clear;
@end
@interface AWSAbstractCognitoCredentialsProviderHelper : NSObject <AWSCognitoCredentialsProviderHelper>
@property (nonatomic, strong, readonly) NSString *identityPoolId;
@property (nonatomic, strong, nullable) NSString *identityId;
@property (nonatomic, strong, readonly, nullable) id<AWSIdentityProviderManager> identityProviderManager;
@end
@class AWSServiceConfiguration;
@interface AWSCognitoCredentialsProviderHelper : AWSAbstractCognitoCredentialsProviderHelper
@property (nonatomic, assign) BOOL useEnhancedFlow;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                   useEnhancedFlow:(BOOL)useEnhancedFlow
           identityProviderManager:(nullable id<AWSIdentityProviderManager>)identityProviderManager;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                   useEnhancedFlow:(BOOL)useEnhancedFlow
           identityProviderManager:(nullable id<AWSIdentityProviderManager>)identityProviderManager
         identityPoolConfiguration:(AWSServiceConfiguration *)configuration;
@end
NS_ASSUME_NONNULL_END