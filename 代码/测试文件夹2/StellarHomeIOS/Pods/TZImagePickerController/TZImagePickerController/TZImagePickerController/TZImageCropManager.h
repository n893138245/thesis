#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TZImageCropManager : NSObject
+ (void)overlayClippingWithView:(UIView *)view cropRect:(CGRect)cropRect containerView:(UIView *)containerView needCircleCrop:(BOOL)needCircleCrop;
+ (UIImage *)cropImageView:(UIImageView *)imageView toRect:(CGRect)rect zoomScale:(double)zoomScale containerView:(UIView *)containerView;
+ (UIImage *)circularClipImage:(UIImage *)image;
@end
@interface UIImage (TZGif)
+ (UIImage *)sd_tz_animatedGIFWithData:(NSData *)data;
@end