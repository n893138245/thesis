#import <Foundation/Foundation.h>
#if !DISABLE_SWIZZLING
extern BOOL RXAbortOnThreadingHazard;
extern NSString * __nonnull const RXObjCRuntimeErrorDomain;
extern NSString * __nonnull const RXObjCRuntimeErrorIsKVOKey;
typedef NS_ENUM(NSInteger, RXObjCRuntimeError) {
    RXObjCRuntimeErrorUnknown                                           = 1,
    RXObjCRuntimeErrorObjectMessagesAlreadyBeingIntercepted             = 2,
    RXObjCRuntimeErrorSelectorNotImplemented                            = 3,
    RXObjCRuntimeErrorCantInterceptCoreFoundationTollFreeBridgedObjects = 4,
    RXObjCRuntimeErrorThreadingCollisionWithOtherInterceptionMechanism  = 5,
    RXObjCRuntimeErrorSavingOriginalForwardingMethodFailed              = 6,
    RXObjCRuntimeErrorReplacingMethodWithForwardingImplementation       = 7,
    RXObjCRuntimeErrorObservingPerformanceSensitiveMessages             = 8,
    RXObjCRuntimeErrorObservingMessagesWithUnsupportedReturnType        = 9,
};
SEL _Nonnull RX_selector(SEL _Nonnull selector);
void * __nonnull RX_reference_from_selector(SEL __nonnull selector);
@protocol RXMessageSentObserver
@property (nonatomic, assign, readonly) IMP __nonnull targetImplementation;
-(void)messageSentWithArguments:(NSArray* __nonnull)arguments;
-(void)methodInvokedWithArguments:(NSArray* __nonnull)arguments;
@end
@protocol RXDeallocatingObserver
@property (nonatomic, assign, readonly) IMP __nonnull targetImplementation;
-(void)deallocating;
@end
IMP __nullable RX_ensure_observing(id __nonnull target, SEL __nonnull selector, NSError *__autoreleasing __nullable * __nullable error);
#endif
NSArray * __nonnull RX_extract_arguments(NSInvocation * __nonnull invocation);
BOOL RX_is_method_with_description_void(struct objc_method_description method);
BOOL RX_is_method_signature_void(NSMethodSignature * __nonnull methodSignature);
IMP __nonnull RX_default_target_implementation(void);