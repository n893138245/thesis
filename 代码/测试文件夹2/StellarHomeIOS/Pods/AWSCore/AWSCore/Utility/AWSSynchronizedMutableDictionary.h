#import <Foundation/Foundation.h>
@interface AWSSynchronizedMutableDictionary : NSObject
- (id)objectForKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (void)removeObject:(id)object;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (NSArray *)allKeys;
@end