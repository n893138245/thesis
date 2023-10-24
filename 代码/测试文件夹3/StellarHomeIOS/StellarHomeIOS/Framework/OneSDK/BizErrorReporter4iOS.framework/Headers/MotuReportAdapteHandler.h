#ifndef MotuReportAdapteHandler_h
#define MotuReportAdapteHandler_h
#import <Foundation/Foundation.h>
#import "AdapterExceptionModule.h"
@interface MotuReportAdapteHandler : NSObject
- (void) adapterWithExceptionModule:(AdapterExceptionModule*)exceptionModule;
- (BOOL) adapterSyncWithExceptionModule:(AdapterExceptionModule*)exceptionModule;
@end
#endif 