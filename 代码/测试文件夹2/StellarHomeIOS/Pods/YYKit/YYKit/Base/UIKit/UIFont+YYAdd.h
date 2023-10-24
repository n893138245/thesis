#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIFont (YYAdd) <NSCoding>
#pragma mark - Font Traits
@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0); 
@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0); 
@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0); 
@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0); 
@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0); 
- (nullable UIFont *)fontWithBold NS_AVAILABLE_IOS(7_0);
- (nullable UIFont *)fontWithItalic NS_AVAILABLE_IOS(7_0);
- (nullable UIFont *)fontWithBoldItalic NS_AVAILABLE_IOS(7_0);
- (nullable UIFont *)fontWithNormal NS_AVAILABLE_IOS(7_0);
#pragma mark - Create font
+ (nullable UIFont *)fontWithCTFont:(CTFontRef)CTFont;
+ (nullable UIFont *)fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;
- (nullable CTFontRef)CTFontRef CF_RETURNS_RETAINED;
- (nullable CGFontRef)CGFontRef CF_RETURNS_RETAINED;
#pragma mark - Load and unload font
+ (BOOL)loadFontFromPath:(NSString *)path;
+ (void)unloadFontFromPath:(NSString *)path;
+ (nullable UIFont *)loadFontFromData:(NSData *)data;
+ (BOOL)unloadFontFromData:(UIFont *)font;
#pragma mark - Dump font data
+ (nullable NSData *)dataFromFont:(UIFont *)font;
+ (nullable NSData *)dataFromCGFont:(CGFontRef)cgFont;
@end
NS_ASSUME_NONNULL_END