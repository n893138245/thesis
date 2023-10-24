#import <Foundation/Foundation.h>
@interface AppMonitorDimension : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *constantValue;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name constantValue:(NSString *)constantValue;
@end