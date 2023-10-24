#import "AWSS3Service.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSS3TransferManagerErrorDomain;
typedef NS_ENUM(NSInteger, AWSS3TransferManagerErrorType) {
    AWSS3TransferManagerErrorUnknown,
    AWSS3TransferManagerErrorCancelled,
    AWSS3TransferManagerErrorPaused,
    AWSS3TransferManagerErrorCompleted,
    AWSS3TransferManagerErrorInternalInConsistency,
    AWSS3TransferManagerErrorMissingRequiredParameters,
    AWSS3TransferManagerErrorInvalidParameters,
};
typedef NS_ENUM(NSInteger, AWSS3TransferManagerRequestState) {
    AWSS3TransferManagerRequestStateNotStarted,
    AWSS3TransferManagerRequestStateRunning,
    AWSS3TransferManagerRequestStatePaused,
    AWSS3TransferManagerRequestStateCanceling,
    AWSS3TransferManagerRequestStateCompleted,
};
typedef void (^AWSS3TransferManagerResumeAllBlock) (AWSRequest *request);
@class AWSS3;
@class AWSS3TransferManagerUploadRequest;
@class AWSS3TransferManagerUploadOutput;
@class AWSS3TransferManagerDownloadRequest;
@class AWSS3TransferManagerDownloadOutput;
DEPRECATED_MSG_ATTRIBUTE("Use `AWSS3TransferUtility` for upload and download operations.")
@interface AWSS3TransferManager : AWSService
+ (instancetype)defaultS3TransferManager;
+ (void)registerS3TransferManagerWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;
+ (instancetype)S3TransferManagerForKey:(NSString *)key;
+ (void)removeS3TransferManagerForKey:(NSString *)key;
- (AWSTask *)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest;
- (AWSTask *)download:(AWSS3TransferManagerDownloadRequest *)downloadRequest;
- (AWSTask *)cancelAll;
- (AWSTask *)pauseAll;
- (AWSTask *)resumeAll:(AWSS3TransferManagerResumeAllBlock)block;
- (AWSTask *)clearCache;
@end
DEPRECATED_MSG_ATTRIBUTE("Use `AWSS3TransferUtility` for upload and download operations.")
@interface AWSS3TransferManagerUploadRequest : AWSS3PutObjectRequest
@property (nonatomic, assign, readonly) AWSS3TransferManagerRequestState state;
@property (nonatomic, strong) NSURL *body;
@end
DEPRECATED_MSG_ATTRIBUTE("Use `AWSS3TransferUtility` for upload and download operations.")
@interface AWSS3TransferManagerUploadOutput : AWSS3PutObjectOutput
@end
DEPRECATED_MSG_ATTRIBUTE("Use `AWSS3TransferUtility` for upload and download operations.")
@interface AWSS3TransferManagerDownloadRequest : AWSS3GetObjectRequest
@property (nonatomic, assign, readonly) AWSS3TransferManagerRequestState state;
@end
DEPRECATED_MSG_ATTRIBUTE("Use `AWSS3TransferUtility` for upload and download operations.")
@interface AWSS3TransferManagerDownloadOutput : AWSS3GetObjectOutput
@end
NS_ASSUME_NONNULL_END