NS_ASSUME_NONNULL_BEGIN
@class AWSS3TransferUtilityTask;
@class AWSS3TransferUtilityUploadTask;
@class AWSS3TransferUtilityMultiPartUploadTask;
@class AWSS3TransferUtilityDownloadTask;
@class AWSS3TransferUtilityExpression;
@class AWSS3TransferUtilityUploadExpression;
@class AWSS3TransferUtilityMultiPartUploadExpression;
@class AWSS3TransferUtilityDownloadExpression;
typedef NS_ENUM(NSInteger, AWSS3TransferUtilityTransferStatusType) {
    AWSS3TransferUtilityTransferStatusUnknown,
    AWSS3TransferUtilityTransferStatusInProgress,
    AWSS3TransferUtilityTransferStatusPaused,
    AWSS3TransferUtilityTransferStatusCompleted,
    AWSS3TransferUtilityTransferStatusWaiting,
    AWSS3TransferUtilityTransferStatusError,
    AWSS3TransferUtilityTransferStatusCancelled
};
typedef void (^AWSS3TransferUtilityUploadCompletionHandlerBlock) (AWSS3TransferUtilityUploadTask *task,
                                                                  NSError * _Nullable error);
typedef void (^AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock) (AWSS3TransferUtilityMultiPartUploadTask *task,
                                                                           NSError * _Nullable error);
typedef void (^AWSS3TransferUtilityDownloadCompletionHandlerBlock) (AWSS3TransferUtilityDownloadTask *task,
                                                                    NSURL * _Nullable location,
                                                                    NSData * _Nullable data,
                                                                    NSError * _Nullable error);
typedef void (^AWSS3TransferUtilityProgressBlock) (AWSS3TransferUtilityTask *task,
                                                   NSProgress *progress);
typedef void (^AWSS3TransferUtilityMultiPartProgressBlock) (AWSS3TransferUtilityMultiPartUploadTask *task,
                                                            NSProgress *progress);
#pragma mark - AWSS3TransferUtilityTasks
@interface AWSS3TransferUtilityTask : NSObject
@property (readonly) NSString *transferID;
@property (readonly) NSUInteger taskIdentifier;
@property (readonly) NSString *bucket;
@property (readonly) NSString *key;
@property (readonly) NSProgress *progress;
@property (readonly) AWSS3TransferUtilityTransferStatusType status;
@property (readonly) NSURLSessionTask *sessionTask;
@property (nullable, readonly) NSURLRequest *request;
@property (nullable, readonly) NSHTTPURLResponse *response;
- (void)cancel;
- (void)resume;
- (void)suspend;
@end
@interface AWSS3TransferUtilityUploadTask : AWSS3TransferUtilityTask
- (void) setCompletionHandler: (AWSS3TransferUtilityUploadCompletionHandlerBlock)completionHandler;
- (void) setProgressBlock: (AWSS3TransferUtilityProgressBlock) progressBlock;
@end
@interface AWSS3TransferUtilityMultiPartUploadTask: NSObject
@property (readonly) NSString *transferID;
@property (readonly) NSString *bucket;
@property (readonly) NSString *key;
@property (readonly) NSProgress *progress;
@property (readonly) AWSS3TransferUtilityTransferStatusType status;
- (void)cancel;
- (void)resume;
- (void)suspend;
- (void) setCompletionHandler: (AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock)completionHandler;
- (void) setProgressBlock: (AWSS3TransferUtilityMultiPartProgressBlock) progressBlock;
@end
@interface AWSS3TransferUtilityDownloadTask : AWSS3TransferUtilityTask
- (void) setCompletionHandler: (AWSS3TransferUtilityDownloadCompletionHandlerBlock)completionHandler;
- (void) setProgressBlock: (AWSS3TransferUtilityProgressBlock) progressBlock;
@end
@interface AWSS3TransferUtilityUploadSubTask: NSObject
@end
#pragma mark - AWSS3TransferUtilityExpressions
@interface AWSS3TransferUtilityExpression : NSObject
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *requestParameters;
@property (copy, nonatomic, nullable) AWSS3TransferUtilityProgressBlock progressBlock;
- (void)setValue:(nullable NSString *)value forRequestHeader:(NSString *)requestHeader;
- (void)setValue:(nullable NSString *)value forRequestParameter:(NSString *)requestParameter;
@end
@interface AWSS3TransferUtilityUploadExpression : AWSS3TransferUtilityExpression
@property (nonatomic, nullable) NSString *contentMD5;
@end
@interface AWSS3TransferUtilityMultiPartUploadExpression : NSObject
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *requestParameters;
@property (copy, nonatomic, nullable) AWSS3TransferUtilityMultiPartProgressBlock progressBlock;
- (void)setValue:(nullable NSString *)value forRequestHeader:(NSString *)requestHeader;
- (void)setValue:(nullable NSString *)value forRequestParameter:(NSString *)requestParameter;
@end
@interface AWSS3TransferUtilityDownloadExpression : AWSS3TransferUtilityExpression
@end
NS_ASSUME_NONNULL_END