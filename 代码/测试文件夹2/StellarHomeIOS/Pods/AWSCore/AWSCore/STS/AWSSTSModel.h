#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
#import "AWSModel.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSSTSErrorDomain;
typedef NS_ENUM(NSInteger, AWSSTSErrorType) {
    AWSSTSErrorUnknown,
    AWSSTSErrorExpiredToken,
    AWSSTSErrorIDPCommunicationError,
    AWSSTSErrorIDPRejectedClaim,
    AWSSTSErrorInvalidAuthorizationMessage,
    AWSSTSErrorInvalidIdentityToken,
    AWSSTSErrorMalformedPolicyDocument,
    AWSSTSErrorPackedPolicyTooLarge,
    AWSSTSErrorRegionDisabled,
};
@class AWSSTSAssumeRoleRequest;
@class AWSSTSAssumeRoleResponse;
@class AWSSTSAssumeRoleWithSAMLRequest;
@class AWSSTSAssumeRoleWithSAMLResponse;
@class AWSSTSAssumeRoleWithWebIdentityRequest;
@class AWSSTSAssumeRoleWithWebIdentityResponse;
@class AWSSTSAssumedRoleUser;
@class AWSSTSCredentials;
@class AWSSTSDecodeAuthorizationMessageRequest;
@class AWSSTSDecodeAuthorizationMessageResponse;
@class AWSSTSFederatedUser;
@class AWSSTSGetAccessKeyInfoRequest;
@class AWSSTSGetAccessKeyInfoResponse;
@class AWSSTSGetCallerIdentityRequest;
@class AWSSTSGetCallerIdentityResponse;
@class AWSSTSGetFederationTokenRequest;
@class AWSSTSGetFederationTokenResponse;
@class AWSSTSGetSessionTokenRequest;
@class AWSSTSGetSessionTokenResponse;
@class AWSSTSPolicyDescriptorType;
@class AWSSTSTag;
@interface AWSSTSAssumeRoleRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable durationSeconds;
@property (nonatomic, strong) NSString * _Nullable externalId;
@property (nonatomic, strong) NSString * _Nullable policy;
@property (nonatomic, strong) NSArray<AWSSTSPolicyDescriptorType *> * _Nullable policyArns;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable roleSessionName;
@property (nonatomic, strong) NSString * _Nullable serialNumber;
@property (nonatomic, strong) NSArray<AWSSTSTag *> * _Nullable tags;
@property (nonatomic, strong) NSString * _Nullable tokenCode;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable transitiveTagKeys;
@end
@interface AWSSTSAssumeRoleResponse : AWSModel
@property (nonatomic, strong) AWSSTSAssumedRoleUser * _Nullable assumedRoleUser;
@property (nonatomic, strong) AWSSTSCredentials * _Nullable credentials;
@property (nonatomic, strong) NSNumber * _Nullable packedPolicySize;
@end
@interface AWSSTSAssumeRoleWithSAMLRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable durationSeconds;
@property (nonatomic, strong) NSString * _Nullable policy;
@property (nonatomic, strong) NSArray<AWSSTSPolicyDescriptorType *> * _Nullable policyArns;
@property (nonatomic, strong) NSString * _Nullable principalArn;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable SAMLAssertion;
@end
@interface AWSSTSAssumeRoleWithSAMLResponse : AWSModel
@property (nonatomic, strong) AWSSTSAssumedRoleUser * _Nullable assumedRoleUser;
@property (nonatomic, strong) NSString * _Nullable audience;
@property (nonatomic, strong) AWSSTSCredentials * _Nullable credentials;
@property (nonatomic, strong) NSString * _Nullable issuer;
@property (nonatomic, strong) NSString * _Nullable nameQualifier;
@property (nonatomic, strong) NSNumber * _Nullable packedPolicySize;
@property (nonatomic, strong) NSString * _Nullable subject;
@property (nonatomic, strong) NSString * _Nullable subjectType;
@end
@interface AWSSTSAssumeRoleWithWebIdentityRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable durationSeconds;
@property (nonatomic, strong) NSString * _Nullable policy;
@property (nonatomic, strong) NSArray<AWSSTSPolicyDescriptorType *> * _Nullable policyArns;
@property (nonatomic, strong) NSString * _Nullable providerId;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable roleSessionName;
@property (nonatomic, strong) NSString * _Nullable webIdentityToken;
@end
@interface AWSSTSAssumeRoleWithWebIdentityResponse : AWSModel
@property (nonatomic, strong) AWSSTSAssumedRoleUser * _Nullable assumedRoleUser;
@property (nonatomic, strong) NSString * _Nullable audience;
@property (nonatomic, strong) AWSSTSCredentials * _Nullable credentials;
@property (nonatomic, strong) NSNumber * _Nullable packedPolicySize;
@property (nonatomic, strong) NSString * _Nullable provider;
@property (nonatomic, strong) NSString * _Nullable subjectFromWebIdentityToken;
@end
@interface AWSSTSAssumedRoleUser : AWSModel
@property (nonatomic, strong) NSString * _Nullable arn;
@property (nonatomic, strong) NSString * _Nullable assumedRoleId;
@end
@interface AWSSTSCredentials : AWSModel
@property (nonatomic, strong) NSString * _Nullable accessKeyId;
@property (nonatomic, strong) NSDate * _Nullable expiration;
@property (nonatomic, strong) NSString * _Nullable secretAccessKey;
@property (nonatomic, strong) NSString * _Nullable sessionToken;
@end
@interface AWSSTSDecodeAuthorizationMessageRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable encodedMessage;
@end
@interface AWSSTSDecodeAuthorizationMessageResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable decodedMessage;
@end
@interface AWSSTSFederatedUser : AWSModel
@property (nonatomic, strong) NSString * _Nullable arn;
@property (nonatomic, strong) NSString * _Nullable federatedUserId;
@end
@interface AWSSTSGetAccessKeyInfoRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable accessKeyId;
@end
@interface AWSSTSGetAccessKeyInfoResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable account;
@end
@interface AWSSTSGetCallerIdentityRequest : AWSRequest
@end
@interface AWSSTSGetCallerIdentityResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable account;
@property (nonatomic, strong) NSString * _Nullable arn;
@property (nonatomic, strong) NSString * _Nullable userId;
@end
@interface AWSSTSGetFederationTokenRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable durationSeconds;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSString * _Nullable policy;
@property (nonatomic, strong) NSArray<AWSSTSPolicyDescriptorType *> * _Nullable policyArns;
@property (nonatomic, strong) NSArray<AWSSTSTag *> * _Nullable tags;
@end
@interface AWSSTSGetFederationTokenResponse : AWSModel
@property (nonatomic, strong) AWSSTSCredentials * _Nullable credentials;
@property (nonatomic, strong) AWSSTSFederatedUser * _Nullable federatedUser;
@property (nonatomic, strong) NSNumber * _Nullable packedPolicySize;
@end
@interface AWSSTSGetSessionTokenRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable durationSeconds;
@property (nonatomic, strong) NSString * _Nullable serialNumber;
@property (nonatomic, strong) NSString * _Nullable tokenCode;
@end
@interface AWSSTSGetSessionTokenResponse : AWSModel
@property (nonatomic, strong) AWSSTSCredentials * _Nullable credentials;
@end
@interface AWSSTSPolicyDescriptorType : AWSModel
@property (nonatomic, strong) NSString * _Nullable arn;
@end
@interface AWSSTSTag : AWSModel
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable value;
@end
NS_ASSUME_NONNULL_END