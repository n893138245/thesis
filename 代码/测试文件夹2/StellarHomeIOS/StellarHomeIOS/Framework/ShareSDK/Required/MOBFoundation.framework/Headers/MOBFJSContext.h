#import <Foundation/Foundation.h>
#import "MOBFJSTypeDefine.h"
@class JSContext;
@interface MOBFJSContext : NSObject
+ (instancetype)defaultContext;
- (instancetype)initWithContext:(JSContext *)context;
- (void)registerJSMethod:(NSString *)name block:(MOBFJSMethodIMP)block;
- (NSString *)callJSMethod:(NSString *)name arguments:(NSArray *)arguments;
- (void)loadPluginWithPath:(NSString *)path forName:(NSString *)name;
- (void)loadPlugin:(NSString *)content forName:(NSString *)name;
- (void)runScript:(NSString *)script;
@end