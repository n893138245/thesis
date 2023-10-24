#import "NSValueTransformer+AWSMTLInversionAdditions.h"
#import "AWSMTLValueTransformer.h"
@implementation NSValueTransformer (AWSMTLInversionAdditions)
- (NSValueTransformer *)awsmtl_invertedTransformer {
	NSParameterAssert(self.class.allowsReverseTransformation);
	return [AWSMTLValueTransformer reversibleTransformerWithForwardBlock:^(id value) {
		return [self reverseTransformedValue:value];
	} reverseBlock:^(id value) {
		return [self transformedValue:value];
	}];
}
@end