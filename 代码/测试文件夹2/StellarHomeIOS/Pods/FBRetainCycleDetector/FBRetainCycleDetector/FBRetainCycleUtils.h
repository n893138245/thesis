#import <Foundation/Foundation.h>
@class FBObjectGraphConfiguration;
@class FBObjectiveCGraphElement;
#ifdef __cplusplus
extern "C" {
#endif
FBObjectiveCGraphElement *_Nullable FBWrapObjectGraphElementWithContext(FBObjectiveCGraphElement *_Nullable sourceElement,
                                                                        id _Nullable object,
                                                                        FBObjectGraphConfiguration *_Nullable configuration,
                                                                        NSArray<NSString *> *_Nullable namePath);
FBObjectiveCGraphElement *_Nullable FBWrapObjectGraphElement(FBObjectiveCGraphElement *_Nullable sourceElement,
                                                             id _Nullable object,
                                                             FBObjectGraphConfiguration *_Nullable configuration);
#ifdef __cplusplus
}
#endif