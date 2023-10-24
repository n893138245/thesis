#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
#import <sys/uio.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#ifndef DD_NSLOG_LEVEL
    #define DD_NSLOG_LEVEL 2
#endif
#define NSLogError(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(DD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define XCODE_COLORS_ESCAPE_SEQ "\033["
#define XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCAPE_SEQ "fg;" 
#define XCODE_COLORS_RESET_BG   XCODE_COLORS_ESCAPE_SEQ "bg;" 
#define XCODE_COLORS_RESET      XCODE_COLORS_ESCAPE_SEQ ";"  
#define MAP_TO_TERMINAL_APP_COLORS 1
typedef struct {
  uint8_t r;
  uint8_t g;
  uint8_t b;
} DDRGBColor;
@interface DDTTYLoggerColorProfile : NSObject {
    @public
    DDLogFlag mask;
    NSInteger context;
    uint8_t fg_r;
    uint8_t fg_g;
    uint8_t fg_b;
    uint8_t bg_r;
    uint8_t bg_g;
    uint8_t bg_b;
    NSUInteger fgCodeIndex;
    NSString *fgCodeRaw;
    NSUInteger bgCodeIndex;
    NSString *bgCodeRaw;
    char fgCode[24];
    size_t fgCodeLen;
    char bgCode[24];
    size_t bgCodeLen;
    char resetCode[8];
    size_t resetCodeLen;
}
- (nullable instancetype)initWithForegroundColor:(nullable DDColor *)fgColor backgroundColor:(nullable DDColor *)bgColor flag:(DDLogFlag)mask context:(NSInteger)ctxt;
@end
#pragma mark -
@interface DDTTYLogger () {
    NSString *_appName;
    char *_app;
    size_t _appLen;
    NSString *_processID;
    char *_pid;
    size_t _pidLen;
    BOOL _colorsEnabled;
    NSMutableArray *_colorProfilesArray;
    NSMutableDictionary *_colorProfilesDict;
}
@end
@implementation DDTTYLogger
static BOOL isaColorTTY;
static BOOL isaColor256TTY;
static BOOL isaXcodeColorTTY;
static NSArray *codes_fg = nil;
static NSArray *codes_bg = nil;
static NSArray *colors   = nil;
static DDTTYLogger *sharedInstance;
+ (void)initialize_colors_16 {
    if (codes_fg || codes_bg || colors) {
        return;
    }
    NSMutableArray *m_colors   = [NSMutableArray arrayWithCapacity:16];
    codes_fg = @[
        @"30m",  
        @"31m",  
        @"32m",  
        @"33m",  
        @"34m",  
        @"35m",  
        @"36m",  
        @"37m",  
        @"1;30m",  
        @"1;31m",  
        @"1;32m",  
        @"1;33m",  
        @"1;34m",  
        @"1;35m",  
        @"1;36m",  
        @"1;37m",  
    ];
    codes_bg = @[
        @"40m",  
        @"41m",  
        @"42m",  
        @"43m",  
        @"44m",  
        @"45m",  
        @"46m",  
        @"47m",  
        @"1;40m",  
        @"1;41m",  
        @"1;42m",  
        @"1;43m",  
        @"1;44m",  
        @"1;45m",  
        @"1;46m",  
        @"1;47m",  
    ];
#if MAP_TO_TERMINAL_APP_COLORS
    DDRGBColor rgbColors[] = {
        {  0,   0,   0}, 
        {194,  54,  33}, 
        { 37, 188,  36}, 
        {173, 173,  39}, 
        { 73,  46, 225}, 
        {211,  56, 211}, 
        { 51, 187, 200}, 
        {203, 204, 205}, 
        {129, 131, 131}, 
        {252,  57,  31}, 
        { 49, 231,  34}, 
        {234, 236,  35}, 
        { 88,  51, 255}, 
        {249,  53, 248}, 
        { 20, 240, 240}, 
        {233, 235, 235}, 
    };
#else 
    DDRGBColor rgbColors[] = {
        {  0,   0,   0}, 
        {205,   0,   0}, 
        {  0, 205,   0}, 
        {205, 205,   0}, 
        {  0,   0, 238}, 
        {205,   0, 205}, 
        {  0, 205, 205}, 
        {229, 229, 229}, 
        {127, 127, 127}, 
        {255,   0,   0}, 
        {  0, 255,   0}, 
        {255, 255,   0}, 
        { 92,  92, 255}, 
        {255,   0, 255}, 
        {  0, 255, 255}, 
        {255, 255, 255}, 
    };
#endif 
    for (size_t i = 0; i < sizeof(rgbColors) / sizeof(rgbColors[0]); ++i) {
        [m_colors addObject:DDMakeColor(rgbColors[i].r, rgbColors[i].g, rgbColors[i].b)];
    }
    colors   = [m_colors   copy];
    NSAssert([codes_fg count] == [codes_bg count], @"Invalid colors/codes array(s)");
    NSAssert([codes_fg count] == [colors count],   @"Invalid colors/codes array(s)");
}
+ (void)initialize_colors_256 {
    if (codes_fg || codes_bg || colors) {
        return;
    }
    NSMutableArray *m_codes_fg = [NSMutableArray arrayWithCapacity:(256 - 16)];
    NSMutableArray *m_codes_bg = [NSMutableArray arrayWithCapacity:(256 - 16)];
    NSMutableArray *m_colors   = [NSMutableArray arrayWithCapacity:(256 - 16)];
    #if MAP_TO_TERMINAL_APP_COLORS
    DDRGBColor rgbColors[] = {
        { 47,  49,  49},
        { 60,  42, 144},
        { 66,  44, 183},
        { 73,  46, 222},
        { 81,  50, 253},
        { 88,  51, 255},
        { 42, 128,  37},
        { 42, 127, 128},
        { 44, 126, 169},
        { 56, 125, 209},
        { 59, 124, 245},
        { 66, 123, 255},
        { 51, 163,  41},
        { 39, 162, 121},
        { 42, 161, 162},
        { 53, 160, 202},
        { 45, 159, 240},
        { 58, 158, 255},
        { 31, 196,  37},
        { 48, 196, 115},
        { 39, 195, 155},
        { 49, 195, 195},
        { 32, 194, 235},
        { 53, 193, 255},
        { 50, 229,  35},
        { 40, 229, 109},
        { 27, 229, 149},
        { 49, 228, 189},
        { 33, 228, 228},
        { 53, 227, 255},
        { 27, 254,  30},
        { 30, 254, 103},
        { 45, 254, 143},
        { 38, 253, 182},
        { 38, 253, 222},
        { 42, 253, 252},
        {140,  48,  40},
        {136,  51, 136},
        {135,  52, 177},
        {134,  52, 217},
        {135,  56, 248},
        {134,  53, 255},
        {125, 125,  38},
        {124, 125, 125},
        {122, 124, 166},
        {123, 124, 207},
        {123, 122, 247},
        {124, 121, 255},
        {119, 160,  35},
        {117, 160, 120},
        {117, 160, 160},
        {115, 159, 201},
        {116, 158, 240},
        {117, 157, 255},
        {113, 195,  39},
        {110, 194, 114},
        {111, 194, 154},
        {108, 194, 194},
        {109, 193, 234},
        {108, 192, 255},
        {105, 228,  30},
        {103, 228, 109},
        {105, 228, 148},
        {100, 227, 188},
        { 99, 227, 227},
        { 99, 226, 253},
        { 92, 253,  34},
        { 96, 253, 103},
        { 97, 253, 142},
        { 88, 253, 182},
        { 93, 253, 221},
        { 88, 254, 251},
        {177,  53,  34},
        {174,  54, 131},
        {172,  55, 172},
        {171,  57, 213},
        {170,  55, 249},
        {170,  57, 255},
        {165, 123,  37},
        {163, 123, 123},
        {162, 123, 164},
        {161, 122, 205},
        {161, 121, 241},
        {161, 121, 255},
        {158, 159,  33},
        {157, 158, 118},
        {157, 158, 159},
        {155, 157, 199},
        {155, 157, 239},
        {154, 156, 255},
        {152, 193,  40},
        {151, 193, 113},
        {150, 193, 153},
        {150, 192, 193},
        {148, 192, 232},
        {149, 191, 253},
        {146, 227,  28},
        {144, 227, 108},
        {144, 227, 147},
        {144, 227, 187},
        {142, 226, 227},
        {142, 225, 252},
        {138, 253,  36},
        {137, 253, 102},
        {136, 253, 141},
        {138, 254, 181},
        {135, 255, 220},
        {133, 255, 250},
        {214,  57,  30},
        {211,  59, 126},
        {209,  57, 168},
        {208,  55, 208},
        {207,  58, 247},
        {206,  61, 255},
        {204, 121,  32},
        {202, 121, 121},
        {201, 121, 161},
        {200, 120, 202},
        {200, 120, 241},
        {198, 119, 255},
        {198, 157,  37},
        {196, 157, 116},
        {195, 156, 157},
        {195, 156, 197},
        {194, 155, 236},
        {193, 155, 255},
        {191, 192,  36},
        {190, 191, 112},
        {189, 191, 152},
        {189, 191, 191},
        {188, 190, 230},
        {187, 190, 253},
        {185, 226,  28},
        {184, 226, 106},
        {183, 225, 146},
        {183, 225, 186},
        {182, 225, 225},
        {181, 224, 252},
        {178, 255,  35},
        {178, 255, 101},
        {177, 254, 141},
        {176, 254, 180},
        {176, 254, 220},
        {175, 253, 249},
        {247,  56,  30},
        {245,  57, 122},
        {243,  59, 163},
        {244,  60, 204},
        {242,  59, 241},
        {240,  55, 255},
        {241, 119,  36},
        {240, 120, 118},
        {238, 119, 158},
        {237, 119, 199},
        {237, 118, 238},
        {236, 118, 255},
        {235, 154,  36},
        {235, 154, 114},
        {234, 154, 154},
        {232, 154, 194},
        {232, 153, 234},
        {232, 153, 255},
        {230, 190,  30},
        {229, 189, 110},
        {228, 189, 150},
        {227, 189, 190},
        {227, 189, 229},
        {226, 188, 255},
        {224, 224,  35},
        {223, 224, 105},
        {222, 224, 144},
        {222, 223, 184},
        {222, 223, 224},
        {220, 223, 253},
        {217, 253,  28},
        {217, 253,  99},
        {216, 252, 139},
        {216, 252, 179},
        {215, 252, 218},
        {215, 251, 250},
        {255,  61,  30},
        {255,  60, 118},
        {255,  58, 159},
        {255,  56, 199},
        {255,  55, 238},
        {255,  59, 255},
        {255, 117,  29},
        {255, 117, 115},
        {255, 117, 155},
        {255, 117, 195},
        {255, 116, 235},
        {254, 116, 255},
        {255, 152,  27},
        {255, 152, 111},
        {254, 152, 152},
        {255, 152, 192},
        {254, 151, 231},
        {253, 151, 253},
        {255, 187,  33},
        {253, 187, 107},
        {252, 187, 148},
        {253, 187, 187},
        {254, 187, 227},
        {252, 186, 252},
        {252, 222,  34},
        {251, 222, 103},
        {251, 222, 143},
        {250, 222, 182},
        {251, 221, 222},
        {252, 221, 252},
        {251, 252,  15},
        {251, 252,  97},
        {249, 252, 137},
        {247, 252, 177},
        {247, 253, 217},
        {254, 255, 255},
        { 52,  53,  53},
        { 57,  58,  59},
        { 66,  67,  67},
        { 75,  76,  76},
        { 83,  85,  85},
        { 92,  93,  94},
        {101, 102, 102},
        {109, 111, 111},
        {118, 119, 119},
        {126, 127, 128},
        {134, 136, 136},
        {143, 144, 145},
        {151, 152, 153},
        {159, 161, 161},
        {167, 169, 169},
        {176, 177, 177},
        {184, 185, 186},
        {192, 193, 194},
        {200, 201, 202},
        {208, 209, 210},
        {216, 218, 218},
        {224, 226, 226},
        {232, 234, 234},
        {240, 242, 242},
    };
    for (size_t i = 0; i < sizeof(rgbColors) / sizeof(rgbColors[0]); ++i) {
        [m_colors addObject:DDMakeColor(rgbColors[i].r, rgbColors[i].g, rgbColors[i].b)];
    }
    int index = 16;
    while (index < 256) {
        [m_codes_fg addObject:[NSString stringWithFormat:@"38;5;%dm", index]];
        [m_codes_bg addObject:[NSString stringWithFormat:@"48;5;%dm", index]];
        index++;
    }
    #else 
    int index = 16;
    int r; 
    int g; 
    int b; 
    int ri; 
    int gi; 
    int bi; 
    int r = 0;
    int g = 0;
    int b = 0;
    for (ri = 0; ri < 6; ri++) {
        r = (ri == 0) ? 0 : 95 + (40 * (ri - 1));
        for (gi = 0; gi < 6; gi++) {
            g = (gi == 0) ? 0 : 95 + (40 * (gi - 1));
            for (bi = 0; bi < 6; bi++) {
                b = (bi == 0) ? 0 : 95 + (40 * (bi - 1));
                [m_codes_fg addObject:[NSString stringWithFormat:@"38;5;%dm", index]];
                [m_codes_bg addObject:[NSString stringWithFormat:@"48;5;%dm", index]];
                [m_colors addObject:DDMakeColor(r, g, b)];
                index++;
            }
        }
    }
    r = 8;
    g = 8;
    b = 8;
    while (index < 256) {
        [m_codes_fg addObject:[NSString stringWithFormat:@"38;5;%dm", index]];
        [m_codes_bg addObject:[NSString stringWithFormat:@"48;5;%dm", index]];
        [m_colors addObject:DDMakeColor(r, g, b)];
        r += 10;
        g += 10;
        b += 10;
        index++;
    }
    #endif 
    codes_fg = [m_codes_fg copy];
    codes_bg = [m_codes_bg copy];
    colors   = [m_colors   copy];
    NSAssert([codes_fg count] == [codes_bg count], @"Invalid colors/codes array(s)");
    NSAssert([codes_fg count] == [colors count],   @"Invalid colors/codes array(s)");
}
+ (void)getRed:(CGFloat *)rPtr green:(CGFloat *)gPtr blue:(CGFloat *)bPtr fromColor:(DDColor *)color {
    #if TARGET_OS_IPHONE
    BOOL done = NO;
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        done = [color getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    }
    if (!done) {
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char pixel[4];
        CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)(kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast));
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
        if (rPtr) {
            *rPtr = pixel[0] / 255.0f;
        }
        if (gPtr) {
            *gPtr = pixel[1] / 255.0f;
        }
        if (bPtr) {
            *bPtr = pixel[2] / 255.0f;
        }
        CGContextRelease(context);
        CGColorSpaceRelease(rgbColorSpace);
    }
    #elif defined(DD_CLI) || !__has_include(<AppKit/NSColor.h>)
    [color getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    #else 
    NSColor *safeColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [safeColor getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    #endif 
}
+ (NSUInteger)codeIndexForColor:(DDColor *)inColor {
    CGFloat inR, inG, inB;
    [self getRed:&inR green:&inG blue:&inB fromColor:inColor];
    NSUInteger bestIndex = 0;
    CGFloat lowestDistance = 100.0f;
    NSUInteger i = 0;
    for (DDColor *color in colors) {
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b fromColor:color];
    #if CGFLOAT_IS_DOUBLE
        CGFloat distance = sqrt(pow(r - inR, 2.0) + pow(g - inG, 2.0) + pow(b - inB, 2.0));
    #else
        CGFloat distance = sqrtf(powf(r - inR, 2.0f) + powf(g - inG, 2.0f) + powf(b - inB, 2.0f));
    #endif
        NSLogVerbose(@"DDTTYLogger: %3lu : %.3f,%.3f,%.3f & %.3f,%.3f,%.3f = %.6f",
                     (unsigned long)i, inR, inG, inB, r, g, b, distance);
        if (distance < lowestDistance) {
            bestIndex = i;
            lowestDistance = distance;
            NSLogVerbose(@"DDTTYLogger: New best index = %lu", (unsigned long)bestIndex);
        }
        i++;
    }
    return bestIndex;
}
+ (instancetype)sharedInstance {
    static dispatch_once_t DDTTYLoggerOnceToken;
    dispatch_once(&DDTTYLoggerOnceToken, ^{
        char *xcode_colors = getenv("XcodeColors");
        char *term = getenv("TERM");
        if (xcode_colors && (strcmp(xcode_colors, "YES") == 0)) {
            isaXcodeColorTTY = YES;
        } else if (term) {
            if (strcasestr(term, "color") != NULL) {
                isaColorTTY = YES;
                isaColor256TTY = (strcasestr(term, "256") != NULL);
                if (isaColor256TTY) {
                    [self initialize_colors_256];
                } else {
                    [self initialize_colors_16];
                }
            }
        }
        NSLogInfo(@"DDTTYLogger: isaColorTTY = %@", (isaColorTTY ? @"YES" : @"NO"));
        NSLogInfo(@"DDTTYLogger: isaColor256TTY: %@", (isaColor256TTY ? @"YES" : @"NO"));
        NSLogInfo(@"DDTTYLogger: isaXcodeColorTTY: %@", (isaXcodeColorTTY ? @"YES" : @"NO"));
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (sharedInstance != nil) {
        return nil;
    }
    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
        NSLogWarn(@"CocoaLumberjack: Warning: Usage of DDTTYLogger detected when DDOSLogger is available and can be used! Please consider migrating to DDOSLogger.");
    }
    if ((self = [super init])) {
        _appName = [[NSProcessInfo processInfo] processName];
        _appLen = [_appName lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (_appLen == 0) {
            _appName = @"<UnnamedApp>";
            _appLen = [_appName lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        }
        _app = (char *)calloc(_appLen + 1, sizeof(char));
        if (_app == NULL) {
            return nil;
        }
        BOOL processedAppName = [_appName getCString:_app maxLength:(_appLen + 1) encoding:NSUTF8StringEncoding];
        if (NO == processedAppName) {
            free(_app);
            return nil;
        }
        _processID = [NSString stringWithFormat:@"%i", (int)getpid()];
        _pidLen = [_processID lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        _pid = (char *)calloc(_pidLen + 1, sizeof(char));
        if (_pid == NULL) {
            free(_app);
            return nil;
        }
        BOOL processedID = [_processID getCString:_pid maxLength:(_pidLen + 1) encoding:NSUTF8StringEncoding];
        if (NO == processedID) {
            free(_app);
            free(_pid);
            return nil;
        }
        _colorsEnabled = NO;
        _colorProfilesArray = [[NSMutableArray alloc] initWithCapacity:8];
        _colorProfilesDict = [[NSMutableDictionary alloc] initWithCapacity:8];
        _automaticallyAppendNewlineForCustomFormatters = YES;
    }
    return self;
}
- (DDLoggerName)loggerName {
    return DDLoggerNameTTY;
}
- (void)loadDefaultColorProfiles {
    [self setForegroundColor:DDMakeColor(214,  57,  30) backgroundColor:nil forFlag:DDLogFlagError];
    [self setForegroundColor:DDMakeColor(204, 121,  32) backgroundColor:nil forFlag:DDLogFlagWarning];
}
- (BOOL)colorsEnabled {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    __block BOOL result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, ^{
            result = self->_colorsEnabled;
        });
    });
    return result;
}
- (void)setColorsEnabled:(BOOL)newColorsEnabled {
    dispatch_block_t block = ^{
        @autoreleasepool {
            self->_colorsEnabled = newColorsEnabled;
            if ([self->_colorProfilesArray count] == 0) {
                [self loadDefaultColorProfiles];
            }
        }
    };
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(self.loggerQueue, block);
    });
}
- (void)setForegroundColor:(DDColor *)txtColor backgroundColor:(DDColor *)bgColor forFlag:(DDLogFlag)mask {
    [self setForegroundColor:txtColor backgroundColor:bgColor forFlag:mask context:LOG_CONTEXT_ALL];
}
- (void)setForegroundColor:(DDColor *)txtColor backgroundColor:(DDColor *)bgColor forFlag:(DDLogFlag)mask context:(NSInteger)ctxt {
    dispatch_block_t block = ^{
        @autoreleasepool {
            DDTTYLoggerColorProfile *newColorProfile =
                [[DDTTYLoggerColorProfile alloc] initWithForegroundColor:txtColor
                                                         backgroundColor:bgColor
                                                                    flag:mask
                                                                 context:ctxt];
            NSLogInfo(@"DDTTYLogger: newColorProfile: %@", newColorProfile);
            NSUInteger i = 0;
            for (DDTTYLoggerColorProfile *colorProfile in self->_colorProfilesArray) {
                if ((colorProfile->mask == mask) && (colorProfile->context == ctxt)) {
                    break;
                }
                i++;
            }
            if (i < [self->_colorProfilesArray count]) {
                self->_colorProfilesArray[i] = newColorProfile;
            } else {
                [self->_colorProfilesArray addObject:newColorProfile];
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)setForegroundColor:(DDColor *)txtColor backgroundColor:(DDColor *)bgColor forTag:(id <NSCopying>)tag {
    NSAssert([(id < NSObject >) tag conformsToProtocol: @protocol(NSCopying)], @"Invalid tag");
    dispatch_block_t block = ^{
        @autoreleasepool {
            DDTTYLoggerColorProfile *newColorProfile =
                [[DDTTYLoggerColorProfile alloc] initWithForegroundColor:txtColor
                                                         backgroundColor:bgColor
                                                                    flag:(DDLogFlag)0
                                                                 context:0];
            NSLogInfo(@"DDTTYLogger: newColorProfile: %@", newColorProfile);
            self->_colorProfilesDict[tag] = newColorProfile;
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)clearColorsForFlag:(DDLogFlag)mask {
    [self clearColorsForFlag:mask context:0];
}
- (void)clearColorsForFlag:(DDLogFlag)mask context:(NSInteger)context {
    dispatch_block_t block = ^{
        @autoreleasepool {
            NSUInteger i = 0;
            for (DDTTYLoggerColorProfile *colorProfile in self->_colorProfilesArray) {
                if ((colorProfile->mask == mask) && (colorProfile->context == context)) {
                    break;
                }
                i++;
            }
            if (i < [self->_colorProfilesArray count]) {
                [self->_colorProfilesArray removeObjectAtIndex:i];
            }
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)clearColorsForTag:(id <NSCopying>)tag {
    NSAssert([(id < NSObject >) tag conformsToProtocol: @protocol(NSCopying)], @"Invalid tag");
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self->_colorProfilesDict removeObjectForKey:tag];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)clearColorsForAllFlags {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self->_colorProfilesArray removeAllObjects];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)clearColorsForAllTags {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self->_colorProfilesDict removeAllObjects];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)clearAllColors {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self->_colorProfilesArray removeAllObjects];
            [self->_colorProfilesDict removeAllObjects];
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *logMsg = logMessage->_message;
    BOOL isFormatted = NO;
    if (_logFormatter) {
        logMsg = [_logFormatter formatLogMessage:logMessage];
        isFormatted = logMsg != logMessage->_message;
    }
    if (logMsg) {
        DDTTYLoggerColorProfile *colorProfile = nil;
        if (_colorsEnabled) {
            if (logMessage->_representedObject) {
                colorProfile = _colorProfilesDict[logMessage->_representedObject];
            }
            if (colorProfile == nil) {
                for (DDTTYLoggerColorProfile *cp in _colorProfilesArray) {
                    if (logMessage->_flag & cp->mask) {
                        if (logMessage->_context == cp->context) {
                            colorProfile = cp;
                            break;
                        }
                        if (cp->context == LOG_CONTEXT_ALL) {
                            colorProfile = cp;
                        }
                    }
                }
            }
        }
        NSUInteger msgLen = [logMsg lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        const BOOL useStack = msgLen < (1024 * 4);
        char *msg;
        if (useStack) {
            msg = (char *)alloca(msgLen + 1);
        } else {
            msg = (char *)calloc(msgLen + 1, sizeof(char));
        }
        if (msg == NULL) {
            return;
        }
        BOOL logMsgEnc = [logMsg getCString:msg maxLength:(msgLen + 1) encoding:NSUTF8StringEncoding];
        if (!logMsgEnc) {
            if (!useStack) {
                free(msg);
            }
            return;
        }
        if (isFormatted) {
            const int iovec_len = (_automaticallyAppendNewlineForCustomFormatters) ? 5 : 4;
            struct iovec v[iovec_len];
            if (colorProfile) {
                v[0].iov_base = colorProfile->fgCode;
                v[0].iov_len = colorProfile->fgCodeLen;
                v[1].iov_base = colorProfile->bgCode;
                v[1].iov_len = colorProfile->bgCodeLen;
                v[iovec_len - 1].iov_base = colorProfile->resetCode;
                v[iovec_len - 1].iov_len = colorProfile->resetCodeLen;
            } else {
                v[0].iov_base = "";
                v[0].iov_len = 0;
                v[1].iov_base = "";
                v[1].iov_len = 0;
                v[iovec_len - 1].iov_base = "";
                v[iovec_len - 1].iov_len = 0;
            }
            v[2].iov_base = msg;
            v[2].iov_len = msgLen;
            if (iovec_len == 5) {
                v[3].iov_base = "\n";
                v[3].iov_len = (msg[msgLen] == '\n') ? 0 : 1;
            }
            writev(STDERR_FILENO, v, iovec_len);
        } else {
            int len;
            char ts[24] = "";
            size_t tsLen = 0;
            if (logMessage->_timestamp) {
                NSTimeInterval epoch = [logMessage->_timestamp timeIntervalSince1970];
                struct tm tm;
                time_t time = (time_t)epoch;
                (void)localtime_r(&time, &tm);
                int milliseconds = (int)((epoch - floor(epoch)) * 1000.0);
                len = snprintf(ts, 24, "%04d-%02d-%02d %02d:%02d:%02d:%03d", 
                               tm.tm_year + 1900,
                               tm.tm_mon + 1,
                               tm.tm_mday,
                               tm.tm_hour,
                               tm.tm_min,
                               tm.tm_sec, milliseconds);
                tsLen = (NSUInteger)MAX(MIN(24 - 1, len), 0);
            }
            char tid[9];
            len = snprintf(tid, 9, "%s", [logMessage->_threadID cStringUsingEncoding:NSUTF8StringEncoding]);
            size_t tidLen = (NSUInteger)MAX(MIN(9 - 1, len), 0);
            struct iovec v[13];
            if (colorProfile) {
                v[0].iov_base = colorProfile->fgCode;
                v[0].iov_len = colorProfile->fgCodeLen;
                v[1].iov_base = colorProfile->bgCode;
                v[1].iov_len = colorProfile->bgCodeLen;
                v[12].iov_base = colorProfile->resetCode;
                v[12].iov_len = colorProfile->resetCodeLen;
            } else {
                v[0].iov_base = "";
                v[0].iov_len = 0;
                v[1].iov_base = "";
                v[1].iov_len = 0;
                v[12].iov_base = "";
                v[12].iov_len = 0;
            }
            v[2].iov_base = ts;
            v[2].iov_len = tsLen;
            v[3].iov_base = " ";
            v[3].iov_len = 1;
            v[4].iov_base = _app;
            v[4].iov_len = _appLen;
            v[5].iov_base = "[";
            v[5].iov_len = 1;
            v[6].iov_base = _pid;
            v[6].iov_len = _pidLen;
            v[7].iov_base = ":";
            v[7].iov_len = 1;
            v[8].iov_base = tid;
            v[8].iov_len = MIN((size_t)8, tidLen); 
            v[9].iov_base = "] ";
            v[9].iov_len = 2;
            v[10].iov_base = (char *)msg;
            v[10].iov_len = msgLen;
            v[11].iov_base = "\n";
            v[11].iov_len = (msg[msgLen] == '\n') ? 0 : 1;
            writev(STDERR_FILENO, v, 13);
        }
        if (!useStack) {
            free(msg);
        }
    }
}
@end
@implementation DDTTYLoggerColorProfile
- (instancetype)initWithForegroundColor:(DDColor *)fgColor backgroundColor:(DDColor *)bgColor flag:(DDLogFlag)aMask context:(NSInteger)ctxt {
    if ((self = [super init])) {
        mask = aMask;
        context = ctxt;
        CGFloat r, g, b;
        if (fgColor) {
            [DDTTYLogger getRed:&r green:&g blue:&b fromColor:fgColor];
            fg_r = (uint8_t)(r * 255.0f);
            fg_g = (uint8_t)(g * 255.0f);
            fg_b = (uint8_t)(b * 255.0f);
        }
        if (bgColor) {
            [DDTTYLogger getRed:&r green:&g blue:&b fromColor:bgColor];
            bg_r = (uint8_t)(r * 255.0f);
            bg_g = (uint8_t)(g * 255.0f);
            bg_b = (uint8_t)(b * 255.0f);
        }
        if (fgColor && isaColorTTY) {
            fgCodeIndex = [DDTTYLogger codeIndexForColor:fgColor];
            fgCodeRaw   = codes_fg[fgCodeIndex];
            NSString *escapeSeq = @"\033[";
            NSUInteger len1 = [escapeSeq lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            NSUInteger len2 = [fgCodeRaw lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            BOOL escapeSeqEnc = [escapeSeq getCString:(fgCode)      maxLength:(len1 + 1) encoding:NSUTF8StringEncoding];
            BOOL fgCodeRawEsc = [fgCodeRaw getCString:(fgCode + len1) maxLength:(len2 + 1) encoding:NSUTF8StringEncoding];
            if (!escapeSeqEnc || !fgCodeRawEsc) {
                return nil;
            }
            fgCodeLen = len1 + len2;
        } else if (fgColor && isaXcodeColorTTY) {
            const char *escapeSeq = XCODE_COLORS_ESCAPE_SEQ;
            int result = snprintf(fgCode, 24, "%sfg%u,%u,%u;", escapeSeq, fg_r, fg_g, fg_b);
            fgCodeLen = (NSUInteger)MAX(MIN(result, (24 - 1)), 0);
        } else {
            fgCode[0] = '\0';
            fgCodeLen = 0;
        }
        if (bgColor && isaColorTTY) {
            bgCodeIndex = [DDTTYLogger codeIndexForColor:bgColor];
            bgCodeRaw   = codes_bg[bgCodeIndex];
            NSString *escapeSeq = @"\033[";
            NSUInteger len1 = [escapeSeq lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            NSUInteger len2 = [bgCodeRaw lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            BOOL escapeSeqEnc = [escapeSeq getCString:(bgCode)      maxLength:(len1 + 1) encoding:NSUTF8StringEncoding];
            BOOL bgCodeRawEsc = [bgCodeRaw getCString:(bgCode + len1) maxLength:(len2 + 1) encoding:NSUTF8StringEncoding];
            if (!escapeSeqEnc || !bgCodeRawEsc) {
                return nil;
            }
            bgCodeLen = len1 + len2;
        } else if (bgColor && isaXcodeColorTTY) {
            const char *escapeSeq = XCODE_COLORS_ESCAPE_SEQ;
            int result = snprintf(bgCode, 24, "%sbg%u,%u,%u;", escapeSeq, bg_r, bg_g, bg_b);
            bgCodeLen = (NSUInteger)MAX(MIN(result, (24 - 1)), 0);
        } else {
            bgCode[0] = '\0';
            bgCodeLen = 0;
        }
        if (isaColorTTY) {
            resetCodeLen = (NSUInteger)MAX(snprintf(resetCode, 8, "\033[0m"), 0);
        } else if (isaXcodeColorTTY) {
            resetCodeLen = (NSUInteger)MAX(snprintf(resetCode, 8, XCODE_COLORS_RESET), 0);
        } else {
            resetCode[0] = '\0';
            resetCodeLen = 0;
        }
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:
            @"<DDTTYLoggerColorProfile: %p mask:%i ctxt:%ld fg:%u,%u,%u bg:%u,%u,%u fgCode:%@ bgCode:%@>",
            self, (int)mask, (long)context, fg_r, fg_g, fg_b, bg_r, bg_g, bg_b, fgCodeRaw, bgCodeRaw];
}
@end