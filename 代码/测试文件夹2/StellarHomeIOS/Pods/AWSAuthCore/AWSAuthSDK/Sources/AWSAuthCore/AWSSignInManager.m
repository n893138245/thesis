#import "AWSSignInManager.h"
#import "AWSIdentityManager.h"
#import "AWSSignInProviderApplicationIntercept.h"
typedef void (^AWSSignInManagerCompletionBlock)(id result, NSError *error);
@interface AWSSignInManager()
@property (atomic, copy) AWSSignInManagerCompletionBlock completionHandler;
@property (nonatomic, strong) id<AWSSignInProvider> currentSignInProvider;
@property (nonatomic, strong) id<AWSSignInProvider> potentialSignInProvider;
@property (nonatomic) BOOL shouldFederate;
@property (nonatomic) BOOL pendingSignIn;
@property (strong, atomic) NSString *pendingUsername;
@property (strong, atomic) NSString *pendingPassword;
-(void)reSignInWithUsername:(NSString *)username
                   password:(NSString *)password;
-(id<AWSSignInProvider>)signInProviderForKey:(NSString *)key;
@end
@implementation AWSSignInManager
static NSMutableDictionary<NSString *, id<AWSSignInProvider>> *signInProviderInfo = nil;
static AWSIdentityManager *identityManager;
+(instancetype)sharedInstance {
    static AWSSignInManager *_sharedSignInManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSignInManager = [[AWSSignInManager alloc] init];
        _sharedSignInManager.shouldFederate = YES;
        signInProviderInfo = [[NSMutableDictionary alloc] init];
        identityManager = [AWSIdentityManager defaultIdentityManager];
    });
    return _sharedSignInManager;
}
-(void)setDontFederate {
    AWSSignInManager.sharedInstance.shouldFederate = NO;
}
-(void)reSignInWithUsername:(NSString *)username
                   password:(NSString *)password {
    AWSSignInManager.sharedInstance.pendingUsername = username;
    AWSSignInManager.sharedInstance.pendingPassword = password;
}
-(void)registerAWSSignInProvider:(id<AWSSignInProvider>)signInProvider {
    [signInProviderInfo setValue:signInProvider
                          forKey:signInProvider.identityProviderName];
}
-(id<AWSSignInProvider>)signInProviderForKey:(NSString *)key {
    return [signInProviderInfo objectForKey:key];
}
-(NSArray<NSString *>*)getRegisteredSignInProviders {
    return [signInProviderInfo allKeys];
}
- (BOOL)isLoggedIn {
    return self.currentSignInProvider.isLoggedIn || self.potentialSignInProvider.isLoggedIn;
}
- (void)wipeAll {
    [identityManager.credentialsProvider clearKeychain];
}
- (void)logoutWithCompletionHandler:(void (^)(id result, NSError *error))completionHandler {
    if ([self.currentSignInProvider isLoggedIn]) {
        [self.currentSignInProvider logout];
    }
    [self wipeAll];
    self.currentSignInProvider = nil;
    [[identityManager.credentialsProvider getIdentityId] continueWithBlock:^id _Nullable(AWSTask<NSString *> * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(task.result, task.error);
        });
        return nil;
    }];
}
- (void)loginWithSignInProviderKey:(NSString *)signInProviderKey
                 completionHandler:(void (^)(id result, NSError *error))completionHandler {
    if ([self signInProviderForKey:signInProviderKey]) {
        self.potentialSignInProvider = [self signInProviderForKey:signInProviderKey];
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"The sign in provider is not registered as an available sign in provider. Please register using `registerAWSSignInProvider:`."
                                     userInfo:nil];
    }
    self.completionHandler = completionHandler;
    [self.potentialSignInProvider login:completionHandler];
}
- (void)resumeSessionWithCompletionHandler:(void (^)(id result, NSError *error))completionHandler {
    self.completionHandler = completionHandler;
    for(NSString *key in [self getRegisteredSignInProviders]) {
        if ([[self signInProviderForKey:key] isLoggedIn]) {
            self.potentialSignInProvider = [self signInProviderForKey:key];
        }
    }
    [self.potentialSignInProvider reloadSession];
    if (self.potentialSignInProvider == nil) {
        [self completeLogin];
    }
}
- (void)completeLogin {
    if (self.potentialSignInProvider) {
        self.currentSignInProvider = self.potentialSignInProvider;
        self.potentialSignInProvider = nil;
    }
    if (!self.shouldFederate) {
        self.completionHandler(self.currentSignInProvider, nil);
    } else {
        [identityManager.credentialsProvider invalidateCachedTemporaryCredentials];
        [[identityManager.credentialsProvider credentials] continueWithBlock:^id _Nullable(AWSTask<AWSCredentials *> * _Nonnull task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate onLoginWithSignInProvider:self.currentSignInProvider
                                                  result:task.result
                                                   error:task.error];
                self.completionHandler(task.result, task.error);
            });
            return nil;
        }];
    }
}
- (BOOL)interceptApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for(NSString *key in [self getRegisteredSignInProviders]) {
        id<AWSSignInProvider> signInProvider = [self signInProviderForKey:key];
        if ([signInProvider conformsToProtocol:@protocol(AWSSignInProviderApplicationIntercept)]) {
            [(id<AWSSignInProviderApplicationIntercept>)signInProvider interceptApplication:application
                                                              didFinishLaunchingWithOptions:launchOptions];
        }
    }
    return YES;
}
- (BOOL)interceptApplication:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(NSString *)sourceApplication
                  annotation:(id)annotation {
    if (self.potentialSignInProvider) {
        if ([self.potentialSignInProvider conformsToProtocol:@protocol(AWSSignInProviderApplicationIntercept)]) {
            id<AWSSignInProviderApplicationIntercept> provider = (id<AWSSignInProviderApplicationIntercept>)self.potentialSignInProvider;
            return [provider interceptApplication:application
                                          openURL:url
                                sourceApplication:sourceApplication
                                       annotation:annotation];
        }
    }
    return YES;
}
@end