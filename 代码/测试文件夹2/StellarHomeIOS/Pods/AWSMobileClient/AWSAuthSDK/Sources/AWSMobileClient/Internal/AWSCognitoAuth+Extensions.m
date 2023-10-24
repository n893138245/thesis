#import <Foundation/Foundation.h>
#import <AWSMobileClient/AWSCognitoAuth.h>
#import <AWSCore/AWSCore.h>
@interface AWSCognitoAuthConfiguration()
- (instancetype)initWithAppClientIdInternal:(NSString *) appClientId
                            appClientSecret:(nullable NSString *)appClientSecret
                                     scopes:(NSSet<NSString *> *) scopes
                          signInRedirectUri:(NSString *) signInRedirectUri
                         signOutRedirectUri:(NSString *) signOutRedirectUri
                                  webDomain:(NSString *) webDomain
                           identityProvider:(nullable NSString *) identityProvider
                              idpIdentifier:(nullable NSString *) idpIdentifier
                   userPoolIdForEnablingASF:(nullable NSString *) userPoolIdForEnablingASF
             enableSFAuthSessionIfAvailable:(BOOL) enableSFAuthSession
                                  signInUri:(NSString *) signInUri
                                 signOutUri:(NSString *) signOutUri
                                  tokensUri:(NSString *) tokensUri
                   signInUriQueryParameters:(NSDictionary<NSString *, NSString *> *) signInUriQueryParameters
                  signOutUriQueryParameters:(NSDictionary<NSString *, NSString *> *) signOutUriQueryParameters
                    tokenUriQueryParameters:(NSDictionary<NSString *, NSString *> *) tokenUriQueryParameters
                         isProviderExternal:(BOOL) isProviderExternal
               cognitoUserPoolServiceConfig:(nullable AWSServiceConfiguration *) serviceConfig;
@end
@implementation AWSCognitoAuthConfiguration(Extension)
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
       userPoolServiceConfiguration:(nullable AWSServiceConfiguration *)serviceConfiguration {
    BOOL isProviderExternal = YES;
    if (signInUri == nil && signOutUri == nil && tokensUri == nil) {
        isProviderExternal = NO;
    }
    return [self initWithAppClientIdInternal:appClientId
                             appClientSecret:appClientSecret
                                      scopes:scopes
                           signInRedirectUri:signInRedirectUri
                          signOutRedirectUri:signOutRedirectUri
                                   webDomain:webDomain
                            identityProvider:identityProvider
                               idpIdentifier:idpIdentifier
                    userPoolIdForEnablingASF:nil
              enableSFAuthSessionIfAvailable:YES
                                   signInUri:signInUri
                                  signOutUri:signOutUri
                                   tokensUri:tokensUri
                    signInUriQueryParameters:signInUriQueryParameters
                   signOutUriQueryParameters:signOutUriQueryParameters
                     tokenUriQueryParameters:tokenUriQueryParameters
                          isProviderExternal:isProviderExternal
                cognitoUserPoolServiceConfig:serviceConfiguration];
}
@end