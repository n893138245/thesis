#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
@interface AWSS3RequestSerializer : NSObject <AWSURLRequestSerializer>
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName;
@end
@interface AWSS3ResponseSerializer : NSObject <AWSHTTPURLResponseSerializer>
@property (nonatomic, assign) Class outputClass;
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName
                           outputClass:(Class)outputClass;
@end