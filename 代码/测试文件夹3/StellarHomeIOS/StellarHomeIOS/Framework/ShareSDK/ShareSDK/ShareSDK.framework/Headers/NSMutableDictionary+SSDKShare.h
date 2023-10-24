#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ShareSDK/SSDKTypeDefine.h>
@interface NSMutableDictionary (SSDKShare)
- (void)SSDKSetShareFlags:(NSArray <NSString *>*)flags;
- (void)SSDKSetupShareParamsByText:(NSString *)text
                            images:(id)images
                               url:(NSURL *)url
                             title:(NSString *)title
                              type:(SSDKContentType)type;
- (void)SSDKSetupShareParamsByImageAsset:(NSArray *)imageAsset
                              videoAsset:(id)videoAsset
                          completeHandle:(void(^)(BOOL complete))completeHandle;
#pragma mark - Wechat
- (void)SSDKSetupWeChatParamsByText:(NSString *)text
                              title:(NSString *)title
                                url:(NSURL *)url
                         thumbImage:(id)thumbImage
                              image:(id)image
                       musicFileURL:(NSURL *)musicFileURL
                            extInfo:(NSString *)extInfo
                           fileData:(id)fileData
                       emoticonData:(id)emoticonData
                sourceFileExtension:(NSString *)fileExtension
                     sourceFileData:(id)sourceFileData
                               type:(SSDKContentType)type
                 forPlatformSubType:(SSDKPlatformType)platformSubType;
- (void)SSDKSetupWeChatMiniProgramShareParamsByTitle:(NSString *)title
                                         description:(NSString *)description
                                          webpageUrl:(NSURL *)webpageUrl
                                                path:(NSString *)path
                                          thumbImage:(id)thumbImage
                                        hdThumbImage:(id)hdThumbImage
                                            userName:(NSString *)userName
                                     withShareTicket:(BOOL)withShareTicket
                                     miniProgramType:(NSUInteger)type
                                  forPlatformSubType:(SSDKPlatformType)platformSubType;
#pragma mark - QQ
- (void)SSDKSetupQQParamsByText:(NSString *)text
                          title:(NSString *)title
                            url:(NSURL *)url
                  audioFlashURL:(NSURL *)audioFlashURL
                  videoFlashURL:(NSURL *)videoFlashURL
                     thumbImage:(id)thumbImage
                         images:(id)images
                           type:(SSDKContentType)type
             forPlatformSubType:(SSDKPlatformType)platformSubType;
- (void)SSDKSetupQQMiniProgramShareParamsByTitle:(NSString *)title
                                     description:(NSString *)description
                                      webpageUrl:(NSURL *)webpageUrl
                                    hdThumbImage:(id)hdThumbImage
                                       miniAppID:(NSString *)miniAppID
                                        miniPath:(NSString *)miniPath
                                  miniWebpageUrl:(NSString *)miniWebpageUrl
                                 miniProgramType:(NSUInteger)miniProgramType
                              forPlatformSubType:(SSDKPlatformType)platformSubType;
- (void)SSDKSetupQQParamsByText:(NSString *)text
                          title:(NSString *)title
                            url:(NSURL *)url
                     thumbImage:(id)thumbImage
                          image:(id)image
                           type:(SSDKContentType)type
             forPlatformSubType:(SSDKPlatformType)platformSubType __deprecated_msg("discard form v4.2.0");
#pragma mark - SinaWeibo
- (void)SSDKSetupSinaWeiboShareParamsByText:(NSString *)text
                                      title:(NSString *)title
                                     images:(id)images
                                      video:(NSString *)video
                                        url:(NSURL *)url
                                   latitude:(double)latitude
                                  longitude:(double)longitude
                                   objectID:(NSString *)objectID
                             isShareToStory:(BOOL)shareToStory
                                       type:(SSDKContentType)type;
