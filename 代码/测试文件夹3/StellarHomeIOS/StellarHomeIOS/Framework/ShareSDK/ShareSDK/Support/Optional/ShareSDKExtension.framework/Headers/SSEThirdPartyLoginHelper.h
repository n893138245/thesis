#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
@class SSEBaseUser;
typedef void (^SSEUserAssociateHandler) (NSString *linkId, SSDKUser *user, id userData);
typedef void (^SSEUserSyncHandler) (SSDKUser *user, SSEUserAssociateHandler associateHandler);
typedef void (^SSELoginResultHandler) (SSDKResponseState state, SSEBaseUser *user, NSError *error);
@interface SSEThirdPartyLoginHelper : NSObject
+ (void)loginByPlatform:(SSDKPlatformType)platform
             onUserSync:(SSEUserSyncHandler)userSyncHandler
          onLoginResult:(SSELoginResultHandler)loginResultHandler;
+ (BOOL)logout:(SSEBaseUser *)user;
+ (SSEBaseUser *)currentUser;
+ (BOOL)changeUser:(SSEBaseUser *)user;
+ (NSDictionary *)users;
+ (void)setUserClass:(Class)userClass;
@end