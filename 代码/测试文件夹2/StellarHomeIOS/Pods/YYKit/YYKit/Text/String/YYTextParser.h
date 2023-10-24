#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol YYTextParser <NSObject>
@required
- (BOOL)parseText:(nullable NSMutableAttributedString *)text selectedRange:(nullable NSRangePointer)selectedRange;
@end
@interface YYTextSimpleMarkdownParser : NSObject <YYTextParser>
@property (nonatomic) CGFloat fontSize;         
@property (nonatomic) CGFloat headerFontSize;   
@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIColor *controlTextColor;
@property (nullable, nonatomic, strong) UIColor *headerTextColor;
@property (nullable, nonatomic, strong) UIColor *inlineTextColor;
@property (nullable, nonatomic, strong) UIColor *codeTextColor;
@property (nullable, nonatomic, strong) UIColor *linkTextColor;
- (void)setColorWithBrightTheme; 
- (void)setColorWithDarkTheme;   
@end
@interface YYTextSimpleEmoticonParser : NSObject <YYTextParser>
@property (nullable, copy) NSDictionary<NSString *, __kindof UIImage *> *emoticonMapper;
@end
NS_ASSUME_NONNULL_END