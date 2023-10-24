#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface YYTransaction : NSObject
+ (YYTransaction *)transactionWithTarget:(id)target selector:(SEL)selector;
- (void)commit;
@end
NS_ASSUME_NONNULL_END