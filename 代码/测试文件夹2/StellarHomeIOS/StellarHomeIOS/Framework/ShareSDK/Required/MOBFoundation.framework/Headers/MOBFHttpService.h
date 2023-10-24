#import <Foundation/Foundation.h>
@class MOBFHttpService;
extern NSString *const kMOBFHttpMethodGet;
extern NSString *const kMOBFHttpMethodPost;
extern NSString *const kMOBFHttpMethodDelete;
extern NSString *const kMOBFHttpMethodHead;
typedef void(^MOBFHttpResultEvent) (NSHTTPURLResponse *response, NSData *responseData);
typedef void(^MOBFHttpFaultEvent) (NSError *error);
typedef void(^MOBFHttpUploadProgressEvent) (int64_t totalBytes, int64_t loadedBytes);
typedef void(^MOBFHttpDownloadProgressEvent) (int64_t totalBytes, int64_t loadedBytes);
@interface MOBFHttpService : NSObject
@property (nonatomic, copy) NSString *method;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) BOOL isCacheResponse;
@property (nonatomic) BOOL autoFillRequestForm;
- (id)initWithURLString:(NSString *)urlString;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithRequest:(NSURLRequest *)request;
- (void)addHeader:(NSString *)header value:(NSString *)value;
- (void)addHeaders:(NSDictionary *)headers;
- (void)addParameter:(id)value forKey:(NSString *)key;
- (void)addParameters:(NSDictionary *)parameters;
- (void)addFileParameter:(NSData *)fileData
                fileName:(NSString *)fileName
                mimeType:(NSString *)mimeType
        transferEncoding:(NSString *)transferEncoding
                  forKey:(NSString *)key;
- (void)setBody:(id)body;
- (void)sendRequestOnResult:(MOBFHttpResultEvent)resultHandler
                    onFault:(MOBFHttpFaultEvent)faultHandler
           onUploadProgress:(MOBFHttpUploadProgressEvent)uploadProgressHandler;
- (void)sendRequestOnResult:(MOBFHttpResultEvent)resultHandler
                    onFault:(MOBFHttpFaultEvent)faultHandler
           onUploadProgress:(MOBFHttpUploadProgressEvent)uploadProgressHandler
         onDownloadProgress:(MOBFHttpDownloadProgressEvent)downloadProgressHandler;
- (void)cancelRequest;
+ (MOBFHttpService *)sendHttpRequestByURLString:(NSString *)urlString
                                         method:(NSString *)method
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                       onResult:(MOBFHttpResultEvent)resultHandler
                                        onFault:(MOBFHttpFaultEvent)faultHandler
                               onUploadProgress:(MOBFHttpUploadProgressEvent)uploadProgressHandler;
+ (MOBFHttpService *)sendHttpRequestByURLString:(NSString *)urlString
                                         method:(NSString *)method
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                        timeout:(NSTimeInterval)timeout
                                       onResult:(MOBFHttpResultEvent)resultHandler
                                        onFault:(MOBFHttpFaultEvent)faultHandler
                               onUploadProgress:(MOBFHttpUploadProgressEvent)uploadProgressHandler;
+ (MOBFHttpService *)sendHttpRequestByURLString:(NSString *)urlString
                                         method:(NSString *)method
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                        timeout:(NSTimeInterval)timeout
                                       onResult:(MOBFHttpResultEvent)resultHandler
                                        onFault:(MOBFHttpFaultEvent)faultHandler
                               onUploadProgress:(MOBFHttpUploadProgressEvent)uploadProgressHandler
                             onDownloadProgress:(MOBFHttpDownloadProgressEvent)downloadProgressHandler;
@end