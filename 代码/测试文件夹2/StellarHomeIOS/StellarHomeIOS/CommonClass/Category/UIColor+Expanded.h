#import <UIKit/UIKit.h>
#define RGBCOLOR(_R_, _G_, _B_)                                                \
  [UIColor colorWithRed:(CGFloat)(_R_) / 255.0f                                \
                  green:(CGFloat)(_G_) / 255.0f                                \
                   blue:(CGFloat)(_B_) / 255.0f                                \
                  alpha:1.0f]
CGColorSpaceRef DeviceRGBSpace();
CGColorSpaceRef DeviceGraySpace();
UIColor *RandomColor();
UIColor *InterpolateColors(UIColor *c1, UIColor *c2, CGFloat percent);
@interface UIColor (UIColor_Expanded)
#pragma mark - Color Wheel
+ (UIImage *)colorWheelOfSize:(CGFloat)side border:(BOOL)yorn;
#pragma mark - Color Space
+ (NSString *)colorSpaceString:(CGColorSpaceModel)model;
@property(nonatomic, readonly) NSString *colorSpaceString;
@property(nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property(nonatomic, readonly) BOOL canProvideRGBComponents;
@property(nonatomic, readonly) BOOL usesMonochromeColorspace;
@property(nonatomic, readonly) BOOL usesRGBColorspace;
#pragma mark - Color Conversion
+ (void)hue:(CGFloat)h
    saturation:(CGFloat)s
    brightness:(CGFloat)v
         toRed:(CGFloat *)pR
         green:(CGFloat *)pG
          blue:(CGFloat *)pB;
+ (void)red:(CGFloat)r
         green:(CGFloat)g
          blue:(CGFloat)b
         toHue:(CGFloat *)pH
    saturation:(CGFloat *)pS
    brightness:(CGFloat *)pV;
void RGB2YUV_f(CGFloat r, CGFloat g, CGFloat b, CGFloat *y, CGFloat *u,
               CGFloat *v);
void YUV2RGB_f(CGFloat y, CGFloat u, CGFloat v, CGFloat *r, CGFloat *g,
               CGFloat *b);
void RGBtoHSP(CGFloat R, CGFloat G, CGFloat B, CGFloat *H, CGFloat *S,
              CGFloat *P);
void HSPtoRGB(CGFloat H, CGFloat S, CGFloat P, CGFloat *R, CGFloat *G,
              CGFloat *B);
@property(nonatomic, readonly) CGFloat perceivedBrightness;
#pragma mark - Color Components
@property(nonatomic, readonly) CGFloat red;
@property(nonatomic, readonly) CGFloat green;
@property(nonatomic, readonly) CGFloat blue;
@property(nonatomic, readonly) CGFloat premultipliedRed;
@property(nonatomic, readonly) CGFloat premultipliedGreen;
@property(nonatomic, readonly) CGFloat premultipliedBlue;
+ (UIColor *)colorWithCyan:(CGFloat)c
                   magenta:(CGFloat)m
                    yellow:(CGFloat)y
                     black:(CGFloat)k;
- (void)toC:(CGFloat *)cyan
        toM:(CGFloat *)magenta
        toY:(CGFloat *)yellow
        toK:(CGFloat *)black;
@property(nonatomic, readonly) CGFloat cyanChannel;
@property(nonatomic, readonly) CGFloat magentaChannel;
@property(nonatomic, readonly) CGFloat yellowChannel;
@property(nonatomic, readonly) CGFloat blackChannel;
@property(nonatomic, readonly) NSArray *cmyk;
#define MAKEBYTE(_VALUE_) (int)(_VALUE_ * 0xFF) & 0xFF
@property(nonatomic, readonly) Byte redByte;
@property(nonatomic, readonly) Byte greenByte;
@property(nonatomic, readonly) Byte blueByte;
@property(nonatomic, readonly) Byte alphaByte;
@property(nonatomic, readonly) Byte whiteByte;
@property(nonatomic, readonly) NSData *colorBytes;
@property(nonatomic, readonly) NSData *premultipledColorBytes;
@property(nonatomic, readonly) CGFloat white;
@property(nonatomic, readonly) CGFloat luminance;
@property(nonatomic, readonly) CGFloat hue;
@property(nonatomic, readonly) CGFloat saturation;
@property(nonatomic, readonly) CGFloat brightness;
@property(nonatomic, readonly) CGFloat alpha;
@property(nonatomic, readonly) uint32_t rgbHex;
- (NSArray *)arrayFromRGBAComponents;
- (UIColor *)colorByLuminanceMapping;
#pragma mark - Alternative Expression
@property(nonatomic, readonly) CGFloat colorfulness;
@property(nonatomic, readonly) CGFloat warmth;
#pragma mark - Building
- (UIColor *)adjustWarmth:(CGFloat)delta;
- (UIColor *)adjustBrightness:(CGFloat)delta;
- (UIColor *)adjustSaturation:(CGFloat)delta;
- (UIColor *)adjustHue:(CGFloat)delta;
#pragma mark - Sorting
- (NSComparisonResult)compareWarmth:(UIColor *)anotherColor;
- (NSComparisonResult)compareColorfulness:(UIColor *)anotherColor;
- (NSComparisonResult)compareHue:(UIColor *)anotherColor;
- (NSComparisonResult)compareSaturation:(UIColor *)anotherColor;
- (NSComparisonResult)compareBrightness:(UIColor *)anotherColor;
#pragma mark - Distance
- (CGFloat)luminanceDistanceFrom:(UIColor *)anotherColor;
- (CGFloat)distanceFrom:(UIColor *)anotherColor;
- (BOOL)isEqualToColor:(UIColor *)anotherColor;
#pragma mark - Math
- (UIColor *)colorByMultiplyingByRed:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue
                               alpha:(CGFloat)alpha;
- (UIColor *)colorByAddingRed:(CGFloat)red
                        green:(CGFloat)green
                         blue:(CGFloat)blue
                        alpha:(CGFloat)alpha;
- (UIColor *)colorByLighteningToRed:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue
                              alpha:(CGFloat)alpha;
- (UIColor *)colorByDarkeningToRed:(CGFloat)red
                             green:(CGFloat)green
                              blue:(CGFloat)blue
                             alpha:(CGFloat)alpha;
- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)colorByAdding:(CGFloat)f;
- (UIColor *)colorByLighteningTo:(CGFloat)f;
- (UIColor *)colorByDarkeningTo:(CGFloat)f;
- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)colorByAddingColor:(UIColor *)color;
- (UIColor *)colorByLighteningToColor:(UIColor *)color;
- (UIColor *)colorByDarkeningToColor:(UIColor *)color;
- (UIColor *)colorByInterpolatingToColor:(UIColor *)color
                              byFraction:(CGFloat)fraction;
- (UIColor *)colorWithBrightness:(CGFloat)brightness;
- (UIColor *)colorWithSaturation:(CGFloat)saturation;
- (UIColor *)colorWithHue:(CGFloat)hue;
- (UIColor *)
    contrastingColor; 
- (UIColor *)complementaryColor; 
- (NSArray *)triadicColors; 
- (NSArray *)analogousColorsWithStepAngle:(CGFloat)stepAngle
                                pairCount:(NSInteger)
                                              pairs; 
- (UIColor *)kevinColorWithColor:(UIColor *)secondColor; 
#pragma mark - Strings
@property(nonatomic, readonly) NSString *stringValue;
@property(nonatomic, readonly) NSString *hexStringValue;
@property(nonatomic, readonly) NSString *valueString;
+ (UIColor *)colorWithString:(NSString *)string;
+ (UIColor *)colorWithHex:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBHex:(uint32_t)hex;
#pragma mark - Temperature
+ (UIColor *)colorWithKelvin:(CGFloat)kelvin;
+ (NSDictionary *)kelvinDictionary;
@property(nonatomic, readonly) CGFloat colorTemperature;
#pragma mark - Random
+ (UIColor *)randomColor;
+ (UIColor *)randomDarkColor:(CGFloat)scaleFactor;
+ (UIColor *)randomLightColor:(CGFloat)scaleFactor;
@end
#pragma mark - Named Colors
@interface UIColor (NamedColors)
+ (NSArray *)availableColorDictionaries;
+ (NSDictionary *)colorDictionaryNamed:(NSString *)dictionaryName;
+ (UIColor *)colorWithName:(NSString *)name
              inDictionary:(NSString *)dictionaryName;
+ (UIColor *)colorWithName:(NSString *)name;
- (NSString *)closestColorNameUsingDictionary:(NSString *)dictionaryName;
- (NSDictionary *)closestColors;
+ (NSArray *)closeColorNames:(NSString *)colorNameString;
+ (NSArray *)closeColorNamesMatchingKeys:(NSArray *)keys;
+ (NSArray *)closeAppleNamesMatchingKeys:(NSArray *)keys;
@property(nonatomic, readonly) NSString *closestColorName;
@property(nonatomic, readonly) UIColor *closestMensColor;
@property(nonatomic, readonly) NSString *closestPseudoPantoneName;
@end
@interface UIImage (UIColor_Expanded)
@property(nonatomic, readonly) CGColorSpaceRef colorSpace;
@property(nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property(nonatomic, readonly) NSString *colorSpaceString;
@end