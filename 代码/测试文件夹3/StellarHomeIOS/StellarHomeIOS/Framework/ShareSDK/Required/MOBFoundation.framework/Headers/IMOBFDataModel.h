#import <Foundation/Foundation.h>
@protocol IMOBFDataModel <NSObject>
@required
- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)set:(id)data key:(NSString *)key;
- (id)get:(NSString *)key;
- (NSDictionary *)dictionaryValue;
+ (NSDictionary <NSString *, NSString *> *)propertyMappingDictionary;
+ (NSDictionary <NSString *, NSString *> *)elementTypeOfCollectionPropertyDictionary;
+ (id)unsupportTypeWithRawData:(id)rawData
                    targetType:(Class)targetType
                  propertyName:(NSString *)propertyName;
+ (id)rawDataWithUnsupportTypeObject:(id)object
                        propertyName:(NSString *)propertyName;
@end