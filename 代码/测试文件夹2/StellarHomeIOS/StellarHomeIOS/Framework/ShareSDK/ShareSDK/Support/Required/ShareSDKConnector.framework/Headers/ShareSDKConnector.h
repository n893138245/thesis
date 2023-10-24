#import <Foundation/Foundation.h>
@interface ShareSDKConnector : NSObject
+ (void)connectWeChat:(Class)wxApiClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectWeChat:(Class)wxApiClass delegate:(id)delegate __deprecated_msg("Discard form v4.2.0");
+ (void)connectWeibo:(Class)weiboSDKClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectQQ:(Class)qqApiInterfaceClass tencentOAuthClass:(Class)tencentOAuthClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectAliSocial:(Class)apOpenApiClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectKaKao:(Class)koSessionClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectYiXin:(Class)yxApiClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectFacebookMessenger:(Class)fbmApiClass __deprecated_msg("discard form v4.1.2");
+ (void)connectDingTalk:(Class)dtOpenApiClass __deprecated_msg("Discard form v4.2.0");
+ (void)connectLine:(Class)lineSDKClass __deprecated_msg("Discard form v4.2.0");
@end