#import <Foundation/Foundation.h>
@interface AppMonitorDimensionValueSet : NSObject<NSCopying>
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, strong) NSMutableDictionary *dict;
- (void)setValue:(NSString *)value forName:(NSString *)name;
- (BOOL)containValueForName:(NSString *)name;
- (NSString *)valueForName:(NSString *)name;
@end