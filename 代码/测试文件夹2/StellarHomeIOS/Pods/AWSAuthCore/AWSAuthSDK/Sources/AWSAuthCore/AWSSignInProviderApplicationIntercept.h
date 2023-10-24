#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol  AWSSignInProviderApplicationIntercept <NSObject>
- (BOOL)interceptApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (BOOL)interceptApplication:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(nullable NSString *)sourceApplication
                  annotation:(id)annotation;
@end
NS_ASSUME_NONNULL_END