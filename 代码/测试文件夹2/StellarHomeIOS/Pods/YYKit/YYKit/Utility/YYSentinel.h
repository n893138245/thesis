#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface YYSentinel : NSObject
@property (readonly) int32_t value;
- (int32_t)increase;
@end
NS_ASSUME_NONNULL_END