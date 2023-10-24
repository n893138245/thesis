#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
#define LOG_CONTEXT_ALL INT_MAX
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#if !(TARGET_OS_OSX)
    #import <UIKit/UIColor.h>
    typedef UIColor DDColor;
    static inline DDColor* _Nonnull DDMakeColor(CGFloat r, CGFloat g, CGFloat b) {return [DDColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];}
#elif defined(DD_CLI) || !__has_include(<AppKit/NSColor.h>)
    #import <CocoaLumberjack/CLIColor.h>
    typedef CLIColor DDColor;
    static inline DDColor* _Nonnull DDMakeColor(CGFloat r, CGFloat g, CGFloat b) {return [DDColor colorWithCalibratedRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];}
#else
    #import <AppKit/NSColor.h>
    typedef NSColor DDColor;
    static inline DDColor  * _Nonnull DDMakeColor(CGFloat r, CGFloat g, CGFloat b) {return [DDColor colorWithCalibratedRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];}
#endif
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_BEGIN
@interface DDTTYLogger : DDAbstractLogger <DDLogger>
@property (nonatomic, class, readonly, strong, nullable) DDTTYLogger *sharedInstance;
@property (readwrite, assign) BOOL colorsEnabled;
@property (nonatomic, readwrite, assign) BOOL automaticallyAppendNewlineForCustomFormatters;
- (instancetype)init NS_UNAVAILABLE;
- (void)setForegroundColor:(nullable DDColor *)txtColor backgroundColor:(nullable DDColor *)bgColor forFlag:(DDLogFlag)mask;
- (void)setForegroundColor:(nullable DDColor *)txtColor backgroundColor:(nullable DDColor *)bgColor forFlag:(DDLogFlag)mask context:(NSInteger)ctxt;
- (void)setForegroundColor:(nullable DDColor *)txtColor backgroundColor:(nullable DDColor *)bgColor forTag:(id <NSCopying>)tag;
- (void)clearColorsForFlag:(DDLogFlag)mask;
- (void)clearColorsForFlag:(DDLogFlag)mask context:(NSInteger)context;
- (void)clearColorsForTag:(id <NSCopying>)tag;
- (void)clearColorsForAllFlags;
- (void)clearColorsForAllTags;
- (void)clearAllColors;
@end
NS_ASSUME_NONNULL_END