- (void)SSDKSetupSinaWeiboLinkCardShareParamsByText:(NSString *)text
                                          cardTitle:(NSString *)cardTitle
                                        cardSummary:(NSString *)cardSummary
                                             images:(id)images
                                                url:(NSURL *)url;
#pragma mark - Facebook
- (void)SSDKSetupFacebookParamsByText:(NSString *)text
                                image:(id)image
                                  url:(NSURL *)url
                             urlTitle:(NSString *)title
                              urlName:(NSString *)urlName
                       attachementUrl:(NSURL *)attachementUrl
                                 type:(SSDKContentType)type __deprecated_msg("discard form v4.2.0");
- (void)SSDKSetupFacebookParamsByText:(NSString *)text
                                image:(id)image
                                  url:(NSURL *)url
                             urlTitle:(NSString *)title
                              urlName:(NSString *)urlName
                       attachementUrl:(NSURL *)attachementUrl
                              hashtag:(NSString *)hashtag
                                quote:(NSString *)quote
                            shareType:(SSDKFacebookShareType)shareType
                                 type:(SSDKContentType)type;
- (void)SSDKSetupFacebookParamsByText:(NSString *)text
                                image:(id)image
                                  url:(NSURL *)url
                             urlTitle:(NSString *)title
                              urlName:(NSString *)urlName
                       attachementUrl:(NSURL *)attachementUrl
                              hashtag:(NSString *)hashtag
                                quote:(NSString *)quote
                                showFromVC:(UIViewController *)showFromVC
                            shareType:(SSDKFacebookShareType)shareType
                                 type:(SSDKContentType)type;
- (void)SSDKSetupFacebookParamsByText:(NSString *)text
                                image:(id)image
                                  url:(NSURL *)url
                             urlTitle:(NSString *)title
                              urlName:(NSString *)urlName
                       attachementUrl:(NSURL *)attachementUrl
                              hashtag:(NSString *)hashtag
                                quote:(NSString *)quote
                        sortShareTypes:(NSArray <NSNumber *>*)sortShareTypes
                                 type:(SSDKContentType)type;
- (void)SSDKSetupFacebookParamsByImagePHAsset:(NSArray*)imageAsset
                                 videoPHAsset:(id)videoAsset;
#pragma mark - Facebook Messenger
- (void)SSDKSetupFacebookMessengerParamsByImage:(id)image
                                          video:(id)video
                                           type:(SSDKContentType)type;
- (void)SSDKSetupFacebookMessengerParamsByTitle:(NSString *)title
                                            url:(NSURL *)url
                                         images:(id)images
                                          video:(id)video
                                           type:(SSDKContentType)type;
#pragma mark - Twitter
- (void)SSDKSetupTwitterParamsByText:(NSString *)text
                              images:(id)images
                               video:(NSURL*)video
                            latitude:(double)latitude
                           longitude:(double)longitude
                                type:(SSDKContentType)type;
- (void)SSDKSetupTwitterParamsByText:(NSString *)text
                              images:(id)images
                            latitude:(double)latitude
                           longitude:(double)longitude
                                type:(SSDKContentType)type __deprecated_msg("Discard form v4.2.0, using \"SSDKSetupTwitterParamsByText:images:video:latitude:longitude:type:\" instead.");
- (void)SSDKSetupTwitterParamsByText:(NSString *)text
                               video:(NSURL*)video
                            latitude:(double)latitude
                           longitude:(double)longitude
                                 tag:(NSString *)str __deprecated_msg("Discard form v4.2.0, using \"SSDKSetupTwitterParamsByText:images:video:latitude:longitude:type:\" instead.");
#pragma mark - Instagram
- (void)SSDKSetupInstagramByImage:(id)image
                 menuDisplayPoint:(CGPoint)point;
- (void)SSDKSetupInstagramByVideo:(NSURL *)video;
#pragma mark - DingTalk
- (void)SSDKSetupDingTalkParamsByText:(NSString *)text
                                image:(id)image
                                title:(NSString *)title
                                  url:(NSURL *)url
                                 type:(SSDKContentType)type;
