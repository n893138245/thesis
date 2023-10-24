#import <Foundation/Foundation.h>
#import <ShareSDK/SSDKTypeDefine.h>
extern NSString *const SSDKAuthTypeBoth;
extern NSString *const SSDKAuthTypeSSO;
extern NSString *const SSDKAuthTypeWeb;
@interface NSMutableDictionary (SSDKInit)
- (void)SSDKSetAuthSettings:(NSArray *)authSettings __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupSinaWeiboByAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri
                          authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupWeChatByAppId:(NSString *)appId
                     appSecret:(NSString *)appSecret __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupWeChatByAppId:(NSString *)appId
                     appSecret:(NSString *)appSecret
                   backUnionID:(BOOL)backUnionID __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupTwitterByConsumerKey:(NSString *)consumerKey
                       consumerSecret:(NSString *)consumerSecret
                          redirectUri:(NSString *)redirectUri __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupQQByAppId:(NSString *)appId
                    appKey:(NSString *)appKey
                  authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupQQByAppId:(NSString *)appId
                    appKey:(NSString *)appKey
                  authType:(NSString *)authType
                    useTIM:(BOOL)useTIM __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupQQByAppId:(NSString *)appId
                    appKey:(NSString *)appKey
                  authType:(NSString *)authType
                    useTIM:(BOOL)useTIM
               backUnionID:(BOOL)backUnionID __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupFacebookByApiKey:(NSString *)apiKey
                        appSecret:(NSString *)appSecret
                         authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupFacebookByApiKey:(NSString *)apiKey
                        appSecret:(NSString *)appSecret
                      displayName:(NSString *)displayName
                         authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupKaiXinByApiKey:(NSString *)apiKey
                      secretKey:(NSString *)secretKey
                    redirectUri:(NSString *)redirectUri __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupPocketByConsumerKey:(NSString *)consumerKey
                         redirectUri:(NSString *)redirectUri
                            authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupGooglePlusByClientID:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                          redirectUri:(NSString *)redirectUri __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupInstagramByClientID:(NSString *)clientId
                        clientSecret:(NSString *)clientSecret
                         redirectUri:(NSString *)redirectUri __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupLinkedInByApiKey:(NSString *)apiKey
                        secretKey:(NSString *)secretKey
                      redirectUrl:(NSString *)redirectUrl __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupTumblrByConsumerKey:(NSString *)consumerKey
                      consumerSecret:(NSString *)consumerSecret
                         callbackUrl:(NSString *)callbackUrl __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupFlickrByApiKey:(NSString *)apiKey
                      apiSecret:(NSString *)apiSecret __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupYouDaoNoteByConsumerKey:(NSString *)consumerKey
                          consumerSecret:(NSString *)consumerSecret
                           oauthCallback:(NSString *)oauthCallback __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupEvernoteByConsumerKey:(NSString *)consumerKey
                        consumerSecret:(NSString *)consumerSecret
                               sandbox:(BOOL)sandbox __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupAliSocialByAppId:(NSString *)appId __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupPinterestByClientId:(NSString *)clientId __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupKaKaoByAppKey:(NSString *)appKey
                    restApiKey:(NSString *)restApiKey
                   redirectUri:(NSString *)redirectUri
                      authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupDropboxByAppKey:(NSString *)appKey
                       appSecret:(NSString *)appSecret
                   oauthCallback:(NSString *)oauthCallback __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupVKontakteByApplicationId:(NSString *)applicationId
                                secretKey:(NSString *)secretKey __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupVKontakteByApplicationId:(NSString *)applicationId
                                secretKey:(NSString *)secretKey
                                 authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupMingDaoByAppKey:(NSString *)appKey
                       appSecret:(NSString *)appSecret
                     redirectUri:(NSString *)redirectUri __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupYiXinByAppId:(NSString *)appId
                    appSecret:(NSString *)appSecret
                  redirectUri:(NSString *)redirectUri
                     authType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupInstapaperByConsumerKey:(NSString *)consumerKey
                          consumerSecret:(NSString *)consumerSecret __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupDingTalkByAppId:(NSString *)appId __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupYouTubeByClientId:(NSString *)clientId
                      clientSecret:(NSString *)clientSecret
                       redirectUri:(NSString *)redirectUri __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetupLineAuthType:(NSString *)authType __deprecated_msg("Discard form v4.2.0");
- (void)SSDKSetpSMSOpenCountryList:(BOOL)open __deprecated_msg("Discard form v4.2.0");
@end