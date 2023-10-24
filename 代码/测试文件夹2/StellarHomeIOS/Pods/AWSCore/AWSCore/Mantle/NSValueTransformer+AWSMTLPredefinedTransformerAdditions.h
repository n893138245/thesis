#import <Foundation/Foundation.h>
void awsmtl_loadMTLPredefinedTransformerAdditions(void);
extern NSString * const AWSMTLURLValueTransformerName;
extern NSString * const AWSMTLBooleanValueTransformerName;
@interface NSValueTransformer (AWSMTLPredefinedTransformerAdditions)
+ (NSValueTransformer *)awsmtl_JSONDictionaryTransformerWithModelClass:(Class)modelClass;
+ (NSValueTransformer *)awsmtl_JSONArrayTransformerWithModelClass:(Class)modelClass;
+ (NSValueTransformer *)awsmtl_valueMappingTransformerWithDictionary:(NSDictionary *)dictionary defaultValue:(id)defaultValue reverseDefaultValue:(id)reverseDefaultValue;
+ (NSValueTransformer *)awsmtl_valueMappingTransformerWithDictionary:(NSDictionary *)dictionary;
@end
@interface NSValueTransformer (UnavailableAWSMTLPredefinedTransformerAdditions)
+ (NSValueTransformer *)awsmtl_externalRepresentationTransformerWithModelClass:(Class)modelClass __attribute__((deprecated("Replaced by +mtl_JSONDictionaryTransformerWithModelClass:")));
+ (NSValueTransformer *)awsmtl_externalRepresentationArrayTransformerWithModelClass:(Class)modelClass __attribute__((deprecated("Replaced by +mtl_JSONArrayTransformerWithModelClass:")));
@end