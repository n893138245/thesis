#import <Foundation/Foundation.h>
#import "AWSTMDiskCache.h"
#import "AWSTMMemoryCache.h"
@class AWSTMCache;
typedef void (^AWSTMCacheBlock)(AWSTMCache *cache);
typedef void (^AWSTMCacheObjectBlock)(AWSTMCache *cache, NSString *key, id object);
@interface AWSTMCache : NSObject
#pragma mark -
@property (readonly) NSString *name;
@property (readonly) dispatch_queue_t queue;
@property (readonly) NSUInteger diskByteCount;
@property (readonly) AWSTMDiskCache *diskCache;
@property (readonly) AWSTMMemoryCache *memoryCache;
#pragma mark -
+ (instancetype)sharedCache;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name rootPath:(NSString *)rootPath;
#pragma mark -
- (void)objectForKey:(NSString *)key block:(AWSTMCacheObjectBlock)block;
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(AWSTMCacheObjectBlock)block;
- (void)removeObjectForKey:(NSString *)key block:(AWSTMCacheObjectBlock)block;
- (void)trimToDate:(NSDate *)date block:(AWSTMCacheBlock)block;
- (void)removeAllObjects:(AWSTMCacheBlock)block;
#pragma mark -
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)trimToDate:(NSDate *)date;
- (void)removeAllObjects;
@end