#import <UIKit/UIKit.h>
typedef void(^MOBFSetImageBlock)(UIImage * _Nullable image, NSError * _Nullable error);
@interface UIView (MOBFWebCache)
- (void)mobf_internalSetImageWithURL:(nullable NSURL *)url
                       setImageBlock:(nullable MOBFSetImageBlock)setImageBlock;
@end