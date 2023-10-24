#import <Foundation/Foundation.h>
@interface NSMutableDictionary (SSERestoreScene)
- (void)SSDKSetupShareParamsByText:(NSString *)text
                            images:(id)images
                               url:(NSURL *)url
                             title:(NSString *)title
                      linkParameter:(NSDictionary <NSString *,NSString*>*)linkParameter;
@end