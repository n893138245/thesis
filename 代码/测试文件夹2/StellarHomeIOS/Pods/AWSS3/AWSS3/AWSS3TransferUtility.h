#import <UIKit/UIKit.h>
#import <AWSCore/AWSCore.h>
#import "AWSS3Service.h"
#import "AWSS3TransferUtilityTasks.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSS3TransferUtilityErrorDomain;
typedef NS_ENUM(NSInteger, AWSS3TransferUtilityErrorType) {
    AWSS3TransferUtilityErrorUnknown,
    AWSS3TransferUtilityErrorRedirection,
    AWSS3TransferUtilityErrorClientError,
    AWSS3TransferUtilityErrorServerError,
    AWSS3TransferUtilityErrorLocalFileNotFound
};
FOUNDATION_EXPORT NSString *const AWSS3TransferUtilityURLSessionDidBecomeInvalidNotification;
@class AWSS3TransferUtilityConfiguration;
@class AWSS3TransferUtilityTask;
@class AWSS3TransferUtilityUploadTask;
@class AWSS3TransferUtilityMultiPartUploadTask;
@class AWSS3TransferUtilityDownloadTask;
@class AWSS3TransferUtilityExpression;
@class AWSS3TransferUtilityUploadExpression;
@class AWSS3TransferUtilityMultiPartUploadExpression;
@class AWSS3TransferUtilityDownloadExpression;
#pragma mark - AWSS3TransferUtility
@interface AWSS3TransferUtility : AWSService
@property (readonly) AWSServiceConfiguration *configuration;
+ (instancetype)defaultS3TransferUtility;
+ (instancetype)defaultS3TransferUtility:(nullable void (^)(NSError *_Nullable error)) completionHandler
  NS_SWIFT_NAME(default(completionHandler:));
+ (void)registerS3TransferUtilityWithConfiguration:(AWSServiceConfiguration *)configuration
                                            forKey:(NSString *)key;
+ (void)registerS3TransferUtilityWithConfiguration:(AWSServiceConfiguration *)configuration
                                            forKey:(NSString *)key
                                 completionHandler:(nullable void (^)(NSError *_Nullable error)) completionHandler;
+ (void)registerS3TransferUtilityWithConfiguration:(AWSServiceConfiguration *)configuration
                      transferUtilityConfiguration:(nullable AWSS3TransferUtilityConfiguration *)transferUtilityConfiguration
                                            forKey:(NSString *)key;
+ (void)registerS3TransferUtilityWithConfiguration:(AWSServiceConfiguration *)configuration
                      transferUtilityConfiguration:(nullable AWSS3TransferUtilityConfiguration *)transferUtilityConfiguration
                                            forKey:(NSString *)key
                                 completionHandler:(nullable void (^)(NSError *_Nullable error)) completionHandler;
+ (nullable instancetype)S3TransferUtilityForKey:(NSString *)key;
+ (void)removeS3TransferUtilityForKey:(NSString *)key;
+ (void)interceptApplication:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
           completionHandler:(void (^)(void))completionHandler;
- (AWSTask<AWSS3TransferUtilityUploadTask *> *)uploadData:(NSData *)data
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityUploadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityUploadTask *> *)uploadData:(NSData *)data
                                                   bucket:(NSString *)bucket
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityUploadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityUploadTask *> *)uploadFile:(NSURL *)fileURL
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityUploadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityUploadTask *> *)uploadFile:(NSURL *)fileURL
                                                   bucket:(NSString *)bucket
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityUploadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityMultiPartUploadTask *> *)uploadDataUsingMultiPart:(NSData *)data
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityMultiPartUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock)completionHandler
                                        NS_SWIFT_NAME(uploadUsingMultiPart(data:key:contentType:expression:completionHandler:));
- (AWSTask<AWSS3TransferUtilityMultiPartUploadTask *> *)uploadDataUsingMultiPart:(NSData *)data
                                                   bucket:(NSString *)bucket
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityMultiPartUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock)completionHandler
                                        NS_SWIFT_NAME(uploadUsingMultiPart(data:bucket:key:contentType:expression:completionHandler:));
- (AWSTask<AWSS3TransferUtilityMultiPartUploadTask *> *)uploadFileUsingMultiPart:(NSURL *)fileURL
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityMultiPartUploadExpression *)expression
                                            completionHandler:(nullable AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock)completionHandler
                                        NS_SWIFT_NAME(uploadUsingMultiPart(fileURL:key:contentType:expression:completionHandler:));
