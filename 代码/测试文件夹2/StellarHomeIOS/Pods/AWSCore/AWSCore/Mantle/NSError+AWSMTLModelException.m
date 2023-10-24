#import "AWSMTLModel.h"
#import "NSError+AWSMTLModelException.h"
static NSString * const AWSMTLModelErrorDomain = @"AWSMTLModelErrorDomain";
static const NSInteger AWSMTLModelErrorExceptionThrown = 1;
static NSString * const AWSMTLModelThrownExceptionErrorKey = @"AWSMTLModelThrownException";
@implementation NSError (AWSMTLModelException)
+ (instancetype)awsmtl_modelErrorWithException:(NSException *)exception {
	NSParameterAssert(exception != nil);
	NSDictionary *userInfo = @{
		NSLocalizedDescriptionKey: exception.description,
		NSLocalizedFailureReasonErrorKey: exception.reason,
		AWSMTLModelThrownExceptionErrorKey: exception
	};
	return [NSError errorWithDomain:AWSMTLModelErrorDomain code:AWSMTLModelErrorExceptionThrown userInfo:userInfo];
}
@end