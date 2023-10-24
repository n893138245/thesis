#import <Foundation/Foundation.h>
@class AWSTMMemoryCache;
typedef void (^AWSTMMemoryCacheBlock)(AWSTMMemoryCache *cache);
typedef void (^AWSTMMemoryCacheObjectBlock)(AWSTMMemoryCache *cache, NSString *key, id object);
@interface AWSTMMemoryCache : NSObject
#pragma mark -
@property (readonly) dispatch_queue_t queue;
@property (readonly) NSUInteger totalCost;
@property (assign) NSUInteger costLimit;
@property (assign) NSTimeInterval ageLimit;
@property (assign) BOOL removeAllObjectsOnMemoryWarning;
@property (assign) BOOL removeAllObjectsOnEnteringBackground;
#pragma mark -
@property (copy) AWSTMMemoryCacheObjectBlock willAddObjectBlock;
@property (copy) AWSTMMemoryCacheObjectBlock willRemoveObjectBlock;
@property (copy) AWSTMMemoryCacheBlock willRemoveAllObjectsBlock;
@property (copy) AWSTMMemoryCacheObjectBlock didAddObjectBlock;
@property (copy) AWSTMMemoryCacheObjectBlock didRemoveObjectBlock;
@property (copy) AWSTMMemoryCacheBlock didRemoveAllObjectsBlock;
@property (copy) AWSTMMemoryCacheBlock didReceiveMemoryWarningBlock;
@property (copy) AWSTMMemoryCacheBlock didEnterBackgroundBlock;
#pragma mark -
+ (instancetype)sharedCache;
#pragma mark -
- (void)objectForKey:(NSString *)key block:(AWSTMMemoryCacheObjectBlock)block;
- (void)setObject:(id)object forKey:(NSString *)key block:(AWSTMMemoryCacheObjectBlock)block;
- (void)setObject:(id)object forKey:(NSString *)key withCost:(NSUInteger)cost block:(AWSTMMemoryCacheObjectBlock)block;
- (void)removeObjectForKey:(NSString *)key block:(AWSTMMemoryCacheObjectBlock)block;
- (void)trimToDate:(NSDate *)date block:(AWSTMMemoryCacheBlock)block;
- (void)trimToCost:(NSUInteger)cost block:(AWSTMMemoryCacheBlock)block;
- (void)trimToCostByDate:(NSUInteger)cost block:(AWSTMMemoryCacheBlock)block;
- (void)removeAllObjects:(AWSTMMemoryCacheBlock)block;
- (void)enumerateObjectsWithBlock:(AWSTMMemoryCacheObjectBlock)block completionBlock:(AWSTMMemoryCacheBlock)completionBlock;
#pragma mark -
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key withCost:(NSUInteger)cost;
- (void)removeObjectForKey:(NSString *)key;
- (void)trimToDate:(NSDate *)date;
- (void)trimToCost:(NSUInteger)cost;
- (void)trimToCostByDate:(NSUInteger)cost;
- (void)removeAllObjects;
- (void)enumerateObjectsWithBlock:(AWSTMMemoryCacheObjectBlock)block;
- (void)handleMemoryWarning __deprecated_msg("This happens automatically in TMCache 2.1. There’s no longer a need to call it directly.");
- (void)handleApplicationBackgrounding __deprecated_msg("This happens automatically in TMCache 2.1. There’s no longer a need to call it directly.");
@end