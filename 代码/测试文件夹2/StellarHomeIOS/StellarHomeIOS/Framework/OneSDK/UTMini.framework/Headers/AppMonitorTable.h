#import <Foundation/Foundation.h>
@interface AppMonitorTable : NSObject
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint columns:(NSArray *)cols rows:(NSArray * )rows aggregate:(BOOL)aggregate;
+ (void)addConstraintWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint name:(NSString *)name min:(double)min max:(double)max defaultValue:(double)value;
+ (BOOL)commitWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint columns:(NSDictionary *)cols rows:(NSDictionary *)rows;
+ (instancetype)monitorForScheme:(NSString *)scheme tableName:(NSString *)tableName;
- (void)registerTableWithRows:(NSArray * )rows columns:(NSArray *)cols aggregate:(BOOL)yn;
- (void)addConstraintWithName:(NSString *)name range:(NSRange)range defaultValue:(NSNumber *)number;
- (void)addConstraintWithName:(NSString *)name min:(double)min max:(double)max defaultValue:(double)value;
- (BOOL)updateTableForColumns:(NSDictionary *)cols rows:(NSDictionary *)rows;
- (BOOL)updateTableWithDictionary:(NSDictionary *)dict;
@end