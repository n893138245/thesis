#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, SSDKCredentialType)
{
    SSDKCredentialTypeUnknown = 0,
    SSDKCredentialTypeOAuth1x = 1,
    SSDKCredentialTypeOAuth2  = 2,
    SSDKCredentialTypeSMS = 3,
};
@interface SSDKCredential : SSDKDataModel
@property (nonatomic, copy) NSString *authCode;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, assign) NSTimeInterval expired;
@property (nonatomic) SSDKCredentialType type;
@property (nonatomic, strong) NSDictionary *rawData;
@property (nonatomic, readonly) BOOL available;
@end