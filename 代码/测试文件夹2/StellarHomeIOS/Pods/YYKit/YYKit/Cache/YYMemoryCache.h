#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface YYMemoryCache : NSObject
#pragma mark - Attribute
@property (nullable, copy) NSString *name;
@property (readonly) NSUInteger totalCount;
@property (readonly) NSUInteger totalCost;
#pragma mark - Limit
@property NSUInteger countLimit;
@property NSUInteger costLimit;
@property NSTimeInterval ageLimit;
@property NSTimeInterval autoTrimInterval;
@property BOOL shouldRemoveAllObjectsOnMemoryWarning;
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;
@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(YYMemoryCache *cache);
@property (nullable, copy) void(^didEnterBackgroundBlock)(YYMemoryCache *cache);
@property BOOL releaseOnMainThread;
@property BOOL releaseAsynchronously;
#pragma mark - Access Methods
- (BOOL)containsObjectForKey:(id)key;
- (nullable id)objectForKey:(id)key;
- (void)setObject:(nullable id)object forKey:(id)key;
- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;
#pragma mark - Trim
- (void)trimToCount:(NSUInteger)count;
- (void)trimToCost:(NSUInteger)cost;
- (void)trimToAge:(NSTimeInterval)age;
@end
NS_ASSUME_NONNULL_END