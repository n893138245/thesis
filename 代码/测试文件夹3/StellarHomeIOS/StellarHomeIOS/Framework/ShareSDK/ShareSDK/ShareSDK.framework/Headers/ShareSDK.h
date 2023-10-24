#import <Foundation/Foundation.h>
#import "SSDKRegister.h"
#import "NSMutableDictionary+SSDKShare.h"
#import "SSDKDataModel.h"
#import "SSDKUser.h"
#import "SSDKCredential.h"
#import "SSDKSession.h"
#import "SSDKImage.h"
#import "SSDKContentEntity.h"
#import "SSDKAuthViewStyle.h"
#import "NSMutableDictionary+SSDKInit.h" 
#import "SSDKShareVideoModel.h"
@interface ShareSDK : NSObject
#pragma mark - 初始化
+ (void)registPlatforms:(void(^)(SSDKRegister *platformsRegister))importHandler;
#pragma mark - 授权
+ (SSDKSession *)authorize:(SSDKPlatformType)platformType
                  settings:(NSDictionary *)settings
            onStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler;
+ (BOOL)hasAuthorized:(SSDKPlatformType)platformTypem;
+ (void)cancelAuthorize:(SSDKPlatformType)platformType result:(void(^)(NSError *error))result;
#pragma mark - 用户
+ (SSDKSession *)getUserInfo:(SSDKPlatformType)platformType
              onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;
#pragma mark - 分享
+ (SSDKSession *)share:(SSDKPlatformType)platformType
            parameters:(NSMutableDictionary *)parameters
        onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler;
+ (SSDKSession *)shareByActivityViewController:(SSDKPlatformType)platformType
            parameters:(NSMutableDictionary *)parameters
        onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler;
#pragma mark - Deprecated
typedef void(^SSDKImportHandler) (SSDKPlatformType platformType) __deprecated_msg("Discard form v4.2.0");
typedef void(^SSDKConfigurationHandler) (SSDKPlatformType platformType, NSMutableDictionary *appInfo) __deprecated_msg("Discard form v4.2.0");
+ (void)registerActivePlatforms:(NSArray *)activePlatforms
                       onImport:(SSDKImportHandler)importHandler
                onConfiguration:(SSDKConfigurationHandler)configurationHandler __deprecated_msg("Discard form v4.2.0. Use 'registPlatforms:' instead.");
+ (void)cancelAuthorize:(SSDKPlatformType)platformType __deprecated_msg("Discard form v4.2.0. Use 'cancelAuthorize:result:' instead.");
@end