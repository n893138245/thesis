#import <MOBFoundation/MobSDK.h>
#import <UIKit/UIKit.h>
#ifndef MobSDK_Privacy_h
#define MobSDK_Privacy_h
@interface MobSDK (Privacy)
+ (void)getPrivacyPolicy:(NSString * _Nullable)type
             compeletion:(void (^ _Nullable)(NSDictionary * _Nullable data,NSError * _Nullable error))result DEPRECATED_MSG_ATTRIBUTE("use -[getPrivacyPolicy:language:compeletion:] method instead.");
+ (void)getPrivacyPolicy:(NSString * _Nullable)type
                language:(NSString * _Nullable)language
             compeletion:(void (^ _Nullable)(NSDictionary * _Nullable data,NSError * _Nullable error))result;
+ (void)uploadPrivacyPermissionStatus:(BOOL)isAgree
                             onResult:(void (^_Nullable)(BOOL success))handler;
+ (void)setAllowShowPrivacyWindow:(BOOL)show  DEPRECATED_MSG_ATTRIBUTE("deprecated");
+ (void)setPrivacyBackgroundColor:(UIColor *_Nullable)backColor
             operationButtonColor:(NSArray <UIColor *>*_Nullable)colors  DEPRECATED_MSG_ATTRIBUTE("deprecated");
@end
#endif 