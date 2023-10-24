#import <AWSMobileClient/AWSCognitoAuth.h>
NS_ASSUME_NONNULL_BEGIN
@interface AWSCognitoAuthConfiguration(Extension)
- (instancetype)initWithAppClientId:(NSString *) appClientId
                    appClientSecret:(nullable NSString *)appClientSecret
                             scopes:(NSSet<NSString *> *) scopes
                  signInRedirectUri:(NSString *) signInRedirectUri
                 signOutRedirectUri:(NSString *) signOutRedirectUri
                          webDomain:(NSString *) webDomain
                   identityProvider:(nullable NSString *)identityProvider
                      idpIdentifier:(nullable NSString *)idpIdentifier
                          signInUri:(nullable NSString *) signInUri
                         signOutUri:(nullable NSString *) signOutUri
                          tokensUri:(nullable NSString *) tokensUri
           signInUriQueryParameters:(nullable NSDictionary<NSString *, NSString *> *) signInUriQueryParameters
          signOutUriQueryParameters:(nullable NSDictionary<NSString *, NSString *> *) signOutUriQueryParameters
            tokenUriQueryParameters:(nullable NSDictionary<NSString *, NSString *> *) tokenUriQueryParameters
       userPoolServiceConfiguration:(nullable AWSServiceConfiguration *)serviceConfiguration;
@end
NS_ASSUME_NONNULL_END