#import <Foundation/Foundation.h>
@class SSDKCredential;
typedef NS_ENUM(NSUInteger, SSDKGender)
{
    SSDKGenderMale      = 0,
    SSDKGenderFemale    = 1,
    SSDKGenderUnknown   = 2,
};
@interface SSDKUser : SSDKDataModel
@property (nonatomic) SSDKPlatformType platformType;
@property (nonatomic, strong) SSDKCredential *credential;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic) NSInteger gender;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *aboutMe;
@property (nonatomic) NSInteger verifyType;
@property (nonatomic, copy) NSString *verifyReason;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic) NSInteger followerCount;
@property (nonatomic) NSInteger friendCount;
@property (nonatomic) NSInteger shareCount;
@property (nonatomic) NSTimeInterval regAt;
@property (nonatomic) NSInteger level;
@property (nonatomic, retain) NSArray *educations;
@property (nonatomic, retain) NSArray *works;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSDictionary *rawData;
@end