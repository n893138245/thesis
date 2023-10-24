#import <Foundation/Foundation.h>
#import "AWSCognitoIdentityProviderService.h"
typedef NS_ENUM(NSInteger, AWSCognitoIdentityUserStatus) {
    AWSCognitoIdentityUserStatusUnknown = 0,
    AWSCognitoIdentityUserStatusConfirmed = -1000,
    AWSCognitoIdentityUserStatusUnconfirmed = -2000,
};
@class AWSCognitoIdentityUserPool;
@class AWSCognitoIdentityUserSession;
@class AWSCognitoIdentityUserSessionToken;
@class AWSCognitoIdentityUserSettings;
@class AWSCognitoIdentityUserMFAOption;
@class AWSCognitoIdentityUserMfaType;
@class AWSCognitoIdentityUserMfaPreferences;
@class AWSCognitoIdentityUserConfirmSignUpResponse;
@class AWSCognitoIdentityUserGetDetailsResponse;
@class AWSCognitoIdentityUserResendConfirmationCodeResponse;
@class AWSCognitoIdentityUserForgotPasswordResponse;
@class AWSCognitoIdentityUserConfirmForgotPasswordResponse;
@class AWSCognitoIdentityUserChangePasswordResponse;
@class AWSCognitoIdentityUserAttributeType;
@class AWSCognitoIdentityUserUpdateAttributesResponse;
@class AWSCognitoIdentityUserDeleteAttributesResponse;
@class AWSCognitoIdentityUserVerifyAttributeResponse;
@class AWSCognitoIdentityUserGetAttributeVerificationCodeResponse;
@class AWSCognitoIdentityUserSetUserSettingsResponse;
@class AWSCognitoIdentityUserGlobalSignOutResponse;
@class AWSCognitoIdentityUserListDevicesResponse;
@class AWSCognitoIdentityUserUpdateDeviceStatusResponse;
@class AWSCognitoIdentityUserGetDeviceResponse;
@class AWSCognitoIdentityUserSetUserMfaPreferenceResponse;
@class AWSCognitoIdentityUserAssociateSoftwareTokenResponse;
@class AWSCognitoIdentityUserVerifySoftwareTokenResponse;
NS_ASSUME_NONNULL_BEGIN
@interface AWSCognitoIdentityUser : NSObject
@property (nonatomic, readonly, nullable) NSString *username;
@property (nonatomic, readonly) AWSCognitoIdentityUserStatus confirmedStatus;
@property (nonatomic, readonly, getter=isSignedIn) BOOL signedIn;
@property (nonatomic, readonly) NSString * deviceId;
- (AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse *> *)confirmSignUp:(NSString *)confirmationCode;
-(AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse *> *) confirmSignUp:(NSString *) confirmationCode
                                                       forceAliasCreation:(BOOL)forceAliasCreation;
-(AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse *> *) confirmSignUp:(NSString *) confirmationCode
                                                           clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
-(AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse *> *) confirmSignUp:(NSString *) confirmationCode
                                                       forceAliasCreation:(BOOL)forceAliasCreation
                                                           clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserResendConfirmationCodeResponse *> *)resendConfirmationCode: (nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserResendConfirmationCodeResponse *> *)resendConfirmationCode;
- (AWSTask<AWSCognitoIdentityUserSession *> *)getSession;
- (AWSTask<AWSCognitoIdentityUserSession *> *)getSession:(NSString *)username
                                                password:(NSString *)password
                                          validationData:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)validationData;
- (AWSTask<AWSCognitoIdentityUserSession *> *)getSession:(NSString *)username
                                                password:(NSString *)password
                                          validationData:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)validationData
                                          clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserSession *> *)getSession:(NSString *)username
                                                password:(NSString *)password
                                          validationData:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)validationData
                                isInitialCustomChallenge:(BOOL)isInitialCustomChallenge;
- (AWSTask<AWSCognitoIdentityUserSession *> *)getSession:(NSString *)username
                                                password:(NSString *)password
                                          validationData:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)validationData
                                          clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData
                                isInitialCustomChallenge:(BOOL)isInitialCustomChallenge;
- (AWSTask<AWSCognitoIdentityUserGetDetailsResponse *> *)getDetails;
- (AWSTask<AWSCognitoIdentityUserForgotPasswordResponse *> *)forgotPassword:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserForgotPasswordResponse *> *)forgotPassword;
- (AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse *> *)confirmForgotPassword:(NSString *)confirmationCode
                                                                                 password:(NSString *)password
                                                                           clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse *> *)confirmForgotPassword:(NSString *)confirmationCode
                                                                                 password:(NSString *)password;
- (AWSTask<AWSCognitoIdentityUserChangePasswordResponse *> *)changePassword:(NSString *)currentPassword
                                                           proposedPassword:(NSString *)proposedPassword;
- (AWSTask<AWSCognitoIdentityUserUpdateAttributesResponse *> *)updateAttributes:(NSArray<AWSCognitoIdentityUserAttributeType *> *)attributes
                                                                 clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserUpdateAttributesResponse *> *)updateAttributes:(NSArray<AWSCognitoIdentityUserAttributeType *> *)attributes;
- (AWSTask<AWSCognitoIdentityUserDeleteAttributesResponse *> *)deleteAttributes:(NSArray<NSString *> *)attributeNames;
- (AWSTask<AWSCognitoIdentityUserVerifyAttributeResponse *> *)verifyAttribute:(NSString *)attributeName
                                                                         code:(NSString *)code;
- (AWSTask<AWSCognitoIdentityUserGetAttributeVerificationCodeResponse *> *)getAttributeVerificationCode:(NSString *)attributeName
                                                                                         clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserGetAttributeVerificationCodeResponse *> *)getAttributeVerificationCode:(NSString *)attributeName;
- (AWSTask<AWSCognitoIdentityUserSetUserSettingsResponse *> *)setUserSettings:(AWSCognitoIdentityUserSettings *)settings;
- (AWSTask<AWSCognitoIdentityUserSetUserMfaPreferenceResponse *> *)setUserMfaPreference:(AWSCognitoIdentityUserMfaPreferences *) preferences;
- (AWSTask<AWSCognitoIdentityUserAssociateSoftwareTokenResponse *> *) associateSoftwareToken;
-(AWSTask<AWSCognitoIdentityUserVerifySoftwareTokenResponse *>*) verifySoftwareToken: (NSString*) userCode friendlyDeviceName: (NSString* _Nullable) friendlyDeviceName;
- (AWSTask *)deleteUser;
- (void)signOut;
- (AWSTask<AWSCognitoIdentityUserGlobalSignOutResponse *> *) globalSignOut;
- (void) signOutAndClearLastKnownUser;
- (void) clearSession;
- (AWSTask<AWSCognitoIdentityUserListDevicesResponse *> *) listDevices: (int) limit paginationToken:(NSString * _Nullable) paginationToken;
- (AWSTask<AWSCognitoIdentityUserUpdateDeviceStatusResponse *> *) updateDeviceStatus: (NSString *) deviceId remembered:(BOOL) remembered;
- (AWSTask<AWSCognitoIdentityUserUpdateDeviceStatusResponse *> *) updateDeviceStatus: (BOOL) remembered;
- (AWSTask<AWSCognitoIdentityUserGetDeviceResponse *> *) getDevice: (NSString *) deviceId;
- (AWSTask<AWSCognitoIdentityUserGetDeviceResponse *> *) getDevice;
- (AWSTask *) forgetDevice: (NSString *) deviceId;
- (AWSTask *) forgetDevice;
@end
@interface AWSCognitoIdentityUserSession : NSObject
@property (nonatomic, readonly) AWSCognitoIdentityUserSessionToken * _Nullable idToken;
@property (nonatomic, readonly) AWSCognitoIdentityUserSessionToken * _Nullable accessToken;
@property (nonatomic, readonly) AWSCognitoIdentityUserSessionToken * _Nullable refreshToken;
@property (nonatomic, readonly) NSDate * _Nullable expirationTime;
@end
@interface AWSCognitoIdentityUserSessionToken : NSObject
@property (nonatomic, readonly) NSString *  tokenString;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString*> * claims DEPRECATED_MSG_ATTRIBUTE("Use `tokenClaims` instead.");
@property (nonatomic, readonly) NSDictionary<NSString *, id> * tokenClaims;
@end
@interface AWSCognitoIdentityUserSettings : NSObject
@property (nonatomic, copy) NSArray<AWSCognitoIdentityUserMFAOption *>* _Nullable mfaOptions;
@end
@interface AWSCognitoIdentityUserMfaPreferences : NSObject
@property (nonatomic, strong) AWSCognitoIdentityUserMfaType* _Nullable smsMfa;
@property (nonatomic, strong) AWSCognitoIdentityUserMfaType* _Nullable softwareTokenMfa;
@end
@interface AWSCognitoIdentityUserMfaType : NSObject
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL preferred;
- (instancetype) initWithEnabled:(BOOL) enabled preferred:(BOOL) preferred;
@end
@interface AWSCognitoIdentityUserMFAOption : NSObject
@property (nonatomic, strong) NSString *  attributeName;
@property (nonatomic, assign) AWSCognitoIdentityProviderDeliveryMediumType deliveryMedium;
@end
@interface AWSCognitoIdentityUserAttributeType : AWSCognitoIdentityProviderAttributeType
- (instancetype) initWithName:(NSString *) name value:(NSString *) value;
@end
#pragma Response wrappers
@interface AWSCognitoIdentityUserConfirmSignUpResponse : AWSCognitoIdentityProviderConfirmSignUpResponse
@end
@interface AWSCognitoIdentityUserResendConfirmationCodeResponse :AWSCognitoIdentityProviderResendConfirmationCodeResponse
@end
@interface AWSCognitoIdentityUserGetDetailsResponse : AWSCognitoIdentityProviderGetUserResponse
@end
@interface AWSCognitoIdentityUserForgotPasswordResponse : AWSCognitoIdentityProviderForgotPasswordResponse
@end
@interface AWSCognitoIdentityUserConfirmForgotPasswordResponse : AWSCognitoIdentityProviderConfirmForgotPasswordResponse
@end
@interface AWSCognitoIdentityUserChangePasswordResponse : AWSCognitoIdentityProviderChangePasswordResponse
@end
@interface AWSCognitoIdentityUserUpdateAttributesResponse : AWSCognitoIdentityProviderUpdateUserAttributesResponse
@end
@interface AWSCognitoIdentityUserDeleteAttributesResponse : AWSCognitoIdentityProviderDeleteUserAttributesResponse
@end
@interface AWSCognitoIdentityUserVerifyAttributeResponse : AWSCognitoIdentityProviderVerifyUserAttributeResponse
@end
@interface AWSCognitoIdentityUserGetAttributeVerificationCodeResponse : AWSCognitoIdentityProviderGetUserAttributeVerificationCodeResponse
@end
@interface AWSCognitoIdentityUserSetUserSettingsResponse : AWSCognitoIdentityProviderSetUserSettingsResponse
@end
@interface AWSCognitoIdentityUserGlobalSignOutResponse : AWSCognitoIdentityProviderGlobalSignOutResponse
@end
@interface AWSCognitoIdentityUserListDevicesResponse : AWSCognitoIdentityProviderListDevicesResponse
@end
@interface AWSCognitoIdentityUserUpdateDeviceStatusResponse : AWSCognitoIdentityProviderUpdateDeviceStatusResponse
@end
@interface AWSCognitoIdentityUserGetDeviceResponse : AWSCognitoIdentityProviderGetDeviceResponse
@end
@interface AWSCognitoIdentityUserVerifySoftwareTokenResponse : AWSCognitoIdentityProviderVerifySoftwareTokenResponse
@end
@interface AWSCognitoIdentityUserAssociateSoftwareTokenResponse : AWSCognitoIdentityProviderAssociateSoftwareTokenResponse
@end
@interface AWSCognitoIdentityUserSetUserMfaPreferenceResponse : AWSCognitoIdentityProviderSetUserMFAPreferenceResponse
@end
NS_ASSUME_NONNULL_END