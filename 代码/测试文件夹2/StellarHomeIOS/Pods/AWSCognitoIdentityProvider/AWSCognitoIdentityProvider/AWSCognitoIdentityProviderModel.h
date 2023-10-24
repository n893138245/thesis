#import <Foundation/Foundation.h>
#import <AWSCore/AWSNetworking.h>
#import <AWSCore/AWSModel.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoIdentityProviderErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderErrorType) {
    AWSCognitoIdentityProviderErrorUnknown,
    AWSCognitoIdentityProviderErrorAliasExists,
    AWSCognitoIdentityProviderErrorCodeDeliveryFailure,
    AWSCognitoIdentityProviderErrorCodeMismatch,
    AWSCognitoIdentityProviderErrorConcurrentModification,
    AWSCognitoIdentityProviderErrorDuplicateProvider,
    AWSCognitoIdentityProviderErrorEnableSoftwareTokenMFA,
    AWSCognitoIdentityProviderErrorExpiredCode,
    AWSCognitoIdentityProviderErrorGroupExists,
    AWSCognitoIdentityProviderErrorInternalError,
    AWSCognitoIdentityProviderErrorInvalidEmailRoleAccessPolicy,
    AWSCognitoIdentityProviderErrorInvalidLambdaResponse,
    AWSCognitoIdentityProviderErrorInvalidOAuthFlow,
    AWSCognitoIdentityProviderErrorInvalidParameter,
    AWSCognitoIdentityProviderErrorInvalidPassword,
    AWSCognitoIdentityProviderErrorInvalidSmsRoleAccessPolicy,
    AWSCognitoIdentityProviderErrorInvalidSmsRoleTrustRelationship,
    AWSCognitoIdentityProviderErrorInvalidUserPoolConfiguration,
    AWSCognitoIdentityProviderErrorLimitExceeded,
    AWSCognitoIdentityProviderErrorMFAMethodNotFound,
    AWSCognitoIdentityProviderErrorNotAuthorized,
    AWSCognitoIdentityProviderErrorPasswordResetRequired,
    AWSCognitoIdentityProviderErrorPreconditionNotMet,
    AWSCognitoIdentityProviderErrorResourceNotFound,
    AWSCognitoIdentityProviderErrorScopeDoesNotExist,
    AWSCognitoIdentityProviderErrorSoftwareTokenMFANotFound,
    AWSCognitoIdentityProviderErrorTooManyFailedAttempts,
    AWSCognitoIdentityProviderErrorTooManyRequests,
    AWSCognitoIdentityProviderErrorUnexpectedLambda,
    AWSCognitoIdentityProviderErrorUnsupportedIdentityProvider,
    AWSCognitoIdentityProviderErrorUnsupportedUserState,
    AWSCognitoIdentityProviderErrorUserImportInProgress,
    AWSCognitoIdentityProviderErrorUserLambdaValidation,
    AWSCognitoIdentityProviderErrorUserNotConfirmed,
    AWSCognitoIdentityProviderErrorUserNotFound,
    AWSCognitoIdentityProviderErrorUserPoolAddOnNotEnabled,
    AWSCognitoIdentityProviderErrorUserPoolTagging,
    AWSCognitoIdentityProviderErrorUsernameExists,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderAccountTakeoverEventActionType) {
    AWSCognitoIdentityProviderAccountTakeoverEventActionTypeUnknown,
    AWSCognitoIdentityProviderAccountTakeoverEventActionTypeBlock,
    AWSCognitoIdentityProviderAccountTakeoverEventActionTypeMfaIfConfigured,
    AWSCognitoIdentityProviderAccountTakeoverEventActionTypeMfaRequired,
    AWSCognitoIdentityProviderAccountTakeoverEventActionTypeNoAction,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderAdvancedSecurityModeType) {
    AWSCognitoIdentityProviderAdvancedSecurityModeTypeUnknown,
    AWSCognitoIdentityProviderAdvancedSecurityModeTypeOff,
    AWSCognitoIdentityProviderAdvancedSecurityModeTypeAudit,
    AWSCognitoIdentityProviderAdvancedSecurityModeTypeEnforced,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderAliasAttributeType) {
    AWSCognitoIdentityProviderAliasAttributeTypeUnknown,
    AWSCognitoIdentityProviderAliasAttributeTypePhoneNumber,
    AWSCognitoIdentityProviderAliasAttributeTypeEmail,
    AWSCognitoIdentityProviderAliasAttributeTypePreferredUsername,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderAttributeDataType) {
    AWSCognitoIdentityProviderAttributeDataTypeUnknown,
    AWSCognitoIdentityProviderAttributeDataTypeString,
    AWSCognitoIdentityProviderAttributeDataTypeNumber,
    AWSCognitoIdentityProviderAttributeDataTypeDateTime,
    AWSCognitoIdentityProviderAttributeDataTypeBoolean,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderAuthFlowType) {
    AWSCognitoIdentityProviderAuthFlowTypeUnknown,
    AWSCognitoIdentityProviderAuthFlowTypeUserSrpAuth,
    AWSCognitoIdentityProviderAuthFlowTypeRefreshTokenAuth,
    AWSCognitoIdentityProviderAuthFlowTypeRefreshToken,
    AWSCognitoIdentityProviderAuthFlowTypeCustomAuth,
    AWSCognitoIdentityProviderAuthFlowTypeAdminNoSrpAuth,
    AWSCognitoIdentityProviderAuthFlowTypeUserPasswordAuth,
    AWSCognitoIdentityProviderAuthFlowTypeAdminUserPasswordAuth,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderChallengeName) {
    AWSCognitoIdentityProviderChallengeNameUnknown,
    AWSCognitoIdentityProviderChallengeNamePassword,
    AWSCognitoIdentityProviderChallengeNameMfa,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderChallengeNameType) {
    AWSCognitoIdentityProviderChallengeNameTypeUnknown,
    AWSCognitoIdentityProviderChallengeNameTypeSmsMfa,
    AWSCognitoIdentityProviderChallengeNameTypeSoftwareTokenMfa,
    AWSCognitoIdentityProviderChallengeNameTypeSelectMfaType,
    AWSCognitoIdentityProviderChallengeNameTypeMfaSetup,
    AWSCognitoIdentityProviderChallengeNameTypePasswordVerifier,
    AWSCognitoIdentityProviderChallengeNameTypeCustomChallenge,
    AWSCognitoIdentityProviderChallengeNameTypeDeviceSrpAuth,
    AWSCognitoIdentityProviderChallengeNameTypeDevicePasswordVerifier,
    AWSCognitoIdentityProviderChallengeNameTypeAdminNoSrpAuth,
    AWSCognitoIdentityProviderChallengeNameTypeNewPasswordRequired,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderChallengeResponse) {
    AWSCognitoIdentityProviderChallengeResponseUnknown,
    AWSCognitoIdentityProviderChallengeResponseSuccess,
    AWSCognitoIdentityProviderChallengeResponseFailure,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderCompromisedCredentialsEventActionType) {
    AWSCognitoIdentityProviderCompromisedCredentialsEventActionTypeUnknown,
    AWSCognitoIdentityProviderCompromisedCredentialsEventActionTypeBlock,
    AWSCognitoIdentityProviderCompromisedCredentialsEventActionTypeNoAction,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderDefaultEmailOptionType) {
    AWSCognitoIdentityProviderDefaultEmailOptionTypeUnknown,
    AWSCognitoIdentityProviderDefaultEmailOptionTypeConfirmWithLink,
    AWSCognitoIdentityProviderDefaultEmailOptionTypeConfirmWithCode,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderDeliveryMediumType) {
    AWSCognitoIdentityProviderDeliveryMediumTypeUnknown,
    AWSCognitoIdentityProviderDeliveryMediumTypeSms,
    AWSCognitoIdentityProviderDeliveryMediumTypeEmail,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderDeviceRememberedStatusType) {
    AWSCognitoIdentityProviderDeviceRememberedStatusTypeUnknown,
    AWSCognitoIdentityProviderDeviceRememberedStatusTypeRemembered,
    AWSCognitoIdentityProviderDeviceRememberedStatusTypeNotRemembered,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderDomainStatusType) {
    AWSCognitoIdentityProviderDomainStatusTypeUnknown,
    AWSCognitoIdentityProviderDomainStatusTypeCreating,
    AWSCognitoIdentityProviderDomainStatusTypeDeleting,
    AWSCognitoIdentityProviderDomainStatusTypeUpdating,
    AWSCognitoIdentityProviderDomainStatusTypeActive,
    AWSCognitoIdentityProviderDomainStatusTypeFailed,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderEmailSendingAccountType) {
    AWSCognitoIdentityProviderEmailSendingAccountTypeUnknown,
    AWSCognitoIdentityProviderEmailSendingAccountTypeCognitoDefault,
    AWSCognitoIdentityProviderEmailSendingAccountTypeDeveloper,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderEventFilterType) {
    AWSCognitoIdentityProviderEventFilterTypeUnknown,
    AWSCognitoIdentityProviderEventFilterTypeSignIn,
    AWSCognitoIdentityProviderEventFilterTypePasswordChange,
    AWSCognitoIdentityProviderEventFilterTypeSignUp,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderEventResponseType) {
    AWSCognitoIdentityProviderEventResponseTypeUnknown,
    AWSCognitoIdentityProviderEventResponseTypeSuccess,
    AWSCognitoIdentityProviderEventResponseTypeFailure,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderEventType) {
    AWSCognitoIdentityProviderEventTypeUnknown,
    AWSCognitoIdentityProviderEventTypeSignIn,
    AWSCognitoIdentityProviderEventTypeSignUp,
    AWSCognitoIdentityProviderEventTypeForgotPassword,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderExplicitAuthFlowsType) {
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeUnknown,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeAdminNoSrpAuth,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeCustomAuthFlowOnly,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeUserPasswordAuth,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeAllowAdminUserPasswordAuth,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeAllowCustomAuth,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeAllowUserPasswordAuth,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeAllowUserSrpAuth,
    AWSCognitoIdentityProviderExplicitAuthFlowsTypeAllowRefreshTokenAuth,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderFeedbackValueType) {
    AWSCognitoIdentityProviderFeedbackValueTypeUnknown,
    AWSCognitoIdentityProviderFeedbackValueTypeValid,
    AWSCognitoIdentityProviderFeedbackValueTypeInvalid,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderIdentityProviderTypeType) {
    AWSCognitoIdentityProviderIdentityProviderTypeTypeUnknown,
    AWSCognitoIdentityProviderIdentityProviderTypeTypeSaml,
    AWSCognitoIdentityProviderIdentityProviderTypeTypeFacebook,
    AWSCognitoIdentityProviderIdentityProviderTypeTypeGoogle,
    AWSCognitoIdentityProviderIdentityProviderTypeTypeLoginWithAmazon,
    AWSCognitoIdentityProviderIdentityProviderTypeTypeSignInWithApple,
    AWSCognitoIdentityProviderIdentityProviderTypeTypeOidc,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderMessageActionType) {
    AWSCognitoIdentityProviderMessageActionTypeUnknown,
    AWSCognitoIdentityProviderMessageActionTypeResend,
    AWSCognitoIdentityProviderMessageActionTypeSuppress,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderOAuthFlowType) {
    AWSCognitoIdentityProviderOAuthFlowTypeUnknown,
    AWSCognitoIdentityProviderOAuthFlowTypeCode,
    AWSCognitoIdentityProviderOAuthFlowTypeImplicit,
    AWSCognitoIdentityProviderOAuthFlowTypeClientCredentials,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderPreventUserExistenceErrorTypes) {
    AWSCognitoIdentityProviderPreventUserExistenceErrorTypesUnknown,
    AWSCognitoIdentityProviderPreventUserExistenceErrorTypesLegacy,
    AWSCognitoIdentityProviderPreventUserExistenceErrorTypesEnabled,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderRecoveryOptionNameType) {
    AWSCognitoIdentityProviderRecoveryOptionNameTypeUnknown,
    AWSCognitoIdentityProviderRecoveryOptionNameTypeVerifiedEmail,
    AWSCognitoIdentityProviderRecoveryOptionNameTypeVerifiedPhoneNumber,
    AWSCognitoIdentityProviderRecoveryOptionNameTypeAdminOnly,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderRiskDecisionType) {
    AWSCognitoIdentityProviderRiskDecisionTypeUnknown,
    AWSCognitoIdentityProviderRiskDecisionTypeNoRisk,
    AWSCognitoIdentityProviderRiskDecisionTypeAccountTakeover,
    AWSCognitoIdentityProviderRiskDecisionTypeBlock,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderRiskLevelType) {
    AWSCognitoIdentityProviderRiskLevelTypeUnknown,
    AWSCognitoIdentityProviderRiskLevelTypeLow,
    AWSCognitoIdentityProviderRiskLevelTypeMedium,
    AWSCognitoIdentityProviderRiskLevelTypeHigh,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderStatusType) {
    AWSCognitoIdentityProviderStatusTypeUnknown,
    AWSCognitoIdentityProviderStatusTypeEnabled,
    AWSCognitoIdentityProviderStatusTypeDisabled,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderTimeUnitsType) {
    AWSCognitoIdentityProviderTimeUnitsTypeUnknown,
    AWSCognitoIdentityProviderTimeUnitsTypeSeconds,
    AWSCognitoIdentityProviderTimeUnitsTypeMinutes,
    AWSCognitoIdentityProviderTimeUnitsTypeHours,
    AWSCognitoIdentityProviderTimeUnitsTypeDays,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderUserImportJobStatusType) {
    AWSCognitoIdentityProviderUserImportJobStatusTypeUnknown,
    AWSCognitoIdentityProviderUserImportJobStatusTypeCreated,
    AWSCognitoIdentityProviderUserImportJobStatusTypePending,
    AWSCognitoIdentityProviderUserImportJobStatusTypeInProgress,
    AWSCognitoIdentityProviderUserImportJobStatusTypeStopping,
    AWSCognitoIdentityProviderUserImportJobStatusTypeExpired,
    AWSCognitoIdentityProviderUserImportJobStatusTypeStopped,
    AWSCognitoIdentityProviderUserImportJobStatusTypeFailed,
    AWSCognitoIdentityProviderUserImportJobStatusTypeSucceeded,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderUserPoolMfaType) {
    AWSCognitoIdentityProviderUserPoolMfaTypeUnknown,
    AWSCognitoIdentityProviderUserPoolMfaTypeOff,
    AWSCognitoIdentityProviderUserPoolMfaTypeOn,
    AWSCognitoIdentityProviderUserPoolMfaTypeOptional,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderUserStatusType) {
    AWSCognitoIdentityProviderUserStatusTypeUnknown,
    AWSCognitoIdentityProviderUserStatusTypeUnconfirmed,
    AWSCognitoIdentityProviderUserStatusTypeConfirmed,
    AWSCognitoIdentityProviderUserStatusTypeArchived,
    AWSCognitoIdentityProviderUserStatusTypeCompromised,
    AWSCognitoIdentityProviderUserStatusTypeResetRequired,
    AWSCognitoIdentityProviderUserStatusTypeForceChangePassword,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderUsernameAttributeType) {
    AWSCognitoIdentityProviderUsernameAttributeTypeUnknown,
    AWSCognitoIdentityProviderUsernameAttributeTypePhoneNumber,
    AWSCognitoIdentityProviderUsernameAttributeTypeEmail,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderVerifiedAttributeType) {
    AWSCognitoIdentityProviderVerifiedAttributeTypeUnknown,
    AWSCognitoIdentityProviderVerifiedAttributeTypePhoneNumber,
    AWSCognitoIdentityProviderVerifiedAttributeTypeEmail,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityProviderVerifySoftwareTokenResponseType) {
    AWSCognitoIdentityProviderVerifySoftwareTokenResponseTypeUnknown,
    AWSCognitoIdentityProviderVerifySoftwareTokenResponseTypeSuccess,
    AWSCognitoIdentityProviderVerifySoftwareTokenResponseTypeError,
};
@class AWSCognitoIdentityProviderAccountRecoverySettingType;
@class AWSCognitoIdentityProviderAccountTakeoverActionType;
@class AWSCognitoIdentityProviderAccountTakeoverActionsType;
@class AWSCognitoIdentityProviderAccountTakeoverRiskConfigurationType;
@class AWSCognitoIdentityProviderAddCustomAttributesRequest;
@class AWSCognitoIdentityProviderAddCustomAttributesResponse;
@class AWSCognitoIdentityProviderAdminAddUserToGroupRequest;
@class AWSCognitoIdentityProviderAdminConfirmSignUpRequest;
@class AWSCognitoIdentityProviderAdminConfirmSignUpResponse;
@class AWSCognitoIdentityProviderAdminCreateUserConfigType;
@class AWSCognitoIdentityProviderAdminCreateUserRequest;
@class AWSCognitoIdentityProviderAdminCreateUserResponse;
@class AWSCognitoIdentityProviderAdminDeleteUserAttributesRequest;
@class AWSCognitoIdentityProviderAdminDeleteUserAttributesResponse;
@class AWSCognitoIdentityProviderAdminDeleteUserRequest;
@class AWSCognitoIdentityProviderAdminDisableProviderForUserRequest;
@class AWSCognitoIdentityProviderAdminDisableProviderForUserResponse;
@class AWSCognitoIdentityProviderAdminDisableUserRequest;
@class AWSCognitoIdentityProviderAdminDisableUserResponse;
@class AWSCognitoIdentityProviderAdminEnableUserRequest;
@class AWSCognitoIdentityProviderAdminEnableUserResponse;
@class AWSCognitoIdentityProviderAdminForgetDeviceRequest;
@class AWSCognitoIdentityProviderAdminGetDeviceRequest;
@class AWSCognitoIdentityProviderAdminGetDeviceResponse;
@class AWSCognitoIdentityProviderAdminGetUserRequest;
@class AWSCognitoIdentityProviderAdminGetUserResponse;
@class AWSCognitoIdentityProviderAdminInitiateAuthRequest;
@class AWSCognitoIdentityProviderAdminInitiateAuthResponse;
@class AWSCognitoIdentityProviderAdminLinkProviderForUserRequest;
@class AWSCognitoIdentityProviderAdminLinkProviderForUserResponse;
@class AWSCognitoIdentityProviderAdminListDevicesRequest;
@class AWSCognitoIdentityProviderAdminListDevicesResponse;
@class AWSCognitoIdentityProviderAdminListGroupsForUserRequest;
@class AWSCognitoIdentityProviderAdminListGroupsForUserResponse;
@class AWSCognitoIdentityProviderAdminListUserAuthEventsRequest;
@class AWSCognitoIdentityProviderAdminListUserAuthEventsResponse;
@class AWSCognitoIdentityProviderAdminRemoveUserFromGroupRequest;
@class AWSCognitoIdentityProviderAdminResetUserPasswordRequest;
@class AWSCognitoIdentityProviderAdminResetUserPasswordResponse;
@class AWSCognitoIdentityProviderAdminRespondToAuthChallengeRequest;
@class AWSCognitoIdentityProviderAdminRespondToAuthChallengeResponse;
@class AWSCognitoIdentityProviderAdminSetUserMFAPreferenceRequest;
@class AWSCognitoIdentityProviderAdminSetUserMFAPreferenceResponse;
@class AWSCognitoIdentityProviderAdminSetUserPasswordRequest;
@class AWSCognitoIdentityProviderAdminSetUserPasswordResponse;
@class AWSCognitoIdentityProviderAdminSetUserSettingsRequest;
@class AWSCognitoIdentityProviderAdminSetUserSettingsResponse;
@class AWSCognitoIdentityProviderAdminUpdateAuthEventFeedbackRequest;
@class AWSCognitoIdentityProviderAdminUpdateAuthEventFeedbackResponse;
@class AWSCognitoIdentityProviderAdminUpdateDeviceStatusRequest;
@class AWSCognitoIdentityProviderAdminUpdateDeviceStatusResponse;
@class AWSCognitoIdentityProviderAdminUpdateUserAttributesRequest;
@class AWSCognitoIdentityProviderAdminUpdateUserAttributesResponse;
@class AWSCognitoIdentityProviderAdminUserGlobalSignOutRequest;
@class AWSCognitoIdentityProviderAdminUserGlobalSignOutResponse;
@class AWSCognitoIdentityProviderAnalyticsConfigurationType;
@class AWSCognitoIdentityProviderAnalyticsMetadataType;
@class AWSCognitoIdentityProviderAssociateSoftwareTokenRequest;
@class AWSCognitoIdentityProviderAssociateSoftwareTokenResponse;
@class AWSCognitoIdentityProviderAttributeType;
@class AWSCognitoIdentityProviderAuthEventType;
@class AWSCognitoIdentityProviderAuthenticationResultType;
@class AWSCognitoIdentityProviderChallengeResponseType;
@class AWSCognitoIdentityProviderChangePasswordRequest;
@class AWSCognitoIdentityProviderChangePasswordResponse;
@class AWSCognitoIdentityProviderCodeDeliveryDetailsType;
@class AWSCognitoIdentityProviderCompromisedCredentialsActionsType;
@class AWSCognitoIdentityProviderCompromisedCredentialsRiskConfigurationType;
@class AWSCognitoIdentityProviderConfirmDeviceRequest;
@class AWSCognitoIdentityProviderConfirmDeviceResponse;
@class AWSCognitoIdentityProviderConfirmForgotPasswordRequest;
@class AWSCognitoIdentityProviderConfirmForgotPasswordResponse;
@class AWSCognitoIdentityProviderConfirmSignUpRequest;
@class AWSCognitoIdentityProviderConfirmSignUpResponse;
@class AWSCognitoIdentityProviderContextDataType;
@class AWSCognitoIdentityProviderCreateGroupRequest;
@class AWSCognitoIdentityProviderCreateGroupResponse;
@class AWSCognitoIdentityProviderCreateIdentityProviderRequest;
@class AWSCognitoIdentityProviderCreateIdentityProviderResponse;
@class AWSCognitoIdentityProviderCreateResourceServerRequest;
@class AWSCognitoIdentityProviderCreateResourceServerResponse;
@class AWSCognitoIdentityProviderCreateUserImportJobRequest;
@class AWSCognitoIdentityProviderCreateUserImportJobResponse;
@class AWSCognitoIdentityProviderCreateUserPoolClientRequest;
@class AWSCognitoIdentityProviderCreateUserPoolClientResponse;
@class AWSCognitoIdentityProviderCreateUserPoolDomainRequest;
@class AWSCognitoIdentityProviderCreateUserPoolDomainResponse;
@class AWSCognitoIdentityProviderCreateUserPoolRequest;
@class AWSCognitoIdentityProviderCreateUserPoolResponse;
@class AWSCognitoIdentityProviderCustomDomainConfigType;
@class AWSCognitoIdentityProviderDeleteGroupRequest;
@class AWSCognitoIdentityProviderDeleteIdentityProviderRequest;
@class AWSCognitoIdentityProviderDeleteResourceServerRequest;
@class AWSCognitoIdentityProviderDeleteUserAttributesRequest;
@class AWSCognitoIdentityProviderDeleteUserAttributesResponse;
@class AWSCognitoIdentityProviderDeleteUserPoolClientRequest;
@class AWSCognitoIdentityProviderDeleteUserPoolDomainRequest;
@class AWSCognitoIdentityProviderDeleteUserPoolDomainResponse;
@class AWSCognitoIdentityProviderDeleteUserPoolRequest;
@class AWSCognitoIdentityProviderDeleteUserRequest;
@class AWSCognitoIdentityProviderDescribeIdentityProviderRequest;
@class AWSCognitoIdentityProviderDescribeIdentityProviderResponse;
@class AWSCognitoIdentityProviderDescribeResourceServerRequest;
@class AWSCognitoIdentityProviderDescribeResourceServerResponse;
@class AWSCognitoIdentityProviderDescribeRiskConfigurationRequest;
@class AWSCognitoIdentityProviderDescribeRiskConfigurationResponse;
@class AWSCognitoIdentityProviderDescribeUserImportJobRequest;
@class AWSCognitoIdentityProviderDescribeUserImportJobResponse;
@class AWSCognitoIdentityProviderDescribeUserPoolClientRequest;
@class AWSCognitoIdentityProviderDescribeUserPoolClientResponse;
@class AWSCognitoIdentityProviderDescribeUserPoolDomainRequest;
@class AWSCognitoIdentityProviderDescribeUserPoolDomainResponse;
@class AWSCognitoIdentityProviderDescribeUserPoolRequest;
@class AWSCognitoIdentityProviderDescribeUserPoolResponse;
@class AWSCognitoIdentityProviderDeviceConfigurationType;
@class AWSCognitoIdentityProviderDeviceSecretVerifierConfigType;
@class AWSCognitoIdentityProviderDeviceType;
@class AWSCognitoIdentityProviderDomainDescriptionType;
@class AWSCognitoIdentityProviderEmailConfigurationType;
@class AWSCognitoIdentityProviderEventContextDataType;
@class AWSCognitoIdentityProviderEventFeedbackType;
@class AWSCognitoIdentityProviderEventRiskType;
@class AWSCognitoIdentityProviderForgetDeviceRequest;
@class AWSCognitoIdentityProviderForgotPasswordRequest;
@class AWSCognitoIdentityProviderForgotPasswordResponse;
@class AWSCognitoIdentityProviderGetCSVHeaderRequest;
@class AWSCognitoIdentityProviderGetCSVHeaderResponse;
@class AWSCognitoIdentityProviderGetDeviceRequest;
@class AWSCognitoIdentityProviderGetDeviceResponse;
@class AWSCognitoIdentityProviderGetGroupRequest;
@class AWSCognitoIdentityProviderGetGroupResponse;
@class AWSCognitoIdentityProviderGetIdentityProviderByIdentifierRequest;
@class AWSCognitoIdentityProviderGetIdentityProviderByIdentifierResponse;
@class AWSCognitoIdentityProviderGetSigningCertificateRequest;
@class AWSCognitoIdentityProviderGetSigningCertificateResponse;
@class AWSCognitoIdentityProviderGetUICustomizationRequest;
@class AWSCognitoIdentityProviderGetUICustomizationResponse;
@class AWSCognitoIdentityProviderGetUserAttributeVerificationCodeRequest;
@class AWSCognitoIdentityProviderGetUserAttributeVerificationCodeResponse;
@class AWSCognitoIdentityProviderGetUserPoolMfaConfigRequest;
@class AWSCognitoIdentityProviderGetUserPoolMfaConfigResponse;
@class AWSCognitoIdentityProviderGetUserRequest;
@class AWSCognitoIdentityProviderGetUserResponse;
@class AWSCognitoIdentityProviderGlobalSignOutRequest;
@class AWSCognitoIdentityProviderGlobalSignOutResponse;
@class AWSCognitoIdentityProviderGroupType;
@class AWSCognitoIdentityProviderHttpHeader;
@class AWSCognitoIdentityProviderIdentityProviderType;
@class AWSCognitoIdentityProviderInitiateAuthRequest;
@class AWSCognitoIdentityProviderInitiateAuthResponse;
@class AWSCognitoIdentityProviderLambdaConfigType;
@class AWSCognitoIdentityProviderListDevicesRequest;
@class AWSCognitoIdentityProviderListDevicesResponse;
@class AWSCognitoIdentityProviderListGroupsRequest;
@class AWSCognitoIdentityProviderListGroupsResponse;
@class AWSCognitoIdentityProviderListIdentityProvidersRequest;
@class AWSCognitoIdentityProviderListIdentityProvidersResponse;
@class AWSCognitoIdentityProviderListResourceServersRequest;
@class AWSCognitoIdentityProviderListResourceServersResponse;
@class AWSCognitoIdentityProviderListTagsForResourceRequest;
@class AWSCognitoIdentityProviderListTagsForResourceResponse;
@class AWSCognitoIdentityProviderListUserImportJobsRequest;
@class AWSCognitoIdentityProviderListUserImportJobsResponse;
@class AWSCognitoIdentityProviderListUserPoolClientsRequest;
@class AWSCognitoIdentityProviderListUserPoolClientsResponse;
@class AWSCognitoIdentityProviderListUserPoolsRequest;
@class AWSCognitoIdentityProviderListUserPoolsResponse;
@class AWSCognitoIdentityProviderListUsersInGroupRequest;
@class AWSCognitoIdentityProviderListUsersInGroupResponse;
@class AWSCognitoIdentityProviderListUsersRequest;
@class AWSCognitoIdentityProviderListUsersResponse;
@class AWSCognitoIdentityProviderMFAOptionType;
@class AWSCognitoIdentityProviderMessageTemplateType;
@class AWSCognitoIdentityProviderLatestDeviceMetadataType;
@class AWSCognitoIdentityProviderNotifyConfigurationType;
@class AWSCognitoIdentityProviderNotifyEmailType;
@class AWSCognitoIdentityProviderNumberAttributeConstraintsType;
@class AWSCognitoIdentityProviderPasswordPolicyType;
@class AWSCognitoIdentityProviderProviderDescription;
@class AWSCognitoIdentityProviderProviderUserIdentifierType;
@class AWSCognitoIdentityProviderRecoveryOptionType;
@class AWSCognitoIdentityProviderResendConfirmationCodeRequest;
@class AWSCognitoIdentityProviderResendConfirmationCodeResponse;
@class AWSCognitoIdentityProviderResourceServerScopeType;
@class AWSCognitoIdentityProviderResourceServerType;
@class AWSCognitoIdentityProviderRespondToAuthChallengeRequest;
@class AWSCognitoIdentityProviderRespondToAuthChallengeResponse;
@class AWSCognitoIdentityProviderRiskConfigurationType;
@class AWSCognitoIdentityProviderRiskExceptionConfigurationType;
@class AWSCognitoIdentityProviderSMSMfaSettingsType;
@class AWSCognitoIdentityProviderSchemaAttributeType;
@class AWSCognitoIdentityProviderSetRiskConfigurationRequest;
@class AWSCognitoIdentityProviderSetRiskConfigurationResponse;
@class AWSCognitoIdentityProviderSetUICustomizationRequest;
@class AWSCognitoIdentityProviderSetUICustomizationResponse;
@class AWSCognitoIdentityProviderSetUserMFAPreferenceRequest;
@class AWSCognitoIdentityProviderSetUserMFAPreferenceResponse;
@class AWSCognitoIdentityProviderSetUserPoolMfaConfigRequest;
@class AWSCognitoIdentityProviderSetUserPoolMfaConfigResponse;
@class AWSCognitoIdentityProviderSetUserSettingsRequest;
@class AWSCognitoIdentityProviderSetUserSettingsResponse;
@class AWSCognitoIdentityProviderSignUpRequest;
@class AWSCognitoIdentityProviderSignUpResponse;
@class AWSCognitoIdentityProviderSmsConfigurationType;
@class AWSCognitoIdentityProviderSmsMfaConfigType;
@class AWSCognitoIdentityProviderSoftwareTokenMfaConfigType;
@class AWSCognitoIdentityProviderSoftwareTokenMfaSettingsType;
@class AWSCognitoIdentityProviderStartUserImportJobRequest;
@class AWSCognitoIdentityProviderStartUserImportJobResponse;
@class AWSCognitoIdentityProviderStopUserImportJobRequest;
@class AWSCognitoIdentityProviderStopUserImportJobResponse;
@class AWSCognitoIdentityProviderStringAttributeConstraintsType;
@class AWSCognitoIdentityProviderTagResourceRequest;
@class AWSCognitoIdentityProviderTagResourceResponse;
@class AWSCognitoIdentityProviderTokenValidityUnitsType;
@class AWSCognitoIdentityProviderUICustomizationType;
@class AWSCognitoIdentityProviderUntagResourceRequest;
@class AWSCognitoIdentityProviderUntagResourceResponse;
@class AWSCognitoIdentityProviderUpdateAuthEventFeedbackRequest;
@class AWSCognitoIdentityProviderUpdateAuthEventFeedbackResponse;
@class AWSCognitoIdentityProviderUpdateDeviceStatusRequest;
@class AWSCognitoIdentityProviderUpdateDeviceStatusResponse;
@class AWSCognitoIdentityProviderUpdateGroupRequest;
@class AWSCognitoIdentityProviderUpdateGroupResponse;
@class AWSCognitoIdentityProviderUpdateIdentityProviderRequest;
@class AWSCognitoIdentityProviderUpdateIdentityProviderResponse;
@class AWSCognitoIdentityProviderUpdateResourceServerRequest;
@class AWSCognitoIdentityProviderUpdateResourceServerResponse;
@class AWSCognitoIdentityProviderUpdateUserAttributesRequest;
@class AWSCognitoIdentityProviderUpdateUserAttributesResponse;
@class AWSCognitoIdentityProviderUpdateUserPoolClientRequest;
@class AWSCognitoIdentityProviderUpdateUserPoolClientResponse;
@class AWSCognitoIdentityProviderUpdateUserPoolDomainRequest;
@class AWSCognitoIdentityProviderUpdateUserPoolDomainResponse;
@class AWSCognitoIdentityProviderUpdateUserPoolRequest;
@class AWSCognitoIdentityProviderUpdateUserPoolResponse;
@class AWSCognitoIdentityProviderUserContextDataType;
@class AWSCognitoIdentityProviderUserImportJobType;
@class AWSCognitoIdentityProviderUserPoolAddOnsType;
@class AWSCognitoIdentityProviderUserPoolClientDescription;
@class AWSCognitoIdentityProviderUserPoolClientType;
@class AWSCognitoIdentityProviderUserPoolDescriptionType;
@class AWSCognitoIdentityProviderUserPoolPolicyType;
@class AWSCognitoIdentityProviderUserPoolType;
@class AWSCognitoIdentityProviderUserType;
@class AWSCognitoIdentityProviderUsernameConfigurationType;
@class AWSCognitoIdentityProviderVerificationMessageTemplateType;
@class AWSCognitoIdentityProviderVerifySoftwareTokenRequest;
@class AWSCognitoIdentityProviderVerifySoftwareTokenResponse;
@class AWSCognitoIdentityProviderVerifyUserAttributeRequest;
@class AWSCognitoIdentityProviderVerifyUserAttributeResponse;
@interface AWSCognitoIdentityProviderAccountRecoverySettingType : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderRecoveryOptionType *> * _Nullable recoveryMechanisms;
@end
@interface AWSCognitoIdentityProviderAccountTakeoverActionType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderAccountTakeoverEventActionType eventAction;
@property (nonatomic, strong) NSNumber * _Nullable notify;
@end
@interface AWSCognitoIdentityProviderAccountTakeoverActionsType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountTakeoverActionType * _Nullable highAction;
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountTakeoverActionType * _Nullable lowAction;
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountTakeoverActionType * _Nullable mediumAction;
@end
@interface AWSCognitoIdentityProviderAccountTakeoverRiskConfigurationType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountTakeoverActionsType * _Nullable actions;
@property (nonatomic, strong) AWSCognitoIdentityProviderNotifyConfigurationType * _Nullable notifyConfiguration;
@end
@interface AWSCognitoIdentityProviderAddCustomAttributesRequest : AWSRequest
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderSchemaAttributeType *> * _Nullable customAttributes;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderAddCustomAttributesResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminAddUserToGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminConfirmSignUpRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminConfirmSignUpResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminCreateUserConfigType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable allowAdminCreateUserOnly;
@property (nonatomic, strong) AWSCognitoIdentityProviderMessageTemplateType * _Nullable inviteMessageTemplate;
@property (nonatomic, strong) NSNumber * _Nullable unusedAccountValidityDays;
@end
@interface AWSCognitoIdentityProviderAdminCreateUserRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable desiredDeliveryMediums;
@property (nonatomic, strong) NSNumber * _Nullable forceAliasCreation;
@property (nonatomic, assign) AWSCognitoIdentityProviderMessageActionType messageAction;
@property (nonatomic, strong) NSString * _Nullable temporaryPassword;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable userAttributes;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable validationData;
@end
@interface AWSCognitoIdentityProviderAdminCreateUserResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserType * _Nullable user;
@end
@interface AWSCognitoIdentityProviderAdminDeleteUserAttributesRequest : AWSRequest
@property (nonatomic, strong) NSArray<NSString *> * _Nullable userAttributeNames;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminDeleteUserAttributesResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminDeleteUserRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminDisableProviderForUserRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderProviderUserIdentifierType * _Nullable user;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderAdminDisableProviderForUserResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminDisableUserRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminDisableUserResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminEnableUserRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminEnableUserResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminForgetDeviceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminGetDeviceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminGetDeviceResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderDeviceType * _Nullable device;
@end
@interface AWSCognitoIdentityProviderAdminGetUserRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminGetUserResponse : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable enabled;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderMFAOptionType *> * _Nullable MFAOptions;
@property (nonatomic, strong) NSString * _Nullable preferredMfaSetting;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable userAttributes;
@property (nonatomic, strong) NSDate * _Nullable userCreateDate;
@property (nonatomic, strong) NSDate * _Nullable userLastModifiedDate;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable userMFASettingList;
@property (nonatomic, assign) AWSCognitoIdentityProviderUserStatusType userStatus;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminInitiateAuthRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, assign) AWSCognitoIdentityProviderAuthFlowType authFlow;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable authParameters;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) AWSCognitoIdentityProviderContextDataType * _Nullable contextData;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderAdminInitiateAuthResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAuthenticationResultType * _Nullable authenticationResult;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeNameType challengeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable challengeParameters;
@property (nonatomic, strong) NSString * _Nullable session;
@end
@interface AWSCognitoIdentityProviderAdminLinkProviderForUserRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderProviderUserIdentifierType * _Nullable destinationUser;
@property (nonatomic, strong) AWSCognitoIdentityProviderProviderUserIdentifierType * _Nullable sourceUser;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderAdminLinkProviderForUserResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminListDevicesRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable limit;
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminListDevicesResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderDeviceType *> * _Nullable devices;
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@end
@interface AWSCognitoIdentityProviderAdminListGroupsForUserRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable limit;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminListGroupsForUserResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderGroupType *> * _Nullable groups;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityProviderAdminListUserAuthEventsRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminListUserAuthEventsResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAuthEventType *> * _Nullable authEvents;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityProviderAdminRemoveUserFromGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminResetUserPasswordRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminResetUserPasswordResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminRespondToAuthChallengeRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeNameType challengeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable challengeResponses;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) AWSCognitoIdentityProviderContextDataType * _Nullable contextData;
@property (nonatomic, strong) NSString * _Nullable session;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderAdminRespondToAuthChallengeResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAuthenticationResultType * _Nullable authenticationResult;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeNameType challengeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable challengeParameters;
@property (nonatomic, strong) NSString * _Nullable session;
@end
@interface AWSCognitoIdentityProviderAdminSetUserMFAPreferenceRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderSMSMfaSettingsType * _Nullable SMSMfaSettings;
@property (nonatomic, strong) AWSCognitoIdentityProviderSoftwareTokenMfaSettingsType * _Nullable softwareTokenMfaSettings;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminSetUserMFAPreferenceResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminSetUserPasswordRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable password;
@property (nonatomic, strong) NSNumber * _Nullable permanent;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminSetUserPasswordResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminSetUserSettingsRequest : AWSRequest
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderMFAOptionType *> * _Nullable MFAOptions;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminSetUserSettingsResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminUpdateAuthEventFeedbackRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable eventId;
@property (nonatomic, assign) AWSCognitoIdentityProviderFeedbackValueType feedbackValue;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminUpdateAuthEventFeedbackResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminUpdateDeviceStatusRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@property (nonatomic, assign) AWSCognitoIdentityProviderDeviceRememberedStatusType deviceRememberedStatus;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminUpdateDeviceStatusResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminUpdateUserAttributesRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable userAttributes;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminUpdateUserAttributesResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAdminUserGlobalSignOutRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderAdminUserGlobalSignOutResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderAnalyticsConfigurationType : AWSModel
@property (nonatomic, strong) NSString * _Nullable applicationArn;
@property (nonatomic, strong) NSString * _Nullable applicationId;
@property (nonatomic, strong) NSString * _Nullable externalId;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSNumber * _Nullable userDataShared;
@end
@interface AWSCognitoIdentityProviderAnalyticsMetadataType : AWSModel
@property (nonatomic, strong) NSString * _Nullable analyticsEndpointId;
@end
@interface AWSCognitoIdentityProviderAssociateSoftwareTokenRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable session;
@end
@interface AWSCognitoIdentityProviderAssociateSoftwareTokenResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable secretCode;
@property (nonatomic, strong) NSString * _Nullable session;
@end
@interface AWSCognitoIdentityProviderAttributeType : AWSModel
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSCognitoIdentityProviderAuthEventType : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderChallengeResponseType *> * _Nullable challengeResponses;
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) AWSCognitoIdentityProviderEventContextDataType * _Nullable eventContextData;
@property (nonatomic, strong) AWSCognitoIdentityProviderEventFeedbackType * _Nullable eventFeedback;
@property (nonatomic, strong) NSString * _Nullable eventId;
@property (nonatomic, assign) AWSCognitoIdentityProviderEventResponseType eventResponse;
@property (nonatomic, strong) AWSCognitoIdentityProviderEventRiskType * _Nullable eventRisk;
@property (nonatomic, assign) AWSCognitoIdentityProviderEventType eventType;
@end
@interface AWSCognitoIdentityProviderAuthenticationResultType : AWSModel
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSNumber * _Nullable expiresIn;
@property (nonatomic, strong) NSString * _Nullable idToken;
@property (nonatomic, strong) AWSCognitoIdentityProviderLatestDeviceMetadataType * _Nullable latestDeviceMetadata;
@property (nonatomic, strong) NSString * _Nullable refreshToken;
@property (nonatomic, strong) NSString * _Nullable tokenType;
@end
@interface AWSCognitoIdentityProviderChallengeResponseType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeName challengeName;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeResponse challengeResponse;
@end
@interface AWSCognitoIdentityProviderChangePasswordRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable previousPassword;
@property (nonatomic, strong) NSString * _Nullable proposedPassword;
@end
@interface AWSCognitoIdentityProviderChangePasswordResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderCodeDeliveryDetailsType : AWSModel
@property (nonatomic, strong) NSString * _Nullable attributeName;
@property (nonatomic, assign) AWSCognitoIdentityProviderDeliveryMediumType deliveryMedium;
@property (nonatomic, strong) NSString * _Nullable destination;
@end
@interface AWSCognitoIdentityProviderCompromisedCredentialsActionsType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderCompromisedCredentialsEventActionType eventAction;
@end
@interface AWSCognitoIdentityProviderCompromisedCredentialsRiskConfigurationType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderCompromisedCredentialsActionsType * _Nullable actions;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable eventFilter;
@end
@interface AWSCognitoIdentityProviderConfirmDeviceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@property (nonatomic, strong) NSString * _Nullable deviceName;
@property (nonatomic, strong) AWSCognitoIdentityProviderDeviceSecretVerifierConfigType * _Nullable deviceSecretVerifierConfig;
@end
@interface AWSCognitoIdentityProviderConfirmDeviceResponse : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable userConfirmationNecessary;
@end
@interface AWSCognitoIdentityProviderConfirmForgotPasswordRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable confirmationCode;
@property (nonatomic, strong) NSString * _Nullable password;
@property (nonatomic, strong) NSString * _Nullable secretHash;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderConfirmForgotPasswordResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderConfirmSignUpRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable confirmationCode;
@property (nonatomic, strong) NSNumber * _Nullable forceAliasCreation;
@property (nonatomic, strong) NSString * _Nullable secretHash;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderConfirmSignUpResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderContextDataType : AWSModel
@property (nonatomic, strong) NSString * _Nullable encodedData;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderHttpHeader *> * _Nullable httpHeaders;
@property (nonatomic, strong) NSString * _Nullable ipAddress;
@property (nonatomic, strong) NSString * _Nullable serverName;
@property (nonatomic, strong) NSString * _Nullable serverPath;
@end
@interface AWSCognitoIdentityProviderCreateGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable detail;
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSNumber * _Nullable precedence;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderCreateGroupResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderGroupType * _Nullable group;
@end
@interface AWSCognitoIdentityProviderCreateIdentityProviderRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable attributeMapping;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable idpIdentifiers;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable providerDetails;
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, assign) AWSCognitoIdentityProviderIdentityProviderTypeType providerType;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderCreateIdentityProviderResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderIdentityProviderType * _Nullable identityProvider;
@end
@interface AWSCognitoIdentityProviderCreateResourceServerRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderResourceServerScopeType *> * _Nullable scopes;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderCreateResourceServerResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderResourceServerType * _Nullable resourceServer;
@end
@interface AWSCognitoIdentityProviderCreateUserImportJobRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable cloudWatchLogsRoleArn;
@property (nonatomic, strong) NSString * _Nullable jobName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderCreateUserImportJobResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserImportJobType * _Nullable userImportJob;
@end
@interface AWSCognitoIdentityProviderCreateUserPoolClientRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable accessTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOAuthFlows;
@property (nonatomic, strong) NSNumber * _Nullable allowedOAuthFlowsUserPoolClient;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOAuthScopes;
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsConfigurationType * _Nullable analyticsConfiguration;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable callbackURLs;
@property (nonatomic, strong) NSString * _Nullable clientName;
@property (nonatomic, strong) NSString * _Nullable defaultRedirectURI;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable explicitAuthFlows;
@property (nonatomic, strong) NSNumber * _Nullable generateSecret;
@property (nonatomic, strong) NSNumber * _Nullable idTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable logoutURLs;
@property (nonatomic, assign) AWSCognitoIdentityProviderPreventUserExistenceErrorTypes preventUserExistenceErrors;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable readAttributes;
@property (nonatomic, strong) NSNumber * _Nullable refreshTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable supportedIdentityProviders;
@property (nonatomic, strong) AWSCognitoIdentityProviderTokenValidityUnitsType * _Nullable tokenValidityUnits;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable writeAttributes;
@end
@interface AWSCognitoIdentityProviderCreateUserPoolClientResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolClientType * _Nullable userPoolClient;
@end
@interface AWSCognitoIdentityProviderCreateUserPoolDomainRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderCustomDomainConfigType * _Nullable customDomainConfig;
@property (nonatomic, strong) NSString * _Nullable domain;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderCreateUserPoolDomainResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable cloudFrontDomain;
@end
@interface AWSCognitoIdentityProviderCreateUserPoolRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountRecoverySettingType * _Nullable accountRecoverySetting;
@property (nonatomic, strong) AWSCognitoIdentityProviderAdminCreateUserConfigType * _Nullable adminCreateUserConfig;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable aliasAttributes;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable autoVerifiedAttributes;
@property (nonatomic, strong) AWSCognitoIdentityProviderDeviceConfigurationType * _Nullable deviceConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderEmailConfigurationType * _Nullable emailConfiguration;
@property (nonatomic, strong) NSString * _Nullable emailVerificationMessage;
@property (nonatomic, strong) NSString * _Nullable emailVerificationSubject;
@property (nonatomic, strong) AWSCognitoIdentityProviderLambdaConfigType * _Nullable lambdaConfig;
@property (nonatomic, assign) AWSCognitoIdentityProviderUserPoolMfaType mfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolPolicyType * _Nullable policies;
@property (nonatomic, strong) NSString * _Nullable poolName;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderSchemaAttributeType *> * _Nullable schema;
@property (nonatomic, strong) NSString * _Nullable smsAuthenticationMessage;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsConfigurationType * _Nullable smsConfiguration;
@property (nonatomic, strong) NSString * _Nullable smsVerificationMessage;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolAddOnsType * _Nullable userPoolAddOns;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable userPoolTags;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable usernameAttributes;
@property (nonatomic, strong) AWSCognitoIdentityProviderUsernameConfigurationType * _Nullable usernameConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderVerificationMessageTemplateType * _Nullable verificationMessageTemplate;
@end
@interface AWSCognitoIdentityProviderCreateUserPoolResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolType * _Nullable userPool;
@end
@interface AWSCognitoIdentityProviderCustomDomainConfigType : AWSModel
@property (nonatomic, strong) NSString * _Nullable certificateArn;
@end
@interface AWSCognitoIdentityProviderDeleteGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDeleteIdentityProviderRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDeleteResourceServerRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDeleteUserAttributesRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable userAttributeNames;
@end
@interface AWSCognitoIdentityProviderDeleteUserAttributesResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderDeleteUserPoolClientRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDeleteUserPoolDomainRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable domain;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDeleteUserPoolDomainResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderDeleteUserPoolRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDeleteUserRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@end
@interface AWSCognitoIdentityProviderDescribeIdentityProviderRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDescribeIdentityProviderResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderIdentityProviderType * _Nullable identityProvider;
@end
@interface AWSCognitoIdentityProviderDescribeResourceServerRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDescribeResourceServerResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderResourceServerType * _Nullable resourceServer;
@end
@interface AWSCognitoIdentityProviderDescribeRiskConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDescribeRiskConfigurationResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderRiskConfigurationType * _Nullable riskConfiguration;
@end
@interface AWSCognitoIdentityProviderDescribeUserImportJobRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable jobId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDescribeUserImportJobResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserImportJobType * _Nullable userImportJob;
@end
@interface AWSCognitoIdentityProviderDescribeUserPoolClientRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDescribeUserPoolClientResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolClientType * _Nullable userPoolClient;
@end
@interface AWSCognitoIdentityProviderDescribeUserPoolDomainRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable domain;
@end
@interface AWSCognitoIdentityProviderDescribeUserPoolDomainResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderDomainDescriptionType * _Nullable domainDescription;
@end
@interface AWSCognitoIdentityProviderDescribeUserPoolRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderDescribeUserPoolResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolType * _Nullable userPool;
@end
@interface AWSCognitoIdentityProviderDeviceConfigurationType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable challengeRequiredOnNewDevice;
@property (nonatomic, strong) NSNumber * _Nullable deviceOnlyRememberedOnUserPrompt;
@end
@interface AWSCognitoIdentityProviderDeviceSecretVerifierConfigType : AWSModel
@property (nonatomic, strong) NSString * _Nullable passwordVerifier;
@property (nonatomic, strong) NSString * _Nullable salt;
@end
@interface AWSCognitoIdentityProviderDeviceType : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable deviceAttributes;
@property (nonatomic, strong) NSDate * _Nullable deviceCreateDate;
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@property (nonatomic, strong) NSDate * _Nullable deviceLastAuthenticatedDate;
@property (nonatomic, strong) NSDate * _Nullable deviceLastModifiedDate;
@end
@interface AWSCognitoIdentityProviderDomainDescriptionType : AWSModel
@property (nonatomic, strong) NSString * _Nullable AWSAccountId;
@property (nonatomic, strong) NSString * _Nullable cloudFrontDistribution;
@property (nonatomic, strong) AWSCognitoIdentityProviderCustomDomainConfigType * _Nullable customDomainConfig;
@property (nonatomic, strong) NSString * _Nullable domain;
@property (nonatomic, strong) NSString * _Nullable s3Bucket;
@property (nonatomic, assign) AWSCognitoIdentityProviderDomainStatusType status;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable version;
@end
@interface AWSCognitoIdentityProviderEmailConfigurationType : AWSModel
@property (nonatomic, strong) NSString * _Nullable configurationSet;
@property (nonatomic, assign) AWSCognitoIdentityProviderEmailSendingAccountType emailSendingAccount;
@property (nonatomic, strong) NSString * _Nullable from;
@property (nonatomic, strong) NSString * _Nullable replyToEmailAddress;
@property (nonatomic, strong) NSString * _Nullable sourceArn;
@end
@interface AWSCognitoIdentityProviderEventContextDataType : AWSModel
@property (nonatomic, strong) NSString * _Nullable city;
@property (nonatomic, strong) NSString * _Nullable country;
@property (nonatomic, strong) NSString * _Nullable deviceName;
@property (nonatomic, strong) NSString * _Nullable ipAddress;
@property (nonatomic, strong) NSString * _Nullable timezone;
@end
@interface AWSCognitoIdentityProviderEventFeedbackType : AWSModel
@property (nonatomic, strong) NSDate * _Nullable feedbackDate;
@property (nonatomic, assign) AWSCognitoIdentityProviderFeedbackValueType feedbackValue;
@property (nonatomic, strong) NSString * _Nullable provider;
@end
@interface AWSCognitoIdentityProviderEventRiskType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable compromisedCredentialsDetected;
@property (nonatomic, assign) AWSCognitoIdentityProviderRiskDecisionType riskDecision;
@property (nonatomic, assign) AWSCognitoIdentityProviderRiskLevelType riskLevel;
@end
@interface AWSCognitoIdentityProviderForgetDeviceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@end
@interface AWSCognitoIdentityProviderForgotPasswordRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable secretHash;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderForgotPasswordResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderCodeDeliveryDetailsType * _Nullable codeDeliveryDetails;
@end
@interface AWSCognitoIdentityProviderGetCSVHeaderRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetCSVHeaderResponse : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable CSVHeader;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetDeviceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@end
@interface AWSCognitoIdentityProviderGetDeviceResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderDeviceType * _Nullable device;
@end
@interface AWSCognitoIdentityProviderGetGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetGroupResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderGroupType * _Nullable group;
@end
@interface AWSCognitoIdentityProviderGetIdentityProviderByIdentifierRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable idpIdentifier;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetIdentityProviderByIdentifierResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderIdentityProviderType * _Nullable identityProvider;
@end
@interface AWSCognitoIdentityProviderGetSigningCertificateRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetSigningCertificateResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable certificate;
@end
@interface AWSCognitoIdentityProviderGetUICustomizationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetUICustomizationResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUICustomizationType * _Nullable UICustomization;
@end
@interface AWSCognitoIdentityProviderGetUserAttributeVerificationCodeRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable attributeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@end
@interface AWSCognitoIdentityProviderGetUserAttributeVerificationCodeResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderCodeDeliveryDetailsType * _Nullable codeDeliveryDetails;
@end
@interface AWSCognitoIdentityProviderGetUserPoolMfaConfigRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderGetUserPoolMfaConfigResponse : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderUserPoolMfaType mfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsMfaConfigType * _Nullable smsMfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderSoftwareTokenMfaConfigType * _Nullable softwareTokenMfaConfiguration;
@end
@interface AWSCognitoIdentityProviderGetUserRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@end
@interface AWSCognitoIdentityProviderGetUserResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderMFAOptionType *> * _Nullable MFAOptions;
@property (nonatomic, strong) NSString * _Nullable preferredMfaSetting;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable userAttributes;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable userMFASettingList;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderGlobalSignOutRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@end
@interface AWSCognitoIdentityProviderGlobalSignOutResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderGroupType : AWSModel
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable detail;
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSNumber * _Nullable precedence;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderHttpHeader : AWSModel
@property (nonatomic, strong) NSString * _Nullable headerName;
@property (nonatomic, strong) NSString * _Nullable headerValue;
@end
@interface AWSCognitoIdentityProviderIdentityProviderType : AWSModel
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable attributeMapping;
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable idpIdentifiers;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable providerDetails;
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, assign) AWSCognitoIdentityProviderIdentityProviderTypeType providerType;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderInitiateAuthRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, assign) AWSCognitoIdentityProviderAuthFlowType authFlow;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable authParameters;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@end
@interface AWSCognitoIdentityProviderInitiateAuthResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAuthenticationResultType * _Nullable authenticationResult;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeNameType challengeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable challengeParameters;
@property (nonatomic, strong) NSString * _Nullable session;
@end
@interface AWSCognitoIdentityProviderLambdaConfigType : AWSModel
@property (nonatomic, strong) NSString * _Nullable createAuthChallenge;
@property (nonatomic, strong) NSString * _Nullable customMessage;
@property (nonatomic, strong) NSString * _Nullable defineAuthChallenge;
@property (nonatomic, strong) NSString * _Nullable postAuthentication;
@property (nonatomic, strong) NSString * _Nullable postConfirmation;
@property (nonatomic, strong) NSString * _Nullable preAuthentication;
@property (nonatomic, strong) NSString * _Nullable preSignUp;
@property (nonatomic, strong) NSString * _Nullable preTokenGeneration;
@property (nonatomic, strong) NSString * _Nullable userMigration;
@property (nonatomic, strong) NSString * _Nullable verifyAuthChallengeResponse;
@end
@interface AWSCognitoIdentityProviderListDevicesRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSNumber * _Nullable limit;
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@end
@interface AWSCognitoIdentityProviderListDevicesResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderDeviceType *> * _Nullable devices;
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@end
@interface AWSCognitoIdentityProviderListGroupsRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable limit;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListGroupsResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderGroupType *> * _Nullable groups;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityProviderListIdentityProvidersRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListIdentityProvidersResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderProviderDescription *> * _Nullable providers;
@end
@interface AWSCognitoIdentityProviderListResourceServersRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListResourceServersResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderResourceServerType *> * _Nullable resourceServers;
@end
@interface AWSCognitoIdentityProviderListTagsForResourceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable resourceArn;
@end
@interface AWSCognitoIdentityProviderListTagsForResourceResponse : AWSModel
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable tags;
@end
@interface AWSCognitoIdentityProviderListUserImportJobsRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListUserImportJobsResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderUserImportJobType *> * _Nullable userImportJobs;
@end
@interface AWSCognitoIdentityProviderListUserPoolClientsRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListUserPoolClientsResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderUserPoolClientDescription *> * _Nullable userPoolClients;
@end
@interface AWSCognitoIdentityProviderListUserPoolsRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityProviderListUserPoolsResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderUserPoolDescriptionType *> * _Nullable userPools;
@end
@interface AWSCognitoIdentityProviderListUsersInGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSNumber * _Nullable limit;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListUsersInGroupResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderUserType *> * _Nullable users;
@end
@interface AWSCognitoIdentityProviderListUsersRequest : AWSRequest
@property (nonatomic, strong) NSArray<NSString *> * _Nullable attributesToGet;
@property (nonatomic, strong) NSString * _Nullable filter;
@property (nonatomic, strong) NSNumber * _Nullable limit;
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderListUsersResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable paginationToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderUserType *> * _Nullable users;
@end
@interface AWSCognitoIdentityProviderMFAOptionType : AWSModel
@property (nonatomic, strong) NSString * _Nullable attributeName;
@property (nonatomic, assign) AWSCognitoIdentityProviderDeliveryMediumType deliveryMedium;
@end
@interface AWSCognitoIdentityProviderMessageTemplateType : AWSModel
@property (nonatomic, strong) NSString * _Nullable emailMessage;
@property (nonatomic, strong) NSString * _Nullable emailSubject;
@property (nonatomic, strong) NSString * _Nullable SMSMessage;
@end
@interface AWSCognitoIdentityProviderLatestDeviceMetadataType : AWSModel
@property (nonatomic, strong) NSString * _Nullable deviceGroupKey;
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@end
@interface AWSCognitoIdentityProviderNotifyConfigurationType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderNotifyEmailType * _Nullable blockEmail;
@property (nonatomic, strong) NSString * _Nullable from;
@property (nonatomic, strong) AWSCognitoIdentityProviderNotifyEmailType * _Nullable mfaEmail;
@property (nonatomic, strong) AWSCognitoIdentityProviderNotifyEmailType * _Nullable noActionEmail;
@property (nonatomic, strong) NSString * _Nullable replyTo;
@property (nonatomic, strong) NSString * _Nullable sourceArn;
@end
@interface AWSCognitoIdentityProviderNotifyEmailType : AWSModel
@property (nonatomic, strong) NSString * _Nullable htmlBody;
@property (nonatomic, strong) NSString * _Nullable subject;
@property (nonatomic, strong) NSString * _Nullable textBody;
@end
@interface AWSCognitoIdentityProviderNumberAttributeConstraintsType : AWSModel
@property (nonatomic, strong) NSString * _Nullable maxValue;
@property (nonatomic, strong) NSString * _Nullable minValue;
@end
@interface AWSCognitoIdentityProviderPasswordPolicyType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable minimumLength;
@property (nonatomic, strong) NSNumber * _Nullable requireLowercase;
@property (nonatomic, strong) NSNumber * _Nullable requireNumbers;
@property (nonatomic, strong) NSNumber * _Nullable requireSymbols;
@property (nonatomic, strong) NSNumber * _Nullable requireUppercase;
@property (nonatomic, strong) NSNumber * _Nullable temporaryPasswordValidityDays;
@end
@interface AWSCognitoIdentityProviderProviderDescription : AWSModel
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, assign) AWSCognitoIdentityProviderIdentityProviderTypeType providerType;
@end
@interface AWSCognitoIdentityProviderProviderUserIdentifierType : AWSModel
@property (nonatomic, strong) NSString * _Nullable providerAttributeName;
@property (nonatomic, strong) NSString * _Nullable providerAttributeValue;
@property (nonatomic, strong) NSString * _Nullable providerName;
@end
@interface AWSCognitoIdentityProviderRecoveryOptionType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderRecoveryOptionNameType name;
@property (nonatomic, strong) NSNumber * _Nullable priority;
@end
@interface AWSCognitoIdentityProviderResendConfirmationCodeRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable secretHash;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderResendConfirmationCodeResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderCodeDeliveryDetailsType * _Nullable codeDeliveryDetails;
@end
@interface AWSCognitoIdentityProviderResourceServerScopeType : AWSModel
@property (nonatomic, strong) NSString * _Nullable scopeDescription;
@property (nonatomic, strong) NSString * _Nullable scopeName;
@end
@interface AWSCognitoIdentityProviderResourceServerType : AWSModel
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderResourceServerScopeType *> * _Nullable scopes;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderRespondToAuthChallengeRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeNameType challengeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable challengeResponses;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable session;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@end
@interface AWSCognitoIdentityProviderRespondToAuthChallengeResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAuthenticationResultType * _Nullable authenticationResult;
@property (nonatomic, assign) AWSCognitoIdentityProviderChallengeNameType challengeName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable challengeParameters;
@property (nonatomic, strong) NSString * _Nullable session;
@end
@interface AWSCognitoIdentityProviderRiskConfigurationType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountTakeoverRiskConfigurationType * _Nullable accountTakeoverRiskConfiguration;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) AWSCognitoIdentityProviderCompromisedCredentialsRiskConfigurationType * _Nullable compromisedCredentialsRiskConfiguration;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) AWSCognitoIdentityProviderRiskExceptionConfigurationType * _Nullable riskExceptionConfiguration;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderRiskExceptionConfigurationType : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable blockedIPRangeList;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable skippedIPRangeList;
@end
@interface AWSCognitoIdentityProviderSMSMfaSettingsType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable enabled;
@property (nonatomic, strong) NSNumber * _Nullable preferredMfa;
@end
@interface AWSCognitoIdentityProviderSchemaAttributeType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderAttributeDataType attributeDataType;
@property (nonatomic, strong) NSNumber * _Nullable developerOnlyAttribute;
@property (nonatomic, strong) NSNumber * _Nullable varying;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) AWSCognitoIdentityProviderNumberAttributeConstraintsType * _Nullable numberAttributeConstraints;
@property (nonatomic, strong) NSNumber * _Nullable required;
@property (nonatomic, strong) AWSCognitoIdentityProviderStringAttributeConstraintsType * _Nullable stringAttributeConstraints;
@end
@interface AWSCognitoIdentityProviderSetRiskConfigurationRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountTakeoverRiskConfigurationType * _Nullable accountTakeoverRiskConfiguration;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) AWSCognitoIdentityProviderCompromisedCredentialsRiskConfigurationType * _Nullable compromisedCredentialsRiskConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderRiskExceptionConfigurationType * _Nullable riskExceptionConfiguration;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderSetRiskConfigurationResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderRiskConfigurationType * _Nullable riskConfiguration;
@end
@interface AWSCognitoIdentityProviderSetUICustomizationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable CSS;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSData * _Nullable imageFile;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderSetUICustomizationResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUICustomizationType * _Nullable UICustomization;
@end
@interface AWSCognitoIdentityProviderSetUserMFAPreferenceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) AWSCognitoIdentityProviderSMSMfaSettingsType * _Nullable SMSMfaSettings;
@property (nonatomic, strong) AWSCognitoIdentityProviderSoftwareTokenMfaSettingsType * _Nullable softwareTokenMfaSettings;
@end
@interface AWSCognitoIdentityProviderSetUserMFAPreferenceResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderSetUserPoolMfaConfigRequest : AWSRequest
@property (nonatomic, assign) AWSCognitoIdentityProviderUserPoolMfaType mfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsMfaConfigType * _Nullable smsMfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderSoftwareTokenMfaConfigType * _Nullable softwareTokenMfaConfiguration;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderSetUserPoolMfaConfigResponse : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderUserPoolMfaType mfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsMfaConfigType * _Nullable smsMfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderSoftwareTokenMfaConfigType * _Nullable softwareTokenMfaConfiguration;
@end
@interface AWSCognitoIdentityProviderSetUserSettingsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderMFAOptionType *> * _Nullable MFAOptions;
@end
@interface AWSCognitoIdentityProviderSetUserSettingsResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderSignUpRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsMetadataType * _Nullable analyticsMetadata;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSString * _Nullable password;
@property (nonatomic, strong) NSString * _Nullable secretHash;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable userAttributes;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserContextDataType * _Nullable userContextData;
@property (nonatomic, strong) NSString * _Nullable username;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable validationData;
@end
@interface AWSCognitoIdentityProviderSignUpResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderCodeDeliveryDetailsType * _Nullable codeDeliveryDetails;
@property (nonatomic, strong) NSNumber * _Nullable userConfirmed;
@property (nonatomic, strong) NSString * _Nullable userSub;
@end
@interface AWSCognitoIdentityProviderSmsConfigurationType : AWSModel
@property (nonatomic, strong) NSString * _Nullable externalId;
@property (nonatomic, strong) NSString * _Nullable snsCallerArn;
@end
@interface AWSCognitoIdentityProviderSmsMfaConfigType : AWSModel
@property (nonatomic, strong) NSString * _Nullable smsAuthenticationMessage;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsConfigurationType * _Nullable smsConfiguration;
@end
@interface AWSCognitoIdentityProviderSoftwareTokenMfaConfigType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable enabled;
@end
@interface AWSCognitoIdentityProviderSoftwareTokenMfaSettingsType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable enabled;
@property (nonatomic, strong) NSNumber * _Nullable preferredMfa;
@end
@interface AWSCognitoIdentityProviderStartUserImportJobRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable jobId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderStartUserImportJobResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserImportJobType * _Nullable userImportJob;
@end
@interface AWSCognitoIdentityProviderStopUserImportJobRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable jobId;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderStopUserImportJobResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserImportJobType * _Nullable userImportJob;
@end
@interface AWSCognitoIdentityProviderStringAttributeConstraintsType : AWSModel
@property (nonatomic, strong) NSString * _Nullable maxLength;
@property (nonatomic, strong) NSString * _Nullable minLength;
@end
@interface AWSCognitoIdentityProviderTagResourceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable resourceArn;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable tags;
@end
@interface AWSCognitoIdentityProviderTagResourceResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderTokenValidityUnitsType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderTimeUnitsType accessToken;
@property (nonatomic, assign) AWSCognitoIdentityProviderTimeUnitsType idToken;
@property (nonatomic, assign) AWSCognitoIdentityProviderTimeUnitsType refreshToken;
@end
@interface AWSCognitoIdentityProviderUICustomizationType : AWSModel
@property (nonatomic, strong) NSString * _Nullable CSS;
@property (nonatomic, strong) NSString * _Nullable CSSVersion;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable imageUrl;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUntagResourceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable resourceArn;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable tagKeys;
@end
@interface AWSCognitoIdentityProviderUntagResourceResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderUpdateAuthEventFeedbackRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable eventId;
@property (nonatomic, strong) NSString * _Nullable feedbackToken;
@property (nonatomic, assign) AWSCognitoIdentityProviderFeedbackValueType feedbackValue;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderUpdateAuthEventFeedbackResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderUpdateDeviceStatusRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable deviceKey;
@property (nonatomic, assign) AWSCognitoIdentityProviderDeviceRememberedStatusType deviceRememberedStatus;
@end
@interface AWSCognitoIdentityProviderUpdateDeviceStatusResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderUpdateGroupRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable detail;
@property (nonatomic, strong) NSString * _Nullable groupName;
@property (nonatomic, strong) NSNumber * _Nullable precedence;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUpdateGroupResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderGroupType * _Nullable group;
@end
@interface AWSCognitoIdentityProviderUpdateIdentityProviderRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable attributeMapping;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable idpIdentifiers;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable providerDetails;
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUpdateIdentityProviderResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderIdentityProviderType * _Nullable identityProvider;
@end
@interface AWSCognitoIdentityProviderUpdateResourceServerRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderResourceServerScopeType *> * _Nullable scopes;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUpdateResourceServerResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderResourceServerType * _Nullable resourceServer;
@end
@interface AWSCognitoIdentityProviderUpdateUserAttributesRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable clientMetadata;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable userAttributes;
@end
@interface AWSCognitoIdentityProviderUpdateUserAttributesResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderCodeDeliveryDetailsType *> * _Nullable codeDeliveryDetailsList;
@end
@interface AWSCognitoIdentityProviderUpdateUserPoolClientRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable accessTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOAuthFlows;
@property (nonatomic, strong) NSNumber * _Nullable allowedOAuthFlowsUserPoolClient;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOAuthScopes;
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsConfigurationType * _Nullable analyticsConfiguration;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable callbackURLs;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable clientName;
@property (nonatomic, strong) NSString * _Nullable defaultRedirectURI;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable explicitAuthFlows;
@property (nonatomic, strong) NSNumber * _Nullable idTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable logoutURLs;
@property (nonatomic, assign) AWSCognitoIdentityProviderPreventUserExistenceErrorTypes preventUserExistenceErrors;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable readAttributes;
@property (nonatomic, strong) NSNumber * _Nullable refreshTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable supportedIdentityProviders;
@property (nonatomic, strong) AWSCognitoIdentityProviderTokenValidityUnitsType * _Nullable tokenValidityUnits;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable writeAttributes;
@end
@interface AWSCognitoIdentityProviderUpdateUserPoolClientResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolClientType * _Nullable userPoolClient;
@end
@interface AWSCognitoIdentityProviderUpdateUserPoolDomainRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderCustomDomainConfigType * _Nullable customDomainConfig;
@property (nonatomic, strong) NSString * _Nullable domain;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUpdateUserPoolDomainResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable cloudFrontDomain;
@end
@interface AWSCognitoIdentityProviderUpdateUserPoolRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountRecoverySettingType * _Nullable accountRecoverySetting;
@property (nonatomic, strong) AWSCognitoIdentityProviderAdminCreateUserConfigType * _Nullable adminCreateUserConfig;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable autoVerifiedAttributes;
@property (nonatomic, strong) AWSCognitoIdentityProviderDeviceConfigurationType * _Nullable deviceConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderEmailConfigurationType * _Nullable emailConfiguration;
@property (nonatomic, strong) NSString * _Nullable emailVerificationMessage;
@property (nonatomic, strong) NSString * _Nullable emailVerificationSubject;
@property (nonatomic, strong) AWSCognitoIdentityProviderLambdaConfigType * _Nullable lambdaConfig;
@property (nonatomic, assign) AWSCognitoIdentityProviderUserPoolMfaType mfaConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolPolicyType * _Nullable policies;
@property (nonatomic, strong) NSString * _Nullable smsAuthenticationMessage;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsConfigurationType * _Nullable smsConfiguration;
@property (nonatomic, strong) NSString * _Nullable smsVerificationMessage;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolAddOnsType * _Nullable userPoolAddOns;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable userPoolTags;
@property (nonatomic, strong) AWSCognitoIdentityProviderVerificationMessageTemplateType * _Nullable verificationMessageTemplate;
@end
@interface AWSCognitoIdentityProviderUpdateUserPoolResponse : AWSModel
@end
@interface AWSCognitoIdentityProviderUserContextDataType : AWSModel
@property (nonatomic, strong) NSString * _Nullable encodedData;
@end
@interface AWSCognitoIdentityProviderUserImportJobType : AWSModel
@property (nonatomic, strong) NSString * _Nullable cloudWatchLogsRoleArn;
@property (nonatomic, strong) NSDate * _Nullable completionDate;
@property (nonatomic, strong) NSString * _Nullable completionMessage;
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSNumber * _Nullable failedUsers;
@property (nonatomic, strong) NSNumber * _Nullable importedUsers;
@property (nonatomic, strong) NSString * _Nullable jobId;
@property (nonatomic, strong) NSString * _Nullable jobName;
@property (nonatomic, strong) NSString * _Nullable preSignedUrl;
@property (nonatomic, strong) NSNumber * _Nullable skippedUsers;
@property (nonatomic, strong) NSDate * _Nullable startDate;
@property (nonatomic, assign) AWSCognitoIdentityProviderUserImportJobStatusType status;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUserPoolAddOnsType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderAdvancedSecurityModeType advancedSecurityMode;
@end
@interface AWSCognitoIdentityProviderUserPoolClientDescription : AWSModel
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable clientName;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@end
@interface AWSCognitoIdentityProviderUserPoolClientType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable accessTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOAuthFlows;
@property (nonatomic, strong) NSNumber * _Nullable allowedOAuthFlowsUserPoolClient;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOAuthScopes;
@property (nonatomic, strong) AWSCognitoIdentityProviderAnalyticsConfigurationType * _Nullable analyticsConfiguration;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable callbackURLs;
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable clientName;
@property (nonatomic, strong) NSString * _Nullable clientSecret;
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable defaultRedirectURI;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable explicitAuthFlows;
@property (nonatomic, strong) NSNumber * _Nullable idTokenValidity;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable logoutURLs;
@property (nonatomic, assign) AWSCognitoIdentityProviderPreventUserExistenceErrorTypes preventUserExistenceErrors;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable readAttributes;
@property (nonatomic, strong) NSNumber * _Nullable refreshTokenValidity;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable supportedIdentityProviders;
@property (nonatomic, strong) AWSCognitoIdentityProviderTokenValidityUnitsType * _Nullable tokenValidityUnits;
@property (nonatomic, strong) NSString * _Nullable userPoolId;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable writeAttributes;
@end
@interface AWSCognitoIdentityProviderUserPoolDescriptionType : AWSModel
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSCognitoIdentityProviderLambdaConfigType * _Nullable lambdaConfig;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, assign) AWSCognitoIdentityProviderStatusType status;
@end
@interface AWSCognitoIdentityProviderUserPoolPolicyType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderPasswordPolicyType * _Nullable passwordPolicy;
@end
@interface AWSCognitoIdentityProviderUserPoolType : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityProviderAccountRecoverySettingType * _Nullable accountRecoverySetting;
@property (nonatomic, strong) AWSCognitoIdentityProviderAdminCreateUserConfigType * _Nullable adminCreateUserConfig;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable aliasAttributes;
@property (nonatomic, strong) NSString * _Nullable arn;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable autoVerifiedAttributes;
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable customDomain;
@property (nonatomic, strong) AWSCognitoIdentityProviderDeviceConfigurationType * _Nullable deviceConfiguration;
@property (nonatomic, strong) NSString * _Nullable domain;
@property (nonatomic, strong) AWSCognitoIdentityProviderEmailConfigurationType * _Nullable emailConfiguration;
@property (nonatomic, strong) NSString * _Nullable emailConfigurationFailure;
@property (nonatomic, strong) NSString * _Nullable emailVerificationMessage;
@property (nonatomic, strong) NSString * _Nullable emailVerificationSubject;
@property (nonatomic, strong) NSNumber * _Nullable estimatedNumberOfUsers;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSCognitoIdentityProviderLambdaConfigType * _Nullable lambdaConfig;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, assign) AWSCognitoIdentityProviderUserPoolMfaType mfaConfiguration;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolPolicyType * _Nullable policies;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderSchemaAttributeType *> * _Nullable schemaAttributes;
@property (nonatomic, strong) NSString * _Nullable smsAuthenticationMessage;
@property (nonatomic, strong) AWSCognitoIdentityProviderSmsConfigurationType * _Nullable smsConfiguration;
@property (nonatomic, strong) NSString * _Nullable smsConfigurationFailure;
@property (nonatomic, strong) NSString * _Nullable smsVerificationMessage;
@property (nonatomic, assign) AWSCognitoIdentityProviderStatusType status;
@property (nonatomic, strong) AWSCognitoIdentityProviderUserPoolAddOnsType * _Nullable userPoolAddOns;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable userPoolTags;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable usernameAttributes;
@property (nonatomic, strong) AWSCognitoIdentityProviderUsernameConfigurationType * _Nullable usernameConfiguration;
@property (nonatomic, strong) AWSCognitoIdentityProviderVerificationMessageTemplateType * _Nullable verificationMessageTemplate;
@end
@interface AWSCognitoIdentityProviderUserType : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderAttributeType *> * _Nullable attributes;
@property (nonatomic, strong) NSNumber * _Nullable enabled;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityProviderMFAOptionType *> * _Nullable MFAOptions;
@property (nonatomic, strong) NSDate * _Nullable userCreateDate;
@property (nonatomic, strong) NSDate * _Nullable userLastModifiedDate;
@property (nonatomic, assign) AWSCognitoIdentityProviderUserStatusType userStatus;
@property (nonatomic, strong) NSString * _Nullable username;
@end
@interface AWSCognitoIdentityProviderUsernameConfigurationType : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable caseSensitive;
@end
@interface AWSCognitoIdentityProviderVerificationMessageTemplateType : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityProviderDefaultEmailOptionType defaultEmailOption;
@property (nonatomic, strong) NSString * _Nullable emailMessage;
@property (nonatomic, strong) NSString * _Nullable emailMessageByLink;
@property (nonatomic, strong) NSString * _Nullable emailSubject;
@property (nonatomic, strong) NSString * _Nullable emailSubjectByLink;
@property (nonatomic, strong) NSString * _Nullable smsMessage;
@end
@interface AWSCognitoIdentityProviderVerifySoftwareTokenRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable friendlyDeviceName;
@property (nonatomic, strong) NSString * _Nullable session;
@property (nonatomic, strong) NSString * _Nullable userCode;
@end
@interface AWSCognitoIdentityProviderVerifySoftwareTokenResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable session;
@property (nonatomic, assign) AWSCognitoIdentityProviderVerifySoftwareTokenResponseType status;
@end
@interface AWSCognitoIdentityProviderVerifyUserAttributeRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessToken;
@property (nonatomic, strong) NSString * _Nullable attributeName;
@property (nonatomic, strong) NSString * _Nullable code;
@end
@interface AWSCognitoIdentityProviderVerifyUserAttributeResponse : AWSModel
@end
NS_ASSUME_NONNULL_END