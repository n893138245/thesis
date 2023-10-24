#import <Foundation/Foundation.h>
#import "AWSCore.h"
#import "AWSSTSModel.h"
#import "AWSSTSResources.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSSTS : AWSService
@property (nonatomic, strong, readonly) AWSServiceConfiguration *configuration;
+ (instancetype)defaultSTS;
+ (void)registerSTSWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;
+ (instancetype)STSForKey:(NSString *)key;
+ (void)removeSTSForKey:(NSString *)key;
- (AWSTask<AWSSTSAssumeRoleResponse *> *)assumeRole:(AWSSTSAssumeRoleRequest *)request;
- (void)assumeRole:(AWSSTSAssumeRoleRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSAssumeRoleResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSAssumeRoleWithSAMLResponse *> *)assumeRoleWithSAML:(AWSSTSAssumeRoleWithSAMLRequest *)request;
- (void)assumeRoleWithSAML:(AWSSTSAssumeRoleWithSAMLRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSAssumeRoleWithSAMLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSAssumeRoleWithWebIdentityResponse *> *)assumeRoleWithWebIdentity:(AWSSTSAssumeRoleWithWebIdentityRequest *)request;
- (void)assumeRoleWithWebIdentity:(AWSSTSAssumeRoleWithWebIdentityRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSAssumeRoleWithWebIdentityResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSDecodeAuthorizationMessageResponse *> *)decodeAuthorizationMessage:(AWSSTSDecodeAuthorizationMessageRequest *)request;
- (void)decodeAuthorizationMessage:(AWSSTSDecodeAuthorizationMessageRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSDecodeAuthorizationMessageResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSGetAccessKeyInfoResponse *> *)getAccessKeyInfo:(AWSSTSGetAccessKeyInfoRequest *)request;
- (void)getAccessKeyInfo:(AWSSTSGetAccessKeyInfoRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSGetAccessKeyInfoResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSGetCallerIdentityResponse *> *)getCallerIdentity:(AWSSTSGetCallerIdentityRequest *)request;
- (void)getCallerIdentity:(AWSSTSGetCallerIdentityRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSGetCallerIdentityResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSGetFederationTokenResponse *> *)getFederationToken:(AWSSTSGetFederationTokenRequest *)request;
- (void)getFederationToken:(AWSSTSGetFederationTokenRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSGetFederationTokenResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSSTSGetSessionTokenResponse *> *)getSessionToken:(AWSSTSGetSessionTokenRequest *)request;
- (void)getSessionToken:(AWSSTSGetSessionTokenRequest *)request completionHandler:(void (^ _Nullable)(AWSSTSGetSessionTokenResponse * _Nullable response, NSError * _Nullable error))completionHandler;
@end
NS_ASSUME_NONNULL_END