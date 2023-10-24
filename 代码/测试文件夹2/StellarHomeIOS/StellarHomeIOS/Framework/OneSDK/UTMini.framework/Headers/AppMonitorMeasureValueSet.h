#import <Foundation/Foundation.h>
#import "AppMonitorMeasureValue.h"
@interface AppMonitorMeasureValueSet : NSObject<NSCopying>
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)setDoubleValue:(double)value forName:(NSString *)name;
- (void)setValue:(AppMonitorMeasureValue *)value forName:(NSString *)name;
- (BOOL)containValueForName:(NSString *)name;
- (AppMonitorMeasureValue *)valueForName:(NSString *)name;
- (void)merge:(AppMonitorMeasureValueSet*)measureValueSet;
- (NSDictionary *)jsonDict;
@end