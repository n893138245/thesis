#import <Foundation/Foundation.h>
#import "AWSModel.h"
FOUNDATION_EXPORT NSString *const AWSNetworkingErrorDomain;
typedef NS_ENUM(NSInteger, AWSNetworkingErrorType) {
    AWSNetworkingErrorUnknown,
    AWSNetworkingErrorCancelled,
    AWSNetworkingErrorSessionInvalid
};
typedef NS_ENUM(NSInteger, AWSNetworkingRetryType) {
    AWSNetworkingRetryTypeUnknown,
    AWSNetworkingRetryTypeShouldNotRetry,
    AWSNetworkingRetryTypeShouldRetry,
    AWSNetworkingRetryTypeShouldRefreshCredentialsAndRetry,
    AWSNetworkingRetryTypeShouldCorrectClockSkewAndRetry,
    AWSNetworkingRetryTypeResetStreamAndRetry
};
FOUNDATION_EXPORT NSString *const AWSResponseObjectErrorUserInfoKey;
@class AWSNetworkingConfiguration;
@class AWSNetworkingRequest;
@class AWSTask<__covariant ResultType>;
typedef void (^AWSNetworkingUploadProgressBlock) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^AWSNetworkingDownloadProgressBlock) (int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
#pragma mark - AWSHTTPMethod
typedef NS_ENUM(NSInteger, AWSHTTPMethod) {
    AWSHTTPMethodUnknown,
    AWSHTTPMethodGET,
    AWSHTTPMethodHEAD,
    AWSHTTPMethodPOST,
    AWSHTTPMethodPUT,
    AWSHTTPMethodPATCH,
    AWSHTTPMethodDELETE
};
@interface NSString (AWSHTTPMethod)
+ (instancetype)aws_stringWithHTTPMethod:(AWSHTTPMethod)HTTPMethod;
@end
#pragma mark - AWSNetworking
@interface AWSNetworking : NSObject
- (instancetype)initWithConfiguration:(AWSNetworkingConfiguration *)configuration;
- (AWSTask *)sendRequest:(AWSNetworkingRequest *)request;
@end
#pragma mark - Protocols
@protocol AWSURLRequestSerializer <NSObject>
@required
- (AWSTask *)validateRequest:(NSURLRequest *)request;
- (AWSTask *)serializeRequest:(NSMutableURLRequest *)request
                     headers:(NSDictionary *)headers
                  parameters:(NSDictionary *)parameters;
@end
@protocol AWSNetworkingRequestInterceptor <NSObject>
@required
- (AWSTask *)interceptRequest:(NSMutableURLRequest *)request;
@end
@protocol AWSNetworkingHTTPResponseInterceptor <NSObject>
@required
- (AWSTask *)interceptResponse:(NSHTTPURLResponse *)response
                         data:(id)data
              originalRequest:(NSURLRequest *)originalRequest
               currentRequest:(NSURLRequest *)currentRequest;
@end
@protocol AWSHTTPURLResponseSerializer <NSObject>
@required
- (BOOL)validateResponse:(NSHTTPURLResponse *)response
             fromRequest:(NSURLRequest *)request
                    data:(id)data
                   error:(NSError *__autoreleasing *)error;
- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                originalRequest:(NSURLRequest *)originalRequest
                 currentRequest:(NSURLRequest *)currentRequest
                           data:(id)data
                          error:(NSError *__autoreleasing *)error;
@end
@protocol AWSURLRequestRetryHandler <NSObject>
@required
@property (nonatomic, assign) uint32_t maxRetryCount;
- (AWSNetworkingRetryType)shouldRetry:(uint32_t)currentRetryCount
                      originalRequest:(AWSNetworkingRequest *)originalRequest
                             response:(NSHTTPURLResponse *)response
                                 data:(NSData *)data
                                error:(NSError *)error;
- (NSTimeInterval)timeIntervalForRetry:(uint32_t)currentRetryCount
                              response:(NSHTTPURLResponse *)response
                                  data:(NSData *)data
                                 error:(NSError *)error;
@optional
- (NSDictionary *)resetParameters:(NSDictionary *)parameters;
@end
#pragma mark - AWSNetworkingConfiguration
@interface AWSNetworkingConfiguration : NSObject <NSCopying>
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, assign) AWSHTTPMethod HTTPMethod;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, assign) BOOL allowsCellularAccess;
@property (nonatomic, strong) NSString *sharedContainerIdentifier;
@property (nonatomic, strong) id<AWSURLRequestSerializer> requestSerializer;
@property (nonatomic, strong) NSArray<id<AWSNetworkingRequestInterceptor>> *requestInterceptors;
@property (nonatomic, strong) id<AWSHTTPURLResponseSerializer> responseSerializer;
@property (nonatomic, strong) NSArray<id<AWSNetworkingHTTPResponseInterceptor>> *responseInterceptors;
@property (nonatomic, strong) id<AWSURLRequestRetryHandler> retryHandler;
@property (nonatomic, assign) uint32_t maxRetryCount;
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest;
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForResource;
@end
#pragma mark - AWSNetworkingRequest
@interface AWSNetworkingRequest : AWSNetworkingConfiguration
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSURL *uploadingFileURL;
@property (nonatomic, strong) NSURL *downloadingFileURL;
@property (nonatomic, assign) BOOL shouldWriteDirectly;
@property (nonatomic, copy) AWSNetworkingUploadProgressBlock uploadProgress;
@property (nonatomic, copy) AWSNetworkingDownloadProgressBlock downloadProgress;
@property (readonly, nonatomic, strong) NSURLSessionTask *task;
@property (readonly, nonatomic, assign, getter = isCancelled) BOOL cancelled;
- (void)assignProperties:(AWSNetworkingConfiguration *)configuration;
- (void)cancel;
- (void)pause;
@end
@interface AWSRequest : AWSModel
@property (nonatomic, copy) AWSNetworkingUploadProgressBlock uploadProgress;
@property (nonatomic, copy) AWSNetworkingDownloadProgressBlock downloadProgress;
@property (nonatomic, assign, readonly, getter = isCancelled) BOOL cancelled;
@property (nonatomic, strong) NSURL *downloadingFileURL;
- (AWSTask *)cancel;
- (AWSTask *)pause;
@end
@interface AWSNetworkingRequestInterceptor : NSObject <AWSNetworkingRequestInterceptor>
@property (nonatomic, readonly) NSString *userAgent;
- (instancetype)initWithUserAgent:(NSString *)userAgent;
@end