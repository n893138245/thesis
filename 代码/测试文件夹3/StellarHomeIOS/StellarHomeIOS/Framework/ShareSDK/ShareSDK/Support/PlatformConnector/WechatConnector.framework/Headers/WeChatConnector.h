#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
typedef void(^SSDKRequestTokenOperation)(NSString *authCode, void(^getUserinfo)(NSString *uid, NSString *token));
typedef void(^SSDKRefreshTokenOperation)(NSString *uid, void(^getUserinfo)(NSString *token));
typedef void(^SSDKOpenAppFromMiniProgramCallback)(SSDKResponseState state, NSString *extStr, NSError *error);
@interface WeChatConnector : NSObject
+ (void)setRequestAuthTokenOperation:(SSDKRequestTokenOperation)operation;
+ (void)setRefreshAuthTokenOperation:(SSDKRefreshTokenOperation)operation;
+ (void)setWXCallbackOperation:(void(^)(id req,id resp))operation;
+ (void)openMiniProgramWithUserName:(NSString *)userName
                               path:(NSString *)path
                    miniProgramType:(NSInteger)miniProgramType
                           complete:(void(^) (BOOL success))complete __deprecated_msg("Discard form v4.3.17");
+ (void)openMiniProgramWithUserName:(NSString *)userName
                               path:(NSString *)path
                    miniProgramType:(NSInteger)miniProgramType
                             extMsg:(NSString *)extMsg
                             extDic:(NSDictionary *)extDic
                           complete:(void(^)(BOOL success))complete;
+ (void)openAppFromMiniProgramWithCallback:(SSDKOpenAppFromMiniProgramCallback)callback;
+ (void)setLang:(NSString *)lang;
@end