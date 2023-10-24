#ifndef ShareSDK_SSDKTypeDefine_h
#define ShareSDK_SSDKTypeDefine_h
@class SSDKContentEntity;
@class SSDKUser;
typedef NS_ENUM(NSUInteger, SSDKPlatformType){
    SSDKPlatformTypeUnknown             = 0,
    SSDKPlatformTypeSinaWeibo           = 1,
    SSDKPlatformSubTypeQZone            = 6,
    SSDKPlatformTypeKaixin              = 8,
    SSDKPlatformTypeFacebook            = 10,
    SSDKPlatformTypeTwitter             = 11,
    SSDKPlatformTypeYinXiang            = 12,
    SSDKPlatformTypeGooglePlus          = 14,
    SSDKPlatformTypeInstagram           = 15,
    SSDKPlatformTypeLinkedIn            = 16,
    SSDKPlatformTypeTumblr              = 17,
    SSDKPlatformTypeMail                = 18,
    SSDKPlatformTypeSMS                 = 19,
    SSDKPlatformTypePrint               = 20,
    SSDKPlatformTypeCopy                = 21,
    SSDKPlatformSubTypeWechatSession    = 22,
    SSDKPlatformSubTypeWechatTimeline   = 23,
    SSDKPlatformSubTypeQQFriend         = 24,
    SSDKPlatformTypeInstapaper          = 25,
    SSDKPlatformTypePocket              = 26,
    SSDKPlatformTypeYouDaoNote          = 27,
    SSDKPlatformTypePinterest           = 30,
    SSDKPlatformTypeFlickr              = 34,
    SSDKPlatformTypeDropbox             = 35,
    SSDKPlatformTypeVKontakte           = 36,
    SSDKPlatformSubTypeWechatFav        = 37,
    SSDKPlatformSubTypeYiXinSession     = 38,
    SSDKPlatformSubTypeYiXinTimeline    = 39,
    SSDKPlatformSubTypeYiXinFav         = 40,
    SSDKPlatformTypeMingDao             = 41,
    SSDKPlatformTypeLine                = 42,
    SSDKPlatformTypeWhatsApp            = 43,
    SSDKPlatformSubTypeKakaoTalk        = 44,
    SSDKPlatformSubTypeKakaoStory       = 45,
    SSDKPlatformTypeFacebookMessenger   = 46,
    SSDKPlatformTypeTelegram            = 47,
    SSDKPlatformTypeAliSocial           = 50,
    SSDKPlatformTypeAliSocialTimeline   = 51,
    SSDKPlatformTypeDingTalk            = 52,
    SSDKPlatformTypeYouTube             = 53,
    SSDKPlatformTypeReddit              = 56,
    SSDKPlatformTypeFacebookAccount     = 58,
    SSDKPlatformTypeDouyin              = 59,
    SSDKPlatformTypeTikTokChina         = SSDKPlatformTypeDouyin,
    SSDKPlatformTypeWework              = 60,
    SSDKPlatformTypeAppleAccount        = 61,
    SSDKPlatformTypeTikTok              = 70,
    SSDKPlatformTypeOasis               = 64,
    SSDKPlatformTypeSnapChat              = 66,
    SSDKPlatformTypeKuaiShou              = 68,
    SSDKPlatformTypeWatermelonVideo       = 69,
    SSDKPlatformTypeYiXin               = 994,
    SSDKPlatformTypeKakao               = 995,
    SSDKPlatformTypeEvernote            = 996,
    SSDKPlatformTypeWechat              = 997,
    SSDKPlatformTypeQQ                  = 998,
    SSDKPlatformTypeAny                 = 999
};
typedef NS_ENUM(NSUInteger, SSDKEvernoteHostType){
    SSDKEvernoteHostTypeSandbox         = 0,
    SSDKEvernoteHostTypeCN              = 1,
    SSDKEvernoteHostTypeUS              = 2,
};
typedef NS_ENUM(NSUInteger, SSDKResponseState){
    SSDKResponseStateBegin      = 0,
    SSDKResponseStateSuccess    = 1,
    SSDKResponseStateFail       = 2,
    SSDKResponseStateCancel     = 3,
    SSDKResponseStateUpload     = 4,
    SSDKResponseStatePlatformCancel     = 5,
};
typedef NS_ENUM(NSUInteger, SSDKContentType){
    SSDKContentTypeAuto         = 0,
    SSDKContentTypeText         = 1,
    SSDKContentTypeImage        = 2,
    SSDKContentTypeWebPage      = 3,
    SSDKContentTypeApp          = 4,
    SSDKContentTypeAudio        = 5,
    SSDKContentTypeVideo        = 6,
    SSDKContentTypeFile         = 7,
    SSDKContentTypeFBMessageImages = 8,
    SSDKContentTypeFBMessageVideo = 9,
    SSDKContentTypeMiniProgram  = 10,
    SSDKContentTypeMessage  = 11
};
typedef NS_ENUM(NSUInteger, SSDKAuthorizeType) {
    SSDKAuthorizeTypeSSO,
    SSDKAuthorizeTypeWeb,
    SSDKAuthorizeTypeBoth,
};
typedef NS_ENUM(NSUInteger, SSDKShareEventType) {
    SSDKShareEventTypeOpenMenu,
    SSDKShareEventTypeCloseMenu,
    SSDKShareEventTypeOpenEditor,
    SSDKShareEventTypeFailed,
    SSDKShareEventTypeCancel
};
typedef NS_ENUM(NSUInteger, SSDKUploadState) {
    SSDKUploadStateBegin = 1,
    SSDKUploadStateUploading,
    SSDKUploadStateFinish,
};
typedef NS_ENUM(NSUInteger, SSDKPrivacyStatus){
    SSDKPrivacyStatusPublic = 0,
    SSDKPrivacyStatusPrivate = 1,
    SSDKPrivacyStatusUnlisted = 2
};
typedef NS_ENUM(NSUInteger, SSDKFacebookShareType){
    SSDKFacebookShareTypeNative = 1,
    SSDKFacebookShareTypeShareSheet,
    SSDKFacebookShareTypeBrowser,
    SSDKFacebookShareTypeWeb,
    SSDKFacebookShareTypeFeedBrowser,
    SSDKFacebookShareTypeFeedWeb
};
typedef void(^SSDKAuthorizeStateChangedHandler) (SSDKResponseState state, SSDKUser *user, NSError *error);
typedef void(^SSDKGetUserStateChangedHandler) (SSDKResponseState state, SSDKUser *user, NSError *error);
typedef void(^SSDKShareStateChangedHandler) (SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity,  NSError *error);
extern NSString * SSDKShareUserDataHandleOpenObjectKey;
extern NSString * SSDKShareFacebookAutoLogEnableNotification;
extern NSString * SSDKShareFacebookAutoLogEnableKey;
#endif