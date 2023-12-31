#import "AWSDDTTYLogger.h"
#import <unistd.h>
#import <sys/uio.h>
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
#ifndef AWSDD_NSLOG_LEVEL
    #define AWSDD_NSLOG_LEVEL 2
#endif
#define NSLogError(frmt, ...)    do{ if(AWSDD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(AWSDD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(AWSDD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(AWSDD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(AWSDD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define XCODE_COLORS_ESCAPE_SEQ "\033["
#define XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCAPE_SEQ "fg;" 
#define XCODE_COLORS_RESET_BG   XCODE_COLORS_ESCAPE_SEQ "bg;" 
#define XCODE_COLORS_RESET      XCODE_COLORS_ESCAPE_SEQ ";"  
#define MAP_TO_TERMINAL_APP_COLORS 1
@interface AWSDDTTYLoggerColorProfile : NSObject {
    @public
    AWSDDLogFlag mask;
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
- (instancetype)initWithForegroundColor:(AWSDDColor *)fgColor backgroundColor:(AWSDDColor *)bgColor flag:(AWSDDLogFlag)mask context:(NSInteger)ctxt;
@end
#pragma mark -
@interface AWSDDTTYLogger () {
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
@implementation AWSDDTTYLogger
static BOOL isaColorTTY;
static BOOL isaColor256TTY;
static BOOL isaXcodeColorTTY;
static NSArray *codes_fg = nil;
static NSArray *codes_bg = nil;
static NSArray *colors   = nil;
static AWSDDTTYLogger *sharedInstance;
+ (void)initialize_colors_16 {
    if (codes_fg || codes_bg || colors) {
        return;
    }
    NSMutableArray *m_codes_fg = [NSMutableArray arrayWithCapacity:16];
    NSMutableArray *m_codes_bg = [NSMutableArray arrayWithCapacity:16];
    NSMutableArray *m_colors   = [NSMutableArray arrayWithCapacity:16];
    [m_codes_fg addObject:@"30m"];   
    [m_codes_fg addObject:@"31m"];   
    [m_codes_fg addObject:@"32m"];   
    [m_codes_fg addObject:@"33m"];   
    [m_codes_fg addObject:@"34m"];   
    [m_codes_fg addObject:@"35m"];   
    [m_codes_fg addObject:@"36m"];   
    [m_codes_fg addObject:@"37m"];   
    [m_codes_fg addObject:@"1;30m"]; 
    [m_codes_fg addObject:@"1;31m"]; 
    [m_codes_fg addObject:@"1;32m"]; 
    [m_codes_fg addObject:@"1;33m"]; 
    [m_codes_fg addObject:@"1;34m"]; 
    [m_codes_fg addObject:@"1;35m"]; 
    [m_codes_fg addObject:@"1;36m"]; 
    [m_codes_fg addObject:@"1;37m"]; 
    [m_codes_bg addObject:@"40m"];   
    [m_codes_bg addObject:@"41m"];   
    [m_codes_bg addObject:@"42m"];   
    [m_codes_bg addObject:@"43m"];   
    [m_codes_bg addObject:@"44m"];   
    [m_codes_bg addObject:@"45m"];   
    [m_codes_bg addObject:@"46m"];   
    [m_codes_bg addObject:@"47m"];   
    [m_codes_bg addObject:@"1;40m"]; 
    [m_codes_bg addObject:@"1;41m"]; 
    [m_codes_bg addObject:@"1;42m"]; 
    [m_codes_bg addObject:@"1;43m"]; 
    [m_codes_bg addObject:@"1;44m"]; 
    [m_codes_bg addObject:@"1;45m"]; 
    [m_codes_bg addObject:@"1;46m"]; 
    [m_codes_bg addObject:@"1;47m"]; 
#if MAP_TO_TERMINAL_APP_COLORS
    [m_colors addObject:AWSDDMakeColor(  0,   0,   0)]; 
    [m_colors addObject:AWSDDMakeColor(194,  54,  33)]; 
    [m_colors addObject:AWSDDMakeColor( 37, 188,  36)]; 
    [m_colors addObject:AWSDDMakeColor(173, 173,  39)]; 
    [m_colors addObject:AWSDDMakeColor( 73,  46, 225)]; 
    [m_colors addObject:AWSDDMakeColor(211,  56, 211)]; 
    [m_colors addObject:AWSDDMakeColor( 51, 187, 200)]; 
    [m_colors addObject:AWSDDMakeColor(203, 204, 205)]; 
    [m_colors addObject:AWSDDMakeColor(129, 131, 131)]; 
    [m_colors addObject:AWSDDMakeColor(252,  57,  31)]; 
    [m_colors addObject:AWSDDMakeColor( 49, 231,  34)]; 
    [m_colors addObject:AWSDDMakeColor(234, 236,  35)]; 
    [m_colors addObject:AWSDDMakeColor( 88,  51, 255)]; 
    [m_colors addObject:AWSDDMakeColor(249,  53, 248)]; 
    [m_colors addObject:AWSDDMakeColor( 20, 240, 240)]; 
    [m_colors addObject:AWSDDMakeColor(233, 235, 235)]; 
#else 
    [m_colors addObject:AWSDDMakeColor(  0,   0,   0)]; 
    [m_colors addObject:AWSDDMakeColor(205,   0,   0)]; 
    [m_colors addObject:AWSDDMakeColor(  0, 205,   0)]; 
    [m_colors addObject:AWSDDMakeColor(205, 205,   0)]; 
    [m_colors addObject:AWSDDMakeColor(  0,   0, 238)]; 
    [m_colors addObject:AWSDDMakeColor(205,   0, 205)]; 
    [m_colors addObject:AWSDDMakeColor(  0, 205, 205)]; 
    [m_colors addObject:AWSDDMakeColor(229, 229, 229)]; 
    [m_colors addObject:AWSDDMakeColor(127, 127, 127)]; 
    [m_colors addObject:AWSDDMakeColor(255,   0,   0)]; 
    [m_colors addObject:AWSDDMakeColor(  0, 255,   0)]; 
    [m_colors addObject:AWSDDMakeColor(255, 255,   0)]; 
    [m_colors addObject:AWSDDMakeColor( 92,  92, 255)]; 
    [m_colors addObject:AWSDDMakeColor(255,   0, 255)]; 
    [m_colors addObject:AWSDDMakeColor(  0, 255, 255)]; 
    [m_colors addObject:AWSDDMakeColor(255, 255, 255)]; 
#endif 
    codes_fg = [m_codes_fg copy];
    codes_bg = [m_codes_bg copy];
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
    [m_colors addObject:AWSDDMakeColor( 47,  49,  49)];
    [m_colors addObject:AWSDDMakeColor( 60,  42, 144)];
    [m_colors addObject:AWSDDMakeColor( 66,  44, 183)];
    [m_colors addObject:AWSDDMakeColor( 73,  46, 222)];
    [m_colors addObject:AWSDDMakeColor( 81,  50, 253)];
    [m_colors addObject:AWSDDMakeColor( 88,  51, 255)];
    [m_colors addObject:AWSDDMakeColor( 42, 128,  37)];
    [m_colors addObject:AWSDDMakeColor( 42, 127, 128)];
    [m_colors addObject:AWSDDMakeColor( 44, 126, 169)];
    [m_colors addObject:AWSDDMakeColor( 56, 125, 209)];
    [m_colors addObject:AWSDDMakeColor( 59, 124, 245)];
    [m_colors addObject:AWSDDMakeColor( 66, 123, 255)];
    [m_colors addObject:AWSDDMakeColor( 51, 163,  41)];
    [m_colors addObject:AWSDDMakeColor( 39, 162, 121)];
    [m_colors addObject:AWSDDMakeColor( 42, 161, 162)];
    [m_colors addObject:AWSDDMakeColor( 53, 160, 202)];
    [m_colors addObject:AWSDDMakeColor( 45, 159, 240)];
    [m_colors addObject:AWSDDMakeColor( 58, 158, 255)];
    [m_colors addObject:AWSDDMakeColor( 31, 196,  37)];
    [m_colors addObject:AWSDDMakeColor( 48, 196, 115)];
    [m_colors addObject:AWSDDMakeColor( 39, 195, 155)];
    [m_colors addObject:AWSDDMakeColor( 49, 195, 195)];
    [m_colors addObject:AWSDDMakeColor( 32, 194, 235)];
    [m_colors addObject:AWSDDMakeColor( 53, 193, 255)];
    [m_colors addObject:AWSDDMakeColor( 50, 229,  35)];
    [m_colors addObject:AWSDDMakeColor( 40, 229, 109)];
    [m_colors addObject:AWSDDMakeColor( 27, 229, 149)];
    [m_colors addObject:AWSDDMakeColor( 49, 228, 189)];
    [m_colors addObject:AWSDDMakeColor( 33, 228, 228)];
    [m_colors addObject:AWSDDMakeColor( 53, 227, 255)];
    [m_colors addObject:AWSDDMakeColor( 27, 254,  30)];
    [m_colors addObject:AWSDDMakeColor( 30, 254, 103)];
    [m_colors addObject:AWSDDMakeColor( 45, 254, 143)];
    [m_colors addObject:AWSDDMakeColor( 38, 253, 182)];
    [m_colors addObject:AWSDDMakeColor( 38, 253, 222)];
    [m_colors addObject:AWSDDMakeColor( 42, 253, 252)];
    [m_colors addObject:AWSDDMakeColor(140,  48,  40)];
    [m_colors addObject:AWSDDMakeColor(136,  51, 136)];
    [m_colors addObject:AWSDDMakeColor(135,  52, 177)];
    [m_colors addObject:AWSDDMakeColor(134,  52, 217)];
    [m_colors addObject:AWSDDMakeColor(135,  56, 248)];
    [m_colors addObject:AWSDDMakeColor(134,  53, 255)];
    [m_colors addObject:AWSDDMakeColor(125, 125,  38)];
    [m_colors addObject:AWSDDMakeColor(124, 125, 125)];
    [m_colors addObject:AWSDDMakeColor(122, 124, 166)];
    [m_colors addObject:AWSDDMakeColor(123, 124, 207)];
    [m_colors addObject:AWSDDMakeColor(123, 122, 247)];
    [m_colors addObject:AWSDDMakeColor(124, 121, 255)];
    [m_colors addObject:AWSDDMakeColor(119, 160,  35)];
    [m_colors addObject:AWSDDMakeColor(117, 160, 120)];
    [m_colors addObject:AWSDDMakeColor(117, 160, 160)];
    [m_colors addObject:AWSDDMakeColor(115, 159, 201)];
    [m_colors addObject:AWSDDMakeColor(116, 158, 240)];
    [m_colors addObject:AWSDDMakeColor(117, 157, 255)];
    [m_colors addObject:AWSDDMakeColor(113, 195,  39)];
    [m_colors addObject:AWSDDMakeColor(110, 194, 114)];
    [m_colors addObject:AWSDDMakeColor(111, 194, 154)];
    [m_colors addObject:AWSDDMakeColor(108, 194, 194)];
    [m_colors addObject:AWSDDMakeColor(109, 193, 234)];
    [m_colors addObject:AWSDDMakeColor(108, 192, 255)];
    [m_colors addObject:AWSDDMakeColor(105, 228,  30)];
    [m_colors addObject:AWSDDMakeColor(103, 228, 109)];
    [m_colors addObject:AWSDDMakeColor(105, 228, 148)];
    [m_colors addObject:AWSDDMakeColor(100, 227, 188)];
    [m_colors addObject:AWSDDMakeColor( 99, 227, 227)];
    [m_colors addObject:AWSDDMakeColor( 99, 226, 253)];
    [m_colors addObject:AWSDDMakeColor( 92, 253,  34)];
    [m_colors addObject:AWSDDMakeColor( 96, 253, 103)];
    [m_colors addObject:AWSDDMakeColor( 97, 253, 142)];
    [m_colors addObject:AWSDDMakeColor( 88, 253, 182)];
    [m_colors addObject:AWSDDMakeColor( 93, 253, 221)];
    [m_colors addObject:AWSDDMakeColor( 88, 254, 251)];
    [m_colors addObject:AWSDDMakeColor(177,  53,  34)];
    [m_colors addObject:AWSDDMakeColor(174,  54, 131)];
    [m_colors addObject:AWSDDMakeColor(172,  55, 172)];
    [m_colors addObject:AWSDDMakeColor(171,  57, 213)];
    [m_colors addObject:AWSDDMakeColor(170,  55, 249)];
    [m_colors addObject:AWSDDMakeColor(170,  57, 255)];
    [m_colors addObject:AWSDDMakeColor(165, 123,  37)];
    [m_colors addObject:AWSDDMakeColor(163, 123, 123)];
    [m_colors addObject:AWSDDMakeColor(162, 123, 164)];
    [m_colors addObject:AWSDDMakeColor(161, 122, 205)];
    [m_colors addObject:AWSDDMakeColor(161, 121, 241)];
    [m_colors addObject:AWSDDMakeColor(161, 121, 255)];
    [m_colors addObject:AWSDDMakeColor(158, 159,  33)];
    [m_colors addObject:AWSDDMakeColor(157, 158, 118)];
    [m_colors addObject:AWSDDMakeColor(157, 158, 159)];
    [m_colors addObject:AWSDDMakeColor(155, 157, 199)];
    [m_colors addObject:AWSDDMakeColor(155, 157, 239)];
    [m_colors addObject:AWSDDMakeColor(154, 156, 255)];
    [m_colors addObject:AWSDDMakeColor(152, 193,  40)];
    [m_colors addObject:AWSDDMakeColor(151, 193, 113)];
    [m_colors addObject:AWSDDMakeColor(150, 193, 153)];
    [m_colors addObject:AWSDDMakeColor(150, 192, 193)];
    [m_colors addObject:AWSDDMakeColor(148, 192, 232)];
    [m_colors addObject:AWSDDMakeColor(149, 191, 253)];
    [m_colors addObject:AWSDDMakeColor(146, 227,  28)];
    [m_colors addObject:AWSDDMakeColor(144, 227, 108)];
    [m_colors addObject:AWSDDMakeColor(144, 227, 147)];
    [m_colors addObject:AWSDDMakeColor(144, 227, 187)];
    [m_colors addObject:AWSDDMakeColor(142, 226, 227)];
    [m_colors addObject:AWSDDMakeColor(142, 225, 252)];
    [m_colors addObject:AWSDDMakeColor(138, 253,  36)];
    [m_colors addObject:AWSDDMakeColor(137, 253, 102)];
    [m_colors addObject:AWSDDMakeColor(136, 253, 141)];
    [m_colors addObject:AWSDDMakeColor(138, 254, 181)];
    [m_colors addObject:AWSDDMakeColor(135, 255, 220)];
    [m_colors addObject:AWSDDMakeColor(133, 255, 250)];
    [m_colors addObject:AWSDDMakeColor(214,  57,  30)];
    [m_colors addObject:AWSDDMakeColor(211,  59, 126)];
    [m_colors addObject:AWSDDMakeColor(209,  57, 168)];
    [m_colors addObject:AWSDDMakeColor(208,  55, 208)];
    [m_colors addObject:AWSDDMakeColor(207,  58, 247)];
    [m_colors addObject:AWSDDMakeColor(206,  61, 255)];
    [m_colors addObject:AWSDDMakeColor(204, 121,  32)];
    [m_colors addObject:AWSDDMakeColor(202, 121, 121)];
    [m_colors addObject:AWSDDMakeColor(201, 121, 161)];
    [m_colors addObject:AWSDDMakeColor(200, 120, 202)];
    [m_colors addObject:AWSDDMakeColor(200, 120, 241)];
    [m_colors addObject:AWSDDMakeColor(198, 119, 255)];
    [m_colors addObject:AWSDDMakeColor(198, 157,  37)];
    [m_colors addObject:AWSDDMakeColor(196, 157, 116)];
    [m_colors addObject:AWSDDMakeColor(195, 156, 157)];
    [m_colors addObject:AWSDDMakeColor(195, 156, 197)];
    [m_colors addObject:AWSDDMakeColor(194, 155, 236)];
    [m_colors addObject:AWSDDMakeColor(193, 155, 255)];
    [m_colors addObject:AWSDDMakeColor(191, 192,  36)];
    [m_colors addObject:AWSDDMakeColor(190, 191, 112)];
    [m_colors addObject:AWSDDMakeColor(189, 191, 152)];
    [m_colors addObject:AWSDDMakeColor(189, 191, 191)];
    [m_colors addObject:AWSDDMakeColor(188, 190, 230)];
    [m_colors addObject:AWSDDMakeColor(187, 190, 253)];
    [m_colors addObject:AWSDDMakeColor(185, 226,  28)];
    [m_colors addObject:AWSDDMakeColor(184, 226, 106)];
    [m_colors addObject:AWSDDMakeColor(183, 225, 146)];
    [m_colors addObject:AWSDDMakeColor(183, 225, 186)];
    [m_colors addObject:AWSDDMakeColor(182, 225, 225)];
    [m_colors addObject:AWSDDMakeColor(181, 224, 252)];
    [m_colors addObject:AWSDDMakeColor(178, 255,  35)];
    [m_colors addObject:AWSDDMakeColor(178, 255, 101)];
    [m_colors addObject:AWSDDMakeColor(177, 254, 141)];
    [m_colors addObject:AWSDDMakeColor(176, 254, 180)];
    [m_colors addObject:AWSDDMakeColor(176, 254, 220)];
    [m_colors addObject:AWSDDMakeColor(175, 253, 249)];
    [m_colors addObject:AWSDDMakeColor(247,  56,  30)];
    [m_colors addObject:AWSDDMakeColor(245,  57, 122)];
    [m_colors addObject:AWSDDMakeColor(243,  59, 163)];
    [m_colors addObject:AWSDDMakeColor(244,  60, 204)];
    [m_colors addObject:AWSDDMakeColor(242,  59, 241)];
    [m_colors addObject:AWSDDMakeColor(240,  55, 255)];
    [m_colors addObject:AWSDDMakeColor(241, 119,  36)];
    [m_colors addObject:AWSDDMakeColor(240, 120, 118)];
    [m_colors addObject:AWSDDMakeColor(238, 119, 158)];
    [m_colors addObject:AWSDDMakeColor(237, 119, 199)];
    [m_colors addObject:AWSDDMakeColor(237, 118, 238)];
    [m_colors addObject:AWSDDMakeColor(236, 118, 255)];
    [m_colors addObject:AWSDDMakeColor(235, 154,  36)];
    [m_colors addObject:AWSDDMakeColor(235, 154, 114)];
    [m_colors addObject:AWSDDMakeColor(234, 154, 154)];
    [m_colors addObject:AWSDDMakeColor(232, 154, 194)];
    [m_colors addObject:AWSDDMakeColor(232, 153, 234)];
    [m_colors addObject:AWSDDMakeColor(232, 153, 255)];
    [m_colors addObject:AWSDDMakeColor(230, 190,  30)];
    [m_colors addObject:AWSDDMakeColor(229, 189, 110)];
    [m_colors addObject:AWSDDMakeColor(228, 189, 150)];
    [m_colors addObject:AWSDDMakeColor(227, 189, 190)];
    [m_colors addObject:AWSDDMakeColor(227, 189, 229)];
    [m_colors addObject:AWSDDMakeColor(226, 188, 255)];
    [m_colors addObject:AWSDDMakeColor(224, 224,  35)];
    [m_colors addObject:AWSDDMakeColor(223, 224, 105)];
    [m_colors addObject:AWSDDMakeColor(222, 224, 144)];
    [m_colors addObject:AWSDDMakeColor(222, 223, 184)];
    [m_colors addObject:AWSDDMakeColor(222, 223, 224)];
    [m_colors addObject:AWSDDMakeColor(220, 223, 253)];
    [m_colors addObject:AWSDDMakeColor(217, 253,  28)];
    [m_colors addObject:AWSDDMakeColor(217, 253,  99)];
    [m_colors addObject:AWSDDMakeColor(216, 252, 139)];
    [m_colors addObject:AWSDDMakeColor(216, 252, 179)];
    [m_colors addObject:AWSDDMakeColor(215, 252, 218)];
    [m_colors addObject:AWSDDMakeColor(215, 251, 250)];
    [m_colors addObject:AWSDDMakeColor(255,  61,  30)];
    [m_colors addObject:AWSDDMakeColor(255,  60, 118)];
    [m_colors addObject:AWSDDMakeColor(255,  58, 159)];
    [m_colors addObject:AWSDDMakeColor(255,  56, 199)];
    [m_colors addObject:AWSDDMakeColor(255,  55, 238)];
    [m_colors addObject:AWSDDMakeColor(255,  59, 255)];
    [m_colors addObject:AWSDDMakeColor(255, 117,  29)];
    [m_colors addObject:AWSDDMakeColor(255, 117, 115)];
    [m_colors addObject:AWSDDMakeColor(255, 117, 155)];
    [m_colors addObject:AWSDDMakeColor(255, 117, 195)];
    [m_colors addObject:AWSDDMakeColor(255, 116, 235)];
    [m_colors addObject:AWSDDMakeColor(254, 116, 255)];
    [m_colors addObject:AWSDDMakeColor(255, 152,  27)];
    [m_colors addObject:AWSDDMakeColor(255, 152, 111)];
    [m_colors addObject:AWSDDMakeColor(254, 152, 152)];
    [m_colors addObject:AWSDDMakeColor(255, 152, 192)];
    [m_colors addObject:AWSDDMakeColor(254, 151, 231)];
    [m_colors addObject:AWSDDMakeColor(253, 151, 253)];
    [m_colors addObject:AWSDDMakeColor(255, 187,  33)];
    [m_colors addObject:AWSDDMakeColor(253, 187, 107)];
    [m_colors addObject:AWSDDMakeColor(252, 187, 148)];
    [m_colors addObject:AWSDDMakeColor(253, 187, 187)];
    [m_colors addObject:AWSDDMakeColor(254, 187, 227)];
    [m_colors addObject:AWSDDMakeColor(252, 186, 252)];
    [m_colors addObject:AWSDDMakeColor(252, 222,  34)];
    [m_colors addObject:AWSDDMakeColor(251, 222, 103)];
    [m_colors addObject:AWSDDMakeColor(251, 222, 143)];
    [m_colors addObject:AWSDDMakeColor(250, 222, 182)];
    [m_colors addObject:AWSDDMakeColor(251, 221, 222)];
    [m_colors addObject:AWSDDMakeColor(252, 221, 252)];
    [m_colors addObject:AWSDDMakeColor(251, 252,  15)];
    [m_colors addObject:AWSDDMakeColor(251, 252,  97)];
    [m_colors addObject:AWSDDMakeColor(249, 252, 137)];
    [m_colors addObject:AWSDDMakeColor(247, 252, 177)];
    [m_colors addObject:AWSDDMakeColor(247, 253, 217)];
    [m_colors addObject:AWSDDMakeColor(254, 255, 255)];
    [m_colors addObject:AWSDDMakeColor( 52,  53,  53)];
    [m_colors addObject:AWSDDMakeColor( 57,  58,  59)];
    [m_colors addObject:AWSDDMakeColor( 66,  67,  67)];
    [m_colors addObject:AWSDDMakeColor( 75,  76,  76)];
    [m_colors addObject:AWSDDMakeColor( 83,  85,  85)];
    [m_colors addObject:AWSDDMakeColor( 92,  93,  94)];
    [m_colors addObject:AWSDDMakeColor(101, 102, 102)];
    [m_colors addObject:AWSDDMakeColor(109, 111, 111)];
    [m_colors addObject:AWSDDMakeColor(118, 119, 119)];
    [m_colors addObject:AWSDDMakeColor(126, 127, 128)];
    [m_colors addObject:AWSDDMakeColor(134, 136, 136)];
    [m_colors addObject:AWSDDMakeColor(143, 144, 145)];
    [m_colors addObject:AWSDDMakeColor(151, 152, 153)];
    [m_colors addObject:AWSDDMakeColor(159, 161, 161)];
    [m_colors addObject:AWSDDMakeColor(167, 169, 169)];
    [m_colors addObject:AWSDDMakeColor(176, 177, 177)];
    [m_colors addObject:AWSDDMakeColor(184, 185, 186)];
    [m_colors addObject:AWSDDMakeColor(192, 193, 194)];
    [m_colors addObject:AWSDDMakeColor(200, 201, 202)];
    [m_colors addObject:AWSDDMakeColor(208, 209, 210)];
    [m_colors addObject:AWSDDMakeColor(216, 218, 218)];
    [m_colors addObject:AWSDDMakeColor(224, 226, 226)];
    [m_colors addObject:AWSDDMakeColor(232, 234, 234)];
    [m_colors addObject:AWSDDMakeColor(240, 242, 242)];
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
                [m_colors addObject:AWSDDMakeColor(r, g, b)];
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
        [m_colors addObject:AWSDDMakeColor(r, g, b)];
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
+ (void)getRed:(CGFloat *)rPtr green:(CGFloat *)gPtr blue:(CGFloat *)bPtr fromColor:(AWSDDColor *)color {
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
    #elif defined(AWSDD_CLI) || !__has_include(<AppKit/NSColor.h>)
    [color getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    #else 
    NSColor *safeColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [safeColor getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    #endif 
}
+ (NSUInteger)codeIndexForColor:(AWSDDColor *)inColor {
    CGFloat inR, inG, inB;
    [self getRed:&inR green:&inG blue:&inB fromColor:inColor];
    NSUInteger bestIndex = 0;
    CGFloat lowestDistance = 100.0f;
    NSUInteger i = 0;
    for (AWSDDColor *color in colors) {
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b fromColor:color];
    #if CGFLOAT_IS_DOUBLE
        CGFloat distance = sqrt(pow(r - inR, 2.0) + pow(g - inG, 2.0) + pow(b - inB, 2.0));
    #else
        CGFloat distance = sqrtf(powf(r - inR, 2.0f) + powf(g - inG, 2.0f) + powf(b - inB, 2.0f));
    #endif
        NSLogVerbose(@"AWSDDTTYLogger: %3lu : %.3f,%.3f,%.3f & %.3f,%.3f,%.3f = %.6f",
                     (unsigned long)i, inR, inG, inB, r, g, b, distance);
        if (distance < lowestDistance) {
            bestIndex = i;
            lowestDistance = distance;
            NSLogVerbose(@"AWSDDTTYLogger: New best index = %lu", (unsigned long)bestIndex);
        }
        i++;
    }
    return bestIndex;
}
+ (instancetype)sharedInstance {
    static dispatch_once_t AWSDDTTYLoggerOnceToken;
    dispatch_once(&AWSDDTTYLoggerOnceToken, ^{
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
        NSLogInfo(@"AWSDDTTYLogger: isaColorTTY = %@", (isaColorTTY ? @"YES" : @"NO"));
        NSLogInfo(@"AWSDDTTYLogger: isaColor256TTY: %@", (isaColor256TTY ? @"YES" : @"NO"));
        NSLogInfo(@"AWSDDTTYLogger: isaXcodeColorTTY: %@", (isaXcodeColorTTY ? @"YES" : @"NO"));
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (sharedInstance != nil) {
        return nil;
    }
    if ((self = [super init])) {
        _appName = [[NSProcessInfo processInfo] processName];
        _appLen = [_appName lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (_appLen == 0) {
            _appName = @"<UnnamedApp>";
            _appLen = [_appName lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        }
        _app = (char *)malloc(_appLen + 1);
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
        _pid = (char *)malloc(_pidLen + 1);
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
- (void)loadDefaultColorProfiles {
    [self setForegroundColor:AWSDDMakeColor(214,  57,  30) backgroundColor:nil forFlag:AWSDDLogFlagError];
    [self setForegroundColor:AWSDDMakeColor(204, 121,  32) backgroundColor:nil forFlag:AWSDDLogFlagWarning];
}
- (BOOL)colorsEnabled {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
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
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(self.loggerQueue, block);
    });
}
- (void)setForegroundColor:(AWSDDColor *)txtColor backgroundColor:(AWSDDColor *)bgColor forFlag:(AWSDDLogFlag)mask {
    [self setForegroundColor:txtColor backgroundColor:bgColor forFlag:mask context:LOG_CONTEXT_ALL];
}
- (void)setForegroundColor:(AWSDDColor *)txtColor backgroundColor:(AWSDDColor *)bgColor forFlag:(AWSDDLogFlag)mask context:(NSInteger)ctxt {
    dispatch_block_t block = ^{
        @autoreleasepool {
            AWSDDTTYLoggerColorProfile *newColorProfile =
                [[AWSDDTTYLoggerColorProfile alloc] initWithForegroundColor:txtColor
                                                         backgroundColor:bgColor
                                                                    flag:mask
                                                                 context:ctxt];
            NSLogInfo(@"AWSDDTTYLogger: newColorProfile: %@", newColorProfile);
            NSUInteger i = 0;
            for (AWSDDTTYLoggerColorProfile *colorProfile in self->_colorProfilesArray) {
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
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)setForegroundColor:(AWSDDColor *)txtColor backgroundColor:(AWSDDColor *)bgColor forTag:(id <NSCopying>)tag {
    NSAssert([(id < NSObject >) tag conformsToProtocol: @protocol(NSCopying)], @"Invalid tag");
    dispatch_block_t block = ^{
        @autoreleasepool {
            AWSDDTTYLoggerColorProfile *newColorProfile =
                [[AWSDDTTYLoggerColorProfile alloc] initWithForegroundColor:txtColor
                                                         backgroundColor:bgColor
                                                                    flag:(AWSDDLogFlag)0
                                                                 context:0];
            NSLogInfo(@"AWSDDTTYLogger: newColorProfile: %@", newColorProfile);
            self->_colorProfilesDict[tag] = newColorProfile;
        }
    };
    if ([self isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)clearColorsForFlag:(AWSDDLogFlag)mask {
    [self clearColorsForFlag:mask context:0];
}
- (void)clearColorsForFlag:(AWSDDLogFlag)mask context:(NSInteger)context {
    dispatch_block_t block = ^{
        @autoreleasepool {
            NSUInteger i = 0;
            for (AWSDDTTYLoggerColorProfile *colorProfile in self->_colorProfilesArray) {
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
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
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
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
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
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
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
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
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
        dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
        NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_async(globalLoggingQueue, ^{
            dispatch_async(self.loggerQueue, block);
        });
    }
}
- (void)logMessage:(AWSDDLogMessage *)logMessage {
    NSString *logMsg = logMessage->_message;
    BOOL isFormatted = NO;
    if (_logFormatter) {
        logMsg = [_logFormatter formatLogMessage:logMessage];
        isFormatted = logMsg != logMessage->_message;
    }
    if (logMsg) {
        AWSDDTTYLoggerColorProfile *colorProfile = nil;
        if (_colorsEnabled) {
            if (logMessage->_tag) {
                colorProfile = _colorProfilesDict[logMessage->_tag];
            }
            if (colorProfile == nil) {
                for (AWSDDTTYLoggerColorProfile *cp in _colorProfilesArray) {
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
        char msgStack[useStack ? (msgLen + 1) : 1]; 
        char *msg = useStack ? msgStack : (char *)malloc(msgLen + 1);
        if (msg == NULL) {
            return;
        }
        BOOL logMsgEnc = [logMsg getCString:msg maxLength:(msgLen + 1) encoding:NSUTF8StringEncoding];
        if (!logMsgEnc) {
            if (!useStack && msg != NULL) {
                free(msg);
            }
            return;
        }
        if (isFormatted) {
            int iovec_len = (_automaticallyAppendNewlineForCustomFormatters) ? 5 : 4;
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
            v[2].iov_base = (char *)msg;
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
- (NSString *)loggerName {
    return @"cocoa.lumberjack.ttyLogger";
}
@end
@implementation AWSDDTTYLoggerColorProfile
- (instancetype)initWithForegroundColor:(AWSDDColor *)fgColor backgroundColor:(AWSDDColor *)bgColor flag:(AWSDDLogFlag)aMask context:(NSInteger)ctxt {
    if ((self = [super init])) {
        mask = aMask;
        context = ctxt;
        CGFloat r, g, b;
        if (fgColor) {
            [AWSDDTTYLogger getRed:&r green:&g blue:&b fromColor:fgColor];
            fg_r = (uint8_t)(r * 255.0f);
            fg_g = (uint8_t)(g * 255.0f);
            fg_b = (uint8_t)(b * 255.0f);
        }
        if (bgColor) {
            [AWSDDTTYLogger getRed:&r green:&g blue:&b fromColor:bgColor];
            bg_r = (uint8_t)(r * 255.0f);
            bg_g = (uint8_t)(g * 255.0f);
            bg_b = (uint8_t)(b * 255.0f);
        }
        if (fgColor && isaColorTTY) {
            fgCodeIndex = [AWSDDTTYLogger codeIndexForColor:fgColor];
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
            bgCodeIndex = [AWSDDTTYLogger codeIndexForColor:bgColor];
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
            @"<AWSDDTTYLoggerColorProfile: %p mask:%i ctxt:%ld fg:%u,%u,%u bg:%u,%u,%u fgCode:%@ bgCode:%@>",
            self, (int)mask, (long)context, fg_r, fg_g, fg_b, bg_r, bg_g, bg_b, fgCodeRaw, bgCodeRaw];
}
@end