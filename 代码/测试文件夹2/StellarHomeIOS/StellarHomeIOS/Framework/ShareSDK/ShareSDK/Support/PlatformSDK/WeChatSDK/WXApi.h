#import <Foundation/Foundation.h>
#import "WXApiObject.h"
NS_ASSUME_NONNULL_BEGIN
#pragma mark - WXApiDelegate
@protocol WXApiDelegate <NSObject>
@optional
- (void)onReq:(BaseReq*)req;
- (void)onResp:(BaseResp*)resp;
@end
#pragma mark - WXApiLogDelegate
@protocol WXApiLogDelegate <NSObject>
- (void)onLog:(NSString*)log logLevel:(WXLogLevel)level;
@end
#pragma mark - WXApi
@interface WXApi : NSObject
+ (BOOL)registerApp:(NSString *)appid universalLink:(NSString *)universalLink;
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(nullable id<WXApiDelegate>)delegate;
+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity delegate:(nullable id<WXApiDelegate>)delegate;
+ (BOOL)isWXAppInstalled;
+ (BOOL)isWXAppSupportApi;
+ (NSString *)getWXAppInstallUrl;
+ (NSString *)getApiVersion;
+ (BOOL)openWXApp;
+ (void)sendReq:(BaseReq *)req completion:(void (^ __nullable)(BOOL success))completion;
+ (void)sendResp:(BaseResp*)resp completion:(void (^ __nullable)(BOOL success))completion;
+ (void)sendAuthReq:(SendAuthReq *)req viewController:(UIViewController*)viewController delegate:(nullable id<WXApiDelegate>)delegate completion:(void (^ __nullable)(BOOL success))completion;
+ (void)checkUniversalLinkReady:(nonnull WXCheckULCompletion)completion;
+ (void)startLogByLevel:(WXLogLevel)level logBlock:(WXLogBolock)logBlock;
+ (void)startLogByLevel:(WXLogLevel)level logDelegate:(id<WXApiLogDelegate>)logDelegate;
+ (void)stopLog;
@end
NS_ASSUME_NONNULL_END