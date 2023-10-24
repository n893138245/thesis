#import <MOBFoundation/MOBFoundation.h>
#import "IMOBBaseUser.h"
#import "MOBFDataModel.h"
@interface MOBFUser : MOBFDataModel <IMOBBaseUser>
@property (nonatomic, copy, readonly, nullable) NSString * uid;
@property (nonatomic, copy, readonly, nullable) NSString * appUid;
@property (nonatomic, copy, nullable) NSString * avatar;
@property (nonatomic, copy, nullable) NSString * nickname;
@property (nonatomic, copy, nullable) NSString * sign;
@property (nonatomic, strong, nullable) NSDictionary * userdata;
+ (MOBFUser* _Nullable)userWithUid:(NSString * _Nonnull)uid
                            avatar:(NSString * _Nullable)avatar
                          nickname:(NSString * _Nullable)nickname __deprecated_msg("use userWithAppUid:avatar:nickname:userData: method instead.");
+ (MOBFUser* _Nullable)userWithAppUid:(NSString * _Nonnull )appUid
                               avatar:(NSString * _Nullable)avatar
                             nickname:(NSString * _Nullable)nickname
                             userdata:(NSDictionary * _Nullable)userdata;
+ (MOBFUser* _Nullable)userWithAppUid:(NSString * _Nonnull )appUid
                               avatar:(NSString * _Nullable)avatar
                             nickname:(NSString * _Nullable)nickname
                                 sign:(NSString * _Nullable)sign
                             userdata:(NSDictionary * _Nullable)userdata;
@end