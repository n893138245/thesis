#import <Foundation/Foundation.h>
@interface NSArray (NBAdditions)
- (id)nb_safeObjectAtIndex:(NSUInteger)index class:(Class)clazz;
- (NSString *)nb_safeStringAtIndex:(NSUInteger)index;
- (NSNumber *)nb_safeNumberAtIndex:(NSUInteger)index;
- (NSArray *)nb_safeArrayAtIndex:(NSUInteger)index;
- (NSData *)nb_safeDataAtIndex:(NSUInteger)index;
@end