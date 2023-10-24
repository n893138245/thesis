#import <Foundation/Foundation.h>
#import "AWSCore.h"
#import "AWSCognitoIdentityModel.h"
#import "AWSCognitoIdentityResources.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSCognitoIdentity : AWSService
@property (nonatomic, strong, readonly) AWSServiceConfiguration *configuration;
+ (instancetype)defaultCognitoIdentity;
+ (void)registerCognitoIdentityWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;
+ (instancetype)CognitoIdentityForKey:(NSString *)key;
+ (void)removeCognitoIdentityForKey:(NSString *)key;
- (AWSTask<AWSCognitoIdentityIdentityPool *> *)createIdentityPool:(AWSCognitoIdentityCreateIdentityPoolInput *)request;
- (void)createIdentityPool:(AWSCognitoIdentityCreateIdentityPoolInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityIdentityPool * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityDeleteIdentitiesResponse *> *)deleteIdentities:(AWSCognitoIdentityDeleteIdentitiesInput *)request;
- (void)deleteIdentities:(AWSCognitoIdentityDeleteIdentitiesInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityDeleteIdentitiesResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask *)deleteIdentityPool:(AWSCognitoIdentityDeleteIdentityPoolInput *)request;
- (void)deleteIdentityPool:(AWSCognitoIdentityDeleteIdentityPoolInput *)request completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityIdentityDescription *> *)describeIdentity:(AWSCognitoIdentityDescribeIdentityInput *)request;
- (void)describeIdentity:(AWSCognitoIdentityDescribeIdentityInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityIdentityDescription * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityIdentityPool *> *)describeIdentityPool:(AWSCognitoIdentityDescribeIdentityPoolInput *)request;
- (void)describeIdentityPool:(AWSCognitoIdentityDescribeIdentityPoolInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityIdentityPool * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityGetCredentialsForIdentityResponse *> *)getCredentialsForIdentity:(AWSCognitoIdentityGetCredentialsForIdentityInput *)request;
- (void)getCredentialsForIdentity:(AWSCognitoIdentityGetCredentialsForIdentityInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityGetCredentialsForIdentityResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityGetIdResponse *> *)getId:(AWSCognitoIdentityGetIdInput *)request;
- (void)getId:(AWSCognitoIdentityGetIdInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityGetIdResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityGetIdentityPoolRolesResponse *> *)getIdentityPoolRoles:(AWSCognitoIdentityGetIdentityPoolRolesInput *)request;
- (void)getIdentityPoolRoles:(AWSCognitoIdentityGetIdentityPoolRolesInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityGetIdentityPoolRolesResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityGetOpenIdTokenResponse *> *)getOpenIdToken:(AWSCognitoIdentityGetOpenIdTokenInput *)request;
- (void)getOpenIdToken:(AWSCognitoIdentityGetOpenIdTokenInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityGetOpenIdTokenResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityResponse *> *)getOpenIdTokenForDeveloperIdentity:(AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityInput *)request;
- (void)getOpenIdTokenForDeveloperIdentity:(AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityGetOpenIdTokenForDeveloperIdentityResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityListIdentitiesResponse *> *)listIdentities:(AWSCognitoIdentityListIdentitiesInput *)request;
- (void)listIdentities:(AWSCognitoIdentityListIdentitiesInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityListIdentitiesResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityListIdentityPoolsResponse *> *)listIdentityPools:(AWSCognitoIdentityListIdentityPoolsInput *)request;
- (void)listIdentityPools:(AWSCognitoIdentityListIdentityPoolsInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityListIdentityPoolsResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityListTagsForResourceResponse *> *)listTagsForResource:(AWSCognitoIdentityListTagsForResourceInput *)request;
- (void)listTagsForResource:(AWSCognitoIdentityListTagsForResourceInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityListTagsForResourceResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityLookupDeveloperIdentityResponse *> *)lookupDeveloperIdentity:(AWSCognitoIdentityLookupDeveloperIdentityInput *)request;
- (void)lookupDeveloperIdentity:(AWSCognitoIdentityLookupDeveloperIdentityInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityLookupDeveloperIdentityResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityMergeDeveloperIdentitiesResponse *> *)mergeDeveloperIdentities:(AWSCognitoIdentityMergeDeveloperIdentitiesInput *)request;
- (void)mergeDeveloperIdentities:(AWSCognitoIdentityMergeDeveloperIdentitiesInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityMergeDeveloperIdentitiesResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask *)setIdentityPoolRoles:(AWSCognitoIdentitySetIdentityPoolRolesInput *)request;
- (void)setIdentityPoolRoles:(AWSCognitoIdentitySetIdentityPoolRolesInput *)request completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityTagResourceResponse *> *)tagResource:(AWSCognitoIdentityTagResourceInput *)request;
- (void)tagResource:(AWSCognitoIdentityTagResourceInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityTagResourceResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask *)unlinkDeveloperIdentity:(AWSCognitoIdentityUnlinkDeveloperIdentityInput *)request;
- (void)unlinkDeveloperIdentity:(AWSCognitoIdentityUnlinkDeveloperIdentityInput *)request completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler;
- (AWSTask *)unlinkIdentity:(AWSCognitoIdentityUnlinkIdentityInput *)request;
- (void)unlinkIdentity:(AWSCognitoIdentityUnlinkIdentityInput *)request completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityUntagResourceResponse *> *)untagResource:(AWSCognitoIdentityUntagResourceInput *)request;
- (void)untagResource:(AWSCognitoIdentityUntagResourceInput *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityUntagResourceResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoIdentityIdentityPool *> *)updateIdentityPool:(AWSCognitoIdentityIdentityPool *)request;
- (void)updateIdentityPool:(AWSCognitoIdentityIdentityPool *)request completionHandler:(void (^ _Nullable)(AWSCognitoIdentityIdentityPool * _Nullable response, NSError * _Nullable error))completionHandler;
@end
NS_ASSUME_NONNULL_END