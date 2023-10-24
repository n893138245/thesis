#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
enum  WXErrCode {
    WXSuccess           = 0,    
    WXErrCodeCommon     = -1,   
    WXErrCodeUserCancel = -2,   
    WXErrCodeSentFail   = -3,   
    WXErrCodeAuthDeny   = -4,   
    WXErrCodeUnsupport  = -5,   
};
enum WXScene {
    WXSceneSession          = 0,   
    WXSceneTimeline         = 1,   
    WXSceneFavorite         = 2,   
    WXSceneSpecifiedSession = 3,   
};
enum WXAPISupport {
    WXAPISupportSession = 0,
};
enum WXBizProfileType {
    WXBizProfileType_Normal = 0,    
    WXBizProfileType_Device = 1,    
};
typedef NS_ENUM(NSUInteger, WXMiniProgramType) {
    WXMiniProgramTypeRelease = 0,       
    WXMiniProgramTypeTest = 1,        
    WXMiniProgramTypePreview = 2,         
};
enum WXMPWebviewType {
    WXMPWebviewType_Ad = 0,        
};
typedef NS_ENUM(NSInteger,WXLogLevel) {
    WXLogLevelNormal = 0,      
    WXLogLevelDetail = 1,      
};
typedef void(^WXLogBolock)(NSString *log);
typedef NS_ENUM(NSInteger, WXULCheckStep)
{
    WXULCheckStepParams,
    WXULCheckStepSystemVersion,
    WXULCheckStepWechatVersion,
    WXULCheckStepSDKInnerOperation,
    WXULCheckStepLaunchWechat,
    WXULCheckStepBackToCurrentApp,
    WXULCheckStepFinal,
};
#pragma mark - WXCheckULStepResult
@interface WXCheckULStepResult : NSObject
@property(nonatomic, assign) BOOL success;
@property(nonatomic, strong) NSString* errorInfo;
@property(nonatomic, strong) NSString* suggestion;
- (instancetype)initWithCheckResult:(BOOL)success errorInfo:(nullable NSString*)errorInfo suggestion:(nullable NSString*)suggestion;
@end
typedef void(^WXCheckULCompletion)(WXULCheckStep step, WXCheckULStepResult* result);
#pragma mark - BaseReq
@interface BaseReq : NSObject
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *openID;
@end
#pragma mark - BaseResp
@interface BaseResp : NSObject
@property (nonatomic, assign) int errCode;
@property (nonatomic, copy) NSString *errStr;
@property (nonatomic, assign) int type;
@end
#pragma mark - WXMediaMessage
@class WXMediaMessage;
#pragma mark - SendAuthReq
@interface SendAuthReq : BaseReq
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *state;
@end
#pragma mark - SendAuthResp
@interface SendAuthResp : BaseResp
@property (nonatomic, copy, nullable) NSString *code;
@property (nonatomic, copy, nullable) NSString *state;
@property (nonatomic, copy, nullable) NSString *lang;
@property (nonatomic, copy, nullable) NSString *country;
@end
#pragma mark - SendMessageToWXReq
@interface SendMessageToWXReq : BaseReq
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) WXMediaMessage *message;
@property (nonatomic, assign) BOOL bText;
@property (nonatomic, assign) int scene;
@property (nonatomic, copy, nullable) NSString *toUserOpenId;
@end
#pragma mark - SendMessageToWXResp
@interface SendMessageToWXResp : BaseResp
@property(nonatomic, copy) NSString *lang;
@property(nonatomic, copy) NSString *country;
@end
#pragma mark - GetMessageFromWXReq
@interface GetMessageFromWXReq : BaseReq
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *country;
@end
#pragma mark - GetMessageFromWXResp
@interface GetMessageFromWXResp : BaseResp
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) WXMediaMessage *message;
@property (nonatomic, assign) BOOL bText;
@end
#pragma mark - ShowMessageFromWXReq
@interface ShowMessageFromWXReq : BaseReq
@property (nonatomic, strong) WXMediaMessage *message;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *country;
@end
#pragma mark - ShowMessageFromWXResp
@interface ShowMessageFromWXResp : BaseResp
@end
#pragma mark - LaunchFromWXReq
@interface LaunchFromWXReq : BaseReq
@property (nonatomic, strong) WXMediaMessage *message;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *country;
@end
#pragma mark - OpenWebviewReq
@interface OpenWebviewReq : BaseReq
@property(nonatomic, copy) NSString *url;
@end
#pragma mark - OpenWebviewResp
@interface OpenWebviewResp : BaseResp
@end
#pragma mark - WXOpenBusinessWebViewReq
@interface WXOpenBusinessWebViewReq : BaseReq
@property (nonatomic, assign) UInt32 businessType;
@property (nonatomic, strong, nullable) NSDictionary *queryInfoDic;
@end
#pragma mark - WXOpenBusinessWebViewResp
@interface WXOpenBusinessWebViewResp : BaseResp
@property (nonatomic, copy) NSString *result;
@property (nonatomic, assign) UInt32 businessType;
@end
#pragma mark - OpenRankListReq
@interface OpenRankListReq : BaseReq
@end
#pragma mark - OpenRanklistResp
@interface OpenRankListResp : BaseResp
@end
#pragma mark - WXCardItem
@interface WXCardItem : NSObject
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy, nullable) NSString *extMsg;
@property (nonatomic, assign) UInt32 cardState;
@property (nonatomic, copy) NSString *encryptCode;
@property (nonatomic, copy) NSString *appID;
@end;
#pragma mark - WXInvoiceItem
@interface WXInvoiceItem : NSObject
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy, nullable) NSString *extMsg;
@property (nonatomic, assign) UInt32 cardState;
@property (nonatomic, copy) NSString *encryptCode;
@property (nonatomic, copy) NSString *appID;
@end
#pragma mark - AddCardToWXCardPackageReq
@interface AddCardToWXCardPackageReq : BaseReq
@property (nonatomic, strong) NSArray *cardAry;
@end
#pragma mark - AddCardToWXCardPackageResp
@interface AddCardToWXCardPackageResp : BaseResp
@property (nonatomic, strong) NSArray *cardAry;
@end
#pragma mark - WXChooseCardReq
@interface WXChooseCardReq : BaseReq
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, assign) UInt32 shopID;
@property (nonatomic, assign) UInt32 canMultiSelect;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *cardTpID;
@property (nonatomic, copy) NSString *signType;
@property (nonatomic, copy) NSString *cardSign;
@property (nonatomic, assign) UInt32 timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@end
#pragma mark - WXChooseCardResp
@interface WXChooseCardResp : BaseResp
@property (nonatomic, strong ) NSArray* cardAry;
@end
#pragma mark - WXChooseInvoiceReq
@interface WXChooseInvoiceReq : BaseReq
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, assign) UInt32 shopID;
@property (nonatomic, copy) NSString *signType;
@property (nonatomic, copy) NSString *cardSign;
@property (nonatomic, assign) UInt32 timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@end
#pragma mark - WXChooseInvoiceResp
@interface WXChooseInvoiceResp : BaseResp
@property (nonatomic, strong) NSArray* cardAry;
@end
#pragma mark - WXSubscriptionReq
@interface WXSubscribeMsgReq : BaseReq
@property (nonatomic, assign) UInt32 scene;
@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy, nullable) NSString *reserved;
@end
#pragma mark - WXSubscriptionReq
@interface WXSubscribeMsgResp : BaseResp
@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, assign) UInt32 scene;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *reserved;
@property (nonatomic, copy, nullable) NSString *openId;
@end
#pragma mark - WXSubscribeMiniProgramMsg
@interface WXSubscribeMiniProgramMsgReq : BaseReq
@property (nonatomic, copy) NSString *miniProgramAppid;
@end
#pragma mark - WXSubscriptionReq
@interface WXSubscribeMiniProgramMsgResp : BaseResp
@property(nonatomic, copy) NSString *openId;   
@property(nonatomic, copy) NSString *unionId;  
@property(nonatomic, copy) NSString *nickName; 
@end
#pragma mark - WXinvoiceAuthInsertReq
@interface WXInvoiceAuthInsertReq : BaseReq
@property (nonatomic, copy) NSString *urlString;
@end
#pragma mark - WXinvoiceAuthInsertResp
@interface WXInvoiceAuthInsertResp : BaseResp
@property (nonatomic, copy) NSString *wxOrderId;
@end
#pragma mark - WXMediaMessage
@interface WXMediaMessage : NSObject
+ (WXMediaMessage *)message;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong, nullable) NSData *thumbData;
@property (nonatomic, copy, nullable) NSString *mediaTagName;
@property (nonatomic, copy, nullable) NSString *messageExt;
@property (nonatomic, copy, nullable) NSString *messageAction;
@property (nonatomic, strong) id mediaObject;
- (void)setThumbImage:(UIImage *)image;
@end
#pragma mark - WXImageObject
@interface WXImageObject : NSObject
+ (WXImageObject *)object;
@property (nonatomic, strong) NSData *imageData;
@end
#pragma mark - WXMusicObject
@interface WXMusicObject : NSObject
+ (WXMusicObject *)object;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, copy) NSString *musicLowBandUrl;
@property (nonatomic, copy) NSString *musicDataUrl;
@property (nonatomic, copy) NSString *musicLowBandDataUrl;
@property (nonatomic, copy) NSString *songAlbumUrl;
@property (nonatomic, copy, nullable) NSString *songLyric;
@end
#pragma mark - WXVideoObject
@interface WXVideoObject : NSObject
+ (WXVideoObject *)object;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoLowBandUrl;
@end
#pragma mark - WXWebpageObject
@interface WXWebpageObject : NSObject
+ (WXWebpageObject *)object;
@property (nonatomic, copy) NSString *webpageUrl;
@end
#pragma mark - WXAppExtendObject
@interface WXAppExtendObject : NSObject
+ (WXAppExtendObject *)object;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy, nullable) NSString *extInfo;
@property (nonatomic, strong, nullable) NSData *fileData;
@end
#pragma mark - WXEmoticonObject
@interface WXEmoticonObject : NSObject
+ (WXEmoticonObject *)object;
@property (nonatomic, strong) NSData *emoticonData;
@end
#pragma mark - WXFileObject
@interface WXFileObject : NSObject
+ (WXFileObject *)object;
@property (nonatomic, copy) NSString *fileExtension;
@property (nonatomic, strong) NSData *fileData;
@end
#pragma mark - WXLocationObject
@interface WXLocationObject : NSObject
+ (WXLocationObject *)object;
@property (nonatomic, assign) double lng; 
@property (nonatomic, assign) double lat; 
@end
#pragma mark - WXTextObject
@interface WXTextObject : NSObject
+ (WXTextObject *)object;
@property (nonatomic, copy) NSString *contentText;
@end
#pragma mark - WXMiniProgramObject
@interface WXMiniProgramObject : NSObject
+ (WXMiniProgramObject *)object;
@property (nonatomic, copy) NSString *webpageUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy, nullable) NSString *path;
@property (nonatomic, strong, nullable) NSData *hdImageData;
@property (nonatomic, assign) BOOL withShareTicket;
@property (nonatomic, assign) WXMiniProgramType miniProgramType;
@property (nonatomic, assign) BOOL disableForward;
@end
#pragma mark - WXLaunchMiniProgramReq
@interface WXLaunchMiniProgramReq : BaseReq
+ (WXLaunchMiniProgramReq *)object;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy, nullable) NSString *path;
@property (nonatomic, assign) WXMiniProgramType miniProgramType;
@property (nonatomic, copy, nullable) NSString *extMsg;
@property (nonatomic, copy, nullable) NSDictionary *extDic;
@end
#pragma mark - WXLaunchMiniProgramResp
@interface WXLaunchMiniProgramResp : BaseResp
@property (nonatomic, copy, nullable) NSString *extMsg;
@end
#pragma mark - WXOpenBusinessViewReq
@interface WXOpenBusinessViewReq : BaseReq
+ (WXOpenBusinessViewReq *)object;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy, nullable) NSString *query;
@property (nonatomic, copy, nullable) NSString *extInfo;
@property (nonatomic, strong, nullable) NSData *extData;
@end
@interface WXOpenBusinessViewResp : BaseResp
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy, nullable) NSString *extMsg;
@end
NS_ASSUME_NONNULL_END