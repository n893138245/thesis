#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (YYAdd)
#pragma mark - Sending messages with variable parameters
- (nullable id)performSelectorWithArgs:(SEL)sel, ...;
- (void)performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;
- (nullable id)performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...;
- (nullable id)performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thread waitUntilDone:(BOOL)wait, ...;
- (void)performSelectorWithArgsInBackground:(SEL)sel, ...;
- (void)performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay;
#pragma mark - Swap method (Swizzling)
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;
#pragma mark - Associate value
- (void)setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key;
- (nullable id)getAssociatedValueForKey:(void *)key;
- (void)removeAssociatedValues;
#pragma mark - Others
+ (NSString *)className;
- (NSString *)className;
- (nullable id)deepCopy;
- (nullable id)deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;
@end
NS_ASSUME_NONNULL_END