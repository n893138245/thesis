#import <UIKit/UIKit.h>
@interface UIImageView (MOBFWebCache)
- (void)mobf_setImageWithURL:(nullable NSURL *)url;
- (void)mobf_setImageWithURL:(nullable NSURL *)url
            placeholderImage:(nullable UIImage *)placeholder;
@end