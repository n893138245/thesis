#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSTimer (YYAdd)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
@end
NS_ASSUME_NONNULL_END