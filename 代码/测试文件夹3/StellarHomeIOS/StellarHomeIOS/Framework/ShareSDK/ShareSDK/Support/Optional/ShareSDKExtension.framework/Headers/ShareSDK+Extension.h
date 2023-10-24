#import <ShareSDK/ShareSDK.h>
#import "SSETypeDefine.h"
#import <ShareSDKExtension/SSERestoreSceneHeader.h>
@interface ShareSDK (Extension)
+ (BOOL)isClientInstalled:(SSDKPlatformType)platformType;
+ (void)openAppUrl:(SSDKPlatformType)platformType;
+ (SSDKUser *)currentUser:(SSDKPlatformType)platformType;
+ (void)setCurrentUser:(SSDKUser *)user forPlatformType:(SSDKPlatformType)platformType;
+ (SSDKUser *)userByRawData:(NSDictionary *)userRawData credential:(NSDictionary *)credentialRawData forPlatformType:(SSDKPlatformType)platformType;
+ (void)addFriend:(SSDKPlatformType)platformType
             user:(SSDKUser *)user
   onStateChanged:(SSDKAddFriendStateChangedHandler)stateChangedHandler;
+ (void)getFriends:(SSDKPlatformType)platformType
            cursor:(NSInteger)cursor
              size:(NSUInteger)size
    onStateChanged:(SSDKGetFriendsStateChangedHandler)stateChangedHandler;
#pragma - mark 原Base层
+ (void)callApi:(SSDKPlatformType)type
            url:(NSString *)url
         method:(NSString *)method
     parameters:(NSMutableDictionary *)parameters
        headers:(NSMutableDictionary *)headers
 onStateChanged:(SSDKCallApiStateChangedHandler)stateChangedHandler;
+ (void)setRestoreSceneDelegate:(id<ISSERestoreSceneDelegate>)delegate;
+ (void)setShareVideoEnable:(BOOL)shareVideoEnable;
+ (void)getCommandText:(NSDictionary *_Nullable)paramters withComplete:(void (^_Nullable) (NSString * _Nullable text, NSError *_Nullable error, void (^ _Nullable complete)(NSString * _Nullable text)))completeHandler;
+ (void)shareVideoWithUrl:(NSURL *_Nullable)videoUrl model:(SSDKShareVideoModel *)model withComplete:(void (^_Nullable)(BOOL success, NSError *_Nullable error))completeHandler;
#pragma mark - 平台自定义参数
+ (void)setAutoLogAppEventsEnabled:(BOOL)enable;
@end