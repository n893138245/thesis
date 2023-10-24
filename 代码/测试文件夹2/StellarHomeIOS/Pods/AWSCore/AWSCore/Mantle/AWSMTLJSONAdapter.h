#import <Foundation/Foundation.h>
@class AWSMTLModel;
@protocol AWSMTLJSONSerializing
@required
+ (NSDictionary *)JSONKeyPathsByPropertyKey;
@optional
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key;
+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary;
@end
extern NSString * const AWSMTLJSONAdapterErrorDomain;
extern const NSInteger AWSMTLJSONAdapterErrorNoClassFound;
extern const NSInteger AWSMTLJSONAdapterErrorInvalidJSONDictionary;
extern const NSInteger AWSMTLJSONAdapterErrorInvalidJSONMapping;
@interface AWSMTLJSONAdapter : NSObject
@property (nonatomic, strong, readonly) AWSMTLModel<AWSMTLJSONSerializing> *model;
+ (id)modelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)JSONDictionary error:(NSError **)error;
+ (NSArray *)modelsOfClass:(Class)modelClass fromJSONArray:(NSArray *)JSONArray error:(NSError **)error;
+ (NSDictionary *)JSONDictionaryFromModel:(AWSMTLModel<AWSMTLJSONSerializing> *)model;
+ (NSArray *)JSONArrayFromModels:(NSArray *)models;
- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary modelClass:(Class)modelClass error:(NSError **)error;
- (id)initWithModel:(AWSMTLModel<AWSMTLJSONSerializing> *)model;
- (NSDictionary *)JSONDictionary;
- (NSString *)JSONKeyPathForPropertyKey:(NSString *)key;
@end
@interface AWSMTLJSONAdapter (Deprecated)
+ (id)modelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)JSONDictionary __attribute__((deprecated("Replaced by +modelOfClass:fromJSONDictionary:error:")));
- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary modelClass:(Class)modelClass __attribute__((deprecated("Replaced by -initWithJSONDictionary:modelClass:error:")));
@end