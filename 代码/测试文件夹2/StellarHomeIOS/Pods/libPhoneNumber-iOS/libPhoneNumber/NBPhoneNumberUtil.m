#import "NBPhoneNumberUtil.h"
#import <math.h>
#import "NBMetadataHelper.h"
#import "NBNumberFormat.h"
#import "NBPhoneMetaData.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberDefines.h"
#import "NBPhoneNumberDesc.h"
#import "NBRegExMatcher.h"
#if TARGET_OS_IOS
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#endif
static NSString *NormalizeNonBreakingSpace(NSString *aString) {
  return [aString stringByReplacingOccurrencesOfString:NB_NON_BREAKING_SPACE withString:@" "];
}
static BOOL isNan(NSString *sourceString) {
  static dispatch_once_t onceToken;
  static NSCharacterSet *nonDecimalCharacterSet;
  dispatch_once(&onceToken, ^{
    nonDecimalCharacterSet = [[NSMutableCharacterSet decimalDigitCharacterSet] invertedSet];
  });
  return !([sourceString rangeOfCharacterFromSet:nonDecimalCharacterSet].location == NSNotFound);
}
#pragma mark - NBPhoneNumberUtil interface -
@interface NBPhoneNumberUtil ()
@property(nonatomic, strong) NSLock *entireStringCacheLock;
@property(nonatomic, strong) NSMutableDictionary *entireStringRegexCache;
@property(nonatomic, strong) NSLock *lockPatternCache;
@property(nonatomic, strong) NSMutableDictionary *regexPatternCache;
@property(nonatomic, strong) NSRegularExpression *CAPTURING_DIGIT_PATTERN;
@property(nonatomic, strong) NSRegularExpression *VALID_ALPHA_PHONE_PATTERN;
@property(nonatomic, strong, readwrite) NBMetadataHelper *helper;
@property(nonatomic, strong, readwrite) NBRegExMatcher *matcher;
#if TARGET_OS_IOS
@property(nonatomic, readonly) CTTelephonyNetworkInfo *telephonyNetworkInfo;
#endif
@end
@implementation NBPhoneNumberUtil
#pragma mark - Static Int variables -
const static NSUInteger NANPA_COUNTRY_CODE_ = 1;
const static NSUInteger MIN_LENGTH_FOR_NSN_ = 2;
const static NSUInteger MAX_LENGTH_FOR_NSN_ = 16;
const static NSUInteger MAX_LENGTH_COUNTRY_CODE_ = 3;
const static NSUInteger MAX_INPUT_STRING_LENGTH_ = 250;
#pragma mark - Static String variables -
static NSString *VALID_PUNCTUATION =
    @"-x‐-―−ー－-／ ­​⁠　()（）［］.\\[\\]/~⁓∼～";
