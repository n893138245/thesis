#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextParser.h>
#import <YYKit/YYTextLayout.h>
#import <YYKit/YYTextAttribute.h>
#else
#import "YYTextParser.h"
#import "YYTextLayout.h"
#import "YYTextAttribute.h"
#endif
NS_ASSUME_NONNULL_BEGIN
#if !TARGET_INTERFACE_BUILDER
@interface YYLabel : UIView <NSCoding>
#pragma mark - Accessing the Text Attributes
@property (nullable, nonatomic, copy) NSString *text;
@property (null_resettable, nonatomic, strong) UIFont *font;
@property (null_resettable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlurRadius;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) YYTextVerticalAlignment textVerticalAlignment;
@property (nullable, nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nullable, nonatomic, copy) NSAttributedString *truncationToken;
@property (nonatomic) NSUInteger numberOfLines;
@property (nullable, nonatomic, strong) id<YYTextParser> textParser;
@property (nullable, nonatomic, strong) YYTextLayout *textLayout;
#pragma mark - Configuring the Text Container
@property (nullable, nonatomic, copy) UIBezierPath *textContainerPath;
@property (nullable, nonatomic, copy) NSArray<UIBezierPath *> *exclusionPaths;
@property (nonatomic) UIEdgeInsets textContainerInset;
@property (nonatomic, getter=isVerticalForm) BOOL verticalForm;
@property (nullable, nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;
@property (nullable, nonatomic, copy) YYTextDebugOption *debugOption;
#pragma mark - Getting the Layout Constraints
@property (nonatomic) CGFloat preferredMaxLayoutWidth;
#pragma mark - Interacting with Text Data
@property (nullable, nonatomic, copy) YYTextAction textTapAction;
@property (nullable, nonatomic, copy) YYTextAction textLongPressAction;
@property (nullable, nonatomic, copy) YYTextAction highlightTapAction;
@property (nullable, nonatomic, copy) YYTextAction highlightLongPressAction;
#pragma mark - Configuring the Display Mode
@property (nonatomic) BOOL displaysAsynchronously;
@property (nonatomic) BOOL clearContentsBeforeAsynchronouslyDisplay;
@property (nonatomic) BOOL fadeOnAsynchronouslyDisplay;
@property (nonatomic) BOOL fadeOnHighlight;
@property (nonatomic) BOOL ignoreCommonProperties;
@end
#else 
IB_DESIGNABLE
@interface YYLabel : UIView <NSCoding>
@property (nullable, nonatomic, copy) IBInspectable NSString *text;
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *textColor;
@property (nullable, nonatomic, strong) IBInspectable NSString *fontName_;
@property (nonatomic) IBInspectable CGFloat fontSize_;
@property (nonatomic) IBInspectable BOOL fontIsBold_;
@property (nonatomic) IBInspectable NSUInteger numberOfLines;
@property (nonatomic) IBInspectable NSInteger lineBreakMode;
@property (nonatomic) IBInspectable CGFloat preferredMaxLayoutWidth;
@property (nonatomic, getter=isVerticalForm) IBInspectable BOOL verticalForm;
@property (nonatomic) IBInspectable NSInteger textAlignment;
@property (nonatomic) IBInspectable NSInteger textVerticalAlignment;
@property (nullable, nonatomic, strong) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGPoint shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowBlurRadius;
@property (nullable, nonatomic, copy) IBInspectable NSAttributedString *attributedText;
@property (nonatomic) IBInspectable CGFloat insetTop_;
@property (nonatomic) IBInspectable CGFloat insetBottom_;
@property (nonatomic) IBInspectable CGFloat insetLeft_;
@property (nonatomic) IBInspectable CGFloat insetRight_;
@property (nonatomic) IBInspectable BOOL debugEnabled_;
@property (null_resettable, nonatomic, strong) UIFont *font;
@property (nullable, nonatomic, copy) NSAttributedString *truncationToken;
@property (nullable, nonatomic, strong) id<YYTextParser> textParser;
@property (nullable, nonatomic, strong) YYTextLayout *textLayout;
@property (nullable, nonatomic, copy) UIBezierPath *textContainerPath;
@property (nullable, nonatomic, copy) NSArray<UIBezierPath *> *exclusionPaths;
@property (nonatomic) UIEdgeInsets textContainerInset;
@property (nullable, nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;
@property (nonnull, nonatomic, copy) YYTextDebugOption *debugOption;
@property (nullable, nonatomic, copy) YYTextAction textTapAction;
@property (nullable, nonatomic, copy) YYTextAction textLongPressAction;
@property (nullable, nonatomic, copy) YYTextAction highlightTapAction;
@property (nullable, nonatomic, copy) YYTextAction highlightLongPressAction;
@property (nonatomic) BOOL displaysAsynchronously;
@property (nonatomic) BOOL clearContentsBeforeAsynchronouslyDisplay;
@property (nonatomic) BOOL fadeOnAsynchronouslyDisplay;
@property (nonatomic) BOOL fadeOnHighlight;
@property (nonatomic) BOOL ignoreCommonProperties;
@end
#endif 
NS_ASSUME_NONNULL_END