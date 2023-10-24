#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
NS_ASSUME_NONNULL_BEGIN
@interface YYTextRunDelegate : NSObject <NSCopying, NSCoding>
- (nullable CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED;
@property (nullable, nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic) CGFloat ascent;
@property (nonatomic) CGFloat descent;
@property (nonatomic) CGFloat width;
@end
NS_ASSUME_NONNULL_END