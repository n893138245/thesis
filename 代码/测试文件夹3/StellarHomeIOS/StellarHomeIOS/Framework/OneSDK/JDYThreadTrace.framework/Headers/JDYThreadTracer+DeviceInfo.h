#import <JDYThreadTrace/JDYThreadTracer.h>
#import <mach/mach.h>
@interface JDYThreadTracer (DeviceInfo)
+ (NSString *)formattedDeviceInfo;
+ (NSString *)formattedDeviceInfoWithCustomizedReason:(NSString *)reason;
+ (NSString *)formattedDeviceInfoWithCustomizedReason:(NSString *)reason reportVersion:(NSString*)reportVersion;
+ (float)cpuUsageOfThread:(thread_t)thread;
+ (vm_size_t)memoryUsageOfTask:(task_t)task;
+ (boolean_t) islp64;
@end