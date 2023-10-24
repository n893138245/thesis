#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
#import "AWSModel.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoIdentityErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoIdentityErrorType) {
    AWSCognitoIdentityErrorUnknown,
    AWSCognitoIdentityErrorConcurrentModification,
    AWSCognitoIdentityErrorDeveloperUserAlreadyRegistered,
    AWSCognitoIdentityErrorExternalService,
    AWSCognitoIdentityErrorInternalError,
    AWSCognitoIdentityErrorInvalidIdentityPoolConfiguration,
    AWSCognitoIdentityErrorInvalidParameter,
    AWSCognitoIdentityErrorLimitExceeded,
    AWSCognitoIdentityErrorNotAuthorized,
    AWSCognitoIdentityErrorResourceConflict,
    AWSCognitoIdentityErrorResourceNotFound,
    AWSCognitoIdentityErrorTooManyRequests,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityAmbiguousRoleResolutionType) {
    AWSCognitoIdentityAmbiguousRoleResolutionTypeUnknown,
    AWSCognitoIdentityAmbiguousRoleResolutionTypeAuthenticatedRole,
    AWSCognitoIdentityAmbiguousRoleResolutionTypeDeny,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityErrorCode) {
    AWSCognitoIdentityErrorCodeUnknown,
    AWSCognitoIdentityErrorCodeAccessDenied,
    AWSCognitoIdentityErrorCodeInternalServerError,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityMappingRuleMatchType) {
    AWSCognitoIdentityMappingRuleMatchTypeUnknown,
    AWSCognitoIdentityMappingRuleMatchTypeEquals,
    AWSCognitoIdentityMappingRuleMatchTypeContains,
    AWSCognitoIdentityMappingRuleMatchTypeStartsWith,
    AWSCognitoIdentityMappingRuleMatchTypeNotEqual,
};
typedef NS_ENUM(NSInteger, AWSCognitoIdentityRoleMappingType) {
    AWSCognitoIdentityRoleMappingTypeUnknown,
    AWSCognitoIdentityRoleMappingTypeToken,
    AWSCognitoIdentityRoleMappingTypeRules,
};
@class AWSCognitoIdentityCognitoIdentityProvider;
@class AWSCognitoIdentityCreateIdentityPoolInput;
@class AWSCognitoIdentityCredentials;
@class AWSCognitoIdentityDeleteIdentitiesInput;
@class AWSCognitoIdentityDeleteIdentitiesResponse;
@class AWSCognitoIdentityDeleteIdentityPoolInput;
@class AWSCognitoIdentityDescribeIdentityInput;
@class AWSCognitoIdentityDescribeIdentityPoolInput;
@class AWSCognitoIdentityGetCredentialsForIdentityInput;
@class AWSCognitoIdentityGetCredentialsForIdentityResponse;
@class AWSCognitoIdentityGetIdInput;
@class AWSCognitoIdentityGetIdResponse;
@class AWSCognitoIdentityGetIdentityPoolRolesInput;
@class AWSCognitoIdentityGetIdentityPoolRolesResponse;
@class AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityInput;
@class AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityResponse;
@class AWSCognitoIdentityGetOpenIdTokenInput;
@class AWSCognitoIdentityGetOpenIdTokenResponse;
@class AWSCognitoIdentityIdentityDescription;
@class AWSCognitoIdentityIdentityPool;
@class AWSCognitoIdentityIdentityPoolShortDescription;
@class AWSCognitoIdentityListIdentitiesInput;
@class AWSCognitoIdentityListIdentitiesResponse;
@class AWSCognitoIdentityListIdentityPoolsInput;
@class AWSCognitoIdentityListIdentityPoolsResponse;
@class AWSCognitoIdentityListTagsForResourceInput;
@class AWSCognitoIdentityListTagsForResourceResponse;
@class AWSCognitoIdentityLookupDeveloperIdentityInput;
@class AWSCognitoIdentityLookupDeveloperIdentityResponse;
@class AWSCognitoIdentityMappingRule;
@class AWSCognitoIdentityMergeDeveloperIdentitiesInput;
@class AWSCognitoIdentityMergeDeveloperIdentitiesResponse;
@class AWSCognitoIdentityRoleMapping;
@class AWSCognitoIdentityRulesConfigurationType;
@class AWSCognitoIdentitySetIdentityPoolRolesInput;
@class AWSCognitoIdentityTagResourceInput;
@class AWSCognitoIdentityTagResourceResponse;
@class AWSCognitoIdentityUnlinkDeveloperIdentityInput;
@class AWSCognitoIdentityUnlinkIdentityInput;
@class AWSCognitoIdentityUnprocessedIdentityId;
@class AWSCognitoIdentityUntagResourceInput;
@class AWSCognitoIdentityUntagResourceResponse;
@interface AWSCognitoIdentityCognitoIdentityProvider : AWSModel
@property (nonatomic, strong) NSString * _Nullable clientId;
@property (nonatomic, strong) NSString * _Nullable providerName;
@property (nonatomic, strong) NSNumber * _Nullable serverSideTokenCheck;
@end
@interface AWSCognitoIdentityCreateIdentityPoolInput : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable allowClassicFlow;
@property (nonatomic, strong) NSNumber * _Nullable allowUnauthenticatedIdentities;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityCognitoIdentityProvider *> * _Nullable cognitoIdentityProviders;
@property (nonatomic, strong) NSString * _Nullable developerProviderName;
@property (nonatomic, strong) NSString * _Nullable identityPoolName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable identityPoolTags;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable openIdConnectProviderARNs;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable samlProviderARNs;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable supportedLoginProviders;
@end
@interface AWSCognitoIdentityCredentials : AWSModel
@property (nonatomic, strong) NSString * _Nullable accessKeyId;
@property (nonatomic, strong) NSDate * _Nullable expiration;
@property (nonatomic, strong) NSString * _Nullable secretKey;
@property (nonatomic, strong) NSString * _Nullable sessionToken;
@end
@interface AWSCognitoIdentityDeleteIdentitiesInput : AWSRequest
@property (nonatomic, strong) NSArray<NSString *> * _Nullable identityIdsToDelete;
@end
@interface AWSCognitoIdentityDeleteIdentitiesResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityUnprocessedIdentityId *> * _Nullable unprocessedIdentityIds;
@end
@interface AWSCognitoIdentityDeleteIdentityPoolInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoIdentityDescribeIdentityInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@end
@interface AWSCognitoIdentityDescribeIdentityPoolInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoIdentityGetCredentialsForIdentityInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable customRoleArn;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable logins;
@end
@interface AWSCognitoIdentityGetCredentialsForIdentityResponse : AWSModel
@property (nonatomic, strong) AWSCognitoIdentityCredentials * _Nullable credentials;
@property (nonatomic, strong) NSString * _Nullable identityId;
@end
@interface AWSCognitoIdentityGetIdInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accountId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable logins;
@end
@interface AWSCognitoIdentityGetIdResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityId;
@end
@interface AWSCognitoIdentityGetIdentityPoolRolesInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoIdentityGetIdentityPoolRolesResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSDictionary<NSString *, AWSCognitoIdentityRoleMapping *> * _Nullable roleMappings;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable roles;
@end
@interface AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable logins;
@property (nonatomic, strong) NSNumber * _Nullable tokenDuration;
@end
@interface AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable token;
@end
@interface AWSCognitoIdentityGetOpenIdTokenInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable logins;
@end
@interface AWSCognitoIdentityGetOpenIdTokenResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable token;
@end
@interface AWSCognitoIdentityIdentityDescription : AWSModel
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable logins;
@end
@interface AWSCognitoIdentityIdentityPool : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable allowClassicFlow;
@property (nonatomic, strong) NSNumber * _Nullable allowUnauthenticatedIdentities;
@property (nonatomic, strong) NSArray<AWSCognitoIdentityCognitoIdentityProvider *> * _Nullable cognitoIdentityProviders;
@property (nonatomic, strong) NSString * _Nullable developerProviderName;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSString * _Nullable identityPoolName;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable identityPoolTags;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable openIdConnectProviderARNs;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable samlProviderARNs;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable supportedLoginProviders;
@end
@interface AWSCognitoIdentityIdentityPoolShortDescription : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSString * _Nullable identityPoolName;
@end
@interface AWSCognitoIdentityListIdentitiesInput : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable hideDisabled;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityListIdentitiesResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityIdentityDescription *> * _Nullable identities;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityListIdentityPoolsInput : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityListIdentityPoolsResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityIdentityPoolShortDescription *> * _Nullable identityPools;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityListTagsForResourceInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable resourceArn;
@end
@interface AWSCognitoIdentityListTagsForResourceResponse : AWSModel
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable tags;
@end
@interface AWSCognitoIdentityLookupDeveloperIdentityInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable developerUserIdentifier;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityLookupDeveloperIdentityResponse : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable developerUserIdentifierList;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoIdentityMappingRule : AWSModel
@property (nonatomic, strong) NSString * _Nullable claim;
@property (nonatomic, assign) AWSCognitoIdentityMappingRuleMatchType matchType;
@property (nonatomic, strong) NSString * _Nullable roleARN;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSCognitoIdentityMergeDeveloperIdentitiesInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable destinationUserIdentifier;
@property (nonatomic, strong) NSString * _Nullable developerProviderName;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSString * _Nullable sourceUserIdentifier;
@end
@interface AWSCognitoIdentityMergeDeveloperIdentitiesResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityId;
@end
@interface AWSCognitoIdentityRoleMapping : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityAmbiguousRoleResolutionType ambiguousRoleResolution;
@property (nonatomic, strong) AWSCognitoIdentityRulesConfigurationType * _Nullable rulesConfiguration;
@property (nonatomic, assign) AWSCognitoIdentityRoleMappingType types;
@end
@interface AWSCognitoIdentityRulesConfigurationType : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoIdentityMappingRule *> * _Nullable rules;
@end
@interface AWSCognitoIdentitySetIdentityPoolRolesInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSDictionary<NSString *, AWSCognitoIdentityRoleMapping *> * _Nullable roleMappings;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable roles;
@end
@interface AWSCognitoIdentityTagResourceInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable resourceArn;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable tags;
@end
@interface AWSCognitoIdentityTagResourceResponse : AWSModel
@end
@interface AWSCognitoIdentityUnlinkDeveloperIdentityInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable developerProviderName;
@property (nonatomic, strong) NSString * _Nullable developerUserIdentifier;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoIdentityUnlinkIdentityInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable logins;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable loginsToRemove;
@end
@interface AWSCognitoIdentityUnprocessedIdentityId : AWSModel
@property (nonatomic, assign) AWSCognitoIdentityErrorCode errorCode;
@property (nonatomic, strong) NSString * _Nullable identityId;
@end
@interface AWSCognitoIdentityUntagResourceInput : AWSRequest
@property (nonatomic, strong) NSString * _Nullable resourceArn;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable tagKeys;
@end
@interface AWSCognitoIdentityUntagResourceResponse : AWSModel
@end
NS_ASSUME_NONNULL_END