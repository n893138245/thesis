#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
extern const IMP _rac_objc_msgForward;
void _rac_objc_setAssociatedObject(const void* object, const void* key, id _Nullable value, objc_AssociationPolicy policy);
NS_ASSUME_NONNULL_END