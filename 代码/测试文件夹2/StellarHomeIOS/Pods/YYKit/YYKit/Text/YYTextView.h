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
@class YYTextView;
NS_ASSUME_NONNULL_BEGIN
@protocol YYTextViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView;
- (BOOL)textViewShouldEndEditing:(YYTextView *)textView;
- (void)textViewDidBeginEditing:(YYTextView *)textView;
- (void)textViewDidEndEditing:(YYTextView *)textView;
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(YYTextView *)textView;
- (void)textViewDidChangeSelection:(YYTextView *)textView;
- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange;
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect;
- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange;
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect;
@end
#if !TARGET_INTERFACE_BUILDER
@interface YYTextView : UIScrollView <UITextInput>
#pragma mark - Accessing the Delegate
@property (nullable, nonatomic, weak) id<YYTextViewDelegate> delegate;
#pragma mark - Configuring the Text Attributes
@property (null_resettable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, strong) UIFont *font;
@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) YYTextVerticalAlignment textVerticalAlignment;
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *linkTextAttributes;
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *highlightTextAttributes;
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *typingAttributes;
@property (nullable, nonatomic, copy) NSAttributedString *attributedText;
@property (nullable, nonatomic, strong) id<YYTextParser> textParser;
@property (nullable, nonatomic, strong, readonly) YYTextLayout *textLayout;
#pragma mark - Configuring the Placeholder
@property (nullable, nonatomic, copy) NSString *placeholderText;
@property (nullable, nonatomic, strong) UIFont *placeholderFont;
@property (nullable, nonatomic, strong) UIColor *placeholderTextColor;
@property (nullable, nonatomic, copy) NSAttributedString *placeholderAttributedText;
#pragma mark - Configuring the Text Container
@property (nonatomic) UIEdgeInsets textContainerInset;
@property (nullable, nonatomic, copy) NSArray<UIBezierPath *> *exclusionPaths;
@property (nonatomic, getter=isVerticalForm) BOOL verticalForm;
@property (nullable, nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;
@property (nullable, nonatomic, copy) YYTextDebugOption *debugOption;
#pragma mark - Working with the Selection and Menu
- (void)scrollRangeToVisible:(NSRange)range;
@property (nonatomic) NSRange selectedRange;
@property (nonatomic) BOOL clearsOnInsertion;
@property (nonatomic, getter=isSelectable) BOOL selectable;
@property (nonatomic, getter=isHighlightable) BOOL highlightable;
@property (nonatomic, getter=isEditable) BOOL editable;
@property (nonatomic) BOOL allowsPasteImage;
@property (nonatomic) BOOL allowsPasteAttributedString;
@property (nonatomic) BOOL allowsCopyAttributedString;
#pragma mark - Manage the undo and redo
@property (nonatomic) BOOL allowsUndoAndRedo;
@property (nonatomic) NSUInteger maximumUndoLevel;
#pragma mark - Replacing the System Input Views
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputView;
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputAccessoryView;
@property (nonatomic) CGFloat extraAccessoryViewHeight;
@end
#else 
IB_DESIGNABLE
@interface YYTextView : UIScrollView <UITextInput>
@property (null_resettable, nonatomic, copy) IBInspectable NSString *text;
@property (nullable, nonatomic, strong) IBInspectable UIColor *textColor;
@property (nullable, nonatomic, strong) IBInspectable NSString *fontName_;
@property (nonatomic) IBInspectable CGFloat fontSize_;
@property (nonatomic) IBInspectable BOOL fontIsBold_;
@property (nonatomic) IBInspectable NSTextAlignment textAlignment;
@property (nonatomic) IBInspectable YYTextVerticalAlignment textVerticalAlignment;
@property (nullable, nonatomic, copy) IBInspectable NSString *placeholderText;
@property (nullable, nonatomic, strong) IBInspectable UIColor *placeholderTextColor;
@property (nullable, nonatomic, strong) IBInspectable NSString *placeholderFontName_;
@property (nonatomic) IBInspectable CGFloat placeholderFontSize_;
@property (nonatomic) IBInspectable BOOL placeholderFontIsBold_;
@property (nonatomic, getter=isVerticalForm) IBInspectable BOOL verticalForm;
@property (nonatomic) IBInspectable BOOL clearsOnInsertion;
@property (nonatomic, getter=isSelectable) IBInspectable BOOL selectable;
@property (nonatomic, getter=isHighlightable) IBInspectable BOOL highlightable;
@property (nonatomic, getter=isEditable) IBInspectable BOOL editable;
@property (nonatomic) IBInspectable BOOL allowsPasteImage;
@property (nonatomic) IBInspectable BOOL allowsPasteAttributedString;
@property (nonatomic) IBInspectable BOOL allowsCopyAttributedString;
@property (nonatomic) IBInspectable BOOL allowsUndoAndRedo;
@property (nonatomic) IBInspectable NSUInteger maximumUndoLevel;
@property (nonatomic) IBInspectable CGFloat insetTop_;
@property (nonatomic) IBInspectable CGFloat insetBottom_;
@property (nonatomic) IBInspectable CGFloat insetLeft_;
@property (nonatomic) IBInspectable CGFloat insetRight_;
@property (nonatomic) IBInspectable BOOL debugEnabled_;
@property (nullable, nonatomic, weak) id<YYTextViewDelegate> delegate;
@property (nullable, nonatomic, strong) UIFont *font;
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;
@property (nullable, nonatomic, copy) NSDictionary *linkTextAttributes;
@property (nullable, nonatomic, copy) NSDictionary *highlightTextAttributes;
@property (nullable, nonatomic, copy) NSDictionary *typingAttributes;
@property (nullable, nonatomic, copy) NSAttributedString *attributedText;
@property (nullable, nonatomic, strong) id<YYTextParser> textParser;
@property (nullable, nonatomic, strong, readonly) YYTextLayout *textLayout;
@property (nullable, nonatomic, strong) UIFont *placeholderFont;
@property (nullable, nonatomic, copy) NSAttributedString *placeholderAttributedText;
@property (nonatomic) UIEdgeInsets textContainerInset;
@property (nullable, nonatomic, copy) NSArray *exclusionPaths;
@property (nullable, nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;
@property (nullable, nonatomic, copy) YYTextDebugOption *debugOption;
- (void)scrollRangeToVisible:(NSRange)range;
@property (nonatomic) NSRange selectedRange;
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputView;
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputAccessoryView;
@property (nonatomic) CGFloat extraAccessoryViewHeight;
@end
#endif 
UIKIT_EXTERN NSString *const YYTextViewTextDidBeginEditingNotification;
UIKIT_EXTERN NSString *const YYTextViewTextDidChangeNotification;
UIKIT_EXTERN NSString *const YYTextViewTextDidEndEditingNotification;
NS_ASSUME_NONNULL_END