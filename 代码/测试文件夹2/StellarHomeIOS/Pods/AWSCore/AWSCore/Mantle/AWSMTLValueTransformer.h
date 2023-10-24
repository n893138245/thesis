#import <Foundation/Foundation.h>
typedef id (^AWSMTLValueTransformerBlock)(id);
@interface AWSMTLValueTransformer : NSValueTransformer
+ (instancetype)transformerWithBlock:(AWSMTLValueTransformerBlock)transformationBlock;
+ (instancetype)reversibleTransformerWithBlock:(AWSMTLValueTransformerBlock)transformationBlock;
+ (instancetype)reversibleTransformerWithForwardBlock:(AWSMTLValueTransformerBlock)forwardBlock reverseBlock:(AWSMTLValueTransformerBlock)reverseBlock;
@end