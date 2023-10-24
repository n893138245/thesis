#ifndef MotuAdapterBuilder_h
#define MotuAdapterBuilder_h
#import <Foundation/Foundation.h>
#import "AdapterSenderModule.h"
#import "AdapterExceptionModule.h"
@interface MotuAdapterBuilder : NSObject
- (AdapterSenderModule*)buildWithAdapterExceptionModule:(AdapterExceptionModule*) module;
@end
#endif 