#pragma mark - 支付宝
- (void)SSDKSetupAliSocialParamsByText:(NSString *)text
                                 image:(id)image
                                 title:(NSString *)title
                                   url:(NSURL *)url
                                  type:(SSDKContentType)type
                          platformType:(SSDKPlatformType)platformType;
#pragma mark - Pinterest
- (void)SSDKSetupPinterestParamsByImageUrl:(NSString *)imageUrl
                                   desc:(NSString *)desc
                                    url:(NSURL *)url
                              boardName:(NSString *)boardName;
#pragma mark - Dropbox
- (void)SSDKSetupDropboxParamsByAttachment:(id)attachment;
#pragma mark - 易信
- (void)SSDKSetupYiXinParamsByText:(NSString *)text
                             title:(NSString *)title
                               url:(NSURL *)url
                        thumbImage:(id)thumbImage
                             image:(id)image
                      musicFileURL:(NSURL *)musicFileURL
                   musicLowBandUrl:(id)musicLowBandUrl
                      musicDataUrl:(id)musicDataUrl
               musicLowBandDataUrl:(id)musicLowBandDataUrl
                           extInfo:(NSString *)extInfo
                          fileData:(id)fileData
                   videoLowBandUrl:(id)videoLowBandUrl
                           comment:(NSString *)comment
                          toUserId:(NSString *)userId
                              type:(SSDKContentType)type
                forPlatformSubType:(SSDKPlatformType)platformSubType;
#pragma mark - Flickr
- (void)SSDKSetupFlickrParamsByText:(NSString *)text
                              image:(id)image
                              title:(NSString *)title
                               tags:(NSArray *)tags
                           isPublic:(BOOL)isPublic
                           isFriend:(BOOL)isFriend
                           isFamily:(BOOL)isFamily
                        safetyLevel:(NSInteger)safetyLevel
                        contentType:(NSInteger)contentType
                             hidden:(NSInteger)hidden;
#pragma mark - Instapaper
- (void)SSDKSetupInstapaperParamsByUrl:(NSURL *)url
                                 title:(NSString *)title
                                  desc:(NSString *)desc
                               content:(NSString *)content
                   isPrivateFromSource:(BOOL)isPrivateFromSource
                              folderId:(NSInteger)folderId
                       resolveFinalUrl:(BOOL)resolveFinalUrl;
#pragma mark - Line
- (void)SSDKSetupLineParamsByText:(NSString *)text
                            image:(id)image
                             type:(SSDKContentType)type;
#pragma mark - Evernote
- (void)SSDKSetupEvernoteParamsByText:(NSString *)text
                               images:(id)images
                                video:(NSURL *)video
                                title:(NSString *)title
                             notebook:(NSString *)notebook
                                 tags:(NSArray *)tags
                         platformType:(SSDKPlatformType)platformType;
- (void)SSDKSetupEvernoteParamsByText:(NSString *)text
                               images:(id)images
                                title:(NSString *)title
                             notebook:(NSString *)notebook
                                 tags:(NSArray *)tags
                         platformType:(SSDKPlatformType)platformType __deprecated_msg("discard form v4.2.0");
#pragma mark - Google+
- (void)SSDKSetupGooglePlusParamsByText:(NSString *)text
                                    url:(NSURL *)url
                                   type:(SSDKContentType)type;
