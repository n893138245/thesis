#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface UIButton (YYWebImage)
#pragma mark - image
- (nullable NSURL *)imageURLForState:(UIControlState)state;
- (void)setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder;
- (void)setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
                   options:(YYWebImageOptions)options;
- (void)setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;
- (void)cancelImageRequestForState:(UIControlState)state;
#pragma mark - background image
- (nullable NSURL *)backgroundImageURLForState:(UIControlState)state;
- (void)setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder;
- (void)setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                             options:(YYWebImageOptions)options;
- (void)setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                          completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion;
- (void)setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                             manager:(nullable YYWebImageManager *)manager
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion;
- (void)cancelBackgroundImageRequestForState:(UIControlState)state;
@end
NS_ASSUME_NONNULL_END