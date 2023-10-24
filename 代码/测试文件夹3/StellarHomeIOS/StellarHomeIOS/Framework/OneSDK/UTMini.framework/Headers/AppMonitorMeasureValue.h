#import <Foundation/Foundation.h>
@interface AppMonitorMeasureValue : NSObject
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, strong) NSNumber * offset;
@property (nonatomic, strong) NSNumber * value;
- (instancetype)initWithValue:(NSNumber *)value;
- (instancetype)initWithValue:(NSNumber *)value offset:(NSNumber *)offset;
- (void)merge:(AppMonitorMeasureValue *)measureValue;
- (NSDictionary *)jsonDict;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end