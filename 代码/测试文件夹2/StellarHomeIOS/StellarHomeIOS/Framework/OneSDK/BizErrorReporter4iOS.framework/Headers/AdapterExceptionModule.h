#ifndef AdapterExceptionModule_h
#define AdapterExceptionModule_h
#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import "AdapterBaseModule.h"
@interface AdapterExceptionModule : AdapterBaseModule
@property (nonatomic,readwrite) NSString* exceptionId;
@property (nonatomic,readwrite) NSString* exceptionCode;
@property (nonatomic,readwrite) NSString* exceptionVersion;
@property (nonatomic,readwrite) NSString* exceptionArg1;
@property (nonatomic,readwrite) NSString* exceptionArg2;
@property (nonatomic,readwrite) NSString* exceptionArg3;
@property (nonatomic,readwrite) NSDictionary* exceptionArgs;
@property (nonatomic,readwrite) NSString* exceptionDetail;
@property (nonatomic,readwrite) thread_t thread;
@property (nonatomic,readwrite) NSString* currentStack;
@end
#endif 