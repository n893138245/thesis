#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MOBFErrorTagMsgType){
    MOBFErrorTagMsgTypeGetTagEmpty          = 109996,
    MOBFErrorTagMsgTypeGetTagFailed         = 109997,
    MOBFErrorTagMsgTypeCharacterLimitError  = 109998,
    MOBFErrorTagMsgTypeInvalidParamError    = 109999,
};
@interface MOBFTagService : NSObject
+ (void)tagUserUpload:(NSDictionary *)tags
              result:(void (^)(NSError *error))result;
+ (void)userTags:(void (^) (NSDictionary *userTags, NSError *error))handler;
+ (void)uploadLocation:(CGFloat)accuracy
              latitude:(CGFloat)latitude
             longitude:(CGFloat)longitude
                   tag:(NSDictionary *)tag
                result:(void (^)(NSError *error))result;
@end