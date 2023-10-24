#import <Foundation/Foundation.h>
@interface TBJSONModelKeyMapper : NSObject
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey;
- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey;
@end