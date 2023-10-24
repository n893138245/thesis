#import <Foundation/Foundation.h>
@interface MOBFDebug : NSObject
+ (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
+ (void)watchDeallocObjectWithType:(Class)type;
@end