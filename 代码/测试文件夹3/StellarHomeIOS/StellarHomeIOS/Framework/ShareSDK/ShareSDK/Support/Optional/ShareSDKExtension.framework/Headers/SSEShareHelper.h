#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
@class SSDKImage;
typedef void(^SSEShareHandler) (SSDKPlatformType platformType, NSMutableDictionary *parameters);
typedef void(^SSEScreenCaptureWillShareHandler) (SSDKImage *image, SSEShareHandler shareHandler);
typedef void(^SSEShakeWillShareHandler) (SSEShareHandler shareHandler);
typedef void(^SSEOneKeyShareStateChangeHandler) (SSDKPlatformType platformType, SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end);
@interface SSEShareHelper : NSObject
+ (void)screenCaptureShare:(SSEScreenCaptureWillShareHandler)willShareHandler
            onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler;
+ (void)beginShakeShare:(void(^)(void))beginShakeHandler
              onEndSake:(void(^)(void))endShakeHandler
     onWillShareHandler:(SSEShakeWillShareHandler)willShareHandler
         onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler;
+ (void)endShakeShare;
@end