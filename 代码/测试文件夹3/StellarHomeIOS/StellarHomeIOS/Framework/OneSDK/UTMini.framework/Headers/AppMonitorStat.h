#import <Foundation/Foundation.h>
#import "AppMonitorBase.h"
#import "AppMonitorMeasureSet.h"
#import "AppMonitorDimensionSet.h"
@interface AppMonitorStatTransaction :NSObject
- (void)beginWithMeasureName:(NSString *)measureName;
- (void)endWithMeasureName:(NSString *)measureName;
@end
@interface AppMonitorStat : AppMonitorBase
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(AppMonitorMeasureSet *)measures;
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(AppMonitorMeasureSet *)measures dimensionSet:(AppMonitorDimensionSet *)dimensions;
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(AppMonitorMeasureSet *)measures isCommitDetail:(BOOL)detail;
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(AppMonitorMeasureSet *)measures dimensionSet:(AppMonitorDimensionSet *)dimensions isCommitDetail:(BOOL)detail;
+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint dimensionValueSet:(AppMonitorDimensionValueSet *)dimensionValues measureValueSet:(AppMonitorMeasureValueSet *)measureValues;
+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint dimensionValueSet:(AppMonitorDimensionValueSet *)dimensionValues value:(double)value;
+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint value:(double)value;
+ (void)beginWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureName:(NSString *)measureName;
+ (void)endWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureName:(NSString *)measureName;
+ (AppMonitorStatTransaction *)createTransactionWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint;
@end