#import <Foundation/Foundation.h>
@class TBJSONModelKeyMapper;
@class TBJSONModelError;
@interface TBJSONModel : NSObject
+ (id)modelWithJSONDictionary:(NSDictionary *)dict;
+ (id)modelWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;
- (id)initWithJSONDictionary:(NSDictionary *)dict;
- (id)initWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;
- (void)updateWithJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)toJSONDictionary;
- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON;
+ (TBJSONModelKeyMapper *)modelKeyMapper;
+ (NSDictionary *)jsonToModelKeyMapDictionary;
+ (NSDictionary *)modelContainerClassMapDictioanry;
+ (NSArray *)ignoredPropertyNames;
+ (BOOL)strictMode;
@end