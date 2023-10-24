#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
typedef NS_ENUM(NSUInteger, AliHADeviceEvaluationLevel) {
    UNKNOW_LEVEL,
    HIGH_END_DEVICE,
    MEDIUM_DEVICE,
    LOW_END_DEVICE
};
typedef NS_ENUM(NSUInteger, AliHARuntimeEvaluationLevel) {
    DEVICE_IS_GOOD,
    DEVICE_IS_NORMAL,
    DEVICE_IS_RISKY,
    DEVICE_IS_FATAL,
};
@interface AliHADeviceInfo : NSObject
@property (nonatomic, copy) NSString *deviceBrand;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *osVersion;
@end
@interface AliHACPUInfo : NSObject
@property (nonatomic, assign) float frequency;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, assign) NSUInteger numCores;
@property (nonatomic, assign) float cpuUsageOfApp;              
@property (nonatomic, assign) float cpuUsageOfDevice;           
@property (nonatomic, assign) AliHADeviceEvaluationLevel deviceLevel;  
@property (nonatomic, assign) AliHARuntimeEvaluationLevel runtimeLevel;  
@end
@interface AliHAMemoryInfo : NSObject
@property (nonatomic, assign) unsigned long long totalMemeory;       
@property (nonatomic, assign) float freeMemory;         
@property (nonatomic, assign) float residentMemory;     
@property (nonatomic, assign) float virtualMemory;      
@property (nonatomic, assign) float internal_plus_compressed; 
@property (nonatomic, assign) float physFootprint;      
@property (nonatomic, assign) NSInteger systemMemoryLevel;    
@property (nonatomic, assign) AliHADeviceEvaluationLevel deviceLevel;  
@property (nonatomic, assign) AliHARuntimeEvaluationLevel runtimeLevel;  
@end
@interface AliHADisplayInfo : NSObject
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) NSUInteger density;
@property (nonatomic, assign) CGSize resolution;
@property (nonatomic, assign) AliHADeviceEvaluationLevel deviceLevel;  
@end
@interface AliHAStorageInfo : NSObject
@property (nonatomic, assign) unsigned long long maxStorage;        
@property (nonatomic, assign) unsigned long long freeStorage;       
@property (nonatomic, assign) NSUInteger readSpeed;                 
@property (nonatomic, assign) NSUInteger writeSpeed;                
@property (nonatomic, assign) AliHADeviceEvaluationLevel deviceLevel;  
@end
@interface AliHABatteryInfo : NSObject
@end
@interface AliHADeviceEvaluation : NSObject
+ (AliHADeviceInfo *)getDeviceInfo;
+ (AliHAMemoryInfo *)getMemoryInfo;
+ (AliHACPUInfo *)getCPUInfo;
+ (AliHAStorageInfo *)getStorageInfo;
+ (AliHABatteryInfo *)getBatteryInfo;
+ (AliHADisplayInfo *)getDisplayInfo;
+ (AliHADeviceEvaluationLevel)evaluationForDeviceLevel;
+ (AliHARuntimeEvaluationLevel)evaluationForRuntimeLevel;
@end