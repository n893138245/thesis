#import "NSObject+AWSMTLComparisonAdditions.h"
BOOL AWSMTLEqualObjects(id obj1, id obj2) {
	return (obj1 == obj2 || [obj1 isEqual:obj2]);
}