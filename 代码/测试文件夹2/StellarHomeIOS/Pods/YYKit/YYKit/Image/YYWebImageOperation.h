#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYImageCache.h>
#import <YYKit/YYWebImageManager.h>
#else
#import "YYImageCache.h"
#import "YYWebImageManager.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface YYWebImageOperation : NSOperation
@property (nonatomic, strong, readonly)           NSURLRequest      *request;  
@property (nullable, nonatomic, strong, readonly) NSURLResponse     *response; 
@property (nullable, nonatomic, strong, readonly) YYImageCache      *cache;    
@property (nonatomic, strong, readonly)           NSString          *cacheKey; 
@property (nonatomic, readonly)                   YYWebImageOptions options;   
@property (nonatomic) BOOL shouldUseCredentialStorage;
@property (nullable, nonatomic, strong) NSURLCredential *credential;
- (instancetype)initWithRequest:(NSURLRequest *)request
                        options:(YYWebImageOptions)options
                          cache:(nullable YYImageCache *)cache
                       cacheKey:(nullable NSString *)cacheKey
                       progress:(nullable YYWebImageProgressBlock)progress
                      transform:(nullable YYWebImageTransformBlock)transform
                     completion:(nullable YYWebImageCompletionBlock)completion NS_DESIGNATED_INITIALIZER;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
@end
NS_ASSUME_NONNULL_END