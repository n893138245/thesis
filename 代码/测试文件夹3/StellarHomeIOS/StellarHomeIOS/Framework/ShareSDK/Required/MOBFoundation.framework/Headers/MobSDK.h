#import <Foundation/Foundation.h>
#import "MOBSDKDef.h"
@interface MobSDK : NSObject
+ (NSString * _Nonnull)version;
+ (NSString * _Nullable)appKey;
+ (NSString * _Nullable)appSecret;
+ (NSString *_Nullable)getInternationalDomain;
+ (void)setInternationalDomain:(MOBFSDKDomainType)domainType;
+ (void)changeAppSecret:(NSString * _Nonnull)appSecret;
+ (void)registerAppKey:(NSString * _Nonnull)appKey
             appSecret:(NSString * _Nonnull)appSecret;
#pragma mark - User
+ (void)setUserWithUid:(NSString * _Nullable)uid
              nickName:(NSString * _Nullable)nickname
                avatar:(NSString * _Nullable)avatar
              userData:(NSDictionary * _Nullable)userData;
+ (void)setUserWithUid:(NSString * _Nullable)uid
              nickName:(NSString * _Nullable)nickname
                avatar:(NSString * _Nullable)avatar
                  sign:(NSString * _Nullable)sign
              userData:(NSDictionary * _Nullable)userData;
+ (void)clearUser;
@end