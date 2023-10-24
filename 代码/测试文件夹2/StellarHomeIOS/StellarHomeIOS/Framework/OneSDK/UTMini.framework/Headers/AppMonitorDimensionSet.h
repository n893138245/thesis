#import <Foundation/Foundation.h>
#import "AppMonitorDimensionValueSet.h"
#import "AppMonitorDimension.h"
@interface AppMonitorDimensionSet : NSObject
+ (instancetype)setWithArray:(NSArray *)array;
- (BOOL)valid:(AppMonitorDimensionValueSet*)dimensionValues;
- (void)addDimension:(AppMonitorDimension *)dimension;
- (void)addDimensionWithName:(NSString *)name;
- (AppMonitorDimension *)dimensionForName:(NSString *)name;
- (NSMutableOrderedSet *)dimensions;
- (void)setConstantValue:(AppMonitorDimensionValueSet *)dimensionValues;
@end