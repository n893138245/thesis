#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString *const AWSXMLBuilderErrorDomain;
typedef NS_ENUM(NSInteger, AWSXMLBuilderErrorType) {
    AWSXMLBuilderUnknownError = 900, 
    AWSXMLBuilderDefinitionFileIsEmpty = 901,
    AWSXMLBuilderUndefinedXMLNamespace = 902,
    AWSXMLBuilderUndefinedActionRule = 903,
    AWSXMLBuilderMissingRequiredXMLElements = 904,
    AWSXMLBuilderInvalidXMLValue = 905,
    AWSXMLBuilderUnCatchedRuleTypeInDifinitionFile = 906,
};
FOUNDATION_EXPORT NSString *const AWSXMLParserErrorDomain;
typedef NS_ENUM(NSInteger, AWSXMLParserErrorType) {
    AWSXMLParserUnknownError, 
    AWSXMLParserNoTypeDefinitionInRule, 
    AWSXMLParserUnHandledType, 
    AWSXMLParserUnExpectedType, 
    AWSXMLParserDefinitionFileIsEmpty, 
    AWSXMLParserUnexpectedXMLElement,
    AWSXMLParserXMLNameNotFoundInDefinition, 
    AWSXMLParserMissingRequiredXMLElements,
    AWSXMLParserInvalidXMLValue,
};
FOUNDATION_EXPORT NSString *const AWSQueryParamBuilderErrorDomain;
typedef NS_ENUM(NSInteger, AWSQueryParamBuilderErrorType) {
    AWSQueryParamBuilderUnknownError,
    AWSQueryParamBuilderDefinitionFileIsEmpty,
    AWSQueryParamBuilderUndefinedActionRule,
    AWSQueryParamBuilderInternalError,
    AWSQueryParamBuilderInvalidParameter,
};
FOUNDATION_EXPORT NSString *const AWSEC2ParamBuilderErrorDomain;
typedef NS_ENUM(NSInteger, AWSEC2ParamBuilderErrorType) {
    AWSEC2ParamBuilderUnknownError,
    AWSEC2ParamBuilderDefinitionFileIsEmpty,
    AWSEC2ParamBuilderUndefinedActionRule,
    AWSEC2ParamBuilderInternalError,
    AWSEC2ParamBuilderInvalidParameter,
};
FOUNDATION_EXPORT NSString *const AWSJSONBuilderErrorDomain;
typedef NS_ENUM(NSInteger, AWSJSONBuilderErrorType) {
    AWSJSONBuilderUnknownError,
    AWSJSONBuilderDefinitionFileIsEmpty,
    AWSJSONBuilderUndefinedActionRule,
    AWSJSONBuilderInternalError,
    AWSJSONBuilderInvalidParameter,
};
FOUNDATION_EXPORT NSString *const AWSJSONParserErrorDomain;
typedef NS_ENUM(NSInteger, AWSJSONParserErrorType) {
    AWSJSONParserUnknownError,
    AWSJSONParserDefinitionFileIsEmpty,
    AWSJSONParserUndefinedActionRule,
    AWSJSONParserInternalError,
    AWSJSONParserInvalidParameter,
};
@interface AWSJSONDictionary : NSDictionary
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
                JSONDefinitionRule:(NSDictionary *)rule;
- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
@end
@interface AWSXMLBuilder : NSObject
+ (NSData *)xmlDataForDictionary:(NSDictionary *)params
                      actionName:(NSString *)actionName
           serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                           error:(NSError *__autoreleasing *)error;
+ (NSString *)xmlStringForDictionary:(NSDictionary *)params
                          actionName:(NSString *)actionName
               serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                               error:(NSError *__autoreleasing *)error;
@end
@interface AWSXMLParser : NSObject
+ (AWSXMLParser *)sharedInstance;
- (NSMutableDictionary *)dictionaryForXMLData:(NSData *)data
                                   actionName:(NSString *)actionName
                        serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                        error:(NSError *__autoreleasing *)error;
@end
@interface AWSQueryParamBuilder : NSObject
+ (NSDictionary *)buildFormattedParams:(NSDictionary *)params
                            actionName:(NSString *)actionName
                 serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                 error:(NSError *__autoreleasing *)error;
@end
@interface AWSEC2ParamBuilder : NSObject
+ (NSDictionary *)buildFormattedParams:(NSDictionary *)params
                            actionName:(NSString *)actionName
                 serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                 error:(NSError *__autoreleasing *)error;
@end
@interface AWSJSONBuilder : NSObject
+ (NSData *)jsonDataForDictionary:(NSDictionary *)params
                       actionName:(NSString *)actionName
            serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                            error:(NSError *__autoreleasing *)error;
@end
@interface AWSJSONParser : NSObject
+ (NSDictionary *)dictionaryForJsonData:(NSData *)data
                               response:(NSHTTPURLResponse *)response
                             actionName:(NSString *)actionName
                  serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                  error:(NSError *__autoreleasing *)error;
@end