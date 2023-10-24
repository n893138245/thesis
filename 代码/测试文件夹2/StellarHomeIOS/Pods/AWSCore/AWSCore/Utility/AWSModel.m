#import "AWSModel.h"
@implementation AWSModel
+ (BOOL)supportsSecureCoding {
    return NO;
}
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}
- (NSDictionary *)dictionaryValue {
    NSDictionary *dictionaryValue = [super dictionaryValue];
    NSMutableDictionary *mutableDictionaryValue = [dictionaryValue mutableCopy];
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self valueForKey:key] == nil) {
            [mutableDictionaryValue removeObjectForKey:key];
        }
    }];
    return mutableDictionaryValue;
}
@end
@implementation AWSModelUtility
+ (NSDictionary *)mapMTLDictionaryFromJSONArrayDictionary:(NSDictionary *)JSONArrayDictionary arrayElementType:(NSString *)arrayElementType withModelClass:(Class) modelClass {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    for (NSString *key in [JSONArrayDictionary allKeys]) {
        if ([arrayElementType isEqualToString:@"map"]) {
            [mutableDictionary setObject:[AWSModelUtility mapMTLArrayFromJSONArray:JSONArrayDictionary[key] withModelClass:modelClass] forKey:key];
        } else if  ([arrayElementType isEqualToString:@"structure"]) {
            NSValueTransformer *valueFransformer =  [NSValueTransformer awsmtl_JSONArrayTransformerWithModelClass:[modelClass class]];
            [mutableDictionary setObject:[valueFransformer transformedValue:JSONArrayDictionary[key]] forKey:key];
        }
    }
    return mutableDictionary;
}
+ (NSDictionary *)JSONArrayDictionaryFromMapMTLDictionary:(NSDictionary *)mapMTLDictionary arrayElementType:(NSString *)arrayElementType{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    for (NSString *key in [mapMTLDictionary allKeys]) {
        if ([arrayElementType isEqualToString:@"map"]) {
            [mutableDictionary setObject:[AWSModelUtility JSONArrayFromMapMTLArray:mapMTLDictionary[key]] forKey:key];
        } else if ([arrayElementType isEqualToString:@"structure"]) {
            NSValueTransformer *valueFransformer = [NSValueTransformer awsmtl_JSONArrayTransformerWithModelClass:[AWSModel class]];
            [mutableDictionary setObject:[valueFransformer reverseTransformedValue:mapMTLDictionary[key]] forKey:key];
        }
    }
    return mutableDictionary;
}
+ (NSArray *)mapMTLArrayFromJSONArray:(NSArray *)JSONArray withModelClass:(Class)modelClass {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSDictionary *aDic in JSONArray) {
        NSDictionary *tmpDic = [AWSModelUtility mapMTLDictionaryFromJSONDictionary:aDic withModelClass:[modelClass class]];
        [mutableArray addObject:tmpDic];
    };
    return mutableArray;
}
+ (NSArray *)JSONArrayFromMapMTLArray:(NSArray *)mapMTLArray {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSDictionary *aDic in mapMTLArray) {
        NSDictionary *tmpDic = [AWSModelUtility JSONDictionaryFromMapMTLDictionary:aDic];
        [mutableArray addObject:tmpDic];
    };
    return mutableArray;
}
+ (NSDictionary *)mapMTLDictionaryFromJSONDictionary:(NSDictionary *)JSONDictionary withModelClass:(Class)modelClass {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    for (NSString *key in [JSONDictionary allKeys]) {
        [mutableDictionary setObject:[AWSMTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary[key] error:nil] forKey:key];
    }
    return mutableDictionary;
}
+ (NSDictionary *)JSONDictionaryFromMapMTLDictionary:(NSDictionary *)mapMTLDictionary {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    for (NSString *key in [mapMTLDictionary allKeys]) {
        [mutableDictionary setObject:[AWSMTLJSONAdapter JSONDictionaryFromModel:[mapMTLDictionary objectForKey:key]]
                              forKey:key];
    }
    return mutableDictionary;
}
@end