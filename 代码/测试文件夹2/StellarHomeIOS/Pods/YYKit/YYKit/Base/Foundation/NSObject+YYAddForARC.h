#import <Foundation/Foundation.h>
@interface NSObject (YYAddForARC)
- (instancetype)arcDebugRetain;
- (oneway void)arcDebugRelease;
- (instancetype)arcDebugAutorelease;
- (NSUInteger)arcDebugRetainCount;
@end