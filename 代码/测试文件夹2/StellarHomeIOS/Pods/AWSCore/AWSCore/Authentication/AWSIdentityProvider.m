#import "AWSCore.h"
#import "AWSIdentityProvider.h"
#import "AWSBolts.h"
NSString *const AWSCognitoIdentityIdChangedNotification = @"com.amazonaws.services.cognitoidentity.AWSCognitoIdentityIdChangedNotification";
NSString *const AWSCognitoCredentialsProviderHelperErrorDomain = @"com.amazonaws.service.cognitoidentity.AWSCognitoCredentialsProviderHelper";
NSString *const AWSCognitoNotificationPreviousId = @"PREVID";
NSString *const AWSCognitoNotificationNewId = @"NEWID";
NSString *const AWSIdentityProviderApple = @"appleid.apple.com";
NSString *const AWSIdentityProviderDigits = @"www.digits.com";
NSString *const AWSIdentityProviderFacebook = @"graph.facebook.com";
NSString *const AWSIdentityProviderGoogle = @"accounts.google.com";
NSString *const AWSIdentityProviderLoginWithAmazon = @"www.amazon.com";
NSString *const AWSIdentityProviderTwitter = @"api.twitter.com";
NSString *const AWSIdentityProviderAmazonCognitoIdentity = @"cognito-identity.amazonaws.com";
@interface AWSCognitoCredentialsProvider()
+ (BOOL)shouldResetIdentityId:(NSError *)error
                authenticated:(BOOL)isAuthenticated;
