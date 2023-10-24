#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MOBFViewController : NSObject
+ (UIViewController *)currentViewController;
+ (UIViewController *)currentViewControllerFromWindow:(UIWindow *)window;
@end