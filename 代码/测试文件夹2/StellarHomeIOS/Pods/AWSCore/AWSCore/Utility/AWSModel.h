#import "AWSMantle.h"
@interface AWSModel : AWSMTLModel <AWSMTLJSONSerializing, NSSecureCoding>
@end
@interface AWSModelUtility : NSObject
+ (NSDictionary *)mapMTLDictionaryFromJSONArrayDictionary:(NSDictionary *)JSONArrayDictionary
                                         arrayElementType:(NSString *)arrayElementType
                                           withModelClass:(Class)modelClass;
+ (NSDictionary *)JSONArrayDictionaryFromMapMTLDictionary:(NSDictionary *)mapMTLDictionary
                                         arrayElementType:(NSString *)arrayElementType;
+ (NSArray *)mapMTLArrayFromJSONArray:(NSArray *)JSONArray
                       withModelClass:(Class)modelClass;
+ (NSArray *)JSONArrayFromMapMTLArray:(NSArray *)mapMTLArray;
+ (NSDictionary *)mapMTLDictionaryFromJSONDictionary:(NSDictionary *)JSONDictionary
                                      withModelClass:(Class)modelClass;
+ (NSDictionary *)JSONDictionaryFromMapMTLDictionary:(NSDictionary *)mapMTLDictionary;
@end