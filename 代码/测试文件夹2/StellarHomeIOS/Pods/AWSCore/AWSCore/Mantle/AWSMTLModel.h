#import <Foundation/Foundation.h>
@interface AWSMTLModel : NSObject <NSCopying>
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error;
- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error;
+ (NSSet *)propertyKeys;
@property (nonatomic, copy, readonly) NSDictionary *dictionaryValue;
- (void)mergeValueForKey:(NSString *)key fromModel:(AWSMTLModel *)model;
- (void)mergeValuesForKeysFromModel:(AWSMTLModel *)model;
- (BOOL)isEqual:(id)object;
- (NSString *)description;
@end
@interface AWSMTLModel (Validation)
- (BOOL)validate:(NSError **)error;
@end
@interface AWSMTLModel (Unavailable)
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue __attribute__((deprecated("Replaced by +modelWithDictionary:error:")));
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue __attribute__((deprecated("Replaced by -initWithDictionary:error:")));
+ (instancetype)modelWithExternalRepresentation:(NSDictionary *)externalRepresentation __attribute__((deprecated("Replaced by -[MTLJSONAdapter initWithJSONDictionary:modelClass:]")));
- (instancetype)initWithExternalRepresentation:(NSDictionary *)externalRepresentation __attribute__((deprecated("Replaced by -[MTLJSONAdapter initWithJSONDictionary:modelClass:]")));
@property (nonatomic, copy, readonly) NSDictionary *externalRepresentation __attribute__((deprecated("Replaced by MTLJSONAdapter.JSONDictionary")));
+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey __attribute__((deprecated("Replaced by +JSONKeyPathsByPropertyKey in <MTLJSONSerializing>")));
+ (NSValueTransformer *)transformerForKey:(NSString *)key __attribute__((deprecated("Replaced by +JSONTransformerForKey: in <MTLJSONSerializing>")));
+ (NSDictionary *)migrateExternalRepresentation:(NSDictionary *)externalRepresentation fromVersion:(NSUInteger)fromVersion __attribute__((deprecated("Replaced by -decodeValueForKey:withCoder:modelVersion:")));
@end