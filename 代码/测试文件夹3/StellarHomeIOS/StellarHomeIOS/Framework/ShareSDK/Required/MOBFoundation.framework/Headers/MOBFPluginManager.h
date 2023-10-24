#import <Foundation/Foundation.h>
#import "IMOBFPlugin.h"
typedef id<IMOBFPlugin>(^MOBFPluginConstructHandler) ();
@interface MOBFPluginManager : NSObject
+ (instancetype) defaultManager;
- (BOOL)registerPlugin:(MOBFPluginConstructHandler)pluginConstructHandler forKey:(NSString *)key;
- (BOOL)isRegisterPluginForKey:(NSString *)key;
- (id<IMOBFPlugin>)pluginForKey:(NSString *)key;
- (void)unloadPluginForKey:(NSString *)key;
@end