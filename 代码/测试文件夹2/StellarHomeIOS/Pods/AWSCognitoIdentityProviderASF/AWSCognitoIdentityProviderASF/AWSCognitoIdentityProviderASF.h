#import <Foundation/Foundation.h>
FOUNDATION_EXPORT double AWSCognitoIdentityProviderASFVersionNumber DEPRECATED_MSG_ATTRIBUTE("Use AWSCognitoIdentityProviderASFSDKVersion instead.");
FOUNDATION_EXPORT const unsigned char AWSCognitoIdentityProviderASFVersionString[] DEPRECATED_MSG_ATTRIBUTE("Use AWSCognitoIdentityProviderASFSDKVersion instead.");
@interface AWSCognitoIdentityProviderASF : NSObject
+ (NSString  * _Nullable) userContextData: (NSString* _Nonnull) userPoolId username: (NSString * _Nullable) username deviceId: (NSString * _Nullable ) deviceId userPoolClientId: (NSString * _Nonnull) userPoolClientId;
@end