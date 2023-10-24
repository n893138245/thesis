#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYImageCache.h>
#else
#import "YYImageCache.h"
#endif
@class YYWebImageOperation;
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, YYWebImageOptions) {
    YYWebImageOptionShowNetworkActivity = 1 << 0,
    YYWebImageOptionProgressive = 1 << 1,
    YYWebImageOptionProgressiveBlur = 1 << 2,
    YYWebImageOptionUseNSURLCache = 1 << 3,
    YYWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
    YYWebImageOptionAllowBackgroundTask = 1 << 5,
    YYWebImageOptionHandleCookies = 1 << 6,
    YYWebImageOptionRefreshImageCache = 1 << 7,
    YYWebImageOptionIgnoreDiskCache = 1 << 8,
    YYWebImageOptionIgnorePlaceHolder = 1 << 9,
    YYWebImageOptionIgnoreImageDecoding = 1 << 10,
    YYWebImageOptionIgnoreAnimatedImage = 1 << 11,
    YYWebImageOptionSetImageWithFadeAnimation = 1 << 12,
    YYWebImageOptionAvoidSetImage = 1 << 13,
    YYWebImageOptionIgnoreFailedURL = 1 << 14,
};
typedef NS_ENUM(NSUInteger, YYWebImageFromType) {
    YYWebImageFromNone = 0,
    YYWebImageFromMemoryCacheFast,
    YYWebImageFromMemoryCache,
    YYWebImageFromDiskCache,
    YYWebImageFromRemote,
};
typedef NS_ENUM(NSInteger, YYWebImageStage) {
    YYWebImageStageProgress  = -1,
    YYWebImageStageCancelled = 0,
    YYWebImageStageFinished  = 1,
};
typedef void(^YYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef UIImage * _Nullable (^YYWebImageTransformBlock)(UIImage *image, NSURL *url);
typedef void (^YYWebImageCompletionBlock)(UIImage * _Nullable image,
                                          NSURL *url,
                                          YYWebImageFromType from,
                                          YYWebImageStage stage,
                                          NSError * _Nullable error);
@interface YYWebImageManager : NSObject
+ (instancetype)sharedManager;
- (instancetype)initWithCache:(nullable YYImageCache *)cache
                        queue:(nullable NSOperationQueue *)queue NS_DESIGNATED_INITIALIZER;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (nullable YYWebImageOperation *)requestImageWithURL:(NSURL *)url
                                              options:(YYWebImageOptions)options
                                             progress:(nullable YYWebImageProgressBlock)progress
                                            transform:(nullable YYWebImageTransformBlock)transform
                                           completion:(nullable YYWebImageCompletionBlock)completion;
@property (nullable, nonatomic, strong) YYImageCache *cache;
@property (nullable, nonatomic, strong) NSOperationQueue *queue;
@property (nullable, nonatomic, copy) YYWebImageTransformBlock sharedTransformBlock;
@property (nonatomic) NSTimeInterval timeout;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSDictionary<NSString *, NSString *> *headers;
@property (nullable, nonatomic, copy) NSDictionary<NSString *, NSString *> *(^headersFilter)(NSURL *url, NSDictionary<NSString *, NSString *> * _Nullable header);
@property (nullable, nonatomic, copy) NSString *(^cacheKeyFilter)(NSURL *url);
- (nullable NSDictionary<NSString *, NSString *> *)headersForURL:(NSURL *)url;
- (NSString *)cacheKeyForURL:(NSURL *)url;
@end
NS_ASSUME_NONNULL_END