#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface DCAAccountCommonUtil : NSObject
+ (NSString *)genCodeChallenge:(NSString *)codeVerifier;
+ (NSString *)genCodeVerifier;
+ (NSMutableDictionary*)dictionaryWithJsonString:(NSString *)jsonString;
+(void)catchJsLog:(UIWebView *)webView;
@end
NS_ASSUME_NONNULL_END