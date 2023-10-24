#import "AWSCredentialsProvider.h"
#import "AWSCognitoIdentity.h"
#import "AWSSTS.h"
#import "AWSUICKeyChainStore.h"
#import "AWSCocoaLumberjack.h"
#import "AWSBolts.h"
NSString *const AWSCognitoCredentialsProviderErrorDomain = @"com.amazonaws.AWSCognitoCredentialsProviderErrorDomain";
static NSString *const AWSCredentialsProviderKeychainAccessKeyId = @"accessKey";
static NSString *const AWSCredentialsProviderKeychainSecretAccessKey = @"secretKey";
static NSString *const AWSCredentialsProviderKeychainSessionToken = @"sessionKey";
static NSString *const AWSCredentialsProviderKeychainExpiration = @"expiration";
static NSString *const AWSCredentialsProviderKeychainIdentityId = @"identityId";
@interface AWSCognitoIdentity()
- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
@end
@interface AWSSTS()
- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
@end
@interface AWSAbstractCognitoCredentialsProviderHelper()
@property (nonatomic, strong) id<AWSIdentityProviderManager> identityProviderManager;
@end
@interface AWSCredentials()
- (nullable instancetype)initFromKeychain:(nonnull AWSUICKeyChainStore *)keychain;
@end
@implementation AWSCredentials
- (nullable instancetype)initFromKeychain:(nonnull AWSUICKeyChainStore *)keychain {
    if (self = [super init]) {
        if (keychain[AWSCredentialsProviderKeychainAccessKeyId]
            && keychain[AWSCredentialsProviderKeychainSecretAccessKey]) {
            AWSDDLogVerbose(@"Retrieving credentials from keychain");
            _accessKey = keychain[AWSCredentialsProviderKeychainAccessKeyId];
            _secretKey = keychain[AWSCredentialsProviderKeychainSecretAccessKey];
            _sessionKey = keychain[AWSCredentialsProviderKeychainSessionToken];
            NSString *expirationString = keychain[AWSCredentialsProviderKeychainExpiration];
            if (expirationString) {
                _expiration = [NSDate dateWithTimeIntervalSince1970:[expirationString doubleValue]];
            }
        }
    }
    return self;
}
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey
                       sessionKey:(NSString *)sessionKey
                       expiration:(NSDate *)expiration {
    if (self = [super init]) {
        _accessKey = accessKey;
        _secretKey = secretKey;
        _sessionKey = sessionKey;
        _expiration = expiration;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"{\nAWSCredentials\nAccessKey: %@\nSecretKey: %@\nSessionKey: %@\nExpiration: %@\n}",
            self.accessKey,
            self.secretKey,
            self.sessionKey,
            self.expiration];
}
@end
@interface AWSStaticCredentialsProvider()
@property (nonatomic, strong) AWSCredentials *internalCredentials;
@end
@implementation AWSStaticCredentialsProvider
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey {
    if (self = [super init]) {
        _internalCredentials = [[AWSCredentials alloc] initWithAccessKey:accessKey
                                                               secretKey:secretKey
                                                              sessionKey:nil
                                                              expiration:nil];
    }
    return self;
}
- (AWSTask<AWSCredentials *> *)credentials {
    return [AWSTask taskWithResult:self.internalCredentials];
}
- (void)invalidateCachedTemporaryCredentials {
}
@end
@interface AWSBasicSessionCredentialsProvider()
@property (nonatomic, strong) AWSCredentials *internalCredentials;
@end
@implementation AWSBasicSessionCredentialsProvider
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey
                     sessionToken:(NSString *)sessionToken {
    if (self = [super init]) {
        _internalCredentials = [[AWSCredentials alloc] initWithAccessKey:accessKey
                                                               secretKey:secretKey
                                                              sessionKey:sessionToken
                                                              expiration:nil];
    }
    return self;
}
- (AWSTask<AWSCredentials *> *)credentials {
    return [AWSTask taskWithResult:self.internalCredentials];
}
- (void)invalidateCachedTemporaryCredentials {
}
@end
@implementation AWSAnonymousCredentialsProvider
- (AWSTask<AWSCredentials *> *)credentials {
    return [AWSTask taskWithResult:nil];
}
- (void)invalidateCachedTemporaryCredentials {
}
@end
@interface AWSWebIdentityCredentialsProvider()
@property (nonatomic, strong) AWSSTS *sts;
@property (nonatomic, strong) AWSUICKeyChainStore *keychain;
@property (nonatomic, strong) AWSCredentials *internalCredentials;
@end
@implementation AWSWebIdentityCredentialsProvider
@synthesize internalCredentials = _internalCredentials;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                        providerId:(NSString *)providerId
                           roleArn:(NSString *)roleArn
                   roleSessionName:(NSString *)roleSessionName
                  webIdentityToken:(NSString *)webIdentityToken {
    if (self = [super init]) {
        _keychain = [AWSUICKeyChainStore keyChainStoreWithService:[NSString stringWithFormat:@"%@.%@.%@", providerId, webIdentityToken, roleArn]];
        _providerId = providerId;
        _roleArn = roleArn;
        _roleSessionName = roleSessionName;
        _webIdentityToken = webIdentityToken;
        AWSAnonymousCredentialsProvider *credentialsProvider = [AWSAnonymousCredentialsProvider new];
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:regionType
                                                                             credentialsProvider:credentialsProvider];
        _sts = [[AWSSTS alloc] initWithConfiguration:configuration];
        _internalCredentials = [[AWSCredentials alloc] initFromKeychain:self.keychain];
    }
    return self;
}
#pragma mark - AWSCredentialsProvider methods
- (AWSTask<AWSCredentials *> *)credentials {
    if (self.internalCredentials.accessKey
        && self.internalCredentials.secretKey
        && [self.internalCredentials.expiration compare:[NSDate dateWithTimeIntervalSinceNow:10 * 60]] == NSOrderedDescending) {
        return [AWSTask taskWithResult:self.internalCredentials];
    }
    AWSSTSAssumeRoleWithWebIdentityRequest *webIdentityRequest = [AWSSTSAssumeRoleWithWebIdentityRequest new];
    webIdentityRequest.providerId = self.providerId;
    webIdentityRequest.roleArn = self.roleArn;
    webIdentityRequest.roleSessionName = self.roleSessionName;
    webIdentityRequest.webIdentityToken = self.webIdentityToken;
    return [[self.sts assumeRoleWithWebIdentity:webIdentityRequest] continueWithBlock:^id _Nullable(AWSTask<AWSSTSAssumeRoleWithWebIdentityResponse *> * _Nonnull task) {
        if (task.result) {
            AWSSTSAssumeRoleWithWebIdentityResponse *wifResponse = task.result;
            self.internalCredentials = [[AWSCredentials alloc] initWithAccessKey:wifResponse.credentials.accessKeyId
                                                                       secretKey:wifResponse.credentials.secretAccessKey
                                                                      sessionKey:wifResponse.credentials.sessionToken
                                                                      expiration:wifResponse.credentials.expiration];
            return [AWSTask taskWithResult:self.internalCredentials];
        } else {
            [self invalidateCachedTemporaryCredentials];
        }
        return task;
    }];
}
- (void)invalidateCachedTemporaryCredentials {
    self.internalCredentials = nil;
}
#pragma mark -
- (AWSCredentials *)internalCredentials {
    if (! _internalCredentials) {
        _internalCredentials = [[AWSCredentials alloc] initFromKeychain:self.keychain];
    }
    return _internalCredentials;
}
- (void)setInternalCredentials:(AWSCredentials *)internalCredentials {
    _internalCredentials = internalCredentials;
    self.keychain[AWSCredentialsProviderKeychainAccessKeyId] = internalCredentials.accessKey;
    self.keychain[AWSCredentialsProviderKeychainSecretAccessKey] = internalCredentials.secretKey;
    self.keychain[AWSCredentialsProviderKeychainSessionToken] = internalCredentials.sessionKey;
    if (internalCredentials.expiration) {
        self.keychain[AWSCredentialsProviderKeychainExpiration] = [NSString stringWithFormat:@"%f", [internalCredentials.expiration timeIntervalSince1970]];
    } else {
        self.keychain[AWSCredentialsProviderKeychainExpiration] = nil;
    }
}
@end
@interface AWSCognitoCredentialsProvider()
@property (nonatomic, strong) NSString *authRoleArn;
@property (nonatomic, strong) NSString *unAuthRoleArn;
@property (nonatomic, strong) AWSSTS *sts;
@property (nonatomic, strong) AWSCognitoIdentity *cognitoIdentity;
@property (nonatomic, strong) AWSUICKeyChainStore *keychain;
@property (nonatomic, strong) AWSExecutor *refreshExecutor;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (atomic, assign) BOOL useEnhancedFlow;
@property (nonatomic, strong) AWSCredentials *internalCredentials;
@property (atomic, assign, getter=isRefreshingCredentials) BOOL refreshingCredentials;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *cachedLogins;
@property (nonatomic, strong) NSString *customRoleArnOverride;
- (AWSTask<AWSCredentials *> *)credentialsWithCancellationToken:(AWSCancellationTokenSource * _Nullable)cancellationTokenSource;
@end
@implementation AWSCognitoCredentialsProvider
@synthesize internalCredentials = _internalCredentials;
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
         identityPoolConfiguration:(AWSServiceConfiguration *)configuration {
    if (self = [super init]) {
        AWSCognitoCredentialsProviderHelper *identityProvider = [[AWSCognitoCredentialsProviderHelper alloc] initWithRegionType:regionType
                                                                                                                 identityPoolId:identityPoolId
                                                                                                                useEnhancedFlow:YES
                                                                                                        identityProviderManager:nil
                                                                                                      identityPoolConfiguration:configuration];
        [self setUpWithRegionType:regionType
                 identityProvider:identityProvider
                    unauthRoleArn:nil
                      authRoleArn:nil
        identityPoolConfiguration:configuration];
    }
    return self;
}
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId {
    AWSAnonymousCredentialsProvider *credentialsProvider = [AWSAnonymousCredentialsProvider new];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:regionType
                                                                         credentialsProvider:credentialsProvider];
    return [self initWithRegionType:regionType identityPoolId:identityPoolId identityPoolConfiguration:configuration];
}
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
           identityProviderManager:(nullable id<AWSIdentityProviderManager>)identityProviderManager {
    if (self = [super init]) {
        AWSCognitoCredentialsProviderHelper *identityProvider = [[AWSCognitoCredentialsProviderHelper alloc] initWithRegionType:regionType
                                                                                                                 identityPoolId:identityPoolId
                                                                                                                useEnhancedFlow:YES
                                                                                                        identityProviderManager:identityProviderManager];
        [self setUpWithRegionType:regionType
                 identityProvider:identityProvider
                    unauthRoleArn:nil
                      authRoleArn:nil];
    }
    return self;
}
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                  identityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider {
    if (self = [super init]) {
        [self setUpWithRegionType:regionType
                 identityProvider:identityProvider
                    unauthRoleArn:nil
                      authRoleArn:nil];
    }
    return self;
}
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                     unauthRoleArn:(NSString *)unauthRoleArn
                       authRoleArn:(NSString *)authRoleArn
                  identityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider {
    if (self = [super init]) {
        [self setUpWithRegionType:regionType
                 identityProvider:identityProvider
                    unauthRoleArn:unauthRoleArn
                      authRoleArn:authRoleArn];
    }
    return self;
}
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                     unauthRoleArn:(nullable NSString *)unauthRoleArn
                       authRoleArn:(nullable NSString *)authRoleArn
           identityProviderManager:(nullable id<AWSIdentityProviderManager>)identityProviderManager {
    if (self = [super init]) {
        AWSCognitoCredentialsProviderHelper *identityProvider = [[AWSCognitoCredentialsProviderHelper alloc] initWithRegionType:regionType
                                                                                                                 identityPoolId:identityPoolId
                                                                                                                useEnhancedFlow:NO
                                                                                                        identityProviderManager:identityProviderManager];
        [self setUpWithRegionType:regionType
                 identityProvider:identityProvider
                    unauthRoleArn:unauthRoleArn
                      authRoleArn:authRoleArn];
    }
    return self;
}
- (void)setUpWithRegionType:(AWSRegionType)regionType
           identityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider
              unauthRoleArn:(NSString *)unauthRoleArn
                authRoleArn:(NSString *)authRoleArn
  identityPoolConfiguration:(AWSServiceConfiguration *)configuration {
    _refreshExecutor = [AWSExecutor executorWithOperationQueue:[NSOperationQueue new]];
    _refreshingCredentials = NO;
    _semaphore = dispatch_semaphore_create(0);
    _identityProvider = identityProvider;
    _unAuthRoleArn = unauthRoleArn;
    _authRoleArn = authRoleArn;
    _useEnhancedFlow = !unauthRoleArn && !authRoleArn;
    _keychain = [AWSUICKeyChainStore keyChainStoreWithService:[NSString stringWithFormat:@"%@.%@.%@", [NSBundle mainBundle].bundleIdentifier, [AWSCognitoCredentialsProvider class], identityProvider.identityPoolId]];
    if (identityProvider.identityId) {
        _keychain[AWSCredentialsProviderKeychainIdentityId] = identityProvider.identityId;
    }
    else {
        identityProvider.identityId = _keychain[AWSCredentialsProviderKeychainIdentityId];
    }
    _cognitoIdentity = [[AWSCognitoIdentity alloc] initWithConfiguration:configuration];
    _customRoleArnOverride = nil;
    if (!_useEnhancedFlow) {
        _sts = [[AWSSTS alloc] initWithConfiguration:configuration];
    }
    _internalCredentials = [[AWSCredentials alloc] initFromKeychain:self.keychain];
}
- (void)setUpWithRegionType:(AWSRegionType)regionType
           identityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider
              unauthRoleArn:(NSString *)unauthRoleArn
                authRoleArn:(NSString *)authRoleArn {
    AWSAnonymousCredentialsProvider *credentialsProvider = [AWSAnonymousCredentialsProvider new];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:regionType
                                                                         credentialsProvider:credentialsProvider];
    [self setUpWithRegionType:regionType
             identityProvider:identityProvider
                unauthRoleArn:unauthRoleArn
                  authRoleArn:authRoleArn
    identityPoolConfiguration:configuration];
}
- (AWSTask<AWSCredentials *> *)getCredentialsWithSTS:(NSDictionary<NSString *,NSString *> *)logins
                                       authenticated:(BOOL)auth
                               withCancellationToken:(AWSCancellationTokenSource *)cancellationTokenSource {
    if (cancellationTokenSource.isCancellationRequested) {
        return [AWSTask cancelledTask];
    }
    NSString *roleArn = self.unAuthRoleArn;
    if (auth) {
        roleArn = self.authRoleArn;
    }
    if (!roleArn) {
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderErrorDomain
                                                          code:AWSCognitoCredentialsProviderInvalidConfiguration
                                                      userInfo:@{NSLocalizedDescriptionKey: @"Required role ARN is nil"}]];
    }
    if (![logins objectForKey:AWSIdentityProviderAmazonCognitoIdentity]) {
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderErrorDomain
                                                          code:AWSCognitoCredentialsProviderInvalidCognitoIdentityToken
                                                      userInfo:@{NSLocalizedDescriptionKey: @"Invalid logins dictionary."}]];
    }
    AWSSTSAssumeRoleWithWebIdentityRequest *webIdentityRequest = [AWSSTSAssumeRoleWithWebIdentityRequest new];
    webIdentityRequest.roleArn = roleArn;
    webIdentityRequest.webIdentityToken = [logins objectForKey:AWSIdentityProviderAmazonCognitoIdentity];
    webIdentityRequest.roleSessionName = @"iOS-Provider";
    return [[self.sts assumeRoleWithWebIdentity:webIdentityRequest] continueWithBlock:^id(AWSTask *task) {
        if (cancellationTokenSource.isCancellationRequested) {
            return [AWSTask cancelledTask];
        }
        if (task.result) {
            AWSSTSAssumeRoleWithWebIdentityResponse *webIdentityResponse = task.result;
            self.internalCredentials = [[AWSCredentials alloc] initWithAccessKey:webIdentityResponse.credentials.accessKeyId
                                                                       secretKey:webIdentityResponse.credentials.secretAccessKey
                                                                      sessionKey:webIdentityResponse.credentials.sessionToken
                                                                      expiration:webIdentityResponse.credentials.expiration];
            return [AWSTask taskWithResult:self.internalCredentials];
        } else {
            [self clearCredentials];
        }
        return task;
    }];
}
- (AWSTask<AWSCredentials *> *)getCredentialsWithCognito:(NSDictionary<NSString *,NSString *> *)logins
                                           authenticated:(BOOL)isAuthenticated
                                           customRoleArn:(NSString *)customRoleArn
                                   withCancellationToken:(AWSCancellationTokenSource *)cancellationTokenSource{
    if (cancellationTokenSource.isCancellationRequested) {
        return [AWSTask cancelledTask];
    }
    id<AWSCognitoCredentialsProviderHelper> providerRef = self.identityProvider;
    AWSCognitoIdentityGetCredentialsForIdentityInput *getCredentialsInput = [AWSCognitoIdentityGetCredentialsForIdentityInput new];
    getCredentialsInput.identityId = self.identityId;
    getCredentialsInput.logins = logins;
    getCredentialsInput.customRoleArn = customRoleArn;
    return [[[self.cognitoIdentity getCredentialsForIdentity:getCredentialsInput] continueWithBlock:^id(AWSTask *task) {
        if (cancellationTokenSource.isCancellationRequested) {
            return [AWSTask cancelledTask];
        }
        if (task.error) {
            AWSDDLogError(@"GetCredentialsForIdentity failed. Error is [%@]", task.error);
            if (![AWSCognitoCredentialsProvider shouldResetIdentityId:task.error
                                                        authenticated:isAuthenticated]) {
                return task;
            }
            AWSDDLogDebug(@"Resetting identity Id and calling getIdentityId");
            self.identityId = nil;
            providerRef.identityId = nil;
            return [[providerRef logins] continueWithSuccessBlock:^id _Nullable(AWSTask<NSDictionary<NSString *,NSString *> *> * _Nonnull task) {
                NSDictionary<NSString *,NSString *> *logins = task.result;
                if (cancellationTokenSource.isCancellationRequested) {
                    return [AWSTask cancelledTask];
                }
                if (!providerRef.identityId) {
                    AWSDDLogError(@"In refresh, but identitId is nil.");
                    AWSDDLogError(@"Result from getIdentityId is %@", task.result);
                    return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderHelperErrorDomain
                                                                      code:AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil
                                                                  userInfo:@{NSLocalizedDescriptionKey: @"identityId shouldn't be nil"}]];
                }
                self.identityId = providerRef.identityId;
                AWSDDLogDebug(@"Retrying GetCredentialsForIdentity");
                AWSCognitoIdentityGetCredentialsForIdentityInput *getCredentialsRetry = [AWSCognitoIdentityGetCredentialsForIdentityInput new];
                getCredentialsRetry.identityId = self.identityId;
                getCredentialsRetry.logins = logins;
                getCredentialsRetry.customRoleArn = customRoleArn;
                return [[self.cognitoIdentity getCredentialsForIdentity:getCredentialsRetry] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityGetCredentialsForIdentityResponse *> * _Nonnull task) {
                    if (cancellationTokenSource.isCancellationRequested) {
                        return [AWSTask cancelledTask];
                    }
                    if (task.error) {
                        return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderErrorDomain
                                                                          code:AWSCognitoCredentialsProviderInvalidConfiguration
                                                                      userInfo:@{NSLocalizedDescriptionKey : @"GetCredentialsForIdentity keeps failing. Clearing identityId did not help. Please check your Amazon Cognito Identity configuration."}]];
                    }
                    return task;
                }];
            }];
        }
        return task;
    }] continueWithSuccessBlock:^id(AWSTask *task) {
        AWSCognitoIdentityGetCredentialsForIdentityResponse *getCredentialsResponse = task.result;
        self.internalCredentials = [[AWSCredentials alloc] initWithAccessKey:getCredentialsResponse.credentials.accessKeyId
                                                                   secretKey:getCredentialsResponse.credentials.secretKey
                                                                  sessionKey:getCredentialsResponse.credentials.sessionToken
                                                                  expiration:getCredentialsResponse.credentials.expiration];
        NSString *identityIdFromResponse = getCredentialsResponse.identityId;
        if (!identityIdFromResponse) {
            AWSDDLogError(@"identityId from getCredentialsForIdentity is nil");
            return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderHelperErrorDomain
                                                              code:AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil
                                                          userInfo:@{NSLocalizedDescriptionKey: @"identityId shouldn't be nil"}]
                    ];
        }
        if (cancellationTokenSource.isCancellationRequested) {
            return [AWSTask cancelledTask];
        }
        if (![self.identityId isEqualToString:identityIdFromResponse]) {
            self.identityId = identityIdFromResponse;
            providerRef.identityId = identityIdFromResponse;
        }
        return [AWSTask taskWithResult:self.internalCredentials];
    }];
}
- (AWSTask<AWSCredentials *> *)credentialsWithCancellationToken:(AWSCancellationTokenSource *) cancellationTokenSource {
    if (cancellationTokenSource.isCancellationRequested) {
        return [AWSTask cancelledTask];
    }
    if (self.internalCredentials
        && [self.internalCredentials.expiration compare:[NSDate dateWithTimeIntervalSinceNow:10 * 60]] == NSOrderedDescending) {
        return [AWSTask taskWithResult:self.internalCredentials];
    }
    id<AWSCognitoCredentialsProviderHelper> providerRef = self.identityProvider;
    return [[[providerRef logins] continueWithExecutor:self.refreshExecutor withSuccessBlock:^id _Nullable(AWSTask<NSDictionary<NSString *,NSString *> *> * _Nonnull task) {
        if (cancellationTokenSource.isCancellationRequested) {
            return [AWSTask cancelledTask];
        }
        NSDictionary<NSString *,NSString *> *logins = task.result;
        AWSTask * getIdentityIdTask = nil;
        if(!providerRef.identityId){
            getIdentityIdTask = [self getIdentityId];
        }else {
            self.identityId = providerRef.identityId;
            getIdentityIdTask = [AWSTask taskWithResult:nil];
        }
        return [getIdentityIdTask continueWithSuccessBlock:^id _Nullable(AWSTask * _Nonnull task) {
            if (cancellationTokenSource.isCancellationRequested) {
                return [AWSTask cancelledTask];
            }
            if ((!self.cachedLogins || [self.cachedLogins isEqualToDictionary:logins])
                && self.internalCredentials
                && [self.internalCredentials.expiration compare:[NSDate dateWithTimeIntervalSinceNow:10 * 60]] == NSOrderedDescending) {
                return [AWSTask taskWithResult:self.internalCredentials];
            }
            if (self.isRefreshingCredentials) {
                if (dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC)) != 0) {
                    NSError *error = [NSError errorWithDomain:AWSCognitoCredentialsProviderErrorDomain
                                                         code:AWSCognitoCredentialsProviderCredentialsRefreshTimeout
                                                     userInfo:nil];
                    return [AWSTask taskWithError:error];
                }
            }
            if (cancellationTokenSource.isCancellationRequested) {
                return [AWSTask cancelledTask];
            }
            if ((!self.cachedLogins || [self.cachedLogins isEqualToDictionary:logins])
                && self.internalCredentials
                && [self.internalCredentials.expiration compare:[NSDate dateWithTimeIntervalSinceNow:10 * 60]] == NSOrderedDescending) {
                return [AWSTask taskWithResult:self.internalCredentials];
            }
            self.refreshingCredentials = YES;
            self.cachedLogins = logins;
            if (self.useEnhancedFlow) {
                NSString * customRoleArn = nil;
                if([providerRef.identityProviderManager respondsToSelector:@selector(customRoleArn)]){
                    customRoleArn = providerRef.identityProviderManager.customRoleArn;
                }
                if(self.customRoleArnOverride){
                    customRoleArn = self.customRoleArnOverride;
                }
                return [self getCredentialsWithCognito:logins
                                         authenticated:[providerRef isAuthenticated]
                                         customRoleArn:customRoleArn
                                 withCancellationToken:cancellationTokenSource];
            } else {
                return [self getCredentialsWithSTS:logins
                                     authenticated:[providerRef isAuthenticated]
                             withCancellationToken:cancellationTokenSource];
            }
        }];
    }] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            AWSDDLogError(@"Unable to refresh. Error is [%@]", task.error);
        }
        self.refreshingCredentials = NO;
        dispatch_semaphore_signal(self.semaphore);
        return task;
    }];
}
#pragma mark - AWSCredentialsProvider methods
- (AWSTask<AWSCredentials *> *)credentials {
    return [self credentialsWithCancellationToken:nil];
}
- (void)invalidateCachedTemporaryCredentials {
    self.internalCredentials = nil;
}
#pragma mark -
- (AWSTask<NSString *> *)getIdentityId {
    id<AWSCognitoCredentialsProviderHelper> providerRef = self.identityProvider;
    return [[providerRef getIdentityId] continueWithSuccessBlock:^id _Nullable(AWSTask<NSString *> * _Nonnull task) {
        NSString *identityId = task.result;
        if (!identityId) {
            AWSDDLogError(@"In refresh, but identityId is nil.");
            AWSDDLogError(@"Result from getIdentityId is %@", task.result);
            return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderErrorDomain
                                                              code:AWSCognitoCredentialsProviderIdentityIdIsNil
                                                          userInfo:@{NSLocalizedDescriptionKey: @"identityId shouldn't be nil"}]
                    ];
        }
        self.identityId = identityId;
        return task;
    }];
}
- (void)clearKeychain {
    [self.identityProvider clear];
    self.identityId = nil;
    [self clearCredentials];
}
- (void)clearCredentials {
    [self invalidateCachedTemporaryCredentials];
}
- (void)setIdentityProviderManagerOnce:(id<AWSIdentityProviderManager>)identityProviderManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AWSCognitoCredentialsProviderHelper *cognitoIdentityProvider = self.identityProvider;
        cognitoIdentityProvider.identityProviderManager = identityProviderManager;
    });
}
- (void)setIdentityProvider:(id<AWSCognitoCredentialsProviderHelper>)identityProvider {
    _identityProvider = identityProvider;
    [self clearCredentials];
}
- (NSString *)identityPoolId {
    return self.identityProvider.identityPoolId;
}
+ (BOOL)shouldResetIdentityId:(NSError *)error
                authenticated:(BOOL)isAuthenticated {
    BOOL shouldResetIdentityId = NO;
    if ([error.domain isEqualToString:AWSCognitoIdentityErrorDomain]) {
        if (error.code == AWSCognitoIdentityErrorResourceNotFound) {
            shouldResetIdentityId = isAuthenticated;
        }
        if (error.code == AWSCognitoIdentityErrorUnknown) {
            NSString *errorMessage = [error.userInfo objectForKey:@"__type"];
            shouldResetIdentityId = isAuthenticated || [errorMessage isEqualToString:@"ValidationException"];
        }
        if (error.code == AWSCognitoIdentityErrorNotAuthorized) {
            shouldResetIdentityId = YES;
        }
    }
    return shouldResetIdentityId;
}
#pragma mark - Getters/setters
- (NSString *)identityId {
    NSString *identityId = self.identityProvider.identityId;
    if (identityId) {
        return identityId;
    }
    return [self.keychain stringForKey:AWSCredentialsProviderKeychainIdentityId];
}
- (void)setIdentityId:(NSString *)identityId {
    self.keychain[AWSCredentialsProviderKeychainIdentityId] = identityId;
}
- (AWSCredentials *)internalCredentials {
    if (! _internalCredentials) {
        _internalCredentials = [[AWSCredentials alloc] initFromKeychain:self.keychain];
    }
    return _internalCredentials;
}
- (void)setInternalCredentials:(AWSCredentials *)internalCredentials {
    _internalCredentials = internalCredentials;
    self.keychain[AWSCredentialsProviderKeychainAccessKeyId] = internalCredentials.accessKey;
    self.keychain[AWSCredentialsProviderKeychainSecretAccessKey] = internalCredentials.secretKey;
    self.keychain[AWSCredentialsProviderKeychainSessionToken] = internalCredentials.sessionKey;
    if (internalCredentials.expiration) {
        self.keychain[AWSCredentialsProviderKeychainExpiration] = [NSString stringWithFormat:@"%f", [internalCredentials.expiration timeIntervalSince1970]];
    } else {
        self.keychain[AWSCredentialsProviderKeychainExpiration] = nil;
    }
}
@end