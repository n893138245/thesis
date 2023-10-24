#ifndef AlicloudTracker_h
#define AlicloudTracker_h
@interface AlicloudTracker : NSObject
@property (nonatomic, copy) NSString *sdkId;
@property (nonatomic, copy) NSString *sdkVersion;
- (void)setGlobalProperty:(NSString *)key value:(NSString *)value;
- (void)removeGlobalProperty:(NSString *)key;
- (void)sendCustomHit:(NSString *)eventName
             duration:(long long)duration
           properties:(NSDictionary *)properties;
@end
#endif 