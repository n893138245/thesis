#import "NSThread+YYAdd.h"
#import <CoreFoundation/CoreFoundation.h>
@interface NSThread_YYAdd : NSObject @end
@implementation NSThread_YYAdd @end
#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif
static NSString *const YYNSThreadAutoleasePoolKey = @"YYNSThreadAutoleasePoolKey";
static NSString *const YYNSThreadAutoleasePoolStackKey = @"YYNSThreadAutoleasePoolStackKey";
static const void *PoolStackRetainCallBack(CFAllocatorRef allocator, const void *value) {
    return value;
}
static void PoolStackReleaseCallBack(CFAllocatorRef allocator, const void *value) {
    CFRelease((CFTypeRef)value);
}
static inline void YYAutoreleasePoolPush() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[YYNSThreadAutoleasePoolStackKey];
    if (!poolStack) {
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        dic[YYNSThreadAutoleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    [poolStack addObject:pool]; 
}
static inline void YYAutoreleasePoolPop() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[YYNSThreadAutoleasePoolStackKey];
    [poolStack removeLastObject]; 
}
static void YYRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            YYAutoreleasePoolPush();
        } break;
        case kCFRunLoopBeforeWaiting: {
            YYAutoreleasePoolPop();
            YYAutoreleasePoolPush();
        } break;
        case kCFRunLoopExit: {
            YYAutoreleasePoolPop();
        } break;
        default: break;
    }
}
static void YYRunloopAutoreleasePoolSetup() {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef pushObserver;
    pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopEntry,
                                           true,         
                                           -0x7FFFFFFF,  
                                           YYRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
    CFRelease(pushObserver);
    CFRunLoopObserverRef popObserver;
    popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                          true,        
                                          0x7FFFFFFF,  
                                          YYRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
    CFRelease(popObserver);
}
@implementation NSThread (YYAdd)
+ (void)addAutoreleasePoolToCurrentRunloop {
    if ([NSThread isMainThread]) return; 
    NSThread *thread = [self currentThread];
    if (!thread) return;
    if (thread.threadDictionary[YYNSThreadAutoleasePoolKey]) return; 
    YYRunloopAutoreleasePoolSetup();
    thread.threadDictionary[YYNSThreadAutoleasePoolKey] = YYNSThreadAutoleasePoolKey; 
}
@end