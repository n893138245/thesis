#import "NSArray+AWSMTLManipulationAdditions.h"
@interface NSArray (AWSMTLDeclarations)
- (id)firstObject;
@end
@implementation NSArray (AWSMTLManipulationAdditions)
- (id)awsmtl_firstObject {
	return self.firstObject;
}
- (instancetype)awsmtl_arrayByRemovingObject:(id)object {
	NSMutableArray *result = [self mutableCopy];
	[result removeObject:object];
	return result;
}
- (instancetype)awsmtl_arrayByRemovingFirstObject {
	if (self.count == 0) return self;
	return [self subarrayWithRange:NSMakeRange(1, self.count - 1)];
}
- (instancetype)awsmtl_arrayByRemovingLastObject {
	if (self.count == 0) return self;
	return [self subarrayWithRange:NSMakeRange(0, self.count - 1)];
}
@end