#import <Foundation/Foundation.h>
#import "FBObjectReference.h"
@interface FBObjectInStructReference : NSObject <FBObjectReference>
- (nonnull instancetype)initWithIndex:(NSUInteger)index
                             namePath:(nullable NSArray<NSString *> *)namePath;
@end