#import <AWSCore/AWSCore.h>
NS_ASSUME_NONNULL_BEGIN
static NSString *const AWSS3PresignedURLVersionID = @"versionId";
static NSString *const AWSS3PresignedURLTorrent = @"torrent";
static NSString *const AWSS3PresignedURLServerSideEncryption = @"x-amz-server-side-encryption";
static NSString *const AWSS3PresignedURLServerSideEncryptionCustomerAlgorithm = @"x-amz-server-side-encryption-customer-algorithm";
static NSString *const AWSS3PresignedURLServerSideEncryptionCustomerKey = @"x-amz-server-side-encryption-customer-key";
static NSString *const AWSS3PresignedURLServerSdieEncryptionCustomerKeyMD5 = @"x-amz-server-side-encryption-customer-key-MD5";
FOUNDATION_EXPORT NSString *const AWSS3PresignedURLErrorDomain;
typedef NS_ENUM(NSInteger, AWSS3PresignedURLErrorType) {
    AWSS3PresignedURLErrorUnknown,
    AWSS3PresignedURLErrorAccessKeyIsNil,
    AWSS3PresignedURLErrorSecretKeyIsNil,
    AWSS3PresignedURLErrorBucketNameIsNil,
    AWSS3PresignedURLErrorKeyNameIsNil,
    AWSS3PresignedURLErrorInvalidExpiresDate,
    AWSS3PresignedURLErrorUnsupportedHTTPVerbs,
    AWSS3PresignedURLErrorEndpointIsNil,
    AWSS3PresignedURLErrorInvalidServiceType,
    AWSS3PreSignedURLErrorCredentialProviderIsNil,
    AWSS3PreSignedURLErrorInternalError,
    AWSS3PresignedURLErrorInvalidRequestParameters,
    AWSS3PresignedURLErrorInvalidBucketName,
    AWSS3PresignedURLErrorInvalidBucketNameForAccelerateModeEnabled,
};
@class AWSS3GetPreSignedURLRequest;
@interface AWSS3PreSignedURLBuilder : AWSService
+ (instancetype)defaultS3PreSignedURLBuilder;
+ (void)registerS3PreSignedURLBuilderWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;
+ (instancetype)S3PreSignedURLBuilderForKey:(NSString *)key;
+ (void)removeS3PreSignedURLBuilderForKey:(NSString *)key;
- (AWSTask<NSURL *> *)getPreSignedURL:(AWSS3GetPreSignedURLRequest *)getPreSignedURLRequest;
@end
@interface AWSS3GetPreSignedURLRequest : NSObject
@property (nonatomic, assign, getter=isAccelerateModeEnabled) BOOL accelerateModeEnabled;
@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) AWSHTTPMethod HTTPMethod;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, assign) NSTimeInterval minimumCredentialsExpirationInterval;
@property (nonatomic) NSString * _Nullable contentType;
@property (nonatomic) NSString * _Nullable contentMD5;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *requestParameters;
- (void)setValue:(NSString * _Nullable)value forRequestHeader:(NSString *)requestHeader;
- (void)setValue:(NSString * _Nullable)value forRequestParameter:(NSString *)requestParameter;
@end
NS_ASSUME_NONNULL_END