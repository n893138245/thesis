#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AWSAuthCore/AWSAuthCore.h>
NS_ASSUME_NONNULL_BEGIN
@class SignInUIOptions;
@interface AWSSignInProviderConfig : NSObject
@property (nonatomic) Class<AWSSignInProvider> signInProviderClass;
@property (nonatomic) NSArray<NSString *> *permissions;
@end
@interface _AWSMobileClient : AWSCognitoCredentialsProvider
+ (instancetype)sharedInstance;
- (instancetype)initWithConfiguration:(NSDictionary<NSString *, id> *)config;
- (BOOL)interceptApplication:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(nullable NSString *)sourceApplication
                  annotation:(id)annotation;
- (BOOL)interceptApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
resumeSessionWithCompletionHandler:(void (^)(id result, NSError *error))completionHandler;
- (BOOL)interceptApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (void)setSignInProviders:(nullable NSArray<AWSSignInProviderConfig *> *)signInProviderConfig;
-(void)showSignInScreen:(UINavigationController *)navController
  signInUIConfiguration:(SignInUIOptions *)signInUIConfiguration
      completionHandler:(void (^)(NSString * _Nullable signInProviderKey, NSString * _Nullable signInProviderToken, NSError * _Nullable error))completionHandler;
- (void)setCredentialsProvider:(AWSCognitoCredentialsProvider *)credentialsProvider;
- (AWSCognitoCredentialsProvider *)getCredentialsProvider;
@property (nonatomic, readonly, getter=isLoggedIn) BOOL loggedIn;
- (void)updateCognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCreds;
- (void)registerConfigSignInProviders;
- (void)setCustomRoleArnInternal:(NSString * _Nullable)customRoleArnInternal
                             for:(AWSCognitoCredentialsProvider *)credsProvider;
@end
NS_ASSUME_NONNULL_END