static NSString *COLOMBIA_MOBILE_TO_FIXED_LINE_PREFIX = @"3";
static NSString *PLUS_SIGN = @"+";
static NSString *STAR_SIGN = @"*";
static NSString *RFC3966_EXTN_PREFIX = @";ext=";
static NSString *RFC3966_PREFIX = @"tel:";
static NSString *RFC3966_PHONE_CONTEXT = @";phone-context=";
static NSString *RFC3966_ISDN_SUBADDRESS = @";isub=";
static NSString *DEFAULT_EXTN_PREFIX = @" ext. ";
static NSString *VALID_ALPHA = @"A-Za-z";
#pragma mark - Static regular expression strings -
static NSString *NON_DIGITS_PATTERN = @"\\D+";
static NSString *CC_PATTERN = @"\\$CC";
static NSString *FIRST_GROUP_PATTERN = @"(\\$\\d)";
static NSString *FIRST_GROUP_ONLY_PREFIX_PATTERN = @"^\\(?\\$1\\)?";
static NSString *NP_PATTERN = @"\\$NP";
static NSString *FG_PATTERN = @"\\$FG";
static NSString *VALID_ALPHA_PHONE_PATTERN_STRING = @"(?:.*?[A-Za-z]){3}.*";
static NSString *UNIQUE_INTERNATIONAL_PREFIX = @"[\\d]+(?:[~\\u2053\\u223C\\uFF5E][\\d]+)?";
static NSString *LEADING_PLUS_CHARS_PATTERN;
static NSString *EXTN_PATTERN;
static NSString *SEPARATOR_PATTERN;
static NSString *VALID_PHONE_NUMBER_PATTERN;
static NSString *VALID_START_CHAR_PATTERN;
static NSString *UNWANTED_END_CHAR_PATTERN;
static NSString *SECOND_NUMBER_START_PATTERN;
static NSDictionary *ALL_NORMALIZATION_MAPPINGS;
static NSDictionary *DIALLABLE_CHAR_MAPPINGS;
static NSDictionary *ALL_PLUS_NUMBER_GROUPING_SYMBOLS;
static NSDictionary<NSNumber *, NSString *> *MOBILE_TOKEN_MAPPINGS;
static NSDictionary *DIGIT_MAPPINGS;
static NSArray *GEO_MOBILE_COUNTRIES;
#pragma mark - Deprecated methods
+ (NBPhoneNumberUtil *)sharedInstance {
  static NBPhoneNumberUtil *sharedOnceInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedOnceInstance = [[self alloc] init];
  });
  return sharedOnceInstance;
}
#pragma mark - NSError
- (NSError *)errorWithObject:(id)obj withDomain:(NSString *)domain {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:obj forKey:NSLocalizedDescriptionKey];
  NSError *error = [NSError errorWithDomain:domain code:0 userInfo:userInfo];
  return error;
}
- (NSRegularExpression *)entireRegularExpressionWithPattern:(NSString *)regexPattern
                                                    options:(NSRegularExpressionOptions)options
                                                      error:(NSError **)error {
  [_entireStringCacheLock lock];
  @try {
    if (!_entireStringRegexCache) {
      _entireStringRegexCache = [[NSMutableDictionary alloc] init];
    }
    NSRegularExpression *regex = [_entireStringRegexCache objectForKey:regexPattern];
    if (!regex) {
      NSString *finalRegexString = regexPattern;
      if ([regexPattern rangeOfString:@"^"].location == NSNotFound) {
        finalRegexString = [NSString stringWithFormat:@"^(?:%@)$", regexPattern];
      }
      regex = [self regularExpressionWithPattern:finalRegexString options:0 error:error];
      [_entireStringRegexCache setObject:regex forKey:regexPattern];
    }
    return regex;
  } @finally {
    [_entireStringCacheLock unlock];
  }
}
- (NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern
                                              options:(NSRegularExpressionOptions)options
                                                error:(NSError **)error {
  [_lockPatternCache lock];
  @try {
    if (!_regexPatternCache) {
      _regexPatternCache = [[NSMutableDictionary alloc] init];
    }
    NSRegularExpression *regex = [_regexPatternCache objectForKey:pattern];
    if (!regex) {
      regex =
          [NSRegularExpression regularExpressionWithPattern:pattern options:options error:error];
      [_regexPatternCache setObject:regex forKey:pattern];
    }
    return regex;
  } @finally {
    [_lockPatternCache unlock];
  }
}
- (NSMutableArray *)componentsSeparatedByRegex:(NSString *)sourceString regex:(NSString *)pattern {
  NSString *replacedString =
      [self replaceStringByRegex:sourceString regex:pattern withTemplate:@"<SEP>"];
  NSMutableArray *resArray = [[replacedString componentsSeparatedByString:@"<SEP>"] mutableCopy];
  [resArray removeObject:@""];
  return resArray;
}
- (int)stringPositionByRegex:(NSString *)sourceString regex:(NSString *)pattern {
  if (sourceString == nil || sourceString.length <= 0 || pattern == nil || pattern.length <= 0) {
    return -1;
  }
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:pattern options:0 error:&error];
  NSArray *matches = [currentPattern matchesInString:sourceString
                                             options:0
                                               range:NSMakeRange(0, sourceString.length)];
  int foundPosition = -1;
  if (matches.count > 0) {
    NSTextCheckingResult *match = [matches objectAtIndex:0];
    return (int)match.range.location;
  }
  return foundPosition;
}
- (int)indexOfStringByString:(NSString *)sourceString target:(NSString *)targetString {
  NSRange finded = [sourceString rangeOfString:targetString];
  if (finded.location != NSNotFound) {
    return (int)finded.location;
  }
  return -1;
}
- (NSString *)replaceFirstStringByRegex:(NSString *)sourceString
                                  regex:(NSString *)pattern
                           withTemplate:(NSString *)templateString {
  NSString *replacementResult = [sourceString copy];
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:pattern options:0 error:&error];
  NSRange replaceRange =
      [currentPattern rangeOfFirstMatchInString:sourceString
                                        options:0
                                          range:NSMakeRange(0, sourceString.length)];
  if (replaceRange.location != NSNotFound) {
    replacementResult = [currentPattern stringByReplacingMatchesInString:[sourceString mutableCopy]
                                                                 options:0
                                                                   range:replaceRange
                                                            withTemplate:templateString];
  }
  return replacementResult;
}
- (NSString *)replaceStringByRegex:(NSString *)sourceString
                             regex:(NSString *)pattern
                      withTemplate:(NSString *)templateString {
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:pattern options:0 error:&error];
  NSArray *matches = [currentPattern matchesInString:sourceString
                                             options:0
                                               range:NSMakeRange(0, sourceString.length)];
  if ([matches count] == 1) {
    NSString *replacementResult;
    NSRange replaceRange =
        [currentPattern rangeOfFirstMatchInString:sourceString
                                          options:0
                                            range:NSMakeRange(0, sourceString.length)];
    if (replaceRange.location != NSNotFound) {
      replacementResult =
          [currentPattern stringByReplacingMatchesInString:[sourceString mutableCopy]
                                                   options:0
                                                     range:replaceRange
                                              withTemplate:templateString];
    } else {
      replacementResult = [sourceString copy];
    }
    return replacementResult;
  }
  if ([matches count] > 1) {
    return [currentPattern stringByReplacingMatchesInString:sourceString
                                                    options:0
                                                      range:NSMakeRange(0, sourceString.length)
                                               withTemplate:templateString];
  }
  return [sourceString copy];
}
- (NSTextCheckingResult *)matchFirstByRegex:(NSString *)sourceString regex:(NSString *)pattern {
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:pattern options:0 error:&error];
  NSArray *matches = [currentPattern matchesInString:sourceString
                                             options:0
                                               range:NSMakeRange(0, sourceString.length)];
  if ([matches count] > 0) return [matches objectAtIndex:0];
  return nil;
}
- (NSArray *)matchesByRegex:(NSString *)sourceString regex:(NSString *)pattern {
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:pattern options:0 error:&error];
  NSArray *matches = [currentPattern matchesInString:sourceString
                                             options:0
                                               range:NSMakeRange(0, sourceString.length)];
  return matches;
}
- (NSArray *)matchedStringByRegex:(NSString *)sourceString regex:(NSString *)pattern {
  NSArray *matches = [self matchesByRegex:sourceString regex:pattern];
  NSMutableArray *matchString = [[NSMutableArray alloc] init];
  for (NSTextCheckingResult *match in matches) {
    NSString *curString = [sourceString substringWithRange:match.range];
    [matchString addObject:curString];
  }
  return matchString;
}
- (BOOL)isStartingStringByRegex:(NSString *)sourceString regex:(NSString *)pattern {
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:pattern options:0 error:&error];
  NSArray *matches = [currentPattern matchesInString:sourceString
                                             options:0
                                               range:NSMakeRange(0, sourceString.length)];
  for (NSTextCheckingResult *match in matches) {
    if (match.range.location == 0) {
      return YES;
    }
  }
  return NO;
}
- (NSString *)stringByReplacingOccurrencesString:(NSString *)sourceString
                                         withMap:(NSDictionary *)dicMap
                                removeNonMatches:(BOOL)bRemove {
  NSMutableString *targetString = [[NSMutableString alloc] init];
  NSUInteger length = sourceString.length;
  for (NSUInteger i = 0; i < length; i++) {
    unichar oneChar = [sourceString characterAtIndex:i];
    NSString *keyString = [NSString stringWithCharacters:&oneChar length:1];
    NSString *mappedValue = [dicMap objectForKey:keyString];
    if (mappedValue != nil) {
      [targetString appendString:mappedValue];
    } else {
      if (bRemove == NO) {
        [targetString appendString:keyString];
      }
    }
  }
  return targetString;
}
- (BOOL)isAllDigits:(NSString *)sourceString {
  NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  NSRange r = [sourceString rangeOfCharacterFromSet:nonNumbers];
  return r.location == NSNotFound;
}
- (NSString *)getNationalSignificantNumber:(NBPhoneNumber *)phoneNumber {
  NSString *nationalNumber = [phoneNumber.nationalNumber stringValue];
  if (phoneNumber.italianLeadingZero) {
    NSString *zeroNumbers =
        [@"" stringByPaddingToLength:phoneNumber.numberOfLeadingZeros.integerValue
                          withString:@"0"
                     startingAtIndex:0];
    return [NSString stringWithFormat:@"%@%@", zeroNumbers, nationalNumber];
  }
  return [phoneNumber.nationalNumber stringValue];
}
#pragma mark - Initializations -
+ (void)initialize {
  [super initialize];
  GEO_MOBILE_COUNTRIES = @[ @52, @54, @55 ];
}
- (instancetype)init {
  self = [super init];
  if (self) {
    _lockPatternCache = [[NSLock alloc] init];
    _entireStringCacheLock = [[NSLock alloc] init];
    _helper = [[NBMetadataHelper alloc] init];
    _matcher = [[NBRegExMatcher alloc] init];
    [self initRegularExpressionSet];
    [self initNormalizationMappings];
  }
  return self;
}
- (void)initRegularExpressionSet {
  NSError *error = nil;
  if (!_CAPTURING_DIGIT_PATTERN) {
    _CAPTURING_DIGIT_PATTERN = [self
        regularExpressionWithPattern:[NSString stringWithFormat:@"([%@])", NB_VALID_DIGITS_STRING]
                             options:0
                               error:&error];
  }
  if (!_VALID_ALPHA_PHONE_PATTERN) {
    _VALID_ALPHA_PHONE_PATTERN =
        [self regularExpressionWithPattern:VALID_ALPHA_PHONE_PATTERN_STRING options:0 error:&error];
  }
  static dispatch_once_t onceToken;
  dispatch_once(
      &onceToken, ^{
        NSString *EXTN_PATTERNS_FOR_PARSING =
            @"(?:;ext=([0-9０-９٠-٩۰-۹]{1,7})|[  "
            @"\\t,]*(?:e?xt(?:ensi(?:ó?|ó))?n?|ｅ?ｘｔｎ?|[,xｘX#＃~～]|int|anexo|ｉｎｔ)[:\\.．]?["
            @"  \\t,-]*([0-9０-９٠-٩۰-۹]{1,7})#?|[- ]+([0-9０-９٠-٩۰-۹]{1,5})#)$";
        LEADING_PLUS_CHARS_PATTERN = [NSString stringWithFormat:@"^[%@]+", NB_PLUS_CHARS];
        VALID_START_CHAR_PATTERN =
            [NSString stringWithFormat:@"[%@%@]", NB_PLUS_CHARS, NB_VALID_DIGITS_STRING];
        SECOND_NUMBER_START_PATTERN = @"[\\\\\\/] *x";
        UNWANTED_END_CHAR_PATTERN =
            [NSString stringWithFormat:@"[^%@%@#]+$", NB_VALID_DIGITS_STRING, VALID_ALPHA];
        EXTN_PATTERN = [NSString stringWithFormat:@"(?:%@)$", EXTN_PATTERNS_FOR_PARSING];
        SEPARATOR_PATTERN = [NSString stringWithFormat:@"[%@]+", VALID_PUNCTUATION];
        VALID_PHONE_NUMBER_PATTERN =
            @"^[0-9０-９٠-٩۰-۹]{2}$|^[+＋]*(?:[-x‐-―−ー－-／  "
            @"­​⁠　()（）［］.\\[\\]/~⁓∼～*]*[0-9０-９٠-٩۰-۹]){3,}[-x‐-―−ー－-／  "
            @"­​⁠　()（）［］.\\[\\]/"
            @"~⁓∼～*A-Za-z0-9０-９٠-٩۰-۹]*(?:;ext=([0-9０-９٠-٩۰-۹]{1,7})|[  "
            @"\\t,]*(?:e?xt(?:ensi(?:ó?|ó))?n?|ｅ?ｘｔｎ?|[,xｘ#＃~～]|int|anexo|ｉｎｔ)[:\\.．]?[ "
            @" \\t,-]*([0-9０-９٠-٩۰-۹]{1,7})#?|[- ]+([0-9０-９٠-٩۰-۹]{1,5})#)?$";
      });
}
- (NSDictionary *)DIGIT_MAPPINGS {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    DIGIT_MAPPINGS = [NSDictionary
        dictionaryWithObjectsAndKeys:@"0", @"0", @"1", @"1", @"2", @"2", @"3", @"3", @"4", @"4",
                                     @"5", @"5", @"6", @"6", @"7", @"7", @"8", @"8", @"9", @"9",
                                     @"0", @"\uFF10", @"1", @"\uFF11", @"2", @"\uFF12", @"3",
                                     @"\uFF13", @"4", @"\uFF14", @"5", @"\uFF15", @"6", @"\uFF16",
                                     @"7", @"\uFF17", @"8", @"\uFF18", @"9", @"\uFF19",
                                     @"0", @"\u0660", @"1", @"\u0661", @"2", @"\u0662", @"3",
                                     @"\u0663", @"4", @"\u0664", @"5", @"\u0665", @"6", @"\u0666",
                                     @"7", @"\u0667", @"8", @"\u0668", @"9", @"\u0669",
                                     @"0", @"\u06F0", @"1", @"\u06F1", @"2", @"\u06F2", @"3",
                                     @"\u06F3", @"4", @"\u06F4", @"5", @"\u06F5", @"6", @"\u06F6",
                                     @"7", @"\u06F7", @"8", @"\u06F8", @"9", @"\u06F9",
                                     @"0", @"\u09E6", @"1", @"\u09E7", @"2", @"\u09E8", @"3",
                                     @"\u09E9", @"4", @"\u09EA", @"5", @"\u09EB", @"6", @"\u09EC",
                                     @"7", @"\u09ED", @"8", @"\u09EE", @"9", @"\u09EF",
                                     @"0", @"\u0966", @"1", @"\u0967", @"2", @"\u0968", @"3",
                                     @"\u0969", @"4", @"\u096A", @"5", @"\u096B", @"6", @"\u096C",
                                     @"7", @"\u096D", @"8", @"\u096E", @"9", @"\u096F", nil];
  });
  return DIGIT_MAPPINGS;
}
- (void)initNormalizationMappings {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    DIALLABLE_CHAR_MAPPINGS = [NSDictionary
        dictionaryWithObjectsAndKeys:@"0", @"0", @"1", @"1", @"2", @"2", @"3", @"3", @"4", @"4",
                                     @"5", @"5", @"6", @"6", @"7", @"7", @"8", @"8", @"9", @"9",
                                     @"+", @"+", @"*", @"*", @"#", @"#", nil];
    ALL_NORMALIZATION_MAPPINGS = [NSDictionary
        dictionaryWithObjectsAndKeys:@"0", @"0", @"1", @"1", @"2", @"2", @"3", @"3", @"4", @"4",
                                     @"5", @"5", @"6", @"6", @"7", @"7", @"8", @"8", @"9", @"9",
                                     @"0", @"\uFF10", @"1", @"\uFF11", @"2", @"\uFF12", @"3",
                                     @"\uFF13", @"4", @"\uFF14", @"5", @"\uFF15", @"6", @"\uFF16",
                                     @"7", @"\uFF17", @"8", @"\uFF18", @"9", @"\uFF19",
                                     @"0", @"\u0660", @"1", @"\u0661", @"2", @"\u0662", @"3",
                                     @"\u0663", @"4", @"\u0664", @"5", @"\u0665", @"6", @"\u0666",
                                     @"7", @"\u0667", @"8", @"\u0668", @"9", @"\u0669",
                                     @"0", @"\u06F0", @"1", @"\u06F1", @"2", @"\u06F2", @"3",
                                     @"\u06F3", @"4", @"\u06F4", @"5", @"\u06F5", @"6", @"\u06F6",
                                     @"7", @"\u06F7", @"8", @"\u06F8", @"9", @"\u06F9", @"2", @"A",
                                     @"2", @"B", @"2", @"C", @"3", @"D", @"3", @"E", @"3", @"F",
                                     @"4", @"G", @"4", @"H", @"4", @"I", @"5", @"J", @"5", @"K",
                                     @"5", @"L", @"6", @"M", @"6", @"N", @"6", @"O", @"7", @"P",
                                     @"7", @"Q", @"7", @"R", @"7", @"S", @"8", @"T", @"8", @"U",
                                     @"8", @"V", @"9", @"W", @"9", @"X", @"9", @"Y", @"9", @"Z",
                                     nil];
    ALL_PLUS_NUMBER_GROUPING_SYMBOLS = [NSDictionary
        dictionaryWithObjectsAndKeys:@"0", @"0", @"1", @"1", @"2", @"2", @"3", @"3", @"4", @"4",
                                     @"5", @"5", @"6", @"6", @"7", @"7", @"8", @"8", @"9", @"9",
                                     @"A", @"A", @"B", @"B", @"C", @"C", @"D", @"D", @"E", @"E",
                                     @"F", @"F", @"G", @"G", @"H", @"H", @"I", @"I", @"J", @"J",
                                     @"K", @"K", @"L", @"L", @"M", @"M", @"N", @"N", @"O", @"O",
                                     @"P", @"P", @"Q", @"Q", @"R", @"R", @"S", @"S", @"T", @"T",
                                     @"U", @"U", @"V", @"V", @"W", @"W", @"X", @"X", @"Y", @"Y",
                                     @"Z", @"Z", @"A", @"a", @"B", @"b", @"C", @"c", @"D", @"d",
                                     @"E", @"e", @"F", @"f", @"G", @"g", @"H", @"h", @"I", @"i",
                                     @"J", @"j", @"K", @"k", @"L", @"l", @"M", @"m", @"N", @"n",
                                     @"O", @"o", @"P", @"p", @"Q", @"q", @"R", @"r", @"S", @"s",
                                     @"T", @"t", @"U", @"u", @"V", @"v", @"W", @"w", @"X", @"x",
                                     @"Y", @"y", @"Z", @"z", @"-", @"-", @"-", @"\uFF0D", @"-",
                                     @"\u2010", @"-", @"\u2011", @"-", @"\u2012", @"-", @"\u2013",
                                     @"-", @"\u2014", @"-", @"\u2015", @"-", @"\u2212", @"/", @"/",
                                     @"/", @"\uFF0F", @" ", @" ", @" ", @"\u3000", @" ", @"\u2060",
                                     @".", @".", @".", @"\uFF0E", nil];
    MOBILE_TOKEN_MAPPINGS = @{
      @52: @"1",
      @54: @"9",
    };
  });
}
#pragma mark - Metadata manager (phonenumberutil.js) functions -
- (NSString *)extractPossibleNumber:(NSString *)number {
  number = NormalizeNonBreakingSpace(number);
  NSString *possibleNumber = @"";
  int start = [self stringPositionByRegex:number regex:VALID_START_CHAR_PATTERN];
  if (start >= 0) {
    possibleNumber = [number substringFromIndex:start];
    possibleNumber =
        [self replaceStringByRegex:possibleNumber regex:UNWANTED_END_CHAR_PATTERN withTemplate:@""];
    int secondNumberStart =
        [self stringPositionByRegex:possibleNumber regex:SECOND_NUMBER_START_PATTERN];
    if (secondNumberStart > 0) {
      possibleNumber = [possibleNumber substringWithRange:NSMakeRange(0, secondNumberStart)];
    }
  } else {
    possibleNumber = @"";
  }
  return possibleNumber;
}
- (BOOL)isViablePhoneNumber:(NSString *)phoneNumber {
  phoneNumber = NormalizeNonBreakingSpace(phoneNumber);
  if (phoneNumber.length < MIN_LENGTH_FOR_NSN_) {
    return NO;
  }
  return [self matchesEntirely:VALID_PHONE_NUMBER_PATTERN string:phoneNumber];
}
- (NSString *)normalize:(NSString *)number {
  if ([self matchesEntirely:VALID_ALPHA_PHONE_PATTERN_STRING string:number]) {
    return [self normalizeHelper:number
        normalizationReplacements:ALL_NORMALIZATION_MAPPINGS
                 removeNonMatches:true];
  } else {
    return [self normalizeDigitsOnly:number];
  }
  return nil;
}
- (void)normalizeSB:(NSString **)number {
  if (number == NULL) {
    return;
  }
  (*number) = [self normalize:(*number)];
}
- (NSString *)normalizeDigitsOnly:(NSString *)number {
  number = NormalizeNonBreakingSpace(number);
  return [self stringByReplacingOccurrencesString:number
                                          withMap:self.DIGIT_MAPPINGS
                                 removeNonMatches:YES];
}
- (NSString *)normalizeDiallableCharsOnly:(NSString *)number {
  number = NormalizeNonBreakingSpace(number);
  return [self stringByReplacingOccurrencesString:number
                                          withMap:DIALLABLE_CHAR_MAPPINGS
                                 removeNonMatches:YES];
}
- (NSString *)convertAlphaCharactersInNumber:(NSString *)number {
  number = NormalizeNonBreakingSpace(number);
  return [self stringByReplacingOccurrencesString:number
                                          withMap:ALL_NORMALIZATION_MAPPINGS
                                 removeNonMatches:NO];
}
- (int)getLengthOfGeographicalAreaCode:(NBPhoneNumber *)phoneNumber error:(NSError **)error {
  int res = 0;
  @try {
    res = [self getLengthOfGeographicalAreaCode:phoneNumber];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) {
      (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
    }
  }
  return res;
}
- (int)getLengthOfGeographicalAreaCode:(NBPhoneNumber *)phoneNumber {
  NSString *regionCode = [self getRegionCodeForNumber:phoneNumber];
  NBPhoneMetaData *metadata = [self.helper getMetadataForRegion:regionCode];
  if (metadata == nil) {
    return 0;
  }
  if (metadata.nationalPrefix == nil && phoneNumber.italianLeadingZero == NO) {
    return 0;
  }
  if ([self isNumberGeographical:phoneNumber] == NO) {
    return 0;
  }
  return [self getLengthOfNationalDestinationCode:phoneNumber];
}
- (int)getLengthOfNationalDestinationCode:(NBPhoneNumber *)phoneNumber error:(NSError **)error {
  int res = 0;
  @try {
    res = [self getLengthOfNationalDestinationCode:phoneNumber];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) {
      (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
    }
  }
  return res;
}
- (int)getLengthOfNationalDestinationCode:(NBPhoneNumber *)phoneNumber {
  NBPhoneNumber *copiedProto = nil;
  if ([NBMetadataHelper hasValue:phoneNumber.extension]) {
    copiedProto = [phoneNumber copy];
    copiedProto.extension = nil;
  } else {
    copiedProto = phoneNumber;
  }
  NSString *nationalSignificantNumber =
      [self format:copiedProto numberFormat:NBEPhoneNumberFormatINTERNATIONAL];
  NSMutableArray *numberGroups = [[self componentsSeparatedByRegex:nationalSignificantNumber
                                                             regex:NON_DIGITS_PATTERN] mutableCopy];
  if ([numberGroups count] > 0 && ((NSString *)[numberGroups objectAtIndex:0]).length <= 0) {
    [numberGroups removeObjectAtIndex:0];
  }
  if ([numberGroups count] <= 2) {
    return 0;
  }
  NSArray *regionCodes = [NBMetadataHelper regionCodeFromCountryCode:phoneNumber.countryCode];
  BOOL isExists = NO;
  for (NSString *regCode in regionCodes) {
    if ([regCode isEqualToString:@"AR"]) {
      isExists = YES;
      break;
    }
  }
  if (isExists && [self getNumberType:phoneNumber] == NBEPhoneNumberTypeMOBILE) {
    return (int)((NSString *)[numberGroups objectAtIndex:2]).length + 1;
  }
  return (int)((NSString *)[numberGroups objectAtIndex:1]).length;
}
- (NSString *)getCountryMobileTokenFromCountryCode:(NSInteger)countryCallingCode {
    NSString *mobileToken = MOBILE_TOKEN_MAPPINGS[@(countryCallingCode)];
    if (mobileToken != nil) {
        return mobileToken;
    }
    return @"";
}
- (NSString *)normalizeHelper:(NSString *)sourceString
    normalizationReplacements:(NSDictionary *)normalizationReplacements
             removeNonMatches:(BOOL)removeNonMatches {
  NSUInteger numberLength = sourceString.length;
  NSMutableString *normalizedNumber = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i < numberLength; ++i) {
    NSString *charString = [sourceString substringWithRange:NSMakeRange(i, 1)];
    NSString *newDigit = [normalizationReplacements objectForKey:[charString uppercaseString]];
    if (newDigit != nil) {
      [normalizedNumber appendString:newDigit];
    } else if (removeNonMatches == NO) {
      [normalizedNumber appendString:charString];
    }
  }
  return normalizedNumber;
}
- (BOOL)formattingRuleHasFirstGroupOnly:(NSString *)nationalPrefixFormattingRule {
  BOOL hasFound = [self stringPositionByRegex:nationalPrefixFormattingRule
                                        regex:FIRST_GROUP_ONLY_PREFIX_PATTERN] >= 0;
  return (([nationalPrefixFormattingRule length] == 0) || hasFound);
}
- (BOOL)isNumberGeographical:(NBPhoneNumber *)phoneNumber {
  NBEPhoneNumberType numberType = [self getNumberType:phoneNumber];
  BOOL containGeoMobileContries = [GEO_MOBILE_COUNTRIES containsObject:phoneNumber.countryCode] &&
                                  numberType == NBEPhoneNumberTypeMOBILE;
  BOOL isFixedLine = (numberType == NBEPhoneNumberTypeFIXED_LINE);
  BOOL isFixedLineOrMobile = (numberType == NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE);
  return isFixedLine || isFixedLineOrMobile || containGeoMobileContries;
}
- (BOOL)isValidRegionCode:(NSString *)regionCode {
  return [NBMetadataHelper hasValue:regionCode] && isNan(regionCode) &&
         [self.helper getMetadataForRegion:regionCode.uppercaseString] != nil;
}
- (BOOL)hasValidCountryCallingCode:(NSNumber *)countryCallingCode {
  id res = [NBMetadataHelper regionCodeFromCountryCode:countryCallingCode];
  if (res != nil) {
    return YES;
  }
  return NO;
}
- (NSString *)format:(NBPhoneNumber *)phoneNumber
        numberFormat:(NBEPhoneNumberFormat)numberFormat
               error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self format:phoneNumber numberFormat:numberFormat];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NSString *)format:(NBPhoneNumber *)phoneNumber numberFormat:(NBEPhoneNumberFormat)numberFormat {
  if ([phoneNumber.nationalNumber isEqualToNumber:@0] &&
      [NBMetadataHelper hasValue:phoneNumber.rawInput]) {
    NSString *rawInput = phoneNumber.rawInput;
    if ([NBMetadataHelper hasValue:rawInput]) {
      return rawInput;
    }
  }
  NSNumber *countryCallingCode = phoneNumber.countryCode;
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:phoneNumber];
  if (numberFormat == NBEPhoneNumberFormatE164) {
    return [self prefixNumberWithCountryCallingCode:countryCallingCode
                                  phoneNumberFormat:NBEPhoneNumberFormatE164
                            formattedNationalNumber:nationalSignificantNumber
                                 formattedExtension:@""];
  }
  if ([self hasValidCountryCallingCode:countryCallingCode] == NO) {
    return nationalSignificantNumber;
  }
  NSArray *regionCodeArray = [NBMetadataHelper regionCodeFromCountryCode:countryCallingCode];
  NSString *regionCode = [regionCodeArray objectAtIndex:0];
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:countryCallingCode regionCode:regionCode];
  NSString *formattedExtension =
      [self maybeGetFormattedExtension:phoneNumber metadata:metadata numberFormat:numberFormat];
  NSString *formattedNationalNumber = [self formatNsn:nationalSignificantNumber
                                             metadata:metadata
                                    phoneNumberFormat:numberFormat
                                          carrierCode:nil];
  return [self prefixNumberWithCountryCallingCode:countryCallingCode
                                phoneNumberFormat:numberFormat
                          formattedNationalNumber:formattedNationalNumber
                               formattedExtension:formattedExtension];
}
- (NSString *)formatByPattern:(NBPhoneNumber *)number
                 numberFormat:(NBEPhoneNumberFormat)numberFormat
           userDefinedFormats:(NSArray *)userDefinedFormats
                        error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatByPattern:number
                   numberFormat:numberFormat
             userDefinedFormats:userDefinedFormats];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NSString *)formatByPattern:(NBPhoneNumber *)number
                 numberFormat:(NBEPhoneNumberFormat)numberFormat
           userDefinedFormats:(NSArray *)userDefinedFormats {
  NSNumber *countryCallingCode = number.countryCode;
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:number];
  if ([self hasValidCountryCallingCode:countryCallingCode] == NO) {
    return nationalSignificantNumber;
  }
  NSArray *regionCodes = [NBMetadataHelper regionCodeFromCountryCode:countryCallingCode];
  NSString *regionCode = nil;
  if (regionCodes != nil && regionCodes.count > 0) {
    regionCode = [regionCodes objectAtIndex:0];
  }
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:countryCallingCode regionCode:regionCode];
  NSString *formattedNumber = @"";
  NBNumberFormat *formattingPattern =
      [self chooseFormattingPatternForNumber:userDefinedFormats
                              nationalNumber:nationalSignificantNumber];
  if (formattingPattern == nil) {
    formattedNumber = nationalSignificantNumber;
  } else {
    NBNumberFormat *numFormatCopy = [formattingPattern copy];
    NSString *nationalPrefixFormattingRule = formattingPattern.nationalPrefixFormattingRule;
    if (nationalPrefixFormattingRule.length > 0) {
      NSString *nationalPrefix = metadata.nationalPrefix;
      if (nationalPrefix.length > 0) {
        nationalPrefixFormattingRule = [self replaceStringByRegex:nationalPrefixFormattingRule
                                                            regex:NP_PATTERN
                                                     withTemplate:nationalPrefix];
        nationalPrefixFormattingRule = [self replaceStringByRegex:nationalPrefixFormattingRule
                                                            regex:FG_PATTERN
                                                     withTemplate:@"\\$1"];
        numFormatCopy.nationalPrefixFormattingRule = nationalPrefixFormattingRule;
      } else {
        numFormatCopy.nationalPrefixFormattingRule = @"";
      }
    }
    formattedNumber = [self formatNsnUsingPattern:nationalSignificantNumber
                                formattingPattern:numFormatCopy
                                     numberFormat:numberFormat
                                      carrierCode:nil];
  }
  NSString *formattedExtension =
      [self maybeGetFormattedExtension:number metadata:metadata numberFormat:numberFormat];
  return [self prefixNumberWithCountryCallingCode:countryCallingCode
                                phoneNumberFormat:numberFormat
                          formattedNationalNumber:formattedNumber
                               formattedExtension:formattedExtension];
}
- (NSString *)formatNationalNumberWithCarrierCode:(NBPhoneNumber *)number
                                      carrierCode:(NSString *)carrierCode
                                            error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatNationalNumberWithCarrierCode:number carrierCode:carrierCode];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) {
      (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
    }
  }
  return res;
}
- (NSString *)formatNationalNumberWithCarrierCode:(NBPhoneNumber *)number
                                      carrierCode:(NSString *)carrierCode {
  NSNumber *countryCallingCode = number.countryCode;
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:number];
  if ([self hasValidCountryCallingCode:countryCallingCode] == NO) {
    return nationalSignificantNumber;
  }
  NSString *regionCode = [self getRegionCodeForCountryCode:countryCallingCode];
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:countryCallingCode regionCode:regionCode];
  NSString *formattedExtension = [self maybeGetFormattedExtension:number
                                                         metadata:metadata
                                                     numberFormat:NBEPhoneNumberFormatNATIONAL];
  NSString *formattedNationalNumber = [self formatNsn:nationalSignificantNumber
                                             metadata:metadata
                                    phoneNumberFormat:NBEPhoneNumberFormatNATIONAL
                                          carrierCode:carrierCode];
  return [self prefixNumberWithCountryCallingCode:countryCallingCode
                                phoneNumberFormat:NBEPhoneNumberFormatNATIONAL
                          formattedNationalNumber:formattedNationalNumber
                               formattedExtension:formattedExtension];
}
- (NBPhoneMetaData *)getMetadataForRegionOrCallingCode:(NSNumber *)countryCallingCode
                                            regionCode:(NSString *)regionCode {
  NBMetadataHelper *helper = self.helper;
  return [regionCode isEqualToString:NB_REGION_CODE_FOR_NON_GEO_ENTITY]
             ? [helper getMetadataForNonGeographicalRegion:countryCallingCode]
             : [helper getMetadataForRegion:regionCode];
}
- (NSString *)formatNationalNumberWithPreferredCarrierCode:(NBPhoneNumber *)number
                                       fallbackCarrierCode:(NSString *)fallbackCarrierCode
                                                     error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatNationalNumberWithCarrierCode:number carrierCode:fallbackCarrierCode];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) {
      (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
    }
  }
  return res;
}
- (NSString *)formatNationalNumberWithPreferredCarrierCode:(NBPhoneNumber *)number
                                       fallbackCarrierCode:(NSString *)fallbackCarrierCode {
  NSString *domesticCarrierCode = number.preferredDomesticCarrierCode != nil
                                      ? number.preferredDomesticCarrierCode
                                      : fallbackCarrierCode;
  return [self formatNationalNumberWithCarrierCode:number carrierCode:domesticCarrierCode];
}
- (NSString *)formatNumberForMobileDialing:(NBPhoneNumber *)number
                         regionCallingFrom:(NSString *)regionCallingFrom
                            withFormatting:(BOOL)withFormatting
                                     error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatNumberForMobileDialing:number
                           regionCallingFrom:regionCallingFrom
                              withFormatting:withFormatting];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NSString *)formatNumberForMobileDialing:(NBPhoneNumber *)number
                         regionCallingFrom:(NSString *)regionCallingFrom
                            withFormatting:(BOOL)withFormatting {
  NSNumber *countryCallingCode = number.countryCode;
  if ([self hasValidCountryCallingCode:countryCallingCode] == NO) {
    return [NBMetadataHelper hasValue:number.rawInput] ? number.rawInput : @"";
  }
  NSString *formattedNumber = @"";
  NBPhoneNumber *numberNoExt = [number copy];
  numberNoExt.extension = @"";
  NSString *regionCode = [self getRegionCodeForCountryCode:countryCallingCode];
  if ([regionCallingFrom isEqualToString:regionCode]) {
    NBEPhoneNumberType numberType = [self getNumberType:numberNoExt];
    BOOL isFixedLineOrMobile = (numberType == NBEPhoneNumberTypeFIXED_LINE) ||
                               (numberType == NBEPhoneNumberTypeMOBILE) ||
                               (numberType == NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE);
    if ([regionCode isEqualToString:@"CO"] && numberType == NBEPhoneNumberTypeFIXED_LINE) {
      formattedNumber =
          [self formatNationalNumberWithCarrierCode:numberNoExt
                                        carrierCode:COLOMBIA_MOBILE_TO_FIXED_LINE_PREFIX];
    } else if ([regionCode isEqualToString:@"BR"] && isFixedLineOrMobile) {
      formattedNumber = [NBMetadataHelper hasValue:numberNoExt.preferredDomesticCarrierCode]
                            ? [self formatNationalNumberWithPreferredCarrierCode:numberNoExt
                                                             fallbackCarrierCode:@""]
                            : @"";
    } else {
      if ((countryCallingCode.unsignedIntegerValue == NANPA_COUNTRY_CODE_ ||
           [regionCode isEqualToString:NB_REGION_CODE_FOR_NON_GEO_ENTITY] ||
           ([regionCode isEqualToString:@"MX"] && isFixedLineOrMobile)) &&
          [self canBeInternationallyDialled:numberNoExt]) {
        formattedNumber = [self format:numberNoExt numberFormat:NBEPhoneNumberFormatINTERNATIONAL];
      } else {
        formattedNumber = [self format:numberNoExt numberFormat:NBEPhoneNumberFormatNATIONAL];
      }
    }
  } else if ([self canBeInternationallyDialled:numberNoExt]) {
    return withFormatting ? [self format:numberNoExt numberFormat:NBEPhoneNumberFormatINTERNATIONAL]
                          : [self format:numberNoExt numberFormat:NBEPhoneNumberFormatE164];
  }
  return withFormatting ? formattedNumber
                        : [self normalizeHelper:formattedNumber
                              normalizationReplacements:DIALLABLE_CHAR_MAPPINGS
                                       removeNonMatches:YES];
}
- (NSString *)formatOutOfCountryCallingNumber:(NBPhoneNumber *)number
                            regionCallingFrom:(NSString *)regionCallingFrom
                                        error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatOutOfCountryCallingNumber:number regionCallingFrom:regionCallingFrom];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NSString *)formatOutOfCountryCallingNumber:(NBPhoneNumber *)number
                            regionCallingFrom:(NSString *)regionCallingFrom {
  if ([self isValidRegionCode:regionCallingFrom] == NO) {
    return [self format:number numberFormat:NBEPhoneNumberFormatINTERNATIONAL];
  }
  NSNumber *countryCallingCode = [number.countryCode copy];
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:number];
  if ([self hasValidCountryCallingCode:countryCallingCode] == NO) {
    return nationalSignificantNumber;
  }
  if (countryCallingCode.unsignedIntegerValue == NANPA_COUNTRY_CODE_) {
    if ([self isNANPACountry:regionCallingFrom]) {
      return [NSString
          stringWithFormat:@"%@ %@", countryCallingCode,
                           [self format:number numberFormat:NBEPhoneNumberFormatNATIONAL]];
    }
  } else if ([countryCallingCode
                 isEqualToNumber:[self getCountryCodeForValidRegion:regionCallingFrom error:nil]]) {
    return [self format:number numberFormat:NBEPhoneNumberFormatNATIONAL];
  }
  NBPhoneMetaData *metadataForRegionCallingFrom =
      [self.helper getMetadataForRegion:regionCallingFrom];
  NSString *internationalPrefix = metadataForRegionCallingFrom.internationalPrefix;
  NSString *internationalPrefixForFormatting = @"";
  if ([self matchesEntirely:UNIQUE_INTERNATIONAL_PREFIX string:internationalPrefix]) {
    internationalPrefixForFormatting = internationalPrefix;
  } else if ([NBMetadataHelper
                 hasValue:metadataForRegionCallingFrom.preferredInternationalPrefix]) {
    internationalPrefixForFormatting = metadataForRegionCallingFrom.preferredInternationalPrefix;
  }
  NSString *regionCode = [self getRegionCodeForCountryCode:countryCallingCode];
  NBPhoneMetaData *metadataForRegion =
      [self getMetadataForRegionOrCallingCode:countryCallingCode regionCode:regionCode];
  NSString *formattedNationalNumber = [self formatNsn:nationalSignificantNumber
                                             metadata:metadataForRegion
                                    phoneNumberFormat:NBEPhoneNumberFormatINTERNATIONAL
                                          carrierCode:nil];
  NSString *formattedExtension =
      [self maybeGetFormattedExtension:number
                              metadata:metadataForRegion
                          numberFormat:NBEPhoneNumberFormatINTERNATIONAL];
  NSString *hasLenth =
      [NSString stringWithFormat:@"%@ %@ %@%@", internationalPrefixForFormatting,
                                 countryCallingCode, formattedNationalNumber, formattedExtension];
  NSString *hasNotLength =
      [self prefixNumberWithCountryCallingCode:countryCallingCode
                             phoneNumberFormat:NBEPhoneNumberFormatINTERNATIONAL
                       formattedNationalNumber:formattedNationalNumber
                            formattedExtension:formattedExtension];
  return internationalPrefixForFormatting.length > 0 ? hasLenth : hasNotLength;
}
- (NSString *)prefixNumberWithCountryCallingCode:(NSNumber *)countryCallingCode
                               phoneNumberFormat:(NBEPhoneNumberFormat)numberFormat
                         formattedNationalNumber:(NSString *)formattedNationalNumber
                              formattedExtension:(NSString *)formattedExtension {
  switch (numberFormat) {
    case NBEPhoneNumberFormatE164:
      return [NSString stringWithFormat:@"+%@%@%@", countryCallingCode, formattedNationalNumber,
                                        formattedExtension];
    case NBEPhoneNumberFormatINTERNATIONAL:
      return [NSString stringWithFormat:@"+%@ %@%@", countryCallingCode, formattedNationalNumber,
                                        formattedExtension];
    case NBEPhoneNumberFormatRFC3966:
      return [NSString stringWithFormat:@"%@+%@-%@%@", RFC3966_PREFIX, countryCallingCode,
                                        formattedNationalNumber, formattedExtension];
    case NBEPhoneNumberFormatNATIONAL:
    default:
      return [NSString stringWithFormat:@"%@%@", formattedNationalNumber, formattedExtension];
  }
}
- (NSString *)formatInOriginalFormat:(NBPhoneNumber *)number
                   regionCallingFrom:(NSString *)regionCallingFrom
                               error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatInOriginalFormat:number regionCallingFrom:regionCallingFrom];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NSString *)formatInOriginalFormat:(NBPhoneNumber *)number
                   regionCallingFrom:(NSString *)regionCallingFrom {
  if ([NBMetadataHelper hasValue:number.rawInput] &&
      ([self hasFormattingPatternForNumber:number] == NO)) {
    return number.rawInput;
  }
  if (number.countryCodeSource == nil) {
    return [self format:number numberFormat:NBEPhoneNumberFormatNATIONAL];
  }
  NSString *formattedNumber = @"";
  switch ([number.countryCodeSource integerValue]) {
    case NBECountryCodeSourceFROM_NUMBER_WITH_PLUS_SIGN:
      formattedNumber = [self format:number numberFormat:NBEPhoneNumberFormatINTERNATIONAL];
      break;
    case NBECountryCodeSourceFROM_NUMBER_WITH_IDD:
      formattedNumber =
          [self formatOutOfCountryCallingNumber:number regionCallingFrom:regionCallingFrom];
      break;
    case NBECountryCodeSourceFROM_NUMBER_WITHOUT_PLUS_SIGN:
      formattedNumber = [[self format:number numberFormat:NBEPhoneNumberFormatINTERNATIONAL]
          substringFromIndex:1];
      break;
    case NBECountryCodeSourceFROM_DEFAULT_COUNTRY:
    default: {
      NSString *regionCode = [self getRegionCodeForCountryCode:number.countryCode];
      NSString *nationalPrefix = [self getNddPrefixForRegion:regionCode stripNonDigits:YES];
      NSString *nationalFormat = [self format:number numberFormat:NBEPhoneNumberFormatNATIONAL];
      if (nationalPrefix == nil || nationalPrefix.length == 0) {
        formattedNumber = nationalFormat;
        break;
      }
      if ([self rawInputContainsNationalPrefix:number.rawInput
                                nationalPrefix:nationalPrefix
                                    regionCode:regionCode]) {
        formattedNumber = nationalFormat;
        break;
      }
      NBPhoneMetaData *metadata = [self.helper getMetadataForRegion:regionCode];
      NSString *nationalNumber = [self getNationalSignificantNumber:number];
      NBNumberFormat *formatRule = [self chooseFormattingPatternForNumber:metadata.numberFormats
                                                           nationalNumber:nationalNumber];
      if (formatRule == nil) {
        formattedNumber = nationalFormat;
        break;
      }
      NSString *candidateNationalPrefixRule = formatRule.nationalPrefixFormattingRule;
      NSRange firstGroupRange = [candidateNationalPrefixRule rangeOfString:@"$1"];
      if (firstGroupRange.location == NSNotFound) {
        formattedNumber = nationalFormat;
        break;
      }
      if (firstGroupRange.location <= 0) {
        formattedNumber = nationalFormat;
        break;
      }
      candidateNationalPrefixRule =
          [candidateNationalPrefixRule substringWithRange:NSMakeRange(0, firstGroupRange.location)];
      candidateNationalPrefixRule = [self normalizeDigitsOnly:candidateNationalPrefixRule];
      if (candidateNationalPrefixRule.length == 0) {
        formattedNumber = nationalFormat;
        break;
      }
      NBNumberFormat *numFormatCopy = [formatRule copy];
      numFormatCopy.nationalPrefixFormattingRule = nil;
      formattedNumber = [self formatByPattern:number
                                 numberFormat:NBEPhoneNumberFormatNATIONAL
                           userDefinedFormats:@[ numFormatCopy ]];
      break;
    }
  }
  NSString *rawInput = number.rawInput;
  if (formattedNumber != nil && rawInput.length > 0) {
    NSString *normalizedFormattedNumber = [self normalizeHelper:formattedNumber
                                      normalizationReplacements:DIALLABLE_CHAR_MAPPINGS
                                               removeNonMatches:YES];
    NSString *normalizedRawInput = [self normalizeHelper:rawInput
                               normalizationReplacements:DIALLABLE_CHAR_MAPPINGS
                                        removeNonMatches:YES];
    if ([normalizedFormattedNumber isEqualToString:normalizedRawInput] == NO) {
      formattedNumber = rawInput;
    }
  }
  return formattedNumber;
}
- (BOOL)rawInputContainsNationalPrefix:(NSString *)rawInput
                        nationalPrefix:(NSString *)nationalPrefix
                            regionCode:(NSString *)regionCode {
  BOOL isValid = NO;
  NSString *normalizedNationalNumber = [self normalizeDigitsOnly:rawInput];
  if ([self isStartingStringByRegex:normalizedNationalNumber regex:nationalPrefix]) {
    NSString *subString = [normalizedNationalNumber substringFromIndex:nationalPrefix.length];
    NSError *anError = nil;
    isValid = [self isValidNumber:[self parse:subString defaultRegion:regionCode error:&anError]];
    if (anError != nil) return NO;
  }
  return isValid;
}
- (BOOL)hasUnexpectedItalianLeadingZero:(NBPhoneNumber *)number {
  return number.italianLeadingZero && [self isLeadingZeroPossible:number.countryCode] == NO;
}
- (BOOL)hasFormattingPatternForNumber:(NBPhoneNumber *)number {
  NSNumber *countryCallingCode = number.countryCode;
  NSString *phoneNumberRegion = [self getRegionCodeForCountryCode:countryCallingCode];
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:countryCallingCode regionCode:phoneNumberRegion];
  if (metadata == nil) {
    return NO;
  }
  NSString *nationalNumber = [self getNationalSignificantNumber:number];
  NBNumberFormat *formatRule =
      [self chooseFormattingPatternForNumber:metadata.numberFormats nationalNumber:nationalNumber];
  return formatRule != nil;
}
- (NSString *)formatOutOfCountryKeepingAlphaChars:(NBPhoneNumber *)number
                                regionCallingFrom:(NSString *)regionCallingFrom
                                            error:(NSError **)error {
  NSString *res = nil;
  @try {
    res = [self formatOutOfCountryKeepingAlphaChars:number regionCallingFrom:regionCallingFrom];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NSString *)formatOutOfCountryKeepingAlphaChars:(NBPhoneNumber *)number
                                regionCallingFrom:(NSString *)regionCallingFrom {
  NSString *rawInput = number.rawInput;
  if (rawInput == nil || rawInput.length == 0) {
    return [self formatOutOfCountryCallingNumber:number regionCallingFrom:regionCallingFrom];
  }
  NSNumber *countryCode = number.countryCode;
  if ([self hasValidCountryCallingCode:countryCode] == NO) {
    return rawInput;
  }
  rawInput = [self normalizeHelper:rawInput
         normalizationReplacements:ALL_PLUS_NUMBER_GROUPING_SYMBOLS
                  removeNonMatches:NO];
  NSString *nationalNumber = [self getNationalSignificantNumber:number];
  if (nationalNumber.length > 3) {
    int firstNationalNumberDigit =
        [self indexOfStringByString:rawInput
                             target:[nationalNumber substringWithRange:NSMakeRange(0, 3)]];
    if (firstNationalNumberDigit != -1) {
      rawInput = [rawInput substringFromIndex:firstNationalNumberDigit];
    }
  }
  NBPhoneMetaData *metadataForRegionCallingFrom =
      [self.helper getMetadataForRegion:regionCallingFrom];
  if (countryCode.unsignedIntegerValue == NANPA_COUNTRY_CODE_) {
    if ([self isNANPACountry:regionCallingFrom]) {
      return [NSString stringWithFormat:@"%@ %@", countryCode, rawInput];
    }
  } else if (metadataForRegionCallingFrom != nil &&
             [countryCode
                 isEqualToNumber:[self getCountryCodeForValidRegion:regionCallingFrom error:nil]]) {
    NBNumberFormat *formattingPattern =
        [self chooseFormattingPatternForNumber:metadataForRegionCallingFrom.numberFormats
                                nationalNumber:nationalNumber];
    if (formattingPattern == nil) {
      return rawInput;
    }
    NBNumberFormat *newFormat = [formattingPattern copy];
    newFormat.pattern = @"(\\d+)(.*)";
    newFormat.format = @"$1$2";
    return [self formatNsnUsingPattern:rawInput
                     formattingPattern:newFormat
                          numberFormat:NBEPhoneNumberFormatNATIONAL
                           carrierCode:nil];
  }
  NSString *internationalPrefixForFormatting = @"";
  if (metadataForRegionCallingFrom != nil) {
    NSString *internationalPrefix = metadataForRegionCallingFrom.internationalPrefix;
    internationalPrefixForFormatting =
        [self matchesEntirely:UNIQUE_INTERNATIONAL_PREFIX string:internationalPrefix]
            ? internationalPrefix
            : metadataForRegionCallingFrom.preferredInternationalPrefix;
  }
  NSString *regionCode = [self getRegionCodeForCountryCode:countryCode];
  NBPhoneMetaData *metadataForRegion =
      [self getMetadataForRegionOrCallingCode:countryCode regionCode:regionCode];
  NSString *formattedExtension =
      [self maybeGetFormattedExtension:number
                              metadata:metadataForRegion
                          numberFormat:NBEPhoneNumberFormatINTERNATIONAL];
  if (internationalPrefixForFormatting.length > 0) {
    return [NSString stringWithFormat:@"%@ %@ %@%@", internationalPrefixForFormatting, countryCode,
                                      rawInput, formattedExtension];
  } else {
    return [self prefixNumberWithCountryCallingCode:countryCode
                                  phoneNumberFormat:NBEPhoneNumberFormatINTERNATIONAL
                            formattedNationalNumber:rawInput
                                 formattedExtension:formattedExtension];
  }
}
- (NSString *)formatNsn:(NSString *)phoneNumber
               metadata:(NBPhoneMetaData *)metadata
      phoneNumberFormat:(NBEPhoneNumberFormat)numberFormat
            carrierCode:(NSString *)opt_carrierCode {
  NSArray *intlNumberFormats = metadata.intlNumberFormats;
  NSArray *availableFormats =
      ([intlNumberFormats count] <= 0 || numberFormat == NBEPhoneNumberFormatNATIONAL)
          ? metadata.numberFormats
          : intlNumberFormats;
  NBNumberFormat *formattingPattern =
      [self chooseFormattingPatternForNumber:availableFormats nationalNumber:phoneNumber];
  if (formattingPattern == nil) {
    return phoneNumber;
  }
  return [self formatNsnUsingPattern:phoneNumber
                   formattingPattern:formattingPattern
                        numberFormat:numberFormat
                         carrierCode:opt_carrierCode];
}
- (NBNumberFormat *)chooseFormattingPatternForNumber:(NSArray *)availableFormats
                                      nationalNumber:(NSString *)nationalNumber {
  for (NBNumberFormat *numFormat in availableFormats) {
    NSUInteger size = [numFormat.leadingDigitsPatterns count];
    if (size == 0 ||
        [self stringPositionByRegex:nationalNumber
                              regex:[numFormat.leadingDigitsPatterns lastObject]] == 0) {
      if ([self matchesEntirely:numFormat.pattern string:nationalNumber]) {
        return numFormat;
      }
    }
  }
  return nil;
}
- (NSString *)formatNsnUsingPattern:(NSString *)nationalNumber
                  formattingPattern:(NBNumberFormat *)formattingPattern
                       numberFormat:(NBEPhoneNumberFormat)numberFormat
                        carrierCode:(NSString *)opt_carrierCode {
  NSString *numberFormatRule = formattingPattern.format;
  NSString *domesticCarrierCodeFormattingRule = formattingPattern.domesticCarrierCodeFormattingRule;
  NSString *formattedNationalNumber = @"";
  if (numberFormat == NBEPhoneNumberFormatNATIONAL && [NBMetadataHelper hasValue:opt_carrierCode] &&
      domesticCarrierCodeFormattingRule.length > 0) {
    NSString *carrierCodeFormattingRule =
        [self replaceStringByRegex:domesticCarrierCodeFormattingRule
                             regex:CC_PATTERN
                      withTemplate:opt_carrierCode];
    numberFormatRule = [self replaceFirstStringByRegex:numberFormatRule
                                                 regex:FIRST_GROUP_PATTERN
                                          withTemplate:carrierCodeFormattingRule];
    formattedNationalNumber = [self replaceStringByRegex:nationalNumber
                                                   regex:formattingPattern.pattern
                                            withTemplate:numberFormatRule];
  } else {
    NSString *nationalPrefixFormattingRule = formattingPattern.nationalPrefixFormattingRule;
    if (numberFormat == NBEPhoneNumberFormatNATIONAL &&
        [NBMetadataHelper hasValue:nationalPrefixFormattingRule]) {
      NSString *replacePattern = [self replaceFirstStringByRegex:numberFormatRule
                                                           regex:FIRST_GROUP_PATTERN
                                                    withTemplate:nationalPrefixFormattingRule];
      formattedNationalNumber = [self replaceStringByRegex:nationalNumber
                                                     regex:formattingPattern.pattern
                                              withTemplate:replacePattern];
    } else {
      formattedNationalNumber = [self replaceStringByRegex:nationalNumber
                                                     regex:formattingPattern.pattern
                                              withTemplate:numberFormatRule];
    }
  }
  if (numberFormat == NBEPhoneNumberFormatRFC3966) {
    formattedNationalNumber =
        [self replaceStringByRegex:formattedNationalNumber
                             regex:[NSString stringWithFormat:@"^%@", SEPARATOR_PATTERN]
                      withTemplate:@""];
    formattedNationalNumber = [self replaceStringByRegex:formattedNationalNumber
                                                   regex:SEPARATOR_PATTERN
                                            withTemplate:@"-"];
  }
  return formattedNationalNumber;
}
- (NBPhoneNumber *)getExampleNumber:(NSString *)regionCode error:(NSError *__autoreleasing *)error {
  NBPhoneNumber *res =
      [self getExampleNumberForType:regionCode type:NBEPhoneNumberTypeFIXED_LINE error:error];
  return res;
}
- (NBPhoneNumber *)getExampleNumberForType:(NSString *)regionCode
                                      type:(NBEPhoneNumberType)type
                                     error:(NSError *__autoreleasing *)error {
  NBPhoneNumber *res = nil;
  if ([self isValidRegionCode:regionCode] == NO) {
    return nil;
  }
  NBPhoneNumberDesc *desc =
      [self getNumberDescByType:[self.helper getMetadataForRegion:regionCode] type:type];
  if ([NBMetadataHelper hasValue:desc.exampleNumber]) {
    return [self parse:desc.exampleNumber defaultRegion:regionCode error:error];
  }
  return res;
}
- (NBPhoneNumber *)getExampleNumberForNonGeoEntity:(NSNumber *)countryCallingCode
                                             error:(NSError *__autoreleasing *)error {
  NBPhoneNumber *res = nil;
  NBPhoneMetaData *metadata = [self.helper getMetadataForNonGeographicalRegion:countryCallingCode];
  if (metadata != nil) {
    NSString *fetchedExampleNumber = nil;
    if ([NBMetadataHelper hasValue:metadata.mobile.exampleNumber]) {
      fetchedExampleNumber = metadata.mobile.exampleNumber;
    } else if ([NBMetadataHelper hasValue:metadata.tollFree.exampleNumber]) {
      fetchedExampleNumber = metadata.tollFree.exampleNumber;
    } else if ([NBMetadataHelper hasValue:metadata.sharedCost.exampleNumber]) {
      fetchedExampleNumber = metadata.sharedCost.exampleNumber;
    } else if ([NBMetadataHelper hasValue:metadata.voip.exampleNumber]) {
      fetchedExampleNumber = metadata.voip.exampleNumber;
    } else if ([NBMetadataHelper hasValue:metadata.voicemail.exampleNumber]) {
      fetchedExampleNumber = metadata.voicemail.exampleNumber;
    } else if ([NBMetadataHelper hasValue:metadata.uan.exampleNumber]) {
      fetchedExampleNumber = metadata.uan.exampleNumber;
    } else if ([NBMetadataHelper hasValue:metadata.premiumRate.exampleNumber]) {
      fetchedExampleNumber = metadata.premiumRate.exampleNumber;
    }
    if (fetchedExampleNumber != nil) {
      NSString *callCode =
          [NSString stringWithFormat:@"+%@%@", countryCallingCode, fetchedExampleNumber];
      res = [self parse:callCode defaultRegion:NB_UNKNOWN_REGION error:error];
    }
  }
  return res;
}
- (NSString *)maybeGetFormattedExtension:(NBPhoneNumber *)number
                                metadata:(NBPhoneMetaData *)metadata
                            numberFormat:(NBEPhoneNumberFormat)numberFormat {
  if ([NBMetadataHelper hasValue:number.extension] == NO) {
    return @"";
  } else {
    if (numberFormat == NBEPhoneNumberFormatRFC3966) {
      return [NSString stringWithFormat:@"%@%@", RFC3966_EXTN_PREFIX, number.extension];
    } else {
      if ([NBMetadataHelper hasValue:metadata.preferredExtnPrefix]) {
        return [NSString stringWithFormat:@"%@%@", metadata.preferredExtnPrefix, number.extension];
      } else {
        return [NSString stringWithFormat:@"%@%@", DEFAULT_EXTN_PREFIX, number.extension];
      }
    }
  }
}
- (NBPhoneNumberDesc *)getNumberDescByType:(NBPhoneMetaData *)metadata
                                      type:(NBEPhoneNumberType)type {
  switch (type) {
    case NBEPhoneNumberTypePREMIUM_RATE:
      return metadata.premiumRate;
    case NBEPhoneNumberTypeTOLL_FREE:
      return metadata.tollFree;
    case NBEPhoneNumberTypeMOBILE:
      if (metadata.mobile == nil) return metadata.generalDesc;
      return metadata.mobile;
    case NBEPhoneNumberTypeFIXED_LINE:
    case NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE:
      if (metadata.fixedLine == nil) return metadata.generalDesc;
      return metadata.fixedLine;
    case NBEPhoneNumberTypeSHARED_COST:
      return metadata.sharedCost;
    case NBEPhoneNumberTypeVOIP:
      return metadata.voip;
    case NBEPhoneNumberTypePERSONAL_NUMBER:
      return metadata.personalNumber;
    case NBEPhoneNumberTypePAGER:
      return metadata.pager;
    case NBEPhoneNumberTypeUAN:
      return metadata.uan;
    case NBEPhoneNumberTypeVOICEMAIL:
      return metadata.voicemail;
    default:
      return metadata.generalDesc;
  }
}
- (NBEPhoneNumberType)getNumberType:(NBPhoneNumber *)phoneNumber {
  NSString *regionCode = [self getRegionCodeForNumber:phoneNumber];
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:phoneNumber.countryCode regionCode:regionCode];
  if (metadata == nil) {
    return NBEPhoneNumberTypeUNKNOWN;
  }
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:phoneNumber];
  return [self getNumberTypeHelper:nationalSignificantNumber metadata:metadata];
}
- (NBEPhoneNumberType)getNumberTypeHelper:(NSString *)nationalNumber
                                 metadata:(NBPhoneMetaData *)metadata {
  NBPhoneNumberDesc *generalNumberDesc = metadata.generalDesc;
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:generalNumberDesc] == NO) {
    return NBEPhoneNumberTypeUNKNOWN;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.premiumRate]) {
    return NBEPhoneNumberTypePREMIUM_RATE;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.tollFree]) {
    return NBEPhoneNumberTypeTOLL_FREE;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.sharedCost]) {
    return NBEPhoneNumberTypeSHARED_COST;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.voip]) {
    return NBEPhoneNumberTypeVOIP;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.personalNumber]) {
    return NBEPhoneNumberTypePERSONAL_NUMBER;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.pager]) {
    return NBEPhoneNumberTypePAGER;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.uan]) {
    return NBEPhoneNumberTypeUAN;
  }
  if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.voicemail]) {
    return NBEPhoneNumberTypeVOICEMAIL;
  }
  BOOL isFixedLine = [self isNumberMatchingDesc:nationalNumber numberDesc:metadata.fixedLine];
  if (isFixedLine) {
    if (metadata.sameMobileAndFixedLinePattern) {
      return NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE;
    } else if ([self isNumberMatchingDesc:nationalNumber numberDesc:metadata.mobile]) {
      return NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE;
    }
    return NBEPhoneNumberTypeFIXED_LINE;
  }
  if ([metadata sameMobileAndFixedLinePattern] == NO &&
      [self isNumberMatchingDesc:nationalNumber numberDesc:metadata.mobile]) {
    return NBEPhoneNumberTypeMOBILE;
  }
  return NBEPhoneNumberTypeUNKNOWN;
}
- (BOOL)isNumberMatchingDesc:(NSString *)nationalNumber numberDesc:(NBPhoneNumberDesc *)numberDesc {
  NSNumber *actualLength = [NSNumber numberWithUnsignedInteger:nationalNumber.length];
  if (numberDesc.possibleLength.count > 0 &&
      [numberDesc.possibleLength indexOfObject:actualLength] == NSNotFound) {
    return NO;
  }
  return [self matchesEntirely:numberDesc.nationalNumberPattern string:nationalNumber];
}
- (BOOL)isValidNumber:(NBPhoneNumber *)number {
  NSString *regionCode = [self getRegionCodeForNumber:number];
  return [self isValidNumberForRegion:number regionCode:regionCode];
}
- (BOOL)isValidNumberForRegion:(NBPhoneNumber *)number regionCode:(NSString *)regionCode {
  NSNumber *countryCode = [number.countryCode copy];
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:countryCode regionCode:regionCode];
  if (metadata == nil ||
      ([NB_REGION_CODE_FOR_NON_GEO_ENTITY isEqualToString:regionCode] == NO &&
       ![countryCode isEqualToNumber:[self getCountryCodeForValidRegion:regionCode error:nil]])) {
    return NO;
  }
  NBPhoneNumberDesc *generalNumDesc = metadata.generalDesc;
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:number];
  if ([NBMetadataHelper hasValue:generalNumDesc.nationalNumberPattern] == NO) {
    NSUInteger numberLength = nationalSignificantNumber.length;
    return numberLength > MIN_LENGTH_FOR_NSN_ && numberLength <= MAX_LENGTH_FOR_NSN_;
  }
  return [self getNumberTypeHelper:nationalSignificantNumber metadata:metadata] !=
         NBEPhoneNumberTypeUNKNOWN;
}
- (NSString *)getRegionCodeForNumber:(NBPhoneNumber *)phoneNumber {
  if (phoneNumber == nil) {
    return nil;
  }
  NSArray *regionCodes = [NBMetadataHelper regionCodeFromCountryCode:phoneNumber.countryCode];
  if (regionCodes == nil || [regionCodes count] <= 0) {
    return nil;
  }
  if ([regionCodes count] == 1) {
    return [regionCodes objectAtIndex:0];
  } else {
    return [self getRegionCodeForNumberFromRegionList:phoneNumber regionCodes:regionCodes];
  }
}
- (NSString *)getRegionCodeForNumberFromRegionList:(NBPhoneNumber *)phoneNumber
                                       regionCodes:(NSArray *)regionCodes {
  NSString *nationalNumber = [self getNationalSignificantNumber:phoneNumber];
  NSUInteger regionCodesCount = [regionCodes count];
  NBMetadataHelper *helper = self.helper;
  for (NSUInteger i = 0; i < regionCodesCount; i++) {
    NSString *regionCode = [regionCodes objectAtIndex:i];
    NBPhoneMetaData *metadata = [helper getMetadataForRegion:regionCode];
    if ([NBMetadataHelper hasValue:metadata.leadingDigits]) {
      if ([self stringPositionByRegex:nationalNumber regex:metadata.leadingDigits] == 0) {
        return regionCode;
      }
    } else if ([self getNumberTypeHelper:nationalNumber metadata:metadata] !=
               NBEPhoneNumberTypeUNKNOWN) {
      return regionCode;
    }
  }
  return nil;
}
- (NSString *)getRegionCodeForCountryCode:(NSNumber *)countryCallingCode {
  NSArray *regionCodes = [NBMetadataHelper regionCodeFromCountryCode:countryCallingCode];
  return regionCodes == nil ? NB_UNKNOWN_REGION : [regionCodes objectAtIndex:0];
}
- (NSArray *)getRegionCodesForCountryCode:(NSNumber *)countryCallingCode {
  NSArray *regionCodes = [NBMetadataHelper regionCodeFromCountryCode:countryCallingCode];
  return regionCodes == nil ? nil : regionCodes;
}
- (NSNumber *)getCountryCodeForRegion:(NSString *)regionCode {
  if ([self isValidRegionCode:regionCode] == NO) {
    return @0;
  }
  NSError *error = nil;
  NSNumber *res = [self getCountryCodeForValidRegion:regionCode error:&error];
  if (error != nil) {
    return @0;
  }
  return res;
}
- (NSNumber *)getCountryCodeForValidRegion:(NSString *)regionCode error:(NSError **)error {
  NBPhoneMetaData *metadata = [self.helper getMetadataForRegion:regionCode];
  if (metadata == nil) {
    NSDictionary *userInfo = [NSDictionary
        dictionaryWithObject:[NSString stringWithFormat:@"Invalid region code:%@", regionCode]
                      forKey:NSLocalizedDescriptionKey];
    if (error != NULL) {
      (*error) = [NSError errorWithDomain:@"INVALID_REGION_CODE" code:0 userInfo:userInfo];
    }
    return @-1;
  }
  return metadata.countryCode;
}
- (NSString *)getNddPrefixForRegion:(NSString *)regionCode stripNonDigits:(BOOL)stripNonDigits {
  NBPhoneMetaData *metadata = [self.helper getMetadataForRegion:regionCode];
  if (metadata == nil) {
    return nil;
  }
  NSString *nationalPrefix = metadata.nationalPrefix;
  if (nationalPrefix.length == 0) {
    return nil;
  }
  if (stripNonDigits) {
    nationalPrefix = [nationalPrefix stringByReplacingOccurrencesOfString:@"~" withString:@""];
  }
  return nationalPrefix;
}
- (BOOL)isNANPACountry:(NSString *)regionCode {
  BOOL isExists = NO;
  NSArray *res = [NBMetadataHelper
      regionCodeFromCountryCode:[NSNumber numberWithUnsignedInteger:NANPA_COUNTRY_CODE_]];
  for (NSString *inRegionCode in res) {
    if ([inRegionCode isEqualToString:regionCode.uppercaseString]) {
      isExists = YES;
    }
  }
  return regionCode != nil && isExists;
}
- (BOOL)isLeadingZeroPossible:(NSNumber *)countryCallingCode {
  NBPhoneMetaData *mainMetadataForCallingCode = [self
      getMetadataForRegionOrCallingCode:countryCallingCode
                             regionCode:[self getRegionCodeForCountryCode:countryCallingCode]];
  return mainMetadataForCallingCode != nil && mainMetadataForCallingCode.leadingZeroPossible;
}
- (BOOL)isAlphaNumber:(NSString *)number {
  if ([self isViablePhoneNumber:number] == NO) {
    return NO;
  }
  number = NormalizeNonBreakingSpace(number);
  NSString *strippedNumber = [number copy];
  [self maybeStripExtension:&strippedNumber];
  return [self matchesEntirely:VALID_ALPHA_PHONE_PATTERN_STRING string:strippedNumber];
}
- (BOOL)isPossibleNumber:(NBPhoneNumber *)number error:(NSError **)error {
  BOOL res = NO;
  @try {
    res = [self isPossibleNumber:number];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (BOOL)isPossibleNumber:(NBPhoneNumber *)number {
  return [self isPossibleNumberWithReason:number] == NBEValidationResultIS_POSSIBLE;
}
- (NBEValidationResult)validateNumberLength:(NSString *)number
                                   metadata:(NBPhoneMetaData *)metadata {
  return [self validateNumberLength:number metadata:metadata type:NBEPhoneNumberTypeUNKNOWN];
}
- (NBEValidationResult)validateNumberLength:(NSString *)number
                                   metadata:(NBPhoneMetaData *)metadata
                                       type:(NBEPhoneNumberType)type {
  NBPhoneNumberDesc *descForType = [self getNumberDescByType:metadata type:type];
  NSArray<NSNumber *> *possibleLengths = [descForType.possibleLength count] == 0
                                             ? metadata.generalDesc.possibleLength
                                             : descForType.possibleLength;
  NSArray<NSNumber *> *localLengths = descForType.possibleLengthLocalOnly;
  if (type == NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE) {
    if ([self descHasPossibleNumberData:[self getNumberDescByType:metadata
                                                             type:NBEPhoneNumberTypeFIXED_LINE]]) {
      return [self validateNumberLength:number metadata:metadata type:NBEPhoneNumberTypeMOBILE];
    } else {
      NBPhoneNumberDesc *mobileDesc =
          [self getNumberDescByType:metadata type:NBEPhoneNumberTypeMOBILE];
      if ([self descHasPossibleNumberData:mobileDesc]) {
        NSArray *combinedArray =
            [possibleLengths arrayByAddingObjectsFromArray:[mobileDesc.possibleLength count] == 0
                                                               ? metadata.generalDesc.possibleLength
                                                               : mobileDesc.possibleLength];
        possibleLengths = [combinedArray sortedArrayUsingSelector:@selector(compare:)];
        if (![localLengths count]) {
          localLengths = mobileDesc.possibleLengthLocalOnly;
        } else {
          NSArray *combinedArray =
              [localLengths arrayByAddingObjectsFromArray:mobileDesc.possibleLengthLocalOnly];
          localLengths = [combinedArray sortedArrayUsingSelector:@selector(compare:)];
        }
      }
    }
  }
  if ([possibleLengths.firstObject isEqualToNumber:@(-1)]) {
    return NBEValidationResultINVALID_LENGTH;
  }
  NSNumber *actualLength = @(number.length);
  if ([localLengths containsObject:actualLength]) {
    return NBEValidationResultIS_POSSIBLE_LOCAL_ONLY;
  }
  NSNumber *minimumLength = possibleLengths.firstObject;
  NSComparisonResult comparisionResult = [minimumLength compare:actualLength];
  if (comparisionResult == NSOrderedSame) {
    return NBEValidationResultIS_POSSIBLE;
  } else if (comparisionResult == NSOrderedDescending) {
    return NBEValidationResultTOO_SHORT;
  } else if ([possibleLengths.lastObject compare:actualLength] == NSOrderedAscending) {
    return NBEValidationResultTOO_LONG;
  }
  NSArray *possibleLengthsSubarray =
      [possibleLengths subarrayWithRange:NSMakeRange(1, possibleLengths.count - 1)];
  return [possibleLengthsSubarray containsObject:actualLength] ? NBEValidationResultIS_POSSIBLE
                                                               : NBEValidationResultINVALID_LENGTH;
}
- (NBEValidationResult)testNumberLength:(NSString *)number
                                   desc:(NBPhoneNumberDesc *)phoneNumberDesc {
  NSArray *possibleLengths = phoneNumberDesc.possibleLength;
  NSArray *localLengths = phoneNumberDesc.possibleLengthLocalOnly;
  NSUInteger actualLength = number.length;
  if ([localLengths containsObject:@(actualLength)]) {
    return NBEValidationResultIS_POSSIBLE;
  }
  NSNumber *minimumLength = possibleLengths[0];
  if (minimumLength.unsignedIntegerValue == actualLength) {
    return NBEValidationResultIS_POSSIBLE;
  } else if (minimumLength.unsignedIntegerValue > actualLength) {
    return NBEValidationResultTOO_SHORT;
  } else if (possibleLengths.count - 1 < possibleLengths.count) {
    if (((NSNumber *)possibleLengths[possibleLengths.count - 1]).integerValue < actualLength) {
      return NBEValidationResultTOO_LONG;
    }
  }
  return [possibleLengths containsObject:@(actualLength)] ? NBEValidationResultIS_POSSIBLE
                                                          : NBEValidationResultTOO_LONG;
}
- (NBEValidationResult)isPossibleNumberWithReason:(NBPhoneNumber *)number
                                            error:(NSError *__autoreleasing *)error {
  NBEValidationResult res = NBEValidationResultUNKNOWN;
  @try {
    res = [self isPossibleNumberWithReason:number];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NBEValidationResult)isPossibleNumberWithReason:(NBPhoneNumber *)number {
  NSString *nationalNumber = [self getNationalSignificantNumber:number];
  NSNumber *countryCode = number.countryCode;
  if ([self hasValidCountryCallingCode:countryCode] == NO) {
    return NBEValidationResultINVALID_COUNTRY_CODE;
  }
  NSString *regionCode = [self getRegionCodeForCountryCode:countryCode];
  NBPhoneMetaData *metadata =
      [self getMetadataForRegionOrCallingCode:countryCode regionCode:regionCode];
  return [self testNumberLength:nationalNumber desc:metadata.generalDesc];
}
- (BOOL)isPossibleNumberString:(NSString *)number
             regionDialingFrom:(NSString *)regionDialingFrom
                         error:(NSError **)error {
  number = NormalizeNonBreakingSpace(number);
  BOOL res =
      [self isPossibleNumber:[self parse:number defaultRegion:regionDialingFrom error:error]];
  return res;
}
- (BOOL)truncateTooLongNumber:(NBPhoneNumber *)number {
  if ([self isValidNumber:number]) {
    return YES;
  }
  NBPhoneNumber *numberCopy = [number copy];
  NSNumber *nationalNumber = number.nationalNumber;
  do {
    nationalNumber =
        [NSNumber numberWithLongLong:(long long)floor(nationalNumber.unsignedLongLongValue / 10)];
    numberCopy.nationalNumber = [nationalNumber copy];
    if ([nationalNumber isEqualToNumber:@0] ||
        [self isPossibleNumberWithReason:numberCopy] == NBEValidationResultTOO_SHORT) {
      return NO;
    }
  } while ([self isValidNumber:numberCopy] == NO);
  number.nationalNumber = nationalNumber;
  return YES;
}
- (NSNumber *)extractCountryCode:(NSString *)fullNumber nationalNumber:(NSString **)nationalNumber {
  fullNumber = NormalizeNonBreakingSpace(fullNumber);
  if ((fullNumber.length == 0) || ([[fullNumber substringToIndex:1] isEqualToString:@"0"])) {
    return @0;
  }
  NSUInteger numberLength = fullNumber.length;
  NSUInteger maxCountryCode = MAX_LENGTH_COUNTRY_CODE_;
  if ([fullNumber hasPrefix:@"+"]) {
    maxCountryCode = MAX_LENGTH_COUNTRY_CODE_ + 1;
  }
  for (NSUInteger i = 1; i <= maxCountryCode && i <= numberLength; ++i) {
    NSString *subNumber = [fullNumber substringWithRange:NSMakeRange(0, i)];
    NSNumber *potentialCountryCode = [NSNumber numberWithInteger:[subNumber integerValue]];
    NSArray *regionCodes = [NBMetadataHelper regionCodeFromCountryCode:potentialCountryCode];
    if (regionCodes != nil && regionCodes.count > 0) {
      if (nationalNumber != NULL) {
        if ((*nationalNumber) == nil) {
          (*nationalNumber) = [NSString stringWithFormat:@"%@", [fullNumber substringFromIndex:i]];
        } else {
          (*nationalNumber) = [NSString
              stringWithFormat:@"%@%@", (*nationalNumber), [fullNumber substringFromIndex:i]];
        }
      }
      return potentialCountryCode;
    }
  }
  return @0;
}
- (NSArray *)getSupportedRegions {
  NSArray *allKeys = [[NBMetadataHelper CCode2CNMap] allKeys];
  NSPredicate *predicateIsNaN =
      [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return isNan(evaluatedObject);
      }];
  NSArray *supportedRegions = [allKeys filteredArrayUsingPredicate:predicateIsNaN];
  return supportedRegions;
}
- (NSNumber *)maybeExtractCountryCode:(NSString *)number
                             metadata:(NBPhoneMetaData *)defaultRegionMetadata
                       nationalNumber:(NSString **)nationalNumber
                         keepRawInput:(BOOL)keepRawInput
                          phoneNumber:(NBPhoneNumber **)phoneNumber
                                error:(NSError **)error {
  if (nationalNumber == NULL || phoneNumber == NULL || number.length <= 0) {
    return @0;
  }
  NSString *fullNumber = [number copy];
  NSString *possibleCountryIddPrefix = @"";
  if (defaultRegionMetadata != nil) {
    possibleCountryIddPrefix = defaultRegionMetadata.internationalPrefix;
  }
  if (possibleCountryIddPrefix == nil) {
    possibleCountryIddPrefix = @"NonMatch";
  }
  NBECountryCodeSource countryCodeSource =
      [self maybeStripInternationalPrefixAndNormalize:&fullNumber
                                    possibleIddPrefix:possibleCountryIddPrefix];
  if (keepRawInput) {
    (*phoneNumber).countryCodeSource = [NSNumber numberWithInteger:countryCodeSource];
  }
  if (countryCodeSource != NBECountryCodeSourceFROM_DEFAULT_COUNTRY) {
    if (fullNumber.length <= MIN_LENGTH_FOR_NSN_) {
      NSDictionary *userInfo = [NSDictionary
          dictionaryWithObject:[NSString stringWithFormat:@"TOO_SHORT_AFTER_IDD:%@", fullNumber]
                        forKey:NSLocalizedDescriptionKey];
      if (error != NULL) {
        (*error) = [NSError errorWithDomain:@"TOO_SHORT_AFTER_IDD" code:0 userInfo:userInfo];
      }
      return @0;
    }
    NSNumber *potentialCountryCode =
        [self extractCountryCode:fullNumber nationalNumber:nationalNumber];
    if (![potentialCountryCode isEqualToNumber:@0]) {
      (*phoneNumber).countryCode = potentialCountryCode;
      return potentialCountryCode;
    }
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"INVALID_COUNTRY_CODE:%@",
                                                                      potentialCountryCode]
                                    forKey:NSLocalizedDescriptionKey];
    if (error != NULL) {
      (*error) = [NSError errorWithDomain:@"INVALID_COUNTRY_CODE" code:0 userInfo:userInfo];
    }
    return @0;
  } else if (defaultRegionMetadata != nil) {
    NSNumber *defaultCountryCode = defaultRegionMetadata.countryCode;
    NSString *defaultCountryCodeString = [NSString stringWithFormat:@"%@", defaultCountryCode];
    NSString *normalizedNumber = [fullNumber copy];
    if ([normalizedNumber hasPrefix:defaultCountryCodeString]) {
      NSString *potentialNationalNumber =
          [normalizedNumber substringFromIndex:defaultCountryCodeString.length];
      NBPhoneNumberDesc *generalDesc = defaultRegionMetadata.generalDesc;
      NSString *validNumberPattern = generalDesc.nationalNumberPattern;
      [self maybeStripNationalPrefixAndCarrierCode:&potentialNationalNumber
                                          metadata:defaultRegionMetadata
                                       carrierCode:nil];
      NSString *potentialNationalNumberStr = [potentialNationalNumber copy];
      if ((![self matchesEntirely:validNumberPattern string:fullNumber] &&
           [self matchesEntirely:validNumberPattern string:potentialNationalNumberStr]) ||
          [self testNumberLength:fullNumber desc:generalDesc] == NBEValidationResultTOO_LONG) {
        (*nationalNumber) = [(*nationalNumber) stringByAppendingString:potentialNationalNumberStr];
        if (keepRawInput) {
          (*phoneNumber).countryCodeSource =
              [NSNumber numberWithInteger:NBECountryCodeSourceFROM_NUMBER_WITHOUT_PLUS_SIGN];
        }
        (*phoneNumber).countryCode = defaultCountryCode;
        return defaultCountryCode;
      }
    }
  }
  (*phoneNumber).countryCode = @0;
  return @0;
}
- (BOOL)descHasPossibleNumberData:(NBPhoneNumberDesc *)desc {
  return [desc.possibleLength count] != 1 ||
         ![[desc.possibleLength firstObject] isEqualToNumber:@(-1)];
}
- (BOOL)parsePrefixAsIdd:(NSString *)iddPattern sourceString:(NSString **)number {
  if (number == NULL) {
    return NO;
  }
  NSString *numberStr = [(*number)copy];
  if ([self stringPositionByRegex:numberStr regex:iddPattern] == 0) {
    NSTextCheckingResult *matched =
        [[self matchesByRegex:numberStr regex:iddPattern] objectAtIndex:0];
    NSString *matchedString = [numberStr substringWithRange:matched.range];
    NSUInteger matchEnd = matchedString.length;
    NSString *remainString = [numberStr substringFromIndex:matchEnd];
    NSArray *matchedGroups =
        [_CAPTURING_DIGIT_PATTERN matchesInString:remainString
                                          options:0
                                            range:NSMakeRange(0, remainString.length)];
    if (matchedGroups && [matchedGroups count] > 0 && [matchedGroups objectAtIndex:0] != nil) {
      NSString *digitMatched = [remainString
          substringWithRange:((NSTextCheckingResult *)[matchedGroups objectAtIndex:0]).range];
      if (digitMatched.length > 0) {
        NSString *normalizedGroup = [self normalizeDigitsOnly:digitMatched];
        if ([normalizedGroup isEqualToString:@"0"]) {
          return NO;
        }
      }
    }
    (*number) = [remainString copy];
    return YES;
  }
  return NO;
}
- (NBECountryCodeSource)maybeStripInternationalPrefixAndNormalize:(NSString **)numberStr
                                                possibleIddPrefix:(NSString *)possibleIddPrefix {
  if (numberStr == NULL || (*numberStr).length == 0) {
    return NBECountryCodeSourceFROM_DEFAULT_COUNTRY;
  }
  if ([self isStartingStringByRegex:(*numberStr)regex:LEADING_PLUS_CHARS_PATTERN]) {
    (*numberStr) =
        [self replaceStringByRegex:(*numberStr)regex:LEADING_PLUS_CHARS_PATTERN withTemplate:@""];
    (*numberStr) = [self normalize:(*numberStr)];
    return NBECountryCodeSourceFROM_NUMBER_WITH_PLUS_SIGN;
  }
  NSString *iddPattern = [possibleIddPrefix copy];
  [self normalizeSB:numberStr];
  return [self parsePrefixAsIdd:iddPattern sourceString:numberStr]
             ? NBECountryCodeSourceFROM_NUMBER_WITH_IDD
             : NBECountryCodeSourceFROM_DEFAULT_COUNTRY;
}
- (BOOL)maybeStripNationalPrefixAndCarrierCode:(NSString **)number
                                      metadata:(NBPhoneMetaData *)metadata
                                   carrierCode:(NSString **)carrierCode {
  if (number == NULL) {
    return NO;
  }
  NSString *numberStr = [(*number)copy];
  NSUInteger numberLength = numberStr.length;
  NSString *possibleNationalPrefix = metadata.nationalPrefixForParsing;
  if (numberLength == 0 || [NBMetadataHelper hasValue:possibleNationalPrefix] == NO) {
    return NO;
  }
  NSString *prefixPattern = [NSString stringWithFormat:@"^(?:%@)", possibleNationalPrefix];
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self regularExpressionWithPattern:prefixPattern options:0 error:&error];
  NSArray *prefixMatcher =
      [currentPattern matchesInString:numberStr options:0 range:NSMakeRange(0, numberLength)];
  if (prefixMatcher && [prefixMatcher count] > 0) {
    NSString *nationalNumberRule = metadata.generalDesc.nationalNumberPattern;
    NSTextCheckingResult *firstMatch = [prefixMatcher objectAtIndex:0];
    NSString *firstMatchString = [numberStr substringWithRange:firstMatch.range];
    NSUInteger numOfGroups = firstMatch.numberOfRanges - 1;
    NSString *transformRule = metadata.nationalPrefixTransformRule;
    NSString *transformedNumber = @"";
    NSRange firstRange = [firstMatch rangeAtIndex:numOfGroups];
    NSString *firstMatchStringWithGroup =
        (firstRange.location != NSNotFound && firstRange.location < numberStr.length)
            ? [numberStr substringWithRange:firstRange]
            : nil;
    BOOL noTransform = (transformRule == nil || transformRule.length == 0 ||
                        [NBMetadataHelper hasValue:firstMatchStringWithGroup] == NO);
    if (noTransform) {
      transformedNumber = [numberStr substringFromIndex:firstMatchString.length];
    } else {
      transformedNumber =
          [self replaceFirstStringByRegex:numberStr regex:prefixPattern withTemplate:transformRule];
    }
    if ([NBMetadataHelper hasValue:nationalNumberRule] &&
        [self matchesEntirely:nationalNumberRule string:numberStr] &&
        [self matchesEntirely:nationalNumberRule string:transformedNumber] == NO) {
      return NO;
    }
    if ((noTransform && numOfGroups > 0 && [NBMetadataHelper hasValue:firstMatchStringWithGroup]) ||
        (!noTransform && numOfGroups > 1)) {
      if (carrierCode != NULL && (*carrierCode) != nil) {
        (*carrierCode) = [(*carrierCode) stringByAppendingString:firstMatchStringWithGroup];
      }
    } else if ((noTransform && numOfGroups > 0 && [NBMetadataHelper hasValue:firstMatchString]) ||
               (!noTransform && numOfGroups > 1)) {
      if (carrierCode != NULL && (*carrierCode) != nil) {
        (*carrierCode) = [(*carrierCode) stringByAppendingString:firstMatchString];
      }
    }
    (*number) = transformedNumber;
    return YES;
  }
  return NO;
}
- (NSString *)maybeStripExtension:(NSString **)number {
  if (number == NULL) {
    return @"";
  }
  NSString *numberStr = [(*number)copy];
  int mStart = [self stringPositionByRegex:numberStr regex:EXTN_PATTERN];
  if (mStart >= 0 &&
      [self isViablePhoneNumber:[numberStr substringWithRange:NSMakeRange(0, mStart)]]) {
    NSTextCheckingResult *firstMatch = [self matchFirstByRegex:numberStr regex:EXTN_PATTERN];
    NSUInteger matchedGroupsLength = [firstMatch numberOfRanges];
    for (NSUInteger i = 1; i < matchedGroupsLength; i++) {
      NSRange curRange = [firstMatch rangeAtIndex:i];
      if (curRange.location != NSNotFound && curRange.location < numberStr.length) {
        NSString *matchString = [(*number) substringWithRange:curRange];
        NSString *tokenedString = [numberStr substringWithRange:NSMakeRange(0, mStart)];
        (*number) = @"";
        (*number) = [(*number) stringByAppendingString:tokenedString];
        return matchString;
      }
    }
  }
  return @"";
}
- (BOOL)checkRegionForParsing:(NSString *)numberToParse defaultRegion:(NSString *)defaultRegion {
  return [self isValidRegionCode:defaultRegion] ||
         (numberToParse != nil && numberToParse.length > 0 &&
          [self isStartingStringByRegex:numberToParse regex:LEADING_PLUS_CHARS_PATTERN]);
}
- (NBPhoneNumber *)parse:(NSString *)numberToParse
           defaultRegion:(NSString *)defaultRegion
                   error:(NSError **)error {
  NSError *anError = nil;
  NBPhoneNumber *phoneNumber = [self parseHelper:numberToParse
                                   defaultRegion:defaultRegion
                                    keepRawInput:NO
                                     checkRegion:YES
                                           error:&anError];
  if (anError != nil) {
    if (error != NULL) {
      (*error) = [self errorWithObject:anError.description withDomain:anError.domain];
    }
  }
  return phoneNumber;
}
- (NBPhoneNumber *)parseWithPhoneCarrierRegion:(NSString *)numberToParse error:(NSError **)error {
  numberToParse = NormalizeNonBreakingSpace(numberToParse);
  NSString *defaultRegion = nil;
#if TARGET_OS_IOS
  defaultRegion = [self countryCodeByCarrier];
#else
  defaultRegion = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
#endif
  if ([NB_UNKNOWN_REGION isEqualToString:defaultRegion]) {
    NSLocale *currentLocale = [NSLocale currentLocale];
    defaultRegion = [currentLocale objectForKey:NSLocaleCountryCode];
  }
  return [self parse:numberToParse defaultRegion:defaultRegion error:error];
}
#if TARGET_OS_IOS
static CTTelephonyNetworkInfo *_telephonyNetworkInfo;
- (CTTelephonyNetworkInfo *)telephonyNetworkInfo {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
  });
  return _telephonyNetworkInfo;
}
- (NSString *)countryCodeByCarrier {
  NSString *isoCode = [[self.telephonyNetworkInfo subscriberCellularProvider] isoCountryCode];
  if (isoCode.length == 0) {
    isoCode = NB_UNKNOWN_REGION;
  }
  return isoCode;
}
#endif
- (NBPhoneNumber *)parseAndKeepRawInput:(NSString *)numberToParse
                          defaultRegion:(NSString *)defaultRegion
                                  error:(NSError **)error {
  if ([self isValidRegionCode:defaultRegion] == NO) {
    if (numberToParse.length > 0 && [numberToParse hasPrefix:@"+"] == NO) {
      NSDictionary *userInfo = [NSDictionary
          dictionaryWithObject:[NSString stringWithFormat:@"Invalid country code:%@", numberToParse]
                        forKey:NSLocalizedDescriptionKey];
      if (error != NULL) {
        (*error) = [NSError errorWithDomain:@"INVALID_COUNTRY_CODE" code:0 userInfo:userInfo];
      }
    }
  }
  return [self parseHelper:numberToParse
             defaultRegion:defaultRegion
              keepRawInput:YES
               checkRegion:YES
                     error:error];
}
- (void)setItalianLeadingZerosForPhoneNumber:(NSString *)nationalNumber
                                 phoneNumber:(NBPhoneNumber *)phoneNumber {
  if (nationalNumber.length > 1 && [nationalNumber hasPrefix:@"0"]) {
    phoneNumber.italianLeadingZero = YES;
    NSInteger numberOfLeadingZeros = 1;
    while (numberOfLeadingZeros < nationalNumber.length - 1 &&
           [[nationalNumber substringWithRange:NSMakeRange(numberOfLeadingZeros, 1)]
               isEqualToString:@"0"]) {
      numberOfLeadingZeros++;
    }
    if (numberOfLeadingZeros != 1) {
      phoneNumber.numberOfLeadingZeros = @(numberOfLeadingZeros);
    }
  }
}
- (NBPhoneNumber *)parseHelper:(NSString *)numberToParse
                 defaultRegion:(NSString *)defaultRegion
                  keepRawInput:(BOOL)keepRawInput
                   checkRegion:(BOOL)checkRegion
                         error:(NSError **)error {
  numberToParse = NormalizeNonBreakingSpace(numberToParse);
  if (numberToParse == nil) {
    if (error != NULL) {
      (*error) = [self errorWithObject:[NSString stringWithFormat:@"NOT_A_NUMBER:%@", numberToParse]
                            withDomain:@"NOT_A_NUMBER"];
    }
    return nil;
  } else if (numberToParse.length > MAX_INPUT_STRING_LENGTH_) {
    if (error != NULL) {
      (*error) = [self errorWithObject:[NSString stringWithFormat:@"TOO_LONG:%@", numberToParse]
                            withDomain:@"TOO_LONG"];
    }
    return nil;
  }
  NSString *nationalNumber = @"";
  [self buildNationalNumberForParsing:numberToParse nationalNumber:&nationalNumber];
  if ([self isViablePhoneNumber:nationalNumber] == NO) {
    if (error != NULL) {
      (*error) =
          [self errorWithObject:[NSString stringWithFormat:@"NOT_A_NUMBER:%@", nationalNumber]
                     withDomain:@"NOT_A_NUMBER"];
    }
    return nil;
  }
  if (checkRegion &&
      [self checkRegionForParsing:nationalNumber defaultRegion:defaultRegion] == NO) {
    if (error != NULL) {
      (*error) = [self
          errorWithObject:[NSString stringWithFormat:@"INVALID_COUNTRY_CODE:%@", defaultRegion]
               withDomain:@"INVALID_COUNTRY_CODE"];
    }
    return nil;
  }
  NBPhoneNumber *phoneNumber = [[NBPhoneNumber alloc] init];
  if (keepRawInput) {
    phoneNumber.rawInput = [numberToParse copy];
  }
  NSString *extension = [self maybeStripExtension:&nationalNumber];
  if (extension.length > 0) {
    phoneNumber.extension = [extension copy];
  }
  NBPhoneMetaData *regionMetadata = [self.helper getMetadataForRegion:defaultRegion];
  NSString *normalizedNationalNumber = @"";
  NSNumber *countryCode = nil;
  NSString *nationalNumberStr = [nationalNumber copy];
  {
    NSError *anError = nil;
    countryCode = [self maybeExtractCountryCode:nationalNumberStr
                                       metadata:regionMetadata
                                 nationalNumber:&normalizedNationalNumber
                                   keepRawInput:keepRawInput
                                    phoneNumber:&phoneNumber
                                          error:&anError];
    if (anError != nil) {
      if ([anError.domain isEqualToString:@"INVALID_COUNTRY_CODE"] &&
          [self stringPositionByRegex:nationalNumberStr regex:LEADING_PLUS_CHARS_PATTERN] >= 0) {
        NSError *aNestedError = nil;
        nationalNumberStr = [self replaceStringByRegex:nationalNumberStr
                                                 regex:LEADING_PLUS_CHARS_PATTERN
                                          withTemplate:@""];
        countryCode = [self maybeExtractCountryCode:nationalNumberStr
                                           metadata:regionMetadata
                                     nationalNumber:&normalizedNationalNumber
                                       keepRawInput:keepRawInput
                                        phoneNumber:&phoneNumber
                                              error:&aNestedError];
        if ([countryCode isEqualToNumber:@0]) {
          if (error != NULL)
            (*error) = [self errorWithObject:anError.description withDomain:anError.domain];
          return nil;
        }
      } else {
        if (error != NULL)
          (*error) = [self errorWithObject:anError.description withDomain:anError.domain];
        return nil;
      }
    }
  }
  if (![countryCode isEqualToNumber:@0]) {
    NSString *phoneNumberRegion = [self getRegionCodeForCountryCode:countryCode];
    if (phoneNumberRegion != defaultRegion) {
      regionMetadata =
          [self getMetadataForRegionOrCallingCode:countryCode regionCode:phoneNumberRegion];
    }
  } else {
    [self normalizeSB:&nationalNumber];
    normalizedNationalNumber = [normalizedNationalNumber stringByAppendingString:nationalNumber];
    if (defaultRegion != nil) {
      countryCode = regionMetadata.countryCode;
      phoneNumber.countryCode = countryCode;
    } else if (keepRawInput) {
      [phoneNumber clearCountryCodeSource];
    }
  }
  if (normalizedNationalNumber.length < MIN_LENGTH_FOR_NSN_) {
    if (error != NULL) {
      (*error) = [self
          errorWithObject:[NSString stringWithFormat:@"TOO_SHORT_NSN:%@", normalizedNationalNumber]
               withDomain:@"TOO_SHORT_NSN"];
    }
    return nil;
  }
  if (regionMetadata != nil) {
    NSString *carrierCode = @"";
    NSString *potentialNationalNumber = [normalizedNationalNumber copy];
    [self maybeStripNationalPrefixAndCarrierCode:&potentialNationalNumber
                                        metadata:regionMetadata
                                     carrierCode:&carrierCode];
    NBEValidationResult validationResult =
        [self validateNumberLength:potentialNationalNumber metadata:regionMetadata];
    if (validationResult != NBEValidationResultTOO_SHORT &&
        validationResult != NBEValidationResultIS_POSSIBLE_LOCAL_ONLY &&
        validationResult != NBEValidationResultINVALID_LENGTH) {
      normalizedNationalNumber = potentialNationalNumber;
      if (keepRawInput) {
        phoneNumber.preferredDomesticCarrierCode = [carrierCode copy];
      }
    }
  }
  NSString *normalizedNationalNumberStr = [normalizedNationalNumber copy];
  NSUInteger lengthOfNationalNumber = normalizedNationalNumberStr.length;
  if (lengthOfNationalNumber < MIN_LENGTH_FOR_NSN_) {
    if (error != NULL) {
      (*error) = [self
          errorWithObject:[NSString stringWithFormat:@"TOO_SHORT_NSN:%@", normalizedNationalNumber]
               withDomain:@"TOO_SHORT_NSN"];
    }
    return nil;
  }
  if (lengthOfNationalNumber > MAX_LENGTH_FOR_NSN_) {
    if (error != NULL) {
      (*error) =
          [self errorWithObject:[NSString stringWithFormat:@"TOO_LONG:%@", normalizedNationalNumber]
                     withDomain:@"TOO_LONG"];
    }
    return nil;
  }
  [self setItalianLeadingZerosForPhoneNumber:normalizedNationalNumberStr phoneNumber:phoneNumber];
  phoneNumber.nationalNumber =
      [NSNumber numberWithLongLong:[normalizedNationalNumberStr longLongValue]];
  return phoneNumber;
}
- (void)buildNationalNumberForParsing:(NSString *)numberToParse
                       nationalNumber:(NSString **)nationalNumber {
  if (nationalNumber == NULL) return;
  NSMutableString *result = [[NSMutableString alloc] init];
  int indexOfPhoneContext = [self indexOfStringByString:numberToParse target:RFC3966_PHONE_CONTEXT];
  if (indexOfPhoneContext > 0) {
    NSUInteger phoneContextStart = indexOfPhoneContext + RFC3966_PHONE_CONTEXT.length;
    if ([numberToParse characterAtIndex:phoneContextStart] == '+') {
      NSRange foundRange = [numberToParse
          rangeOfString:@";"
                options:NSLiteralSearch
                  range:NSMakeRange(phoneContextStart, numberToParse.length - phoneContextStart)];
      if (foundRange.location != NSNotFound) {
        NSRange subRange = NSMakeRange(phoneContextStart, foundRange.location - phoneContextStart);
        [result appendString:[numberToParse substringWithRange:subRange]];
      } else {
        [result appendString:[numberToParse substringFromIndex:phoneContextStart]];
      }
    }
    NSUInteger rfc3966Start =
        [self indexOfStringByString:numberToParse target:RFC3966_PREFIX] + RFC3966_PREFIX.length;
    NSString *subString = [numberToParse
        substringWithRange:NSMakeRange(rfc3966Start, indexOfPhoneContext - rfc3966Start)];
    [result appendString:subString];
  } else {
    [result appendString:[self extractPossibleNumber:numberToParse]];
  }
  NSString *nationalNumberStr = [result copy];
  int indexOfIsdn = [self indexOfStringByString:nationalNumberStr target:RFC3966_ISDN_SUBADDRESS];
  if (indexOfIsdn > 0) {
    NSRange range = NSMakeRange(0, indexOfIsdn);
    result = [[NSMutableString alloc] initWithString:[nationalNumberStr substringWithRange:range]];
  }
  *nationalNumber = [result copy];
}
- (NBEMatchType)isNumberMatch:(id)firstNumberIn second:(id)secondNumberIn error:(NSError **)error {
  NBEMatchType res = 0;
  @try {
    res = [self isNumberMatch:firstNumberIn second:secondNumberIn];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (NBEMatchType)isNumberMatch:(id)firstNumberIn second:(id)secondNumberIn {
  NBPhoneNumber *firstNumber = nil, *secondNumber = nil;
  if ([firstNumberIn isKindOfClass:[NSString class]]) {
    NSError *anError;
    firstNumber = [self parse:firstNumberIn defaultRegion:NB_UNKNOWN_REGION error:&anError];
    if (anError != nil) {
      if ([anError.domain isEqualToString:@"INVALID_COUNTRY_CODE"] == NO) {
        return NBEMatchTypeNOT_A_NUMBER;
      }
      if ([secondNumberIn isKindOfClass:[NSString class]] == NO) {
        NSString *secondNumberRegion =
            [self getRegionCodeForCountryCode:((NBPhoneNumber *)secondNumberIn).countryCode];
        if (secondNumberRegion != NB_UNKNOWN_REGION) {
          NSError *aNestedError;
          firstNumber =
              [self parse:firstNumberIn defaultRegion:secondNumberRegion error:&aNestedError];
          if (aNestedError != nil) {
            return NBEMatchTypeNOT_A_NUMBER;
          }
          NBEMatchType match = [self isNumberMatch:firstNumber second:secondNumberIn];
          if (match == NBEMatchTypeEXACT_MATCH) {
            return NBEMatchTypeNSN_MATCH;
          }
          return match;
        }
      }
      NSError *aNestedError;
      firstNumber = [self parseHelper:firstNumberIn
                        defaultRegion:nil
                         keepRawInput:NO
                          checkRegion:NO
                                error:&aNestedError];
      if (aNestedError != nil) {
        return NBEMatchTypeNOT_A_NUMBER;
      }
    }
  } else {
    firstNumber = [firstNumberIn copy];
  }
  if ([secondNumberIn isKindOfClass:[NSString class]]) {
    NSError *parseError;
    secondNumber = [self parse:secondNumberIn defaultRegion:NB_UNKNOWN_REGION error:&parseError];
    if (parseError != nil) {
      if ([parseError.domain isEqualToString:@"INVALID_COUNTRY_CODE"] == NO) {
        return NBEMatchTypeNOT_A_NUMBER;
      }
      return [self isNumberMatch:secondNumberIn second:firstNumber];
    } else {
      return [self isNumberMatch:firstNumberIn second:secondNumber];
    }
  } else {
    secondNumber = [secondNumberIn copy];
  }
  firstNumber.rawInput = @"";
  [firstNumber clearCountryCodeSource];
  firstNumber.preferredDomesticCarrierCode = @"";
  secondNumber.rawInput = @"";
  [secondNumber clearCountryCodeSource];
  secondNumber.preferredDomesticCarrierCode = @"";
  if (firstNumber.extension != nil && firstNumber.extension.length == 0) {
    firstNumber.extension = nil;
  }
  if (secondNumber.extension != nil && secondNumber.extension.length == 0) {
    secondNumber.extension = nil;
  }
  if ([NBMetadataHelper hasValue:firstNumber.extension] &&
      [NBMetadataHelper hasValue:secondNumber.extension] &&
      [firstNumber.extension isEqualToString:secondNumber.extension] == NO) {
    return NBEMatchTypeNO_MATCH;
  }
  NSNumber *firstNumberCountryCode = firstNumber.countryCode;
  NSNumber *secondNumberCountryCode = secondNumber.countryCode;
  if (![firstNumberCountryCode isEqualToNumber:@0] &&
      ![secondNumberCountryCode isEqualToNumber:@0]) {
    if ([firstNumber isEqual:secondNumber]) {
      return NBEMatchTypeEXACT_MATCH;
    } else if ([firstNumberCountryCode isEqualToNumber:secondNumberCountryCode] &&
               [self isNationalNumberSuffixOfTheOther:firstNumber second:secondNumber]) {
      return NBEMatchTypeSHORT_NSN_MATCH;
    }
    return NBEMatchTypeNO_MATCH;
  }
  firstNumber.countryCode = @0;
  secondNumber.countryCode = @0;
  if ([firstNumber isEqual:secondNumber]) {
    return NBEMatchTypeNSN_MATCH;
  }
  if ([self isNationalNumberSuffixOfTheOther:firstNumber second:secondNumber]) {
    return NBEMatchTypeSHORT_NSN_MATCH;
  }
  return NBEMatchTypeNO_MATCH;
}
- (BOOL)isNationalNumberSuffixOfTheOther:(NBPhoneNumber *)firstNumber
                                  second:(NBPhoneNumber *)secondNumber {
  NSString *firstNumberNationalNumber =
      [NSString stringWithFormat:@"%@", firstNumber.nationalNumber];
  NSString *secondNumberNationalNumber =
      [NSString stringWithFormat:@"%@", secondNumber.nationalNumber];
  return [firstNumberNationalNumber hasSuffix:secondNumberNationalNumber] ||
         [secondNumberNationalNumber hasSuffix:firstNumberNationalNumber];
}
- (BOOL)canBeInternationallyDialled:(NBPhoneNumber *)number error:(NSError **)error {
  BOOL res = NO;
  @try {
    res = [self canBeInternationallyDialled:number];
  } @catch (NSException *exception) {
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:exception.reason forKey:NSLocalizedDescriptionKey];
    if (error != NULL) (*error) = [NSError errorWithDomain:exception.name code:0 userInfo:userInfo];
  }
  return res;
}
- (BOOL)canBeInternationallyDialled:(NBPhoneNumber *)number {
  NBPhoneMetaData *metadata =
      [self.helper getMetadataForRegion:[self getRegionCodeForNumber:number]];
  if (metadata == nil) {
    return YES;
  }
  NSString *nationalSignificantNumber = [self getNationalSignificantNumber:number];
  return [self isNumberMatchingDesc:nationalSignificantNumber
                         numberDesc:metadata.noInternationalDialling] == NO;
}
- (BOOL)matchesEntirely:(NSString *)regex string:(NSString *)str {
  if ([regex isEqualToString:@"NA"]) {
    return NO;
  }
  NSError *error = nil;
  NSRegularExpression *currentPattern =
      [self entireRegularExpressionWithPattern:regex options:0 error:&error];
  NSRange stringRange = NSMakeRange(0, str.length);
  NSTextCheckingResult *matchResult =
      [currentPattern firstMatchInString:str options:NSMatchingAnchored range:stringRange];
  if (matchResult != nil) {
    BOOL matchIsEntireString = NSEqualRanges(matchResult.range, stringRange);
    if (matchIsEntireString) {
      return YES;
    }
  }
  return NO;
}
@end