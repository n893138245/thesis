#import <UIKit/UIKit.h>
#import <ShareSDKExtension/SSERestoreScene.h>
@class SSERestoreScene;
@interface UIViewController (SSERestoreScene)
- (instancetype)initWithShareSDKScene:(SSERestoreScene *)scene;
@end