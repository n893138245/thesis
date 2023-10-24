#ifndef UTDIDDevice_h
#define UTDIDDevice_h
#import <Foundation/Foundation.h>
@protocol AidProtocolDelegate;
NS_ASSUME_NONNULL_BEGIN
@interface UTDevice : NSObject
+(NSString *) utdid;
+(NSString *) aid:(NSString *)appName
            token:(NSString *)token;
+(void) aidAsync:(NSString *)appName
                 token:(NSString *)token
           aidDelegate:(id<AidProtocolDelegate> )aidDelegate;
@end
NS_ASSUME_NONNULL_END
#endif