#pragma mark - Kakao
- (void)SSDKSetupKaKaoParamsByText:(NSString *)text
                            images:(id)images
                             title:(NSString *)title
                               url:(NSURL *)url
                        permission:(NSString *)permission
                       enableShare:(BOOL)enableShare
                         imageSize:(CGSize)imageSize
                    appButtonTitle:(NSString *)appButtonTitle
                  androidExecParam:(NSDictionary *)androidExecParam
                  androidMarkParam:(NSString *)androidMarkParam
                  iphoneExecParams:(NSDictionary *)iphoneExecParams
                   iphoneMarkParam:(NSString *)iphoneMarkParam
                    ipadExecParams:(NSDictionary *)ipadExecParams
                     ipadMarkParam:(NSString *)ipadMarkParam
                              type:(SSDKContentType)type
                forPlatformSubType:(SSDKPlatformType)platformSubType __deprecated_msg("Discard form v4.2.0. Using 'SSDKSetupKaKaoParamsByTitle:desc:imageURL:url:templateId:templateArgs:' instead.");
- (void)SSDKSetupKaKaoTalkParamsByUrl:(NSURL *)url
                           templateId:(NSString *)templateId
                         templateArgs:(NSDictionary *)templateArgs;
- (void)SSDKSetupKakaoStoryParamsByContent:(NSString *)content
                                     title:(NSString *)title
                                    images:(id)images
                                       url:(NSURL *)url
                                permission:(int)permission
                                  sharable:(BOOL)sharable
                          androidExecParam:(NSDictionary *)androidExecParam
                              iosExecParam:(NSDictionary *)iosExecParam
                                      type:(SSDKContentType)type;
#pragma mark - LinkedIn
- (void)SSDKSetupLinkedInParamsByText:(NSString *)text
                                image:(id)image
                                  url:(NSURL *)url
                                title:(NSString *)title
                              urlDesc:(NSString *)urlDesc
                           visibility:(NSString *)visibility
                                 type:(SSDKContentType)type;
#pragma mark - Tumblr
- (void)SSDKSetupTumblrParamsByText:(NSString *)text
                              image:(id)image
                                url:(NSURL *)url
                              title:(NSString *)title
                           blogName:(NSString *)blogName
                               type:(SSDKContentType)type;
#pragma mark - Pocket
- (void)SSDKSetupPocketParamsByUrl:(NSURL *)url
                             title:(NSString *)title
                              tags:(id)tags
                           tweetId:(NSString *)tweetId;
#pragma mark - SMS
- (void)SSDKSetupSMSParamsByText:(NSString *)text
                           title:(NSString *)title
                          images:(id)images
                     attachments:(id)attachments
                      recipients:(NSArray *)recipients
                            type:(SSDKContentType)type;
#pragma mark - Copy
- (void)SSDKSetupCopyParamsByText:(NSString *)text
                           images:(id)images
                              url:(NSURL *)url
                             type:(SSDKContentType)type;
#pragma mark - 开心网
- (void)SSDKSetupKaiXinParamsByText:(NSString *)text
                              image:(id)image
                               type:(SSDKContentType)type;
#pragma mark - 明道
- (void)SSDKSetupMingDaoParamsByText:(NSString *)text
                               image:(id)image
                                 url:(NSURL *)url
                               title:(NSString *)title
                                type:(SSDKContentType)type;
#pragma mark - VKontakte
- (void)SSDKSetupVKontakteParamsByText:(NSString *)text
                                images:(id)images
                                   url:(NSURL *)url
                               groupId:(NSString *)groupId
                           friendsOnly:(BOOL)friendsOnly
                              latitude:(double)latitude
                             longitude:(double)longitude
                                  type:(SSDKContentType)type;
#pragma mark - YouTube
- (void)SSDKSetupYouTubeParamsByVideo:(id)video
                                title:(NSString *)title
                          description:(NSString *)description
                                 tags:(id)tags
                        privacyStatus:(SSDKPrivacyStatus)privacyStatus;
- (void)SSDKSetupYouTubeParamsByVideo:(id)video
                                parts:(NSString *)parts
                           jsonString:(NSString *)jsonString;
#pragma mark - WhatsApp
- (void)SSDKSetupWhatsAppParamsByText:(NSString *)text
                                image:(id)image
                                audio:(id)audio
                                video:(id)video
                     menuDisplayPoint:(CGPoint)point
                                 type:(SSDKContentType)type;
