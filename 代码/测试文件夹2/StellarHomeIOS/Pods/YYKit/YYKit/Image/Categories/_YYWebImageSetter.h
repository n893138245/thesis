#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif
NS_ASSUME_NONNULL_BEGIN
extern NSString *const _YYWebImageFadeAnimationKey;
extern const NSTimeInterval _YYWebImageFadeTime;
extern const NSTimeInterval _YYWebImageProgressiveFadeTime;
@interface _YYWebImageSetter : NSObject
@property (nullable, nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) int32_t sentinel;
- (int32_t)setOperationWithSentinel:(int32_t)sentinel
                                url:(nullable NSURL *)imageURL
                            options:(YYWebImageOptions)options
                            manager:(YYWebImageManager *)manager
                           progress:(nullable YYWebImageProgressBlock)progress
                          transform:(nullable YYWebImageTransformBlock)transform
                         completion:(nullable YYWebImageCompletionBlock)completion;
- (int32_t)cancel;
- (int32_t)cancelWithNewURL:(nullable NSURL *)imageURL;
+ (dispatch_queue_t)setterQueue;
@end
NS_ASSUME_NONNULL_END