#import <Foundation/Foundation.h>
#import "AppMonitorMeasure.h"
#import "AppMonitorMeasureValueSet.h"
@interface AppMonitorMeasureSet : NSObject
+ (instancetype)setWithArray:(NSArray *)array;
- (BOOL)valid:(NSString*)module MonitorPoint:(NSString*)monitorpoint measureValues:(AppMonitorMeasureValueSet *)measureValues;
- (void)addMeasure:(AppMonitorMeasure *)measure;
- (void)addMeasureWithName:(NSString *)name;
- (AppMonitorMeasure *)measureForName:(NSString *)name;
- (NSMutableOrderedSet *)measures;
- (void)setConstantValue:(AppMonitorMeasureValueSet *)measureValues;
@end