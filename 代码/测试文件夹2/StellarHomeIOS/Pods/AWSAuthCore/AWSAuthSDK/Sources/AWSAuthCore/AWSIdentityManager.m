#import "AWSIdentityManager.h"
#import "AWSSignInProvider.h"
#import "AWSSignInManager.h"
@interface AWSIdentityManager()
@property (nonatomic, readwrite, strong) AWSCognitoCredentialsProvider *credentialsProvider;
@end
@interface AWSSignInManager()
@property (nonatomic, strong) id<AWSSignInProvider> currentSignInProvider;
@property (nonatomic, strong) id<AWSSignInProvider> potentialSignInProvider;
@end
@implementation AWSIdentityManager
static NSString *const AWSInfoIdentityManager = @"IdentityManager";
static NSString *const AWSInfoRoot = @"AWS";
+ (instancetype)defaultIdentityManager {
    static AWSIdentityManager *_defaultIdentityManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AWSServiceInfo *serviceInfo = [[AWSInfo defaultAWSInfo] defaultServiceInfo:AWSInfoIdentityManager];
        if (!serviceInfo) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"The service configuration is `nil`. You need to configure `awsconfiguration.json` or `Info.plist` before using this method."
                                         userInfo:nil];
        }
        _defaultIdentityManager = [[AWSIdentityManager alloc] initWithCredentialProvider:serviceInfo];
    });
    return _defaultIdentityManager;
}
- (instancetype)initWithCredentialProvider:(AWSServiceInfo *)serviceInfo {
    if (self = [super init]) {
        self.credentialsProvider = serviceInfo.cognitoCredentialsProvider;
        [self.credentialsProvider setIdentityProviderManagerOnce:self];
    }
    return self;
}
-(AWSIdentityManagerAuthState)authState {
    if (self.identityId && AWSSignInManager.sharedInstance.currentSignInProvider) {
        return AWSIdentityManagerAuthStateAuthenticated;
    } else if (self.identityId) {
        return AWSIdentityManagerAuthStateUnauthenticated;
    }
    return AWSIdentityManagerAuthStateUnknown;
}
#pragma mark - AWSIdentityProviderManager
- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    if (![AWSSignInManager sharedInstance].currentSignInProvider) {
        return [AWSTask taskWithResult:nil];
    }
    return [[[AWSSignInManager sharedInstance].currentSignInProvider token] continueWithSuccessBlock:^id _Nullable(AWSTask<NSString *> * _Nonnull task) {
        NSString *token = task.result;
        return [AWSTask taskWithResult:@{[AWSSignInManager sharedInstance].currentSignInProvider.identityProviderName : token}];
    }];
}
#pragma mark -
- (NSString *)identityId {
    return self.credentialsProvider.identityId;
}
@end