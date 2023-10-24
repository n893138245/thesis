#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
#import "AWSSerialization.h"
@interface AWSJSONRequestSerializer : NSObject <AWSURLRequestSerializer>
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName;
@end
@interface AWSXMLRequestSerializer : NSObject <AWSURLRequestSerializer>
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                      actionName:(NSString *)actionName;
+ (BOOL)constructURIandHeadersAndBody:(NSMutableURLRequest *)request
                                rules:(AWSJSONDictionary *)rules
                           parameters:(NSDictionary *)params
                            uriSchema:(NSString *)uriSchema
                           hostPrefix:(NSString *)hostPrefix
                                error:(NSError *__autoreleasing *)error;
@end
@interface AWSQueryStringRequestSerializer : NSObject <AWSURLRequestSerializer>
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName;
@property (nonatomic, strong) NSDictionary *additionalParameters;
@end