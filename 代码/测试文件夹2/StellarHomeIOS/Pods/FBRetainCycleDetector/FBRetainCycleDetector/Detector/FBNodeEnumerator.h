#import <Foundation/Foundation.h>
@class FBObjectiveCGraphElement;
@interface FBNodeEnumerator : NSEnumerator
- (nonnull instancetype)initWithObject:(nonnull FBObjectiveCGraphElement *)object;
- (nullable FBNodeEnumerator *)nextObject;
@property (nonatomic, strong, readonly, nonnull) FBObjectiveCGraphElement *object;
@end