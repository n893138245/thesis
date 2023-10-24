#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
#import "AWSSerialization.h"
@interface AWSJSONResponseSerializer : NSObject <AWSHTTPURLResponseSerializer>
@property (nonatomic, strong, readonly) NSDictionary *serviceDefinitionJSON;
@property (nonatomic, strong, readonly) NSString *actionName;
@property (nonatomic, assign, readonly) Class outputClass;
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName
                           outputClass:(Class)outputClass;
@end
@interface AWSXMLResponseSerializer : NSObject <AWSHTTPURLResponseSerializer>
@property (nonatomic, assign) Class outputClass;
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName
                           outputClass:(Class)outputClass;
+ (NSMutableDictionary *)parseResponse:(NSHTTPURLResponse *)response
                                 rules:(AWSJSONDictionary *)rules
                        bodyDictionary:(NSMutableDictionary *)bodyDictionary
                                 error:(NSError *__autoreleasing *)error;
@end