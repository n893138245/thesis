#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
#import "AWSCredentialsProvider.h"
#import "AWSServiceEnum.h"
FOUNDATION_EXPORT NSString *const AWSiOSSDKVersion;
FOUNDATION_EXPORT NSString *const AWSServiceErrorDomain;
typedef NS_ENUM(NSInteger, AWSServiceErrorType) {
    AWSServiceErrorUnknown,
    AWSServiceErrorRequestTimeTooSkewed,
    AWSServiceErrorInvalidSignatureException,
    AWSServiceErrorSignatureDoesNotMatch,
    AWSServiceErrorRequestExpired,
    AWSServiceErrorAuthFailure,
    AWSServiceErrorAccessDeniedException,
    AWSServiceErrorUnrecognizedClientException,
    AWSServiceErrorIncompleteSignature,
    AWSServiceErrorInvalidClientTokenId,
    AWSServiceErrorMissingAuthenticationToken,
    AWSServiceErrorAccessDenied,
    AWSServiceErrorExpiredToken,
    AWSServiceErrorInvalidAccessKeyId,
    AWSServiceErrorInvalidToken,
    AWSServiceErrorTokenRefreshRequired,
    AWSServiceErrorAccessFailure,
    AWSServiceErrorAuthMissingFailure,
    AWSServiceErrorThrottling,
    AWSServiceErrorThrottlingException,
};
@class AWSEndpoint;
#pragma mark - AWSService
@interface AWSService : NSObject
+ (NSDictionary<NSString *, NSNumber *> *)errorCodeDictionary;
@end
#pragma mark - AWSServiceManager
@class AWSServiceConfiguration;
@interface AWSServiceManager : NSObject
@property (nonatomic, copy) AWSServiceConfiguration *defaultServiceConfiguration;
+ (instancetype)defaultServiceManager;
@end
#pragma mark - AWSServiceConfiguration
@interface AWSServiceConfiguration : AWSNetworkingConfiguration
@property (nonatomic, assign, readonly) AWSRegionType regionType;
@property (nonatomic, strong, readonly) id<AWSCredentialsProvider> credentialsProvider;
@property (nonatomic, strong, readonly) AWSEndpoint *endpoint;
@property (nonatomic, readonly) NSString *userAgent;
@property (nonatomic, readonly) BOOL localTestingEnabled;
+ (NSString *)baseUserAgent;
+ (void)addGlobalUserAgentProductToken:(NSString *)productToken;
- (instancetype)initWithRegion:(AWSRegionType)regionType
           credentialsProvider:(id<AWSCredentialsProvider>)credentialsProvider;
- (instancetype)initWithRegion:(AWSRegionType)regionType
                   serviceType:(AWSServiceType)serviceType
           credentialsProvider:(id<AWSCredentialsProvider>)credentialsProvider
           localTestingEnabled:(BOOL)localTestingEnabled;
- (instancetype)initWithRegion:(AWSRegionType)regionType
                      endpoint:(AWSEndpoint *)endpoint
           credentialsProvider:(id<AWSCredentialsProvider>)credentialsProvider;
- (void)addUserAgentProductToken:(NSString *)productToken;
@end
#pragma mark - AWSEndpoint
@interface AWSEndpoint : NSObject
@property (nonatomic, readonly) AWSRegionType regionType;
@property (nonatomic, readonly) NSString *regionName;
@property (nonatomic, readonly) AWSServiceType serviceType;
@property (nonatomic, readonly) NSString *serviceName;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSString *hostName;
@property (nonatomic, readonly) BOOL useUnsafeURL;
@property (nonatomic, readonly) NSNumber *portNumber;
+ (NSString *)regionNameFromType:(AWSRegionType)regionType;
- (instancetype)initWithRegion:(AWSRegionType)regionType
                       service:(AWSServiceType)serviceType
                  useUnsafeURL:(BOOL)useUnsafeURL;
- (instancetype)initWithRegion:(AWSRegionType)regionType
                       service:(AWSServiceType)serviceType
                           URL:(NSURL *)URL;
- (instancetype)initWithRegion:(AWSRegionType)regionType
                   serviceName:(NSString *)serviceName
                           URL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLString:(NSString *)URLString;
- (instancetype)initLocalEndpointWithRegion:(AWSRegionType)regionType
                                    service:(AWSServiceType)serviceType
                               useUnsafeURL:(BOOL)useUnsafeURL;
@end