#import <Foundation/Foundation.h>
#import "TBJSONModel.h"
@interface NSDictionary(TBJSONModel)
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass;
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass strictMode:(BOOL)strictMode;
- (NSDictionary *)toJSONDictionary;
@end