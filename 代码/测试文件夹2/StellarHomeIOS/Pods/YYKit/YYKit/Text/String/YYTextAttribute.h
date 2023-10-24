#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#pragma mark - Enum Define
typedef NS_OPTIONS(NSInteger, YYTextAttributeType) {
    YYTextAttributeTypeNone     = 0,
    YYTextAttributeTypeUIKit    = 1 << 0, 
    YYTextAttributeTypeCoreText = 1 << 1, 
    YYTextAttributeTypeYYText   = 1 << 2, 
};
extern YYTextAttributeType YYTextAttributeGetType(NSString *attributeName);
typedef NS_OPTIONS (NSInteger, YYTextLineStyle) {
    YYTextLineStyleNone       = 0x00, 
    YYTextLineStyleSingle     = 0x01, 
    YYTextLineStyleThick      = 0x02, 
    YYTextLineStyleDouble     = 0x09, 
    YYTextLineStylePatternSolid      = 0x000, 
    YYTextLineStylePatternDot        = 0x100, 
    YYTextLineStylePatternDash       = 0x200, 
    YYTextLineStylePatternDashDot    = 0x300, 
    YYTextLineStylePatternDashDotDot = 0x400, 
    YYTextLineStylePatternCircleDot  = 0x900, 
};
typedef NS_ENUM(NSInteger, YYTextVerticalAlignment) {
    YYTextVerticalAlignmentTop =    0, 
    YYTextVerticalAlignmentCenter = 1, 
    YYTextVerticalAlignmentBottom = 2, 
};
typedef NS_OPTIONS(NSUInteger, YYTextDirection) {
    YYTextDirectionNone   = 0,
    YYTextDirectionTop    = 1 << 0,
    YYTextDirectionRight  = 1 << 1,
    YYTextDirectionBottom = 1 << 2,
    YYTextDirectionLeft   = 1 << 3,
};
typedef NS_ENUM (NSUInteger, YYTextTruncationType) {
    YYTextTruncationTypeNone   = 0,
    YYTextTruncationTypeStart  = 1,
    YYTextTruncationTypeEnd    = 2,
    YYTextTruncationTypeMiddle = 3,
};
#pragma mark - Attribute Name Defined in YYText
UIKIT_EXTERN NSString *const YYTextBackedStringAttributeName;
UIKIT_EXTERN NSString *const YYTextBindingAttributeName;
UIKIT_EXTERN NSString *const YYTextShadowAttributeName;
UIKIT_EXTERN NSString *const YYTextInnerShadowAttributeName;
UIKIT_EXTERN NSString *const YYTextUnderlineAttributeName;
UIKIT_EXTERN NSString *const YYTextStrikethroughAttributeName;
UIKIT_EXTERN NSString *const YYTextBorderAttributeName;
UIKIT_EXTERN NSString *const YYTextBackgroundBorderAttributeName;
UIKIT_EXTERN NSString *const YYTextBlockBorderAttributeName;
UIKIT_EXTERN NSString *const YYTextAttachmentAttributeName;
UIKIT_EXTERN NSString *const YYTextHighlightAttributeName;
UIKIT_EXTERN NSString *const YYTextGlyphTransformAttributeName;
#pragma mark - String Token Define
UIKIT_EXTERN NSString *const YYTextAttachmentToken; 
UIKIT_EXTERN NSString *const YYTextTruncationToken; 
#pragma mark - Attribute Value Define
typedef void(^YYTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);
@interface YYTextBackedString : NSObject <NSCoding, NSCopying>
+ (instancetype)stringWithString:(nullable NSString *)string;
@property (nullable, nonatomic, copy) NSString *string; 
@end
@interface YYTextBinding : NSObject <NSCoding, NSCopying>
+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm;
@property (nonatomic) BOOL deleteConfirm; 
@end
@interface YYTextShadow : NSObject <NSCoding, NSCopying>
+ (instancetype)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;
@property (nullable, nonatomic, strong) UIColor *color; 
@property (nonatomic) CGSize offset;                    
@property (nonatomic) CGFloat radius;                   
@property (nonatomic) CGBlendMode blendMode;            
@property (nullable, nonatomic, strong) YYTextShadow *subShadow;  
+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow; 
- (NSShadow *)nsShadow; 
@end
@interface YYTextDecoration : NSObject <NSCoding, NSCopying>
+ (instancetype)decorationWithStyle:(YYTextLineStyle)style;
+ (instancetype)decorationWithStyle:(YYTextLineStyle)style width:(nullable NSNumber *)width color:(nullable UIColor *)color;
@property (nonatomic) YYTextLineStyle style;                   
@property (nullable, nonatomic, strong) NSNumber *width;       
@property (nullable, nonatomic, strong) UIColor *color;        
@property (nullable, nonatomic, strong) YYTextShadow *shadow;  
@end
@interface YYTextBorder : NSObject <NSCoding, NSCopying>
+ (instancetype)borderWithLineStyle:(YYTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(nullable UIColor *)color;
+ (instancetype)borderWithFillColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;
@property (nonatomic) YYTextLineStyle lineStyle;              
@property (nonatomic) CGFloat strokeWidth;                    
@property (nullable, nonatomic, strong) UIColor *strokeColor; 
@property (nonatomic) CGLineJoin lineJoin;                    
@property (nonatomic) UIEdgeInsets insets;                    
@property (nonatomic) CGFloat cornerRadius;                   
@property (nullable, nonatomic, strong) YYTextShadow *shadow; 
@property (nullable, nonatomic, strong) UIColor *fillColor;   
@end
@interface YYTextAttachment : NSObject<NSCoding, NSCopying>
+ (instancetype)attachmentWithContent:(nullable id)content;
@property (nullable, nonatomic, strong) id content;             
@property (nonatomic) UIViewContentMode contentMode;            
@property (nonatomic) UIEdgeInsets contentInsets;               
@property (nullable, nonatomic, strong) NSDictionary *userInfo; 
@end
@interface YYTextHighlight : NSObject <NSCoding, NSCopying>
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *attributes;
+ (instancetype)highlightWithAttributes:(nullable NSDictionary<NSString *, id> *)attributes;
+ (instancetype)highlightWithBackgroundColor:(nullable UIColor *)color;
- (void)setFont:(nullable UIFont *)font;
- (void)setColor:(nullable UIColor *)color;
- (void)setStrokeWidth:(nullable NSNumber *)width;
- (void)setStrokeColor:(nullable UIColor *)color;
- (void)setShadow:(nullable YYTextShadow *)shadow;
- (void)setInnerShadow:(nullable YYTextShadow *)shadow;
- (void)setUnderline:(nullable YYTextDecoration *)underline;
- (void)setStrikethrough:(nullable YYTextDecoration *)strikethrough;
- (void)setBackgroundBorder:(nullable YYTextBorder *)border;
- (void)setBorder:(nullable YYTextBorder *)border;
- (void)setAttachment:(nullable YYTextAttachment *)attachment;
@property (nullable, nonatomic, copy) NSDictionary *userInfo;
@property (nullable, nonatomic, copy) YYTextAction tapAction;
@property (nullable, nonatomic, copy) YYTextAction longPressAction;
@end
NS_ASSUME_NONNULL_END