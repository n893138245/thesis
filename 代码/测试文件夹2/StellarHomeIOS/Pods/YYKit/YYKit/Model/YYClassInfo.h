#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, YYEncodingType) {
    YYEncodingTypeMask       = 0xFF, 
    YYEncodingTypeUnknown    = 0, 
    YYEncodingTypeVoid       = 1, 
    YYEncodingTypeBool       = 2, 
    YYEncodingTypeInt8       = 3, 
    YYEncodingTypeUInt8      = 4, 
    YYEncodingTypeInt16      = 5, 
    YYEncodingTypeUInt16     = 6, 
    YYEncodingTypeInt32      = 7, 
    YYEncodingTypeUInt32     = 8, 
    YYEncodingTypeInt64      = 9, 
    YYEncodingTypeUInt64     = 10, 
    YYEncodingTypeFloat      = 11, 
    YYEncodingTypeDouble     = 12, 
    YYEncodingTypeLongDouble = 13, 
    YYEncodingTypeObject     = 14, 
    YYEncodingTypeClass      = 15, 
    YYEncodingTypeSEL        = 16, 
    YYEncodingTypeBlock      = 17, 
    YYEncodingTypePointer    = 18, 
    YYEncodingTypeStruct     = 19, 
    YYEncodingTypeUnion      = 20, 
    YYEncodingTypeCString    = 21, 
    YYEncodingTypeCArray     = 22, 
    YYEncodingTypeQualifierMask   = 0xFF00,   
    YYEncodingTypeQualifierConst  = 1 << 8,  
    YYEncodingTypeQualifierIn     = 1 << 9,  
    YYEncodingTypeQualifierInout  = 1 << 10, 
    YYEncodingTypeQualifierOut    = 1 << 11, 
    YYEncodingTypeQualifierBycopy = 1 << 12, 
    YYEncodingTypeQualifierByref  = 1 << 13, 
    YYEncodingTypeQualifierOneway = 1 << 14, 
    YYEncodingTypePropertyMask         = 0xFF0000, 
    YYEncodingTypePropertyReadonly     = 1 << 16, 
    YYEncodingTypePropertyCopy         = 1 << 17, 
    YYEncodingTypePropertyRetain       = 1 << 18, 
    YYEncodingTypePropertyNonatomic    = 1 << 19, 
    YYEncodingTypePropertyWeak         = 1 << 20, 
    YYEncodingTypePropertyCustomGetter = 1 << 21, 
    YYEncodingTypePropertyCustomSetter = 1 << 22, 
    YYEncodingTypePropertyDynamic      = 1 << 23, 
};
YYEncodingType YYEncodingGetType(const char *typeEncoding);
@interface YYClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              
@property (nonatomic, strong, readonly) NSString *name;         
@property (nonatomic, assign, readonly) ptrdiff_t offset;       
@property (nonatomic, strong, readonly) NSString *typeEncoding; 
@property (nonatomic, assign, readonly) YYEncodingType type;    
- (instancetype)initWithIvar:(Ivar)ivar;
@end
@interface YYClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;                  
@property (nonatomic, strong, readonly) NSString *name;                 
@property (nonatomic, assign, readonly) SEL sel;                        
@property (nonatomic, assign, readonly) IMP imp;                        
@property (nonatomic, strong, readonly) NSString *typeEncoding;         
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; 
- (instancetype)initWithMethod:(Method)method;
@end
@interface YYClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; 
@property (nonatomic, strong, readonly) NSString *name;           
@property (nonatomic, assign, readonly) YYEncodingType type;      
@property (nonatomic, strong, readonly) NSString *typeEncoding;   
@property (nonatomic, strong, readonly) NSString *ivarName;       
@property (nullable, nonatomic, assign, readonly) Class cls;      
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; 
@property (nonatomic, assign, readonly) SEL getter;               
@property (nonatomic, assign, readonly) SEL setter;               
- (instancetype)initWithProperty:(objc_property_t)property;
@end
@interface YYClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; 
@property (nullable, nonatomic, assign, readonly) Class superCls; 
@property (nullable, nonatomic, assign, readonly) Class metaCls;  
@property (nonatomic, readonly) BOOL isMeta; 
@property (nonatomic, strong, readonly) NSString *name; 
@property (nullable, nonatomic, strong, readonly) YYClassInfo *superClassInfo; 
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, YYClassIvarInfo *> *ivarInfos; 
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, YYClassMethodInfo *> *methodInfos; 
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, YYClassPropertyInfo *> *propertyInfos; 
- (void)setNeedUpdate;
- (BOOL)needUpdate;
+ (nullable instancetype)classInfoWithClass:(Class)cls;
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;
@end
NS_ASSUME_NONNULL_END