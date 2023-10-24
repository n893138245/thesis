#import <Foundation/Foundation.h>
@interface NSArray (AWSMTLManipulationAdditions)
@property (nonatomic, readonly, strong) id awsmtl_firstObject;
- (NSArray *)awsmtl_arrayByRemovingObject:(id)object;
- (NSArray *)awsmtl_arrayByRemovingFirstObject;
- (NSArray *)awsmtl_arrayByRemovingLastObject;
@end