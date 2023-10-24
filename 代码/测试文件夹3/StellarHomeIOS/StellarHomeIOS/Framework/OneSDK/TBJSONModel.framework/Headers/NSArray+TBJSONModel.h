#import <Foundation/Foundation.h>
@interface NSArray(TBJSONModel)
- (NSArray *)modelArrayWithClass:(Class)modelClass;
- (NSArray *)modelArrayWithClass:(Class)modelClass strictMode:(BOOL)strictMode;
- (NSArray *)toJSONArray;
@end