#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString *const AWSValidationErrorDomain;
typedef NS_ENUM(NSInteger, AWSValidationErrorType) {
    AWSValidationUnknownError, 
    AWSValidationUnexpectedParameter, 
    AWSValidationUnhandledType,
    AWSValidationMissingRequiredParameter,
    AWSValidationOutOfRangeParameter,
    AWSValidationInvalidStringParameter,
    AWSValidationUnexpectedStringParameter,
    AWSValidationInvalidParameterType,
    AWSValidationInvalidBase64Data,
    AWSValidationHeaderTargetInvalid,
    AWSValidationHeaderAPIActionIsUndefined,
    AWSValidationHeaderDefinitionFileIsNotFound,
    AWSValidationHeaderDefinitionFileIsEmpty,
    AWSValidationHeaderAPIActionIsInvalid,
    AWSValidationURIIsInvalid
};