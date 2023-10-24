#import <Foundation/Foundation.h>
@interface SSDKAuthViewStyle : NSObject
+ (void)setNavigationBarBackgroundImage:(UIImage *)image;
+ (void)setNavigationBarBackgroundColor:(UIColor *)color;
+ (void)setTitle:(NSString *)title;
+ (void)setTitleColor:(UIColor *)color;
+ (void)setCancelButtonLabel:(NSString *)label;
+ (void)setCancelButtonLabelColor:(UIColor *)color;
+ (void)setCancelButtonImage:(UIImage *)image;
+ (void)setCancelButtonLeftMargin:(CGFloat)margin;
+ (void)setRightButton:(UIButton *)button;
+ (void)setRightButtonRightMargin:(CGFloat)margin;
+ (void)setSupportedInterfaceOrientation:(UIInterfaceOrientationMask)toInterfaceOrientation;
+ (void)setStatusBarStyle:(UIStatusBarStyle)style;
+ (void)setShareTitle:(NSString *)shareTitle;
@end