- (void)SSDKSetupWhatsAppParamsByText:(NSString *)text
                                image:(id)image
                                audio:(id)audio
                                video:(id)video
                     menuDisplayPoint:(CGPoint)point
                            useSystem:(BOOL)useSystem
                                 type:(SSDKContentType)type;
#pragma mark - 邮件 Mail
- (void)SSDKSetupMailParamsByText:(NSString *)text
                            title:(NSString *)title
                           images:(id)images
                      attachments:(id)attachments
                       recipients:(NSArray *)recipients
                     ccRecipients:(NSArray *)ccRecipients
                    bccRecipients:(NSArray *)bccRecipients
                             type:(SSDKContentType)type;
#pragma mark - 有道云笔记
- (void)SSDKSetupYouDaoNoteParamsByText:(NSString *)text
                                 images:(id)images
                                  title:(NSString *)title
                                 source:(NSString *)source
                                 author:(NSString *)author
                               notebook:(NSString *)notebook;
#pragma mark - Telegram
- (void)SSDKSetupTelegramParamsByText:(NSString *)text
                                image:(id)image
                                audio:(NSURL *)audio
                                video:(NSURL *)video
                                 file:(NSURL *)file
                     menuDisplayPoint:(CGPoint)point
                                 type:(SSDKContentType)type;
#pragma mark - 抖音
- (void)SSDKSetupDouyinParamesByAssetLocalIds:(NSArray<NSString *> *)assetLocalIds
                                      hashtag:(NSString *)hashtag
                                    extraInfo:(NSDictionary *)extraInfo
                                         type:(SSDKContentType)type;
- (void)SSDKSetupTikTokParamesByAssetLocalIds:(NSArray<NSString *> *)assetLocalIds
                                      hashtag:(NSString *)hashtag
                                    extraInfo:(NSDictionary *)extraInfo
                                         type:(SSDKContentType)type;
- (void)SSDKSetupWeWorkParamsByText:(NSString *)text
                              title:(NSString *)title
                                url:(NSURL *)url
                         thumbImage:(id)thumbImage
                              image:(id)image
                              video:(id)video
                           fileData:(id)fileData
                               type:(SSDKContentType)type;
- (void)SSDKSetupOasisParamsByTitle:(NSString *)title
                               text:(NSString *)text
                      assetLocalIds:(NSArray <NSString *>*)assetLocalIds
                              image:(id)image
                              video:(NSData *)video
                      fileExtension:(NSString *)fileExtension
                               type:(SSDKContentType)type;
- (void)SSDKSetupSnapChatParamsByCaption:(NSString *)caption
                           attachmentUrl:(NSString *)attachmentUrl
                                   image:(id)image
                                   video:(id)video
                                sticker:(id)sticker
                        stickerAnimated:(BOOL)stickerAnimated
                        stickerRotation:(CGFloat)stickerRotation
                         cameraViewState:(NSInteger)cameraViewState
                                    type:(SSDKContentType)type;
#pragma mark - 快手
- (void)SSDKSetupKuaiShouShareParamsByTitle:(NSString *)title
                                       desc:(NSString *)desc
                                    linkURL:(NSString *)linkURL
                                 thumbImage:(id)thumbImage
                                     openID:(NSString *)openID
                             receiverOpenID:(NSString *)receiverOpenID
                            localIdentifier:(NSString *)localIdentifier
                                       tags:(NSArray<NSString *> *)tags
                                  extraInfo:(NSString *)extraInfo
                                       type:(SSDKContentType)type;
#pragma mark - Deprecated
- (void)SSDKEnableUseClientShare __deprecated_msg("Discard form v4.2.0");
- (void)SSDKEnableExtensionShare __deprecated_msg("Discard form v4.2.0");
@end