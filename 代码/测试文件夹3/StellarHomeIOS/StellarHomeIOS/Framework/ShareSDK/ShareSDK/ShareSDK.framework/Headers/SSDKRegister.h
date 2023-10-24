#import <MOBFoundation/MOBFDataModel.h>
#import <ShareSDK/SSDKTypeDefine.h>
@interface SSDKRegister : NSObject
@property (strong, nonatomic, readonly) NSMutableDictionary *platformsInfo;
- (void)setupSinaWeiboWithAppkey:(NSString *)appkey
                       appSecret:(NSString *)appSecret
                     redirectUrl:(NSString *)redirectUrl
                   universalLink:(NSString *)universalLink;
- (void)setupWeChatWithAppId:(NSString *)appId
                   appSecret:(NSString *)appSecret
               universalLink:(NSString *)universalLink;
- (void)setupQQWithAppId:(NSString *)appId
                  appkey:(NSString *)appkey
     enableUniversalLink:(BOOL)enableUniversalLink
           universalLink:(NSString *)universalLink;
- (void)setupTwitterWithKey:(NSString *)key
                     secret:(NSString *)secret
                redirectUrl:(NSString *)redirectUrl;
- (void)setupFacebookWithAppkey:(NSString *)appkey
                      appSecret:(NSString *)appSecret
                    displayName:(NSString *)displayName;
- (void)setupYiXinByAppId:(NSString *)appId
                appSecret:(NSString *)appSecret
              redirectUrl:(NSString *)redirectUrl;
- (void)setupEvernoteByConsumerKey:(NSString *)consumerKey
                    consumerSecret:(NSString *)consumerSecret
                           sandbox:(BOOL)sandbox;
- (void)setupKaiXinByApiKey:(NSString *)apiKey
                  secretKey:(NSString *)secretKey
                redirectUrl:(NSString *)redirectUrl;
- (void)setupPocketWithConsumerKey:(NSString *)consumerKey
                       redirectUrl:(NSString *)redirectUrl;
- (void)setupGooglePlusByClientID:(NSString *)clientId
                     clientSecret:(NSString *)clientSecret
                      redirectUrl:(NSString *)redirectUrl;
- (void)setupInstagramWithClientId:(NSString *)clientId
                      clientSecret:(NSString *)clientSecret
                       redirectUrl:(NSString *)redirectUrl;
- (void)setupInstagramInFBWithClientId:(NSString *)clientId
                      clientSecret:(NSString *)clientSecret
                       redirectUrl:(NSString *)redirectUrl;
- (void)setupLinkedInByApiKey:(NSString *)apiKey
                    secretKey:(NSString *)secretKey
                  redirectUrl:(NSString *)redirectUrl;
- (void)setupTumblrByConsumerKey:(NSString *)consumerKey
                  consumerSecret:(NSString *)consumerSecret
                     redirectUrl:(NSString *)redirectUrl;
- (void)setupFlickrWithApiKey:(NSString *)apiKey
                    apiSecret:(NSString *)apiSecret;
- (void)setupYouDaoNoteWithConsumerKey:(NSString *)consumerKey
                        consumerSecret:(NSString *)consumerSecret
                         oauthCallback:(NSString *)oauthCallback;
- (void)setupAliSocialWithAppId:(NSString *)appId;
- (void)setupPinterestByClientId:(NSString *)clientId;
- (void)setupKaKaoWithAppkey:(NSString *)appkey
                  restApiKey:(NSString *)restApiKey
                 redirectUrl:(NSString *)redirectUrl;
- (void)setupDropboxWithAppKey:(NSString *)appId
                     appSecret:(NSString *)appSecret
                   redirectUrl:(NSString *)redirectUrl;
- (void)setupVKontakteWithApplicationId:(NSString *)applicationId
                              secretKey:(NSString *)secretKey
                               authType:(SSDKAuthorizeType)authType;
- (void)setupInstapaperWithConsumerKey:(NSString *)consumerKey
                        consumerSecret:(NSString *)consumerSecret;
- (void)setupDingTalkWithAppId:(NSString *)appId;
- (void)setupDingTalkAuthWithAppId:(NSString *)appId
                         appSecret:(NSString *)appSecret
                       redirectUrl:(NSString *)redirectUrl;
- (void)setupYouTubeWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSString *)redirectUrl;
- (void)setupLineAuthType:(SSDKAuthorizeType)authType;
- (void)setupSMSOpenCountryList:(BOOL)open;
- (void)setupMingDaoByAppKey:(NSString *)appKey
                   appSecret:(NSString *)appSecret
                 redirectUrl:(NSString *)redirectUrl;
- (void)setupTelegramByBotToken:(NSString *)botToken
                      botDomain:(NSString *)botDomain;
- (void)setupRedditByAppKey:(NSString *)appkey
                redirectUri:(NSString *)redirectUri;
- (void)setupDouyinByAppKey:(NSString *)appKey
                  appSecret:(NSString *)appSecret;
- (void)setupTikTokByAppKey:(NSString *)appKey
                  appSecret:(NSString *)appSecret;
- (void)setupWeWorkByAppKey:(NSString *)appKey
                     corpId:(NSString *)corpId
                    agentId:(NSString *)agentId
                  appSecret:(NSString *)appSecret;
- (void)setOasisByAppkey:(NSString *)appKey;
- (void)setSnapChatClientId:(NSString *)cliendId    
               clientSecret:(NSString *)clientSecret
                redirectUrl:(NSString *)redirectUrl;
- (void)setupKuaiShouWithAppId:(NSString *)appId
                     appSecret:(NSString *)appSecret
               universalLink:(NSString *)universalLink
                      delegate:(id)delegate;
@end