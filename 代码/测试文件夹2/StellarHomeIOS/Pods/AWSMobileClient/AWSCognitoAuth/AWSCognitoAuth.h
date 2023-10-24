#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoAuthSDKVersion;
@class AWSCognitoAuthUserSession;
@class AWSCognitoAuthUserSessionToken;
@class AWSCognitoAuthConfiguration;
@protocol AWSCognitoAuthDelegate;
FOUNDATION_EXPORT NSString *const AWSCognitoAuthErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoAuthClientErrorType) {
    AWSCognitoAuthClientErrorUnknown = 0,
    AWSCognitoAuthClientErrorUserCanceledOperation = -1000,
    AWSCognitoAuthClientErrorLoadingPageFailed = -2000,
    AWSCognitoAuthClientErrorBadRequest = -3000,
    AWSCognitoAuthClientErrorSecurityFailed = -4000,
    AWSCognitoAuthClientInvalidAuthenticationDelegate = -5000,
    AWSCognitoAuthClientNoIdTokenIssued = -6000,
    AWSCognitoAuthClientErrorExpiredRefreshToken = -7000
};
typedef void (^AWSCognitoAuthGetSessionBlock)(AWSCognitoAuthUserSession * _Nullable session, NSError * _Nullable error);
typedef void (^AWSCognitoAuthSignOutBlock)(NSError * _Nullable error);
@interface AWSCognitoAuth : NSObject
@property (nonatomic, weak) id <AWSCognitoAuthDelegate> delegate;
@property (nonatomic, readonly) AWSCognitoAuthConfiguration *authConfiguration;
@property (nonatomic, readonly, getter=isSignedIn) BOOL signedIn;
+ (instancetype)defaultCognitoAuth;
+ (void)registerCognitoAuthWithAuthConfiguration:(AWSCognitoAuthConfiguration *)authConfiguration
                                          forKey:(NSString *)key;
+ (instancetype)CognitoAuthForKey:(NSString *)key;
+ (void)removeCognitoAuthForKey:(NSString *)key;
- (void)getSession:(UIViewController *) vc completion: (nullable AWSCognitoAuthGetSessionBlock) completion;
- (void)getSession: (nullable AWSCognitoAuthGetSessionBlock) completion;
- (void) signOut:(UIViewController *) vc completion: (nullable AWSCognitoAuthSignOutBlock) completion;
- (void) signOut: (nullable AWSCognitoAuthSignOutBlock) completion;
-(void) signOutLocally;
-(void) signOutLocallyAndClearLastKnownUser;
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
@end
@interface AWSCognitoAuthConfiguration : NSObject
@property (nonatomic, readonly) NSString * appClientId;
@property (nonatomic, readonly, nullable) NSString * appClientSecret;
@property (nonatomic, readonly) NSSet<NSString *> * scopes;
@property (nonatomic, readonly) NSString * signInRedirectUri;
@property (nonatomic, readonly) NSString * signOutRedirectUri;
@property (nonatomic, readonly) NSString * webDomain;
@property (nonatomic, readonly, nullable) NSString * identityProvider;
@property (nonatomic, readonly, nullable) NSString * idpIdentifier;
@property (nonatomic, readonly, nullable) NSString * userPoolId;
@property (nonatomic, assign, readonly, getter=isASFEnabled) BOOL asfEnabled;
@property (nonatomic, assign, readonly) BOOL isSFAuthenticationSessionEnabled;
- (instancetype)initWithAppClientId:(NSString *) appClientId
                    appClientSecret:(nullable NSString *) appClientSecret
                             scopes:(NSSet<NSString *> *) scopes
                  signInRedirectUri:(NSString *) signInRedirectUri
                 signOutRedirectUri:(NSString *) signOutRedirectUri
                          webDomain:(NSString *) webDomain;
- (instancetype)initWithAppClientId:(NSString *) appClientId
                    appClientSecret:(nullable NSString *) appClientSecret
                             scopes:(NSSet<NSString *> *) scopes
                  signInRedirectUri:(NSString *) signInRedirectUri
                 signOutRedirectUri:(NSString *) signOutRedirectUri
                          webDomain:(NSString *) webDomain
                   identityProvider:(nullable NSString *) identityProvider
                      idpIdentifier:(nullable NSString *) idpIdentifier
           userPoolIdForEnablingASF:(nullable NSString *) userPoolIdForEnablingASF;
- (instancetype)initWithAppClientId:(NSString *) appClientId
                    appClientSecret:(nullable NSString *) appClientSecret
                             scopes:(NSSet<NSString *> *) scopes
                  signInRedirectUri:(NSString *) signInRedirectUri
                 signOutRedirectUri:(NSString *) signOutRedirectUri
                          webDomain:(NSString *) webDomain
                   identityProvider:(nullable NSString *) identityProvider
                      idpIdentifier:(nullable NSString *) idpIdentifier
           userPoolIdForEnablingASF:(nullable NSString *) userPoolIdForEnablingASF
     enableSFAuthSessionIfAvailable:(BOOL) enableSFAuthSession;
@end
@interface AWSCognitoAuthUserSession : NSObject
@property (nonatomic, readonly, nullable) AWSCognitoAuthUserSessionToken * idToken;
@property (nonatomic, readonly, nullable) AWSCognitoAuthUserSessionToken * accessToken;
@property (nonatomic, readonly, nullable) AWSCognitoAuthUserSessionToken * refreshToken;
@property (nonatomic, readonly, nullable) NSDate * expirationTime;
@property (nonatomic, readonly, nullable) NSString * username;
@end
@interface AWSCognitoAuthUserSessionToken : NSObject
@property (nonatomic, readonly) NSString *  tokenString;
@property (nonatomic, readonly) NSDictionary * claims;
@end
@protocol AWSCognitoAuthDelegate <NSObject>
- (UIViewController *) getViewController;
@optional
- (BOOL) shouldLaunchSignInVCIfRefreshTokenIsExpired;
@end
NS_ASSUME_NONNULL_END