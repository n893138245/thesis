#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSParagraphStyle (YYText)
+ (nullable NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle;
- (nullable CTParagraphStyleRef)CTStyle CF_RETURNS_RETAINED;
@end
NS_ASSUME_NONNULL_END