#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TBRestPoolService : NSObject
- (instancetype)initWithRequestCountLimit:(NSInteger)requestCountLimit eventId:(int)eventId;
- (instancetype)initWithRequestSizeLimit:(NSInteger)sizeLimit eventId:(int)eventId;
- (void)sendLog:(NSObject*)aPageName arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;
- (void)clean;
@end
NS_ASSUME_NONNULL_END