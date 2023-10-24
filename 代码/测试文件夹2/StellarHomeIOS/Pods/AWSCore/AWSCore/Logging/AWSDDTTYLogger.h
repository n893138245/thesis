#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
#define LOG_CONTEXT_ALL INT_MAX
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#if !(TARGET_OS_OSX)
    #import <UIKit/UIColor.h>
    typedef UIColor AWSDDColor;
    static inline AWSDDColor* AWSDDMakeColor(CGFloat r, CGFloat g, CGFloat b) {return [AWSDDColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];}
#elif defined(AWSDD_CLI) || !__has_include(<AppKit/NSColor.h>)
    #import "CLIColor.h"
    typedef CLIColor AWSDDColor;
    static inline AWSDDColor* AWSDDMakeColor(CGFloat r, CGFloat g, CGFloat b) {return [AWSDDColor colorWithCalibratedRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];}
#else
    #import <AppKit/NSColor.h>
    typedef NSColor AWSDDColor;
    static inline AWSDDColor* AWSDDMakeColor(CGFloat r, CGFloat g, CGFloat b) {return [AWSDDColor colorWithCalibratedRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];}
#endif
#pragma clang diagnostic pop
@interface AWSDDTTYLogger : AWSDDAbstractLogger <AWSDDLogger>
@property (class, readonly, strong) AWSDDTTYLogger *sharedInstance;
@property (readwrite, assign) BOOL colorsEnabled;
@property (nonatomic, readwrite, assign) BOOL automaticallyAppendNewlineForCustomFormatters;
- (void)setForegroundColor:(AWSDDColor *)txtColor backgroundColor:(AWSDDColor *)bgColor forFlag:(AWSDDLogFlag)mask;
- (void)setForegroundColor:(AWSDDColor *)txtColor backgroundColor:(AWSDDColor *)bgColor forFlag:(AWSDDLogFlag)mask context:(NSInteger)ctxt;
- (void)setForegroundColor:(AWSDDColor *)txtColor backgroundColor:(AWSDDColor *)bgColor forTag:(id <NSCopying>)tag;
- (void)clearColorsForFlag:(AWSDDLogFlag)mask;
- (void)clearColorsForFlag:(AWSDDLogFlag)mask context:(NSInteger)context;
- (void)clearColorsForTag:(id <NSCopying>)tag;
- (void)clearColorsForAllFlags;
- (void)clearColorsForAllTags;
- (void)clearAllColors;
@end