@end
@interface AWSAbstractCognitoCredentialsProviderHelper()
@property (nonatomic, strong) id<AWSIdentityProviderManager> identityProviderManager;
@property (nonatomic, strong) NSString *identityPoolId;
@property (nonatomic, strong) NSDictionary *cachedLogins;
@end
@interface AWSCognitoIdentity()
- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
@end
@implementation AWSAbstractCognitoCredentialsProviderHelper
#pragma mark - AWSIdentityProvider
- (NSString *)identityProviderName {
    return @"AWSAbstractCognitoCredentialsProviderHelper";
}
- (AWSTask<NSString *> *)token {
    return [AWSTask taskWithResult:nil];
}
#pragma mark - AWSIdentityProviderManager
- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    return [AWSTask taskWithResult:nil];
}
#pragma mark -
- (AWSTask<NSString *> *)getIdentityId {
    return [AWSTask taskWithResult:self.identityId];
}
- (void)clear {
    self.identityId = nil;
    self.cachedLogins = nil;
}
- (BOOL)isAuthenticated {
    return [self.cachedLogins count] > 0;
}
- (void)setIdentityId:(NSString *)identityId {
    if (identityId && ![identityId isEqualToString:_identityId]) {
        [self postIdentityIdChangedNotification:identityId];
    }
    _identityId = identityId;
}
- (void)postIdentityIdChangedNotification:(NSString *)newId {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (self.identityId) {
        [userInfo setObject:self.identityId forKey:AWSCognitoNotificationPreviousId];
    }
    [userInfo setObject:newId forKey:AWSCognitoNotificationNewId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AWSCognitoIdentityIdChangedNotification
                                                            object:self
                                                          userInfo:userInfo];
    });
}
@end
@interface AWSCognitoCredentialsProviderHelper()
@property (nonatomic, strong) AWSCognitoIdentity *cognitoIdentity;
@property (nonatomic, strong) AWSExecutor *executor;
@property (atomic, assign) int32_t count;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (atomic, assign) BOOL hasClearedIdentityId;
@end
@implementation AWSCognitoCredentialsProviderHelper
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                   useEnhancedFlow:(BOOL)useEnhancedFlow
           identityProviderManager:(id<AWSIdentityProviderManager>)identityProviderManager
         identityPoolConfiguration:(AWSServiceConfiguration *)configuration {
    if (self = [super init]) {
        _executor = [AWSExecutor executorWithOperationQueue:[NSOperationQueue new]];
        _count = 0;
        _semaphore = dispatch_semaphore_create(0);
        _useEnhancedFlow = useEnhancedFlow;
        self.identityPoolId = identityPoolId;
        self.identityProviderManager = identityProviderManager;
        _cognitoIdentity = [[AWSCognitoIdentity alloc] initWithConfiguration:configuration];
    }
    return self;
}
- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                   useEnhancedFlow:(BOOL)useEnhancedFlow
           identityProviderManager:(id<AWSIdentityProviderManager>)identityProviderManager {
    AWSAnonymousCredentialsProvider *credentialsProvider = [AWSAnonymousCredentialsProvider new];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:regionType
                                                                         credentialsProvider:credentialsProvider];
    return [self initWithRegionType:regionType
                     identityPoolId:identityPoolId
                    useEnhancedFlow:useEnhancedFlow
            identityProviderManager:identityProviderManager
          identityPoolConfiguration:configuration];
}
#pragma mark - AWSIdentityProvider
- (NSString *)identityProviderName {
    return AWSIdentityProviderAmazonCognitoIdentity;
}
- (AWSTask<NSString *> *)token {
    return [[[self getIdentityId] continueWithSuccessBlock:^id(AWSTask *task) {
        if (!self.identityId) {
            AWSDDLogError(@"In refresh, but identityId is nil.");
            AWSDDLogError(@"Result from getIdentityId is %@", task.result);
            return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderHelperErrorDomain
                                                              code:AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil
                                                          userInfo:@{NSLocalizedDescriptionKey: @"identityId shouldn't be nil"}]];
        }
        if (self.identityProviderManager) {
            return [self.identityProviderManager logins];
        } else {
            return [AWSTask taskWithResult:nil];
        }
    }] continueWithSuccessBlock:^id _Nullable(AWSTask<NSDictionary *>* _Nonnull task) {
        NSDictionary<NSString *, NSString *> *logins = task.result;
        self.cachedLogins = logins;
        if (self.useEnhancedFlow) {
            if(!task.result){
                return task;
            }
            else {
                return [AWSTask taskWithResult:[task.result objectForKey:[self identityProviderName]]];
            }
        }
        AWSCognitoIdentityGetOpenIdTokenInput *getTokenInput = [AWSCognitoIdentityGetOpenIdTokenInput new];
        getTokenInput.identityId = self.identityId;
        getTokenInput.logins = logins;
        return [[[self.cognitoIdentity getOpenIdToken:getTokenInput] continueWithBlock:^id(AWSTask *task) {
            if (task.error) {
                AWSDDLogError(@"GetOpenIdToken failed. Error is [%@]", task.error);
                if (![AWSCognitoCredentialsProvider shouldResetIdentityId:task.error
                                                            authenticated:[self isAuthenticated]]) {
                    return task;
                }
                if (self.hasClearedIdentityId) {
                    return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderErrorDomain
                                                                      code:AWSCognitoCredentialsProviderInvalidConfiguration
                                                                  userInfo:@{NSLocalizedDescriptionKey : @"GetCredentialsForIdentity keeps failing. Clearing identityId did not help. Please check your Amazon Cognito Identity configuration."}]];
                }
                AWSDDLogDebug(@"Resetting identity Id and calling getIdentityId");
                self.identityId = nil;
                self.hasClearedIdentityId = YES;
                return [[self getIdentityId] continueWithSuccessBlock:^id(AWSTask *task) {
                    if (!self.identityId) {
                        AWSDDLogError(@"In refresh, but identitId is nil.");
                        AWSDDLogError(@"Result from getIdentityId is %@", task.result);
                        return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderHelperErrorDomain
                                                                          code:AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil
                                                                      userInfo:@{NSLocalizedDescriptionKey: @"identityId shouldn't be nil"}]
                                ];
                    }
                    AWSDDLogDebug(@"Retrying GetOpenIdToken");
                    AWSCognitoIdentityGetOpenIdTokenInput *tokenRetry = [AWSCognitoIdentityGetOpenIdTokenInput new];
                    tokenRetry.identityId = self.identityId;
                    tokenRetry.logins = self.cachedLogins;
                    return [self.cognitoIdentity getOpenIdToken:tokenRetry];
                }];
            }
            return task;
        }] continueWithSuccessBlock:^id _Nullable(AWSTask * _Nonnull task) {
            AWSCognitoIdentityGetOpenIdTokenResponse *getTokenResponse = task.result;
            NSString *token = getTokenResponse.token;
            NSString *identityIdFromToken = getTokenResponse.identityId;
            if (!identityIdFromToken) {
                AWSDDLogError(@"identityId from getOpenIdToken is nil");
                return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderHelperErrorDomain
                                                                  code:AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil
                                                              userInfo:@{NSLocalizedDescriptionKey: @"identityId shouldn't be nil"}]
                        ];
            }
            if (![self.identityId isEqualToString:identityIdFromToken]) {
                self.identityId = identityIdFromToken;
            }
            return [AWSTask taskWithResult:token];
        }];
    }];
}
#pragma mark - AWSIdentityProviderManager
- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    if (self.identityProviderManager && self.useEnhancedFlow) {
        self.cachedLogins = nil;
        return [[self getIdentityId] continueWithSuccessBlock:^id _Nullable(AWSTask<NSString *> * _Nonnull task) {
            if(self.cachedLogins){
                return [AWSTask taskWithResult:self.cachedLogins];
            }
            else {
                return [self.identityProviderManager logins];
            }
        }];
    }
    return [[self token] continueWithSuccessBlock:^id _Nullable(AWSTask<NSString *> * _Nonnull task) {
        if (!task.result) {
            return [AWSTask taskWithResult:nil];
        }
        NSString *token = task.result;
        return [AWSTask taskWithResult:@{self.identityProviderName : token}];
    }];
}
#pragma mark -
- (AWSTask<NSString *> *)getIdentityId {
    if (self.identityId) {
        return [AWSTask taskWithResult:self.identityId];
    } else {
        AWSTask *task = [AWSTask taskWithResult:nil];
        if (self.identityProviderManager) {
            task = [self.identityProviderManager logins];
        }
        return [[task continueWithExecutor:self.executor withSuccessBlock:^id _Nullable(AWSTask<NSDictionary<NSString *,NSString *> *> * _Nonnull task) {
            NSDictionary<NSString *, NSString *> *logins = task.result;
            self.cachedLogins = logins;
            self.count++;
            if (!self.identityId && self.count <= 1) {
                dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 0));
                AWSCognitoIdentityGetIdInput *getIdInput = [AWSCognitoIdentityGetIdInput new];
                getIdInput.identityPoolId = self.identityPoolId;
                getIdInput.logins = logins;
                return [self.cognitoIdentity getId:getIdInput];
            } else {
                dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
                return [AWSTask taskWithResult:nil];
            }
        }] continueWithBlock:^id(AWSTask *task) {
            if (task.error) {
                AWSDDLogError(@"GetId failed. Error is [%@]", task.error);
            } else if (task.result) {
                AWSCognitoIdentityGetIdResponse *getIdResponse = task.result;
                self.identityId = getIdResponse.identityId;
            }
            self.count--;
            dispatch_semaphore_signal(self.semaphore);
            if (task.faulted) {
                return task;
            }
            if(!self.identityId){
                NSString * error = @"Obtaining an identity id in another thread failed or didn't complete within 5 seconds.";
                AWSDDLogError(@"%@",error);
                return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoCredentialsProviderHelperErrorDomain
                                                                  code:AWSCognitoCredentialsProviderHelperErrorTypeIdentityIsNil
                                                              userInfo:@{NSLocalizedDescriptionKey: error}]];
            } else {
                return [AWSTask taskWithResult:self.identityId];
            }
        }];
    }
}
@end