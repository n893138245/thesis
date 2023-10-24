#import <UIKit/UIKit.h>
@interface UINavigationController (FDFullscreenPopGesture)
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *fd_fullscreenPopGestureRecognizer;
@property (nonatomic, assign) BOOL fd_viewControllerBasedNavigationBarAppearanceEnabled;
@end
@interface UIViewController (FDFullscreenPopGesture)
@property (nonatomic, assign) BOOL fd_interactivePopDisabled;
@property (nonatomic, assign) BOOL fd_prefersNavigationBarHidden;
@end