- (AWSTask<AWSS3TransferUtilityMultiPartUploadTask *> *)uploadFileUsingMultiPart:(NSURL *)fileURL
                                                   bucket:(NSString *)bucket
                                                      key:(NSString *)key
                                              contentType:(NSString *)contentType
                                               expression:(nullable AWSS3TransferUtilityMultiPartUploadExpression *)expression
                                        completionHandler:(nullable AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock)completionHandler
                                        NS_SWIFT_NAME(uploadUsingMultiPart(fileURL:bucket:key:contentType:expression:completionHandler:));
- (AWSTask<AWSS3TransferUtilityDownloadTask *> *)downloadDataForKey:(NSString *)key
                                                         expression:(nullable AWSS3TransferUtilityDownloadExpression *)expression
                                                  completionHandler:(nullable AWSS3TransferUtilityDownloadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityDownloadTask *> *)downloadDataFromBucket:(NSString *)bucket
                                                                    key:(NSString *)key
                                                             expression:(nullable AWSS3TransferUtilityDownloadExpression *)expression
                                                      completionHandler:(nullable AWSS3TransferUtilityDownloadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityDownloadTask *> *)downloadToURL:(NSURL *)fileURL
                                                           key:(NSString *)key
                                                    expression:(nullable AWSS3TransferUtilityDownloadExpression *)expression
                                             completionHandler:(nullable AWSS3TransferUtilityDownloadCompletionHandlerBlock)completionHandler;
- (AWSTask<AWSS3TransferUtilityDownloadTask *> *)downloadToURL:(NSURL *)fileURL
                                                        bucket:(NSString *)bucket
                                                           key:(NSString *)key
                                                    expression:(nullable AWSS3TransferUtilityDownloadExpression *)expression
                                             completionHandler:(nullable AWSS3TransferUtilityDownloadCompletionHandlerBlock)completionHandler;
- (void)enumerateToAssignBlocksForUploadTask:(nullable void (^)(AWSS3TransferUtilityUploadTask *uploadTask,
                                                                _Nullable AWSS3TransferUtilityProgressBlock * _Nullable uploadProgressBlockReference,
                                                                _Nullable AWSS3TransferUtilityUploadCompletionHandlerBlock * _Nullable completionHandlerReference))uploadBlocksAssigner
                                downloadTask:(nullable void (^)(AWSS3TransferUtilityDownloadTask *downloadTask,
                                                                _Nullable AWSS3TransferUtilityProgressBlock * _Nullable downloadProgressBlockReference,
                                                                _Nullable AWSS3TransferUtilityDownloadCompletionHandlerBlock * _Nullable completionHandlerReference))downloadBlocksAssigner;
-(void)enumerateToAssignBlocksForUploadTask:(void (^)(AWSS3TransferUtilityUploadTask *uploadTask,
                                                      AWSS3TransferUtilityProgressBlock _Nullable * _Nullable uploadProgressBlockReference,
                                                      AWSS3TransferUtilityUploadCompletionHandlerBlock _Nullable * _Nullable completionHandlerReference))uploadBlocksAssigner
              multiPartUploadBlocksAssigner: (void (^) (AWSS3TransferUtilityMultiPartUploadTask *multiPartUploadTask,
                                                        AWSS3TransferUtilityMultiPartProgressBlock _Nullable * _Nullable multiPartUploadProgressBlockReference,
                                                        AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock _Nullable * _Nullable completionHandlerReference)) multiPartUploadBlocksAssigner
                     downloadBlocksAssigner:(void (^)(AWSS3TransferUtilityDownloadTask *downloadTask,
                                                      AWSS3TransferUtilityProgressBlock _Nullable * _Nullable downloadProgressBlockReference,
                                                      AWSS3TransferUtilityDownloadCompletionHandlerBlock _Nullable * _Nullable completionHandlerReference))downloadBlocksAssigner;
- (AWSTask<NSArray<__kindof AWSS3TransferUtilityTask *> *> *)getAllTasks __attribute((deprecated));
- (AWSTask<NSArray<AWSS3TransferUtilityUploadTask *> *> *)getUploadTasks;
- (AWSTask<NSArray<AWSS3TransferUtilityMultiPartUploadTask *> *> *)getMultiPartUploadTasks;
- (AWSTask<NSArray<AWSS3TransferUtilityDownloadTask *> *> *)getDownloadTasks;
@end
#pragma mark - AWSS3TransferUtilityConfiguration
@interface AWSS3TransferUtilityConfiguration : NSObject <NSCopying>
@property (nonatomic, assign, getter=isAccelerateModeEnabled) BOOL accelerateModeEnabled;
@property (nonatomic, nullable, copy) NSString *bucket;
@property NSInteger retryLimit;
@property (nonatomic, nullable) NSNumber *multiPartConcurrencyLimit;
@property NSInteger timeoutIntervalForResource;
@end
NS_ASSUME_NONNULL_END