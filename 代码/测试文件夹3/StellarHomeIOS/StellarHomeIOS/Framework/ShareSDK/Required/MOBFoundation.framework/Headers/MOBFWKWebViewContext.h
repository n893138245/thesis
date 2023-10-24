#import <Foundation/Foundation.h>
#import "MOBFJSTypeDefine.h"
#import <WebKit/WebKit.h>
#include <JavaScriptCore/JavaScript.h>
NS_ASSUME_NONNULL_BEGIN
@interface MOBFWKWebViewContext : NSObject
@property (nonatomic, strong) WKWebView *webView;
+ (instancetype)defaultContext;
- (instancetype)initWithWKWebView:(WKWebView *)webview;
- (void)registerJSMethod:(NSString *)name block:(MOBFJSMethodIMP)block;
- (NSString *)callJSMethod:(NSString *)name arguments:(NSArray *)arguments;
- (void)setupWKWebViewNewJSParser;
- (void)initWKWebViewDelegate:(WKWebView *)wkWebView;
- (void)loadPluginWithPath:(NSString *)path forName:(NSString *)name;
- (void)loadPlugin:(NSString *)content forName:(NSString *)name;
- (void)runScript:(NSString *)script;
- (void)callback:(NSString *)callback resultData:(NSDictionary *)resultData;
@end
NS_ASSUME_NONNULL_END