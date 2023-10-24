#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TBJSONModelPropertyValueType) {
    TBClassPropertyValueTypeNone = 0,
    TBClassPropertyTypeChar,
    TBClassPropertyTypeInt,
    TBClassPropertyTypeShort,
    TBClassPropertyTypeLong,
    TBClassPropertyTypeLongLong,
    TBClassPropertyTypeUnsignedChar,
    TBClassPropertyTypeUnsignedInt,
    TBClassPropertyTypeUnsignedShort,
    TBClassPropertyTypeUnsignedLong,
    TBClassPropertyTypeUnsignedLongLong,
    TBClassPropertyTypeFloat,
    TBClassPropertyTypeDouble,
    TBClassPropertyTypeBool,
    TBClassPropertyTypeVoid,
    TBClassPropertyTypeCharString,
    TBClassPropertyTypeObject,
    TBClassPropertyTypeClassObject,
    TBClassPropertyTypeSelector,
    TBClassPropertyTypeArray,
    TBClassPropertyTypeStruct,
    TBClassPropertyTypeUnion,
    TBClassPropertyTypeBitField,
    TBClassPropertyTypePointer,
    TBClassPropertyTypeUnknow
};
@interface TBJSONModelProperty : NSObject{
    @public
    NSString *_name;
    TBJSONModelPropertyValueType _valueType;
    NSString *_typeName;
    Class _objectClass;
    NSArray *_objectProtocols;
    Class _containerElementClass;
    BOOL _isReadonly;
}
+ (instancetype)propertyWithName:(NSString *)name typeString:(NSString *)typeString;
@end