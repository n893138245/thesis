#import <Foundation/Foundation.h>
@protocol FBObjectReference <NSObject>
- (NSUInteger)indexInIvarLayout;
- (nullable id)objectReferenceFromObject:(nullable id)object;
- (nullable NSArray<NSString *> *)namePath;
@end