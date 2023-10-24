#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface UIImageView (YYWebImage)
#pragma mark - image
@property (nullable, nonatomic, strong) NSURL *imageURL;
- (void)setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;
- (void)setImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;
- (void)cancelCurrentImageRequest;
#pragma mark - highlight image
@property (nullable, nonatomic, strong) NSURL *highlightedImageURL;
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                           completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                             progress:(nullable YYWebImageProgressBlock)progress
                            transform:(nullable YYWebImageTransformBlock)transform
                           completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                              manager:(nullable YYWebImageManager *)manager
                             progress:(nullable YYWebImageProgressBlock)progress
                            transform:(nullable YYWebImageTransformBlock)transform
                           completion:(nullable YYWebImageCompletionBlock)completion;
- (void)cancelCurrentHighlightedImageRequest;
@end
NS_ASSUME_NONNULL_END