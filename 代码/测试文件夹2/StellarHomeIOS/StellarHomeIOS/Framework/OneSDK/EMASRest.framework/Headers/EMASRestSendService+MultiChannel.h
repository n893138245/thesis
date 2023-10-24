#import "EMASRestSendService.h"
#import "EMASRestConfiguration.h"
NS_ASSUME_NONNULL_BEGIN
@interface EMASRestSendService (MultiChannel)
+ (void)sendLogAsyncWithConfiguration:(EMASRestConfiguration*)configuration aPageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;
+ (BOOL)sendLogSyncWithConfiguration:(EMASRestConfiguration*)configuration aPageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString *) aArg1 arg2:(NSString *) aArg2 arg3:(NSString *) aArg3 args:(NSDictionary *) aArgs;
@end
NS_ASSUME_NONNULL_END