#import <objc/runtime.h>
typedef enum {
    awsmtl_propertyMemoryManagementPolicyAssign = 0,
    awsmtl_propertyMemoryManagementPolicyRetain,
    awsmtl_propertyMemoryManagementPolicyCopy
} awsmtl_propertyMemoryManagementPolicy;
typedef struct {
    BOOL readonly;
    BOOL nonatomic;
    BOOL weak;
    BOOL canBeCollected;
    BOOL dynamic;
    awsmtl_propertyMemoryManagementPolicy memoryManagementPolicy;
    SEL getter;
    SEL setter;
    const char *ivar;
    Class objectClass;
    char type[];
} awsmtl_propertyAttributes;
awsmtl_propertyAttributes *awsmtl_copyPropertyAttributes (objc_property_t property);