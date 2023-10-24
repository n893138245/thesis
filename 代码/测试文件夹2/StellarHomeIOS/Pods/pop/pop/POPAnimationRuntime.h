#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "POPAnimatablePropertyTypes.h"
#import "POPVector.h"
enum POPValueType
{
  kPOPValueUnknown = 0,
  kPOPValueInteger,
  kPOPValueFloat,
  kPOPValuePoint,
  kPOPValueSize,
  kPOPValueRect,
  kPOPValueEdgeInsets,
  kPOPValueAffineTransform,
  kPOPValueTransform,
  kPOPValueRange,
  kPOPValueColor,
  kPOPValueSCNVector3,
  kPOPValueSCNVector4,
};
using namespace POP;
extern POPValueType POPSelectValueType(const char *objctype, const POPValueType *types, size_t length);
extern POPValueType POPSelectValueType(id obj, const POPValueType *types, size_t length);
extern const POPValueType kPOPAnimatableAllTypes[12];
extern const POPValueType kPOPAnimatableSupportTypes[10];
extern NSString *POPValueTypeToString(POPValueType t);
extern CFMutableDictionaryRef POPDictionaryCreateMutableWeakPointerToWeakPointer(NSUInteger capacity) CF_RETURNS_RETAINED;
extern CFMutableDictionaryRef POPDictionaryCreateMutableWeakPointerToStrongObject(NSUInteger capacity) CF_RETURNS_RETAINED;
extern id POPBox(VectorConstRef vec, POPValueType type, bool force = false);
extern VectorRef POPUnbox(id value, POPValueType &type, NSUInteger &count, bool validate);
NS_INLINE Vector4r read_values(POPAnimatablePropertyReadBlock read, id obj, size_t count)
{
  Vector4r vec = Vector4r::Zero();
  if (0 == count)
    return vec;
  read(obj, vec.data());
  return vec;
}
NS_INLINE NSString *POPStringFromBOOL(BOOL value)
{
  return value ? @"YES" : @"NO";
}