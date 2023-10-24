#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextDebugOption.h>
#import <YYKit/YYTextLine.h>
#import <YYKit/YYTextInput.h>
#else
#import "YYTextDebugOption.h"
#import "YYTextLine.h"
#import "YYTextInput.h"
#endif
@protocol YYTextLinePositionModifier;
NS_ASSUME_NONNULL_BEGIN
extern const CGSize YYTextContainerMaxSize;
@interface YYTextContainer : NSObject <NSCoding, NSCopying>
+ (instancetype)containerWithSize:(CGSize)size;
+ (instancetype)containerWithSize:(CGSize)size insets:(UIEdgeInsets)insets;
+ (instancetype)containerWithPath:(nullable UIBezierPath *)path;
@property CGSize size;
@property UIEdgeInsets insets;
@property (nullable, copy) UIBezierPath *path;
@property (nullable, copy) NSArray<UIBezierPath *> *exclusionPaths;
@property CGFloat pathLineWidth;
@property (getter=isPathFillEvenOdd) BOOL pathFillEvenOdd;
@property (getter=isVerticalForm) BOOL verticalForm;
@property NSUInteger maximumNumberOfRows;
@property YYTextTruncationType truncationType;
@property (nullable, copy) NSAttributedString *truncationToken;
@property (nullable, copy) id<YYTextLinePositionModifier> linePositionModifier;
@end
@protocol YYTextLinePositionModifier <NSObject, NSCopying>
@required
- (void)modifyLines:(NSArray<YYTextLine *> *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container;
@end
@interface YYTextLinePositionSimpleModifier : NSObject <YYTextLinePositionModifier>
@property (assign) CGFloat fixedLineHeight; 
@end
@interface YYTextLayout : NSObject <NSCoding>
#pragma mark - Generate text layout
+ (nullable YYTextLayout *)layoutWithContainerSize:(CGSize)size
                                              text:(NSAttributedString *)text;
+ (nullable YYTextLayout *)layoutWithContainer:(YYTextContainer *)container
                                          text:(NSAttributedString *)text;
+ (nullable YYTextLayout *)layoutWithContainer:(YYTextContainer *)container
                                          text:(NSAttributedString *)text
                                         range:(NSRange)range;
+ (nullable NSArray<YYTextLayout *> *)layoutWithContainers:(NSArray<YYTextContainer *> *)containers
                                                      text:(NSAttributedString *)text;
+ (nullable NSArray<YYTextLayout *> *)layoutWithContainers:(NSArray<YYTextContainer *> *)containers
                                                      text:(NSAttributedString *)text
                                                     range:(NSRange)range;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
#pragma mark - Text layout attributes
@property (nonatomic, strong, readonly) YYTextContainer *container;
@property (nonatomic, strong, readonly) NSAttributedString *text;
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, readonly) CTFramesetterRef frameSetter;
@property (nonatomic, readonly) CTFrameRef frame;
@property (nonatomic, strong, readonly) NSArray<YYTextLine *> *lines;
@property (nullable, nonatomic, strong, readonly) YYTextLine *truncatedLine;
@property (nullable, nonatomic, strong, readonly) NSArray<YYTextAttachment *> *attachments;
@property (nullable, nonatomic, strong, readonly) NSArray<NSValue *> *attachmentRanges;
@property (nullable, nonatomic, strong, readonly) NSArray<NSValue *> *attachmentRects;
@property (nullable, nonatomic, strong, readonly) NSSet *attachmentContentsSet;
@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSRange visibleRange;
@property (nonatomic, readonly) CGRect textBoundingRect;
@property (nonatomic, readonly) CGSize textBoundingSize;
@property (nonatomic, readonly) BOOL containsHighlight;
@property (nonatomic, readonly) BOOL needDrawBlockBorder;
@property (nonatomic, readonly) BOOL needDrawBackgroundBorder;
@property (nonatomic, readonly) BOOL needDrawShadow;
@property (nonatomic, readonly) BOOL needDrawUnderline;
@property (nonatomic, readonly) BOOL needDrawText;
@property (nonatomic, readonly) BOOL needDrawAttachment;
@property (nonatomic, readonly) BOOL needDrawInnerShadow;
@property (nonatomic, readonly) BOOL needDrawStrikethrough;
@property (nonatomic, readonly) BOOL needDrawBorder;
#pragma mark - Query information from text layout
- (NSUInteger)lineIndexForRow:(NSUInteger)row;
- (NSUInteger)lineCountForRow:(NSUInteger)row;
- (NSUInteger)rowIndexForLine:(NSUInteger)line;
- (NSUInteger)lineIndexForPoint:(CGPoint)point;
- (NSUInteger)closestLineIndexForPoint:(CGPoint)point;
- (CGFloat)offsetForTextPosition:(NSUInteger)position lineIndex:(NSUInteger)lineIndex;
- (NSUInteger)textPositionForPoint:(CGPoint)point lineIndex:(NSUInteger)lineIndex;
- (nullable YYTextPosition *)closestPositionToPoint:(CGPoint)point;
- (nullable YYTextPosition *)positionForPoint:(CGPoint)point
                                  oldPosition:(YYTextPosition *)oldPosition
                                otherPosition:(YYTextPosition *)otherPosition;
- (nullable YYTextRange *)textRangeAtPoint:(CGPoint)point;
- (nullable YYTextRange *)closestTextRangeAtPoint:(CGPoint)point;
- (nullable YYTextRange *)textRangeByExtendingPosition:(YYTextPosition *)position;
- (nullable YYTextRange *)textRangeByExtendingPosition:(YYTextPosition *)position
                                           inDirection:(UITextLayoutDirection)direction
                                                offset:(NSInteger)offset;
- (NSUInteger)lineIndexForPosition:(YYTextPosition *)position;
- (CGPoint)linePositionForPosition:(YYTextPosition *)position;
- (CGRect)caretRectForPosition:(YYTextPosition *)position;
- (CGRect)firstRectForRange:(YYTextRange *)range;
- (CGRect)rectForRange:(YYTextRange *)range;
- (NSArray<YYTextSelectionRect *> *)selectionRectsForRange:(YYTextRange *)range;
- (NSArray<YYTextSelectionRect *> *)selectionRectsWithoutStartAndEndForRange:(YYTextRange *)range;
- (NSArray<YYTextSelectionRect *> *)selectionRectsWithOnlyStartAndEndForRange:(YYTextRange *)range;
#pragma mark - Draw text layout
- (void)drawInContext:(nullable CGContextRef)context
                 size:(CGSize)size
                point:(CGPoint)point
                 view:(nullable UIView *)view
                layer:(nullable CALayer *)layer
                debug:(nullable YYTextDebugOption *)debug
               cancel:(nullable BOOL (^)(void))cancel;
- (void)drawInContext:(nullable CGContextRef)context
                 size:(CGSize)size
                debug:(nullable YYTextDebugOption *)debug;
- (void)addAttachmentToView:(nullable UIView *)view layer:(nullable CALayer *)layer;
- (void)removeAttachmentFromViewAndLayer;
@end
NS_ASSUME_NONNULL_END