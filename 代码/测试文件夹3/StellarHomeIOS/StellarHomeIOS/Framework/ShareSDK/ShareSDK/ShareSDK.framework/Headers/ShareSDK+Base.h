#import <ShareSDK/ShareSDK.h>
@class SSDKUserQueryCondition;
@interface ShareSDK (Base)
+ (NSString *)sdkVersion;
+ (NSDictionary *)configWithPlatform:(SSDKPlatformType)platform;
+ (NSMutableArray *)activePlatforms;
+ (SSDKSession *)getUserInfo:(SSDKPlatformType)platformType
                   condition:(SSDKUserQueryCondition *)condition
              onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;
+ (void)recordShareEventWithPlatform:(SSDKPlatformType)platformType eventType:(SSDKShareEventType)eventType;
+ (void)enableAutomaticRecordingEvent:(BOOL)record;
+ (void)enableGetTags:(BOOL)enable;
#pragma mark - Deprecated
typedef void(^SSDKAuthorizeViewDisplayHandler) (UIView *view) __deprecated_msg("Discard form v4.2.0");
typedef void(^SSDKNeedAuthorizeHandler)(SSDKAuthorizeStateChangedHandler authorizeStateChangedHandler) __deprecated_msg("Discard form v4.2.0");
+ (void)authorize:(SSDKPlatformType)platformType
         settings:(NSDictionary *)settings
    onViewDisplay:(SSDKAuthorizeViewDisplayHandler)viewDisplayHandler
   onStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler __deprecated_msg("Discard form v4.2.0");
+ (void)getUserInfo:(SSDKPlatformType)platformType
        conditional:(SSDKUserQueryCondition *)conditional
        onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
     onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler __deprecated_msg("Discard form v4.2.0");
+ (void)share:(SSDKPlatformType)platformType
   parameters:(NSMutableDictionary *)parameters
  onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler __deprecated_msg("Discard form v4.2.0");
@end