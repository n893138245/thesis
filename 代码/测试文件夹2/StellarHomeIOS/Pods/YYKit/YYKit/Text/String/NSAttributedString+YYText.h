#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextAttribute.h>
#import <YYKit/YYTextRubyAnnotation.h>
#else
#import "YYTextAttribute.h"
#import "YYTextRubyAnnotation.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface NSAttributedString (YYText)
- (nullable NSData *)archiveToData;
+ (nullable instancetype)unarchiveFromData:(NSData *)data;
#pragma mark - Retrieving character attribute information
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, id> *attributes;
- (nullable NSDictionary<NSString *, id> *)attributesAtIndex:(NSUInteger)index;
- (nullable id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index;
#pragma mark - Get character attribute as property
@property (nullable, nonatomic, strong, readonly) UIFont *font;
- (nullable UIFont *)fontAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *kern;
- (nullable NSNumber *)kernAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *color;
- (nullable UIColor *)colorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *backgroundColor;
- (nullable UIColor *)backgroundColorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *strokeWidth;
- (nullable NSNumber *)strokeWidthAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *strokeColor;
- (nullable UIColor *)strokeColorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSShadow *shadow;
- (nullable NSShadow *)shadowAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSUnderlineStyle strikethroughStyle;
- (NSUnderlineStyle)strikethroughStyleAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *strikethroughColor;
- (nullable UIColor *)strikethroughColorAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSUnderlineStyle underlineStyle;
- (NSUnderlineStyle)underlineStyleAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *underlineColor;
- (nullable UIColor *)underlineColorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *ligature;
- (nullable NSNumber *)ligatureAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSString *textEffect;
- (nullable NSString *)textEffectAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *obliqueness;
- (nullable NSNumber *)obliquenessAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *expansion;
- (nullable NSNumber *)expansionAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *baselineOffset;
- (nullable NSNumber *)baselineOffsetAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) BOOL verticalGlyphForm;
- (BOOL)verticalGlyphFormAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSString *language;
- (nullable NSString *)languageAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSArray<NSNumber *> *writingDirection;
- (nullable NSArray<NSNumber *> *)writingDirectionAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSParagraphStyle *paragraphStyle;
- (nullable NSParagraphStyle *)paragraphStyleAtIndex:(NSUInteger)index;
#pragma mark - Get paragraph attribute as property
@property (nonatomic, readonly) NSTextAlignment alignment;
- (NSTextAlignment)alignmentAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSLineBreakMode lineBreakMode;
- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat lineSpacing;
- (CGFloat)lineSpacingAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat paragraphSpacing;
- (CGFloat)paragraphSpacingAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat paragraphSpacingBefore;
- (CGFloat)paragraphSpacingBeforeAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat firstLineHeadIndent;
- (CGFloat)firstLineHeadIndentAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat headIndent;
- (CGFloat)headIndentAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat tailIndent;
- (CGFloat)tailIndentAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat minimumLineHeight;
- (CGFloat)minimumLineHeightAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat maximumLineHeight;
- (CGFloat)maximumLineHeightAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat lineHeightMultiple;
- (CGFloat)lineHeightMultipleAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSWritingDirection baseWritingDirection;
- (NSWritingDirection)baseWritingDirectionAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) float hyphenationFactor;
- (float)hyphenationFactorAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGFloat defaultTabInterval;
- (CGFloat)defaultTabIntervalAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, copy, readonly) NSArray<NSTextTab *> *tabStops;
- (nullable NSArray<NSTextTab *> *)tabStopsAtIndex:(NSUInteger)index;
#pragma mark - Get YYText attribute as property
@property (nullable, nonatomic, strong, readonly) YYTextShadow *textShadow;
- (nullable YYTextShadow *)textShadowAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) YYTextShadow *textInnerShadow;
- (nullable YYTextShadow *)textInnerShadowAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) YYTextDecoration *textUnderline;
- (nullable YYTextDecoration *)textUnderlineAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) YYTextDecoration *textStrikethrough;
- (nullable YYTextDecoration *)textStrikethroughAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) YYTextBorder *textBorder;
- (nullable YYTextBorder *)textBorderAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) YYTextBorder *textBackgroundBorder;
- (nullable YYTextBorder *)textBackgroundBorderAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) CGAffineTransform textGlyphTransform;
- (CGAffineTransform)textGlyphTransformAtIndex:(NSUInteger)index;
#pragma mark - Query for YYText
- (nullable NSString *)plainTextForRange:(NSRange)range;
#pragma mark - Create attachment string for YYText
+ (NSMutableAttributedString *)attachmentStringWithContent:(nullable id)content
                                               contentMode:(UIViewContentMode)contentMode
                                                     width:(CGFloat)width
                                                    ascent:(CGFloat)ascent
                                                   descent:(CGFloat)descent;
+ (NSMutableAttributedString *)attachmentStringWithContent:(nullable id)content
                                               contentMode:(UIViewContentMode)contentMode
                                            attachmentSize:(CGSize)attachmentSize
                                               alignToFont:(UIFont *)font
                                                 alignment:(YYTextVerticalAlignment)alignment;
+ (nullable NSMutableAttributedString *)attachmentStringWithEmojiImage:(UIImage *)image
                                                              fontSize:(CGFloat)fontSize;
#pragma mark - Utility
- (NSRange)rangeOfAll;
- (BOOL)isSharedAttributesInAllRange;
- (BOOL)canDrawWithUIKit;
@end
@interface NSMutableAttributedString (YYText)
#pragma mark - Set character attribute
- (void)setAttributes:(nullable NSDictionary<NSString *, id> *)attributes;
- (void)setAttribute:(NSString *)name value:(nullable id)value;
- (void)setAttribute:(NSString *)name value:(nullable id)value range:(NSRange)range;
- (void)removeAttributesInRange:(NSRange)range;
#pragma mark - Set character attribute as property
@property (nullable, nonatomic, strong, readwrite) UIFont *font;
- (void)setFont:(nullable UIFont *)font range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSNumber *kern;
- (void)setKern:(nullable NSNumber *)kern range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) UIColor *color;
- (void)setColor:(nullable UIColor *)color range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) UIColor *backgroundColor;
- (void)setBackgroundColor:(nullable UIColor *)backgroundColor range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSNumber *strokeWidth;
- (void)setStrokeWidth:(nullable NSNumber *)strokeWidth range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) UIColor *strokeColor;
- (void)setStrokeColor:(nullable UIColor *)strokeColor range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSShadow *shadow;
- (void)setShadow:(nullable NSShadow *)shadow range:(NSRange)range;
@property (nonatomic, readwrite) NSUnderlineStyle strikethroughStyle;
- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) UIColor *strikethroughColor;
- (void)setStrikethroughColor:(nullable UIColor *)strikethroughColor range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readwrite) NSUnderlineStyle underlineStyle;
- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) UIColor *underlineColor;
- (void)setUnderlineColor:(nullable UIColor *)underlineColor range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSNumber *ligature;
- (void)setLigature:(nullable NSNumber *)ligature range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSString *textEffect;
- (void)setTextEffect:(nullable NSString *)textEffect range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSNumber *obliqueness;
- (void)setObliqueness:(nullable NSNumber *)obliqueness range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSNumber *expansion;
- (void)setExpansion:(nullable NSNumber *)expansion range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSNumber *baselineOffset;
- (void)setBaselineOffset:(nullable NSNumber *)baselineOffset range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readwrite) BOOL verticalGlyphForm;
- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSString *language;
- (void)setLanguage:(nullable NSString *)language range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSArray<NSNumber *> *writingDirection;
- (void)setWritingDirection:(nullable NSArray<NSNumber *> *)writingDirection range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSParagraphStyle *paragraphStyle;
- (void)setParagraphStyle:(nullable NSParagraphStyle *)paragraphStyle range:(NSRange)range;
#pragma mark - Set paragraph attribute as property
@property (nonatomic, readwrite) NSTextAlignment alignment;
- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range;
@property (nonatomic, readwrite) NSLineBreakMode lineBreakMode;
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat lineSpacing;
- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat paragraphSpacing;
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat paragraphSpacingBefore;
- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat firstLineHeadIndent;
- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat headIndent;
- (void)setHeadIndent:(CGFloat)headIndent range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat tailIndent;
- (void)setTailIndent:(CGFloat)tailIndent range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat minimumLineHeight;
- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat maximumLineHeight;
- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat lineHeightMultiple;
- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;
@property (nonatomic, readwrite) NSWritingDirection baseWritingDirection;
- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;
@property (nonatomic, readwrite) float hyphenationFactor;
- (void)setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat defaultTabInterval;
- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, copy, readwrite) NSArray<NSTextTab *> *tabStops;
- (void)setTabStops:(nullable NSArray<NSTextTab *> *)tabStops range:(NSRange)range NS_AVAILABLE_IOS(7_0);
#pragma mark - Set YYText attribute as property
@property (nullable, nonatomic, strong, readwrite) YYTextShadow *textShadow;
- (void)setTextShadow:(nullable YYTextShadow *)textShadow range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) YYTextShadow *textInnerShadow;
- (void)setTextInnerShadow:(nullable YYTextShadow *)textInnerShadow range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) YYTextDecoration *textUnderline;
- (void)setTextUnderline:(nullable YYTextDecoration *)textUnderline range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) YYTextDecoration *textStrikethrough;
- (void)setTextStrikethrough:(nullable YYTextDecoration *)textStrikethrough range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) YYTextBorder *textBorder;
- (void)setTextBorder:(nullable YYTextBorder *)textBorder range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) YYTextBorder *textBackgroundBorder;
- (void)setTextBackgroundBorder:(nullable YYTextBorder *)textBackgroundBorder range:(NSRange)range;
@property (nonatomic, readwrite) CGAffineTransform textGlyphTransform;
- (void)setTextGlyphTransform:(CGAffineTransform)textGlyphTransform range:(NSRange)range;
#pragma mark - Set discontinuous attribute for range
- (void)setSuperscript:(nullable NSNumber *)superscript range:(NSRange)range;
- (void)setGlyphInfo:(nullable CTGlyphInfoRef)glyphInfo range:(NSRange)range;
- (void)setCharacterShape:(nullable NSNumber *)characterShape range:(NSRange)range;
- (void)setRunDelegate:(nullable CTRunDelegateRef)runDelegate range:(NSRange)range;
- (void)setBaselineClass:(nullable CFStringRef)baselineClass range:(NSRange)range;
- (void)setBaselineInfo:(nullable CFDictionaryRef)baselineInfo range:(NSRange)range;
- (void)setBaselineReferenceInfo:(nullable CFDictionaryRef)referenceInfo range:(NSRange)range;
- (void)setRubyAnnotation:(nullable CTRubyAnnotationRef)ruby range:(NSRange)range NS_AVAILABLE_IOS(8_0);
- (void)setAttachment:(nullable NSTextAttachment *)attachment range:(NSRange)range NS_AVAILABLE_IOS(7_0);
- (void)setLink:(nullable id)link range:(NSRange)range NS_AVAILABLE_IOS(7_0);
- (void)setTextBackedString:(nullable YYTextBackedString *)textBackedString range:(NSRange)range;
- (void)setTextBinding:(nullable YYTextBinding *)textBinding range:(NSRange)range;
- (void)setTextAttachment:(nullable YYTextAttachment *)textAttachment range:(NSRange)range;
- (void)setTextHighlight:(nullable YYTextHighlight *)textHighlight range:(NSRange)range;
- (void)setTextBlockBorder:(nullable YYTextBorder *)textBlockBorder range:(NSRange)range;
- (void)setTextRubyAnnotation:(nullable YYTextRubyAnnotation *)ruby range:(NSRange)range NS_AVAILABLE_IOS(8_0);
#pragma mark - Convenience methods for text highlight
- (void)setTextHighlightRange:(NSRange)range
                        color:(nullable UIColor *)color
              backgroundColor:(nullable UIColor *)backgroundColor
                     userInfo:(nullable NSDictionary *)userInfo
                    tapAction:(nullable YYTextAction)tapAction
              longPressAction:(nullable YYTextAction)longPressAction;
- (void)setTextHighlightRange:(NSRange)range
                        color:(nullable UIColor *)color
              backgroundColor:(nullable UIColor *)backgroundColor
                    tapAction:(nullable YYTextAction)tapAction;
- (void)setTextHighlightRange:(NSRange)range
                        color:(nullable UIColor *)color
              backgroundColor:(nullable UIColor *)backgroundColor
                     userInfo:(nullable NSDictionary *)userInfo;
#pragma mark - Utilities
- (void)insertString:(NSString *)string atIndex:(NSUInteger)location;
- (void)appendString:(NSString *)string;
- (void)setClearColorToJoinedEmoji;
- (void)removeDiscontinuousAttributesInRange:(NSRange)range;
+ (NSArray<NSString *> *)allDiscontinuousAttributeKeys;
@end
NS_ASSUME_NONNULL_END