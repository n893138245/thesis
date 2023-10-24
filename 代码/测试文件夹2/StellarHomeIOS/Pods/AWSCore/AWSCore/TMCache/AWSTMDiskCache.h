#import <Foundation/Foundation.h>
@class AWSTMDiskCache;
@protocol AWSTMCacheBackgroundTaskManager;
typedef void (^AWSTMDiskCacheBlock)(AWSTMDiskCache *cache);
typedef void (^AWSTMDiskCacheObjectBlock)(AWSTMDiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL);
@interface AWSTMDiskCache : NSObject
#pragma mark -
@property (readonly) NSString *name;
@property (readonly) NSURL *cacheURL;
@property (readonly) NSUInteger byteCount;
@property (assign) NSUInteger byteLimit;
@property (assign) NSTimeInterval ageLimit;
#pragma mark -
@property (copy) AWSTMDiskCacheObjectBlock willAddObjectBlock;
@property (copy) AWSTMDiskCacheObjectBlock willRemoveObjectBlock;
@property (copy) AWSTMDiskCacheBlock willRemoveAllObjectsBlock;
@property (copy) AWSTMDiskCacheObjectBlock didAddObjectBlock;
@property (copy) AWSTMDiskCacheObjectBlock didRemoveObjectBlock;
@property (copy) AWSTMDiskCacheBlock didRemoveAllObjectsBlock;
#pragma mark -
+ (instancetype)sharedCache;
+ (dispatch_queue_t)sharedQueue;
+ (void)emptyTrash;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name rootPath:(NSString *)rootPath;
#pragma mark -
- (void)objectForKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;
- (void)fileURLForKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;
- (void)removeObjectForKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;
- (void)trimToDate:(NSDate *)date block:(AWSTMDiskCacheBlock)block;
- (void)trimToSize:(NSUInteger)byteCount block:(AWSTMDiskCacheBlock)block;
- (void)trimToSizeByDate:(NSUInteger)byteCount block:(AWSTMDiskCacheBlock)block;
- (void)removeAllObjects:(AWSTMDiskCacheBlock)block;
- (void)enumerateObjectsWithBlock:(AWSTMDiskCacheObjectBlock)block completionBlock:(AWSTMDiskCacheBlock)completionBlock;
#pragma mark -
- (id <NSCoding>)objectForKey:(NSString *)key;
- (NSURL *)fileURLForKey:(NSString *)key;
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)trimToDate:(NSDate *)date;
- (void)trimToSize:(NSUInteger)byteCount;
- (void)trimToSizeByDate:(NSUInteger)byteCount;
- (void)removeAllObjects;
- (void)enumerateObjectsWithBlock:(AWSTMDiskCacheObjectBlock)block;
#pragma mark -
+ (void)setBackgroundTaskManager:(id <AWSTMCacheBackgroundTaskManager>)backgroundTaskManager;
@end