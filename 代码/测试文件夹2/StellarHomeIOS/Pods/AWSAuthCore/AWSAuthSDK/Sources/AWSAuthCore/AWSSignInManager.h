#import <Foundation/Foundation.h>
#import "AWSSignInProvider.h"
NS_ASSUME_NONNULL_BEGIN
@protocol AWSSignInDelegate <NSObject>
- (void)onLoginWithSignInProvider:(id<AWSSignInProvider>)signInProvider
                           result:(id _Nullable)result
                            error:(NSError * _Nullable)error NS_SWIFT_NAME(onLogin(signInProvider:result:error:));
@end
@interface AWSSignInManager : NSObject
@property (nonatomic, readonly, getter=isLoggedIn) BOOL loggedIn;
@property (nonatomic, weak) id<AWSSignInDelegate> delegate;
+(instancetype)sharedInstance;
-(void)registerAWSSignInProvider:(id<AWSSignInProvider>)signInProvider NS_SWIFT_NAME(register(signInProvider:));
- (void)logoutWithCompletionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;
- (void)loginWithSignInProviderKey:(NSString *)signInProviderKey
                 completionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler NS_SWIFT_NAME(login(signInProviderKey:completionHandler:));
- (void)resumeSessionWithCompletionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;
- (BOOL)interceptApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (BOOL)interceptApplication:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(nullable NSString *)sourceApplication
                  annotation:(id)annotation;
@end
NS_ASSUME_NONNULL_END