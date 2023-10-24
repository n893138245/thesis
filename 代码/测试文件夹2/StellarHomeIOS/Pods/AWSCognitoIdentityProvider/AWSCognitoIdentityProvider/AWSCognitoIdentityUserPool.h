#import <Foundation/Foundation.h>
#import "AWSCognitoIdentityProviderService.h"
@class AWSCognitoIdentityUser;
@class AWSCognitoIdentityUserAttributeType;
@class AWSCognitoIdentityPasswordAuthenticationInput;
@class AWSCognitoIdentityMultifactorAuthenticationInput;
@class AWSCognitoIdentityPasswordAuthenticationDetails;
@class AWSCognitoIdentityCustomChallengeDetails;
@class AWSCognitoIdentityUserPoolConfiguration;
@class AWSCognitoIdentityUserPoolSignUpResponse;
@class AWSCognitoIdentityNewPasswordRequiredDetails;
@class AWSCognitoIdentityMfaCodeDetails;
@class AWSCognitoIdentitySoftwareMfaSetupRequiredDetails;
@class AWSCognitoIdentitySelectMfaDetails;
@protocol AWSCognitoIdentityInteractiveAuthenticationDelegate;
@protocol AWSCognitoIdentityPasswordAuthentication;
@protocol AWSCognitoIdentityMultiFactorAuthentication;
@protocol AWSCognitoIdentityCustomAuthentication;
@protocol AWSCognitoIdentityRememberDevice;
@protocol AWSCognitoIdentityNewPasswordRequired;
@protocol AWSCognitoIdentitySoftwareMfaSetupRequired;
@protocol AWSCognitoIdentitySelectMfa;
NS_ASSUME_NONNULL_BEGIN
@interface AWSCognitoIdentityUserPool : NSObject <AWSIdentityProvider, AWSIdentityProviderManager>
@property (nonatomic, readonly) AWSServiceConfiguration *configuration;
@property (nonatomic, readonly) AWSCognitoIdentityUserPoolConfiguration *userPoolConfiguration;
@property (nonatomic, readonly) NSString *identityProviderName;
@property (nonatomic, strong) id <AWSCognitoIdentityInteractiveAuthenticationDelegate> delegate;
+ (instancetype)defaultCognitoIdentityUserPool;
+ (void)registerCognitoIdentityUserPoolWithUserPoolConfiguration:(AWSCognitoIdentityUserPoolConfiguration *)userPoolConfiguration
                                                          forKey:(NSString *)key;
+ (void)registerCognitoIdentityUserPoolWithConfiguration:(nullable AWSServiceConfiguration *)configuration
                                   userPoolConfiguration:(AWSCognitoIdentityUserPoolConfiguration *)userPoolConfiguration
                                                  forKey:(NSString *)key;
+ (nullable instancetype)CognitoIdentityUserPoolForKey:(NSString *)key;
+ (void)removeCognitoIdentityUserPoolForKey:(NSString *)key;
+ (AWSCognitoIdentityUserPoolConfiguration *)buildUserPoolConfiguration:(nullable AWSServiceInfo *) serviceInfo;
- (AWSTask<AWSCognitoIdentityUserPoolSignUpResponse *> *)signUp:(NSString *)username
                                                       password:(NSString *)password
                                                 userAttributes:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)userAttributes
                                                 validationData:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)validationData
                                                 clientMetaData:(nullable NSDictionary<NSString *, NSString*> *) clientMetaData;
- (AWSTask<AWSCognitoIdentityUserPoolSignUpResponse *> *)signUp:(NSString *)username
                                                       password:(NSString *)password
                                                 userAttributes:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)userAttributes
                                                 validationData:(nullable NSArray<AWSCognitoIdentityUserAttributeType *> *)validationData;
- (nullable AWSCognitoIdentityUser *)currentUser;
- (AWSCognitoIdentityUser *)getUser;
- (AWSCognitoIdentityUser *)getUser:(NSString *)username;
- (void) clearLastKnownUser;
- (void) clearAll;
@end
@interface AWSCognitoIdentityUserPoolConfiguration : NSObject
@property (nonatomic, readonly) NSString *clientId;
@property (nonatomic, readonly, nullable) NSString *clientSecret;
@property (nonatomic, readonly) NSString *poolId;
@property (nonatomic, readonly) NSString *pinpointAppId;
@property (nonatomic, readonly) BOOL shouldProvideCognitoValidationData;
@property (nonatomic, readonly) BOOL migrationEnabled;
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(nullable NSString *)clientSecret
                          poolId:(NSString *)poolId;
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(nullable NSString *)clientSecret
                          poolId:(NSString *)poolId
shouldProvideCognitoValidationData:(BOOL)shouldProvideCognitoValidationData;
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(nullable NSString *)clientSecret
                          poolId:(NSString *)poolId
shouldProvideCognitoValidationData:(BOOL)shouldProvideCognitoValidationData
                   pinpointAppId:(nullable NSString *)pinpointAppId;
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(nullable NSString *)clientSecret
                          poolId:(NSString *)poolId
shouldProvideCognitoValidationData:(BOOL)shouldProvideCognitoValidationData
                   pinpointAppId:(nullable NSString *)pinpointAppId
                migrationEnabled:(BOOL) migrationEnabled;
@end
@interface AWSCognitoIdentityPasswordAuthenticationInput : NSObject
@property(nonatomic, readonly, nullable) NSString *lastKnownUsername;
@end
@interface AWSCognitoIdentityMultifactorAuthenticationInput : NSObject
@property(nonatomic, readonly, nullable) NSString *destination;
@property(nonatomic, assign, readonly) AWSCognitoIdentityProviderDeliveryMediumType deliveryMedium;
@end
@interface AWSCognitoIdentityPasswordAuthenticationDetails : NSObject
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong, nullable) NSArray<AWSCognitoIdentityUserAttributeType *> *validationData;
- (nullable instancetype)initWithUsername:(NSString *)username
                                 password:(NSString *)password;
@end
@interface AWSCognitoIdentityCustomChallengeDetails : NSObject
@property(nonatomic, strong, nullable) NSArray<AWSCognitoIdentityUserAttributeType *> *validationData;
@property(nonatomic, strong, nullable) NSString *initialChallengeName;
@property(nonatomic, strong) NSDictionary<NSString*,NSString*>* challengeResponses;
@property(nonatomic, copy, nullable) NSDictionary<NSString*, NSString*> *clientMetaData;
-(instancetype) initWithChallengeResponses: (NSDictionary<NSString*,NSString*> *) challengeResponses;
@end
@interface AWSCognitoIdentityNewPasswordRequiredDetails : NSObject
@property(nonatomic, strong, nonnull) NSString *proposedPassword;
@property(nonatomic, strong, nullable) NSArray<AWSCognitoIdentityUserAttributeType*> *userAttributes;
@property(nonatomic, copy, nullable) NSDictionary<NSString*, NSString*> *clientMetaData;
-(instancetype) initWithProposedPassword: (NSString *) proposedPassword userAttributes:(NSDictionary<NSString*,NSString*> *) userAttributes;
@end
@interface AWSCognitoIdentityMfaCodeDetails : NSObject
@property(nonatomic, copy, nonnull) NSString *mfaCode;
@property(nonatomic, copy, nullable) NSDictionary<NSString*, NSString*> *clientMetaData;
-(instancetype) initWithMfaCode: (NSString *) mfaCode;
@end
@interface AWSCognitoIdentityCustomAuthenticationInput : NSObject
@property(nonatomic, strong) NSDictionary<NSString*,NSString*>* challengeParameters;
-(instancetype) initWithChallengeParameters: (NSDictionary<NSString*,NSString*> *) challengeParameters;
@end
@interface AWSCognitoIdentityNewPasswordRequiredInput : NSObject
@property(nonatomic, strong) NSDictionary<NSString*,NSString*>* userAttributes;
@property(nonatomic, strong) NSSet<NSString*>* requiredAttributes;
-(instancetype) initWithUserAttributes: (NSDictionary<NSString*,NSString*> *) userAttributes requiredAttributes: (NSSet<NSString*>*) requiredAttributes;
@end
@interface AWSCognitoIdentitySoftwareMfaSetupRequiredInput : NSObject
@property(nonatomic, strong) NSString *secretCode;
@property(nonatomic, strong) NSString *username;
-(instancetype) initWithSecretCode: (NSString *) secretCode username: (NSString *) username;
@end
@interface AWSCognitoIdentitySoftwareMfaSetupRequiredDetails : NSObject
@property(nonatomic, strong, nonnull) NSString *userCode;
@property(nonatomic, strong, nullable) NSString *friendlyDeviceName;
-(instancetype) initWithUserCode: (NSString *) userCode friendlyDeviceName:(NSString* _Nullable) friendlyDeviceName;
@end
@interface AWSCognitoIdentitySelectMfaInput : NSObject
@property(nonatomic, strong) NSDictionary<NSString*,NSString *>* availableMfas;
-(instancetype) initWithAvailableMfas: (NSDictionary<NSString*,NSString *>*) availableMfas;
@end
@interface AWSCognitoIdentitySelectMfaDetails : NSObject
@property(nonatomic, strong, nonnull) NSString *selectedMfa;
-(instancetype) initWithSelectedMfa:(NSString*) selectedMfa;
@end
typedef NS_ENUM(NSInteger, AWSCognitoIdentityClientErrorType) {
    AWSCognitoIdentityProviderClientErrorUnknown = 0,
    AWSCognitoIdentityProviderClientErrorInvalidAuthenticationDelegate = -1000,
    AWSCognitoIdentityProviderClientErrorCustomAuthenticationNotSupported = -2000,
    AWSCognitoIdentityProviderClientErrorDeviceNotTracked = -3000,
};
@interface AWSCognitoIdentityUserPoolSignUpResponse : AWSCognitoIdentityProviderSignUpResponse
@property (nonatomic, readonly) AWSCognitoIdentityUser* user;
@end
@protocol AWSCognitoIdentityInteractiveAuthenticationDelegate <NSObject>
@optional
-(id<AWSCognitoIdentityPasswordAuthentication>) startPasswordAuthentication;
-(id<AWSCognitoIdentityMultiFactorAuthentication>) startMultiFactorAuthentication;
-(id<AWSCognitoIdentityRememberDevice>) startRememberDevice;
-(id<AWSCognitoIdentityNewPasswordRequired>) startNewPasswordRequired;
-(id<AWSCognitoIdentityCustomAuthentication>) startCustomAuthentication;
-(id<AWSCognitoIdentitySoftwareMfaSetupRequired>) startSoftwareMfaSetupRequired;
-(id<AWSCognitoIdentitySelectMfa>) startSelectMfa;
@end
@protocol AWSCognitoIdentityPasswordAuthentication <NSObject>
-(void) getPasswordAuthenticationDetails: (AWSCognitoIdentityPasswordAuthenticationInput *) authenticationInput  passwordAuthenticationCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails *> *) passwordAuthenticationCompletionSource;
-(void) didCompletePasswordAuthenticationStepWithError:(NSError* _Nullable) error;
@end
@protocol AWSCognitoIdentityMultiFactorAuthentication <NSObject>
@optional
-(void) getMultiFactorAuthenticationCode: (AWSCognitoIdentityMultifactorAuthenticationInput *) authenticationInput
                 mfaCodeCompletionSource: (AWSTaskCompletionSource<NSString *> *) mfaCodeCompletionSource __attribute__((deprecated("Use `getMultiFactorAuthenticationCode_v2:mfaCodeCompletionSource:` instead")));
@optional
-(void) getMultiFactorAuthenticationCode_v2: (AWSCognitoIdentityMultifactorAuthenticationInput *) authenticationInput
                    mfaCodeCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentityMfaCodeDetails *> *) mfaCodeCompletionSource;
-(void) didCompleteMultifactorAuthenticationStepWithError:(NSError* _Nullable) error;
@end
@protocol AWSCognitoIdentityCustomAuthentication <NSObject>
-(void) getCustomChallengeDetails: (AWSCognitoIdentityCustomAuthenticationInput *) authenticationInput customAuthCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails *> *) customAuthCompletionSource;
-(void) didCompleteCustomAuthenticationStepWithError:(NSError* _Nullable) error;
@end
@protocol AWSCognitoIdentityRememberDevice <NSObject>
-(void) getRememberDevice: (AWSTaskCompletionSource<NSNumber *> *) rememberDeviceCompletionSource;
-(void) didCompleteRememberDeviceStepWithError:(NSError* _Nullable) error;
@end
@protocol AWSCognitoIdentityNewPasswordRequired <NSObject>
-(void) getNewPasswordDetails: (AWSCognitoIdentityNewPasswordRequiredInput *) newPasswordRequiredInput newPasswordRequiredCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails *> *) newPasswordRequiredCompletionSource;
-(void) didCompleteNewPasswordStepWithError:(NSError* _Nullable) error;
@end
@protocol AWSCognitoIdentitySoftwareMfaSetupRequired <NSObject>
-(void) getSoftwareMfaSetupDetails: (AWSCognitoIdentitySoftwareMfaSetupRequiredInput *) softwareMfaSetupInput softwareMfaSetupRequiredCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentitySoftwareMfaSetupRequiredDetails *> *) softwareMfaSetupRequiredCompletionSource;
-(void) didCompleteMfaSetupStepWithError:(NSError* _Nullable) error;
@end
@protocol AWSCognitoIdentitySelectMfa <NSObject>
-(void) getSelectMfaDetails: (AWSCognitoIdentitySelectMfaInput *) selectMfaInput selectMfaCompletionSource: (AWSTaskCompletionSource<AWSCognitoIdentitySelectMfaDetails *> *) selectMfaCompletionSource;
-(void) didCompleteSelectMfaStepWithError:(NSError* _Nullable) error;
@end
NS_ASSUME_NONNULL_END