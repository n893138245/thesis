#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TBRestPoolSendService : NSObject
+ (TBRestPoolSendService*)sharedInstance;
- (void)initPool;
- (void)addPoolConfig:(int)eventId requestCountLimit:(int)requestCountLimit;
- (void)addPoolConfig:(int)eventId requestSizeLimit:(int)requestSizeLimit;
- (void)sendLog:(NSString*)page eventId:(int)eventId arg1:(NSString*)arg1 arg2:(NSString*)arg2 arg3:(NSString*)arg3 args:(NSDictionary*)args;
- (void)clean;
@end
NS_ASSUME_NONNULL_END