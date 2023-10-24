#import <Foundation/Foundation.h>
@interface AppMonitorBase : NSObject
+ (void)setWriteLogInterval:(NSInteger)writeLogInterval;
+ (NSInteger)writeLogInterval;
+ (void)flushAllLog;
@end