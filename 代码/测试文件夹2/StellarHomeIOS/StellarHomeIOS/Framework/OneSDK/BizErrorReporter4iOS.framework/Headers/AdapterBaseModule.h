#ifndef AdapterBaseModule_h
#define AdapterBaseModule_h
#import <Foundation/Foundation.h>
typedef enum : NSUInteger{
    ADAPTER_STACK=0,  
    ADAPTER_CONTENT=1 
} ADAPTER_AGGREGATION_TYPE;
typedef enum : NSUInteger{
    ADAPTER_WEEX_ERROR=0,     
    ADAPTER_WINDVANE_ERROR=1, 
    ADAPTER_IMAGE_ERROR=2    
} ADAPTER_BUSINESS_TYPE;
@interface AdapterBaseModule : NSObject
@property (nonatomic, readwrite) ADAPTER_BUSINESS_TYPE businessType DEPRECATED_ATTRIBUTE;
@property (nonatomic,readwrite) NSString* customizeBusinessType;
@property (nonatomic, readwrite) ADAPTER_AGGREGATION_TYPE aggregationType;
-(NSString *) NSStringFromAggregationType;
-(NSString *) NSStringFromBusinessType;
@end
#endif 