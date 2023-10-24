#import "EMASRestCacheConfig.h"
@interface EMASRestManager : NSObject
+ (void)turnOnDebug;
+ (void)addRestCacheConfigs:(EMASRestCacheConfig *)config;
+ (void)sendLogAsyncWithConfiguration:(EMASRestCacheConfig *)config aPageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;
@end