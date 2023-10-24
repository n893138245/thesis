#import <Foundation/Foundation.h>
typedef NSString *(^MOBFReplacingOccurrencesHandler) (NSInteger captureCount, NSString *const capturedStrings[captureCount], const NSRange capturedRanges[captureCount], volatile BOOL * const stop);
typedef NS_ENUM(NSUInteger, MOBFRegexOptions)
{
    MOBFRegexOptionsNoOptions               = 0,
    MOBFRegexOptionsCaseless                = 1 << 0,
    MOBFRegexOptionsComments                = 1 << 1,
    MOBFRegexOptionsIgnoreMetacharacters    = 1 << 2,
    MOBFRegexOptionsDotAll                  = 1 << 3,
    MOBFRegexOptionsMultiline               = 1 << 4,
    MOBFRegexOptionsUseUnixLineSeparators   = 1 << 5,
    MOBFRegexOptionsUnicodeWordBoundaries   = 1 << 6,
};
@interface MOBFRegex : NSObject
+ (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)regex
                                       withString:(NSString *)string
                                       usingBlock:(MOBFReplacingOccurrencesHandler)block;
+ (BOOL)isMatchedByRegex:(NSString *)regex
                 options:(MOBFRegexOptions)options
                 inRange:(NSRange)range
              withString:(NSString *)string;
+ (NSArray *)captureComponentsMatchedByRegex:(NSString *)regex
                                  withString:(NSString *)string;
@end