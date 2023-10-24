#import "NBAsYouTypeFormatter.h"
#import "NBPhoneNumberDefines.h"
#import "NBMetadataHelper.h"
#import "NBNumberFormat.h"
#import "NBPhoneMetaData.h"
#import "NBPhoneNumberUtil.h"
#import "NSArray+NBAdditions.h"
static NSString *const NBDigitPlaceHolder = @"\u2008";
static NSString *const NBSeparatorBeforeNationalNumber = @" ";
static const NSUInteger NBMinLeadingDigitsLength = 3;
@interface NBAsYouTypeFormatter ()
@property(nonatomic, strong, readwrite) NSString *currentOutput_, *currentFormattingPattern_;
@property(nonatomic, strong, readwrite) NSString *defaultCountry_;
@property(nonatomic, strong, readwrite) NSString *nationalPrefixExtracted_;
@property(nonatomic, strong, readwrite) NSMutableString *formattingTemplate_, *accruedInput_,
    *prefixBeforeNationalNumber_, *accruedInputWithoutFormatting_, *nationalNumber_;
@property(nonatomic, strong, readwrite) NSRegularExpression *DIGIT_PATTERN_,
    *NATIONAL_PREFIX_SEPARATORS_PATTERN_, *CHARACTER_CLASS_PATTERN_, *STANDALONE_DIGIT_PATTERN_;
@property(nonatomic, strong, readwrite) NSRegularExpression *ELIGIBLE_FORMAT_PATTERN_;
@property(nonatomic, assign, readwrite) BOOL ableToFormat_, inputHasFormatting_, isCompleteNumber_,
    isExpectingCountryCallingCode_, shouldAddSpaceAfterNationalPrefix_;
@property(nonatomic, strong, readwrite) NBPhoneNumberUtil *phoneUtil_;
@property(nonatomic, assign, readwrite) NSUInteger lastMatchPosition_, originalPosition_,
    positionToRemember_;
@property(nonatomic, strong, readwrite) NSMutableArray *possibleFormats_;
@property(nonatomic, strong, readwrite) NBPhoneMetaData *currentMetaData_, *defaultMetaData_;
@end
@implementation NBAsYouTypeFormatter
- (instancetype)init {
  self = [super init];
  if (self) {
    _isSuccessfulFormatting = NO;
    self.currentOutput_ = @"";
    self.formattingTemplate_ = [[NSMutableString alloc] init];
    NSError *anError = nil;
    self.DIGIT_PATTERN_ = [NSRegularExpression regularExpressionWithPattern:NBDigitPlaceHolder
                                                                    options:0
                                                                      error:&anError];
    self.NATIONAL_PREFIX_SEPARATORS_PATTERN_ =
        [NSRegularExpression regularExpressionWithPattern:@"[- ]" options:0 error:&anError];
    self.CHARACTER_CLASS_PATTERN_ =
        [NSRegularExpression regularExpressionWithPattern:@"\\[([^\\[\\]])*\\]"
                                                  options:0
                                                    error:&anError];
    self.STANDALONE_DIGIT_PATTERN_ =
        [NSRegularExpression regularExpressionWithPattern:@"\\d(?=[^,}][^,}])"
                                                  options:0
                                                    error:&anError];
    NSString *eligible_format =
        @"^[-x‐-―−ー－-／ ­​⁠　()（）［］.\\[\\]/~⁓∼～]*(\\$\\d[-x‐-―−ー－-／ "
        @"­​⁠　()（）［］.\\[\\]/~⁓∼～]*)+$";
    self.ELIGIBLE_FORMAT_PATTERN_ =
        [NSRegularExpression regularExpressionWithPattern:eligible_format options:0 error:&anError];
    self.currentFormattingPattern_ = @"";
    self.accruedInput_ = [[NSMutableString alloc] init];
    self.accruedInputWithoutFormatting_ = [[NSMutableString alloc] init];
    self.ableToFormat_ = YES;
    self.inputHasFormatting_ = NO;
    self.isCompleteNumber_ = NO;
    self.isExpectingCountryCallingCode_ = NO;
    self.lastMatchPosition_ = 0;
    self.originalPosition_ = 0;
    self.positionToRemember_ = 0;
    self.prefixBeforeNationalNumber_ = [[NSMutableString alloc] init];
    self.shouldAddSpaceAfterNationalPrefix_ = NO;
    self.nationalPrefixExtracted_ = @"";
    self.nationalNumber_ = [[NSMutableString alloc] init];
    self.possibleFormats_ = [[NSMutableArray alloc] init];
  }
  return self;
}
- (instancetype)initWithRegionCode:(NSString *)regionCode {
  return [self initWithRegionCode:regionCode bundle:[NSBundle mainBundle]];
}
- (instancetype)initWithRegionCode:(NSString *)regionCode bundle:(NSBundle *)bundle {
  self = [self init];
  if (self) {
    self.phoneUtil_ = [NBPhoneNumberUtil sharedInstance];
    self.defaultCountry_ = regionCode;
    self.currentMetaData_ = [self getMetadataForRegion_:self.defaultCountry_];
    self.defaultMetaData_ = self.currentMetaData_;
  }
  return self;
}
- (NBPhoneMetaData *)getMetadataForRegion_:(NSString *)regionCode {
  NBMetadataHelper *helper = [[NBMetadataHelper alloc] init];
  NSNumber *countryCallingCode = [self.phoneUtil_ getCountryCodeForRegion:regionCode];
  NSString *mainCountry = [self.phoneUtil_ getRegionCodeForCountryCode:countryCallingCode];
  NBPhoneMetaData *metadata = [helper getMetadataForRegion:mainCountry];
  if (metadata != nil) {
    return metadata;
  }
  return [[NBPhoneMetaData alloc] init];
}
- (BOOL)maybeCreateNewTemplate_ {
  NSUInteger possibleFormatsLength = [self.possibleFormats_ count];
  for (NSUInteger i = 0; i < possibleFormatsLength; ++i) {
    NBNumberFormat *numberFormat =
        [self.possibleFormats_ nb_safeObjectAtIndex:i class:[NBNumberFormat class]];
    NSString *pattern = numberFormat.pattern;
    if (!pattern.length || [self.currentFormattingPattern_ isEqualToString:pattern]) {
      return NO;
    }
    if ([self createFormattingTemplate_:numberFormat]) {
      self.currentFormattingPattern_ = pattern;
      NSRange nationalPrefixRange =
          NSMakeRange(0, [numberFormat.nationalPrefixFormattingRule length]);
      if (nationalPrefixRange.length > 0) {
        NSTextCheckingResult *matchResult = [self.NATIONAL_PREFIX_SEPARATORS_PATTERN_
            firstMatchInString:numberFormat.nationalPrefixFormattingRule
                       options:0
                         range:nationalPrefixRange];
        self.shouldAddSpaceAfterNationalPrefix_ = (matchResult != nil);
      } else {
        self.shouldAddSpaceAfterNationalPrefix_ = NO;
      }
      self.lastMatchPosition_ = 0;
      return YES;
    }
  }
  self.ableToFormat_ = NO;
  return NO;
}
- (void)getAvailableFormats_:(NSString *)leadingDigits {
  BOOL isIntlNumberFormats =
      (self.isCompleteNumber_ && self.currentMetaData_.intlNumberFormats.count > 0);
  NSArray *formatList = isIntlNumberFormats ? self.currentMetaData_.intlNumberFormats
                                            : self.currentMetaData_.numberFormats;
  NSUInteger formatListLength = formatList.count;
  for (NSUInteger i = 0; i < formatListLength; ++i) {
    NBNumberFormat *format = [formatList nb_safeObjectAtIndex:i class:[NBNumberFormat class]];
    BOOL nationalPrefixIsUsedByCountry =
        (self.currentMetaData_.nationalPrefix && self.currentMetaData_.nationalPrefix.length > 0);
    if (!nationalPrefixIsUsedByCountry || self.isCompleteNumber_ ||
        format.nationalPrefixOptionalWhenFormatting ||
        [self.phoneUtil_ formattingRuleHasFirstGroupOnly:format.nationalPrefixFormattingRule]) {
      if ([self isFormatEligible_:format.format]) {
        [self.possibleFormats_ addObject:format];
      }
    }
  }
  [self narrowDownPossibleFormats_:leadingDigits];
}
- (BOOL)isFormatEligible_:(NSString *)format {
  if (!format.length) {
    return NO;
  }
  NSTextCheckingResult *matchResult =
      [self.ELIGIBLE_FORMAT_PATTERN_ firstMatchInString:format
                                                options:0
                                                  range:NSMakeRange(0, [format length])];
  return (matchResult != nil);
}
- (void)narrowDownPossibleFormats_:(NSString *)leadingDigits {
  NSMutableArray *possibleFormats = [[NSMutableArray alloc] init];
  NSUInteger indexOfLeadingDigitsPattern = leadingDigits.length - NBMinLeadingDigitsLength;
  NSUInteger possibleFormatsLength = self.possibleFormats_.count;
  for (NSUInteger i = 0; i < possibleFormatsLength; ++i) {
    NBNumberFormat *format =
        [self.possibleFormats_ nb_safeObjectAtIndex:i class:[NBNumberFormat class]];
    if (format.leadingDigitsPatterns.count == 0) {
      [possibleFormats addObject:format];
      continue;
    }
    NSInteger lastLeadingDigitsPattern =
        MIN(indexOfLeadingDigitsPattern, format.leadingDigitsPatterns.count - 1);
    NSString *leadingDigitsPattern =
        [format.leadingDigitsPatterns nb_safeStringAtIndex:lastLeadingDigitsPattern];
    if ([self.phoneUtil_ stringPositionByRegex:leadingDigits regex:leadingDigitsPattern] == 0) {
      [possibleFormats addObject:format];
    }
  }
  self.possibleFormats_ = possibleFormats;
}
- (BOOL)createFormattingTemplate_:(NBNumberFormat *)format {
  NSString *numberPattern = format.pattern;
  NSRange stringRange = [numberPattern rangeOfString:@"|"];
  if (stringRange.location != NSNotFound) {
    return NO;
  }
  numberPattern = [self.CHARACTER_CLASS_PATTERN_
      stringByReplacingMatchesInString:numberPattern
                               options:0
                                 range:NSMakeRange(0, [numberPattern length])
                          withTemplate:@"\\\\d"];
  numberPattern = [self.STANDALONE_DIGIT_PATTERN_
      stringByReplacingMatchesInString:numberPattern
                               options:0
                                 range:NSMakeRange(0, [numberPattern length])
                          withTemplate:@"\\\\d"];
  [self.formattingTemplate_ setString:@""];
  NSString *tempTemplate = [self getFormattingTemplate_:numberPattern numberFormat:format.format];
  if (tempTemplate.length > 0) {
    [self.formattingTemplate_ appendString:tempTemplate];
    return YES;
  }
  return NO;
}
- (NSString *)getFormattingTemplate_:(NSString *)numberPattern
                        numberFormat:(NSString *)numberFormat {
  NSString *longestPhoneNumber = @"999999999999999";
  NSArray *m = [self.phoneUtil_ matchedStringByRegex:longestPhoneNumber regex:numberPattern];
  NSString *aPhoneNumber = [m nb_safeStringAtIndex:0];
  if (aPhoneNumber.length < self.nationalNumber_.length) {
    return @"";
  }
  NSString *template = [self.phoneUtil_ replaceStringByRegex:aPhoneNumber
                                                       regex:numberPattern
                                                withTemplate:numberFormat];
  template =
      [self.phoneUtil_ replaceStringByRegex:template regex:@"9" withTemplate:NBDigitPlaceHolder];
  return template;
}
- (void)clear {
  self.currentOutput_ = @"";
  [self.accruedInput_ setString:@""];
  [self.accruedInputWithoutFormatting_ setString:@""];
  [self.formattingTemplate_ setString:@""];
  self.lastMatchPosition_ = 0;
  self.currentFormattingPattern_ = @"";
  [self.prefixBeforeNationalNumber_ setString:@""];
  self.nationalPrefixExtracted_ = @"";
  [self.nationalNumber_ setString:@""];
  self.ableToFormat_ = YES;
  self.inputHasFormatting_ = NO;
  self.positionToRemember_ = 0;
  self.originalPosition_ = 0;
  self.isCompleteNumber_ = NO;
  self.isExpectingCountryCallingCode_ = NO;
  [self.possibleFormats_ removeAllObjects];
  self.shouldAddSpaceAfterNationalPrefix_ = NO;
  if (self.currentMetaData_ != self.defaultMetaData_) {
    self.currentMetaData_ = [self getMetadataForRegion_:self.defaultCountry_];
  }
}
- (NSString *)removeLastDigitAndRememberPosition {
  NSString *accruedInputWithoutFormatting = [self.accruedInput_ copy];
  [self clear];
  NSString *result = @"";
  NSUInteger length = accruedInputWithoutFormatting.length;
  if (length == 0) {
    return result;
  }
  for (NSUInteger i = 0; i < length - 1; i++) {
    NSString *ch = [accruedInputWithoutFormatting substringWithRange:NSMakeRange(i, 1)];
    result = [self inputDigitAndRememberPosition:ch];
  }
  return result;
}
- (NSString *)removeLastDigit {
  NSString *accruedInputWithoutFormatting = [self.accruedInput_ copy];
  [self clear];
  NSString *result = @"";
  NSUInteger length = accruedInputWithoutFormatting.length;
  if (length == 0) {
    return result;
  }
  for (NSUInteger i = 0; i < length - 1; i++) {
    NSString *ch = [accruedInputWithoutFormatting substringWithRange:NSMakeRange(i, 1)];
    result = [self inputDigit:ch];
  }
  return result;
}
- (NSString *)inputStringAndRememberPosition:(NSString *)string {
  [self clear];
  NSString *result = @"";
  NSUInteger length = string.length;
  for (NSUInteger i = 0; i < length; i++) {
    NSString *ch = [string substringWithRange:NSMakeRange(i, 1)];
    result = [self inputDigitAndRememberPosition:ch];
  }
  return result;
}
- (NSString *)inputString:(NSString *)string {
  [self clear];
  NSString *result = @"";
  NSUInteger length = string.length;
  for (NSUInteger i = 0; i < length; i++) {
    NSString *ch = [string substringWithRange:NSMakeRange(i, 1)];
    result = [self inputDigit:ch];
  }
  return result;
}
- (NSString *)inputDigit:(NSString *)nextChar {
  if (!nextChar || nextChar.length <= 0) {
    return self.currentOutput_;
  }
  self.currentOutput_ = [self inputDigitWithOptionToRememberPosition_:nextChar rememberPosition:NO];
  return self.currentOutput_;
}
- (NSString *)inputDigitAndRememberPosition:(NSString *)nextChar {
  if (!nextChar || nextChar.length <= 0) {
    return self.currentOutput_;
  }
  self.currentOutput_ =
      [self inputDigitWithOptionToRememberPosition_:nextChar rememberPosition:YES];
  return self.currentOutput_;
}
- (NSString *)inputDigitWithOptionToRememberPosition_:(NSString *)nextChar
                                     rememberPosition:(BOOL)rememberPosition {
  if (!nextChar || nextChar.length <= 0) {
    _isSuccessfulFormatting = NO;
    return self.currentOutput_;
  }
  [self.accruedInput_ appendString:nextChar];
  if (rememberPosition) {
    self.originalPosition_ = self.accruedInput_.length;
  }
  if (![self isDigitOrLeadingPlusSign_:nextChar]) {
    self.ableToFormat_ = NO;
    self.inputHasFormatting_ = YES;
  } else {
    nextChar =
        [self normalizeAndAccrueDigitsAndPlusSign_:nextChar rememberPosition:rememberPosition];
  }
  if (!self.ableToFormat_) {
    if (self.inputHasFormatting_) {
      _isSuccessfulFormatting = YES;
      return [NSString stringWithString:self.accruedInput_];
    } else if ([self attemptToExtractIdd_]) {
      if ([self attemptToExtractCountryCallingCode_]) {
        _isSuccessfulFormatting = YES;
        return [self attemptToChoosePatternWithPrefixExtracted_];
      }
    } else if ([self ableToExtractLongerNdd_]) {
      [self.prefixBeforeNationalNumber_ appendString:NBSeparatorBeforeNationalNumber];
      _isSuccessfulFormatting = YES;
      return [self attemptToChoosePatternWithPrefixExtracted_];
    }
    _isSuccessfulFormatting = NO;
    return self.accruedInput_;
  }
  switch (self.accruedInputWithoutFormatting_.length) {
    case 0:
    case 1:
    case 2:
      _isSuccessfulFormatting = YES;
      return self.accruedInput_;
    case 3:
      if ([self attemptToExtractIdd_]) {
        self.isExpectingCountryCallingCode_ = YES;
      } else {
        self.nationalPrefixExtracted_ = [self removeNationalPrefixFromNationalNumber_];
        _isSuccessfulFormatting = YES;
        return [self attemptToChooseFormattingPattern_];
      }
    default:
      if (self.isExpectingCountryCallingCode_) {
        if ([self attemptToExtractCountryCallingCode_]) {
          self.isExpectingCountryCallingCode_ = NO;
        }
        _isSuccessfulFormatting = YES;
        return [NSString
            stringWithFormat:@"%@%@", self.prefixBeforeNationalNumber_, self.nationalNumber_];
      }
      if (self.possibleFormats_.count > 0) {
        NSString *tempNationalNumber = [self inputDigitHelper_:nextChar];
        NSString *formattedNumber = [self attemptToFormatAccruedDigits_];
        if (formattedNumber.length > 0) {
          _isSuccessfulFormatting = YES;
          return formattedNumber;
        }
        [self narrowDownPossibleFormats_:self.nationalNumber_];
        if ([self maybeCreateNewTemplate_]) {
          _isSuccessfulFormatting = YES;
          return [self inputAccruedNationalNumber_];
        }
        if (self.ableToFormat_) {
          _isSuccessfulFormatting = YES;
          return [self appendNationalNumber_:tempNationalNumber];
        } else {
          _isSuccessfulFormatting = NO;
          return self.accruedInput_;
        }
      } else {
        _isSuccessfulFormatting = NO;
        return [self attemptToChooseFormattingPattern_];
      }
  }
  _isSuccessfulFormatting = NO;
}
- (NSString *)attemptToChoosePatternWithPrefixExtracted_ {
  self.ableToFormat_ = YES;
  self.isExpectingCountryCallingCode_ = NO;
  [self.possibleFormats_ removeAllObjects];
  return [self attemptToChooseFormattingPattern_];
}
- (BOOL)ableToExtractLongerNdd_ {
  if (self.nationalPrefixExtracted_.length > 0) {
    NSString *nationalNumberStr = [NSString stringWithString:self.nationalNumber_];
    self.nationalNumber_ = [self.nationalPrefixExtracted_ mutableCopy];
    [self.nationalNumber_ appendString:nationalNumberStr];
    NSString *prefixBeforeNationalNumberStr = [self.prefixBeforeNationalNumber_ copy];
    NSRange lastRange = [prefixBeforeNationalNumberStr rangeOfString:self.nationalPrefixExtracted_
                                                             options:NSBackwardsSearch];
    NSUInteger indexOfPreviousNdd = lastRange.location;
    self.prefixBeforeNationalNumber_ = [[prefixBeforeNationalNumberStr
        substringWithRange:NSMakeRange(0, indexOfPreviousNdd)] mutableCopy];
  }
  return self.nationalPrefixExtracted_ != [self removeNationalPrefixFromNationalNumber_];
}
- (BOOL)isDigitOrLeadingPlusSign_:(NSString *)nextChar {
  NSString *digitPattern = [NSString stringWithFormat:@"([%@])", NB_VALID_DIGITS_STRING];
  NSString *plusPattern = [NSString stringWithFormat:@"[%@]+", NB_PLUS_CHARS];
  BOOL isDigitPattern = [[self.phoneUtil_ matchesByRegex:nextChar regex:digitPattern] count] > 0;
  BOOL isPlusPattern = [[self.phoneUtil_ matchesByRegex:nextChar regex:plusPattern] count] > 0;
  return isDigitPattern || (self.accruedInput_.length == 1 && isPlusPattern);
}
- (NSString *)attemptToFormatAccruedDigits_ {
  NSString *nationalNumber = [NSString stringWithString:self.nationalNumber_];
  NSUInteger possibleFormatsLength = self.possibleFormats_.count;
  for (NSUInteger i = 0; i < possibleFormatsLength; ++i) {
    NBNumberFormat *numberFormat = self.possibleFormats_[i];
    NSString *pattern = numberFormat.pattern;
    NSString *patternRegExp = [NSString stringWithFormat:@"^(?:%@)$", pattern];
    BOOL isPatternRegExp =
        [[self.phoneUtil_ matchesByRegex:nationalNumber regex:patternRegExp] count] > 0;
    if (isPatternRegExp) {
      if (numberFormat.nationalPrefixFormattingRule.length > 0) {
        NSArray *matches = [self.NATIONAL_PREFIX_SEPARATORS_PATTERN_
            matchesInString:numberFormat.nationalPrefixFormattingRule
                    options:0
                      range:NSMakeRange(0, numberFormat.nationalPrefixFormattingRule.length)];
        self.shouldAddSpaceAfterNationalPrefix_ = [matches count] > 0;
      } else {
        self.shouldAddSpaceAfterNationalPrefix_ = NO;
      }
      NSString *formattedNumber = [self.phoneUtil_ replaceStringByRegex:nationalNumber
                                                                  regex:pattern
                                                           withTemplate:numberFormat.format];
      return [self appendNationalNumber_:formattedNumber];
    }
  }
  return @"";
}
- (NSString *)appendNationalNumber_:(NSString *)nationalNumber {
  NSUInteger prefixBeforeNationalNumberLength = self.prefixBeforeNationalNumber_.length;
  unichar blank_char = [NBSeparatorBeforeNationalNumber characterAtIndex:0];
  if (self.shouldAddSpaceAfterNationalPrefix_ && prefixBeforeNationalNumberLength > 0 &&
      [self.prefixBeforeNationalNumber_ characterAtIndex:prefixBeforeNationalNumberLength - 1] !=
          blank_char) {
    return [NSString stringWithFormat:@"%@%@%@", self.prefixBeforeNationalNumber_,
                                      NBSeparatorBeforeNationalNumber, nationalNumber];
  } else {
    return [NSString stringWithFormat:@"%@%@", self.prefixBeforeNationalNumber_, nationalNumber];
  }
}
- (NSInteger)getRememberedPosition {
  if (!self.ableToFormat_) {
    return self.originalPosition_;
  }
  NSInteger accruedInputIndex = 0;
  NSInteger currentOutputIndex = 0;
  NSString *accruedInputWithoutFormatting = self.accruedInputWithoutFormatting_;
  NSString *currentOutput = self.currentOutput_;
  while (accruedInputIndex < self.positionToRemember_ &&
         currentOutputIndex < currentOutput.length) {
    if ([accruedInputWithoutFormatting characterAtIndex:accruedInputIndex] ==
        [currentOutput characterAtIndex:currentOutputIndex]) {
      accruedInputIndex++;
    }
    currentOutputIndex++;
  }
  return currentOutputIndex;
}
- (NSString *)attemptToChooseFormattingPattern_ {
  NSString *nationalNumber = [self.nationalNumber_ copy];
  if (nationalNumber.length >= NBMinLeadingDigitsLength) {
    [self getAvailableFormats_:nationalNumber];
    NSString *formattedNumber = [self attemptToFormatAccruedDigits_];
    if (formattedNumber.length > 0) {
      return formattedNumber;
    }
    return [self maybeCreateNewTemplate_] ? [self inputAccruedNationalNumber_] : self.accruedInput_;
  } else {
    return [self appendNationalNumber_:nationalNumber];
  }
}
- (NSString *)inputAccruedNationalNumber_ {
  NSString *nationalNumber = [self.nationalNumber_ copy];
  NSUInteger lengthOfNationalNumber = nationalNumber.length;
  if (lengthOfNationalNumber > 0) {
    NSString *tempNationalNumber = @"";
    for (NSUInteger i = 0; i < lengthOfNationalNumber; i++) {
      tempNationalNumber = [self
          inputDigitHelper_:[NSString stringWithFormat:@"%C", [nationalNumber characterAtIndex:i]]];
    }
    return self.ableToFormat_ ? [self appendNationalNumber_:tempNationalNumber]
                              : self.accruedInput_;
  } else {
    return self.prefixBeforeNationalNumber_;
  }
}
- (BOOL)isNanpaNumberWithNationalPrefix_ {
  if (![self.currentMetaData_.countryCode isEqual:@1]) {
    return NO;
  }
  NSString *nationalNumber = [self.nationalNumber_ copy];
  return ([nationalNumber characterAtIndex:0] == '1') &&
         ([nationalNumber characterAtIndex:1] != '0') &&
         ([nationalNumber characterAtIndex:1] != '1');
}
- (NSString *)removeNationalPrefixFromNationalNumber_ {
  NSString *nationalNumber = [self.nationalNumber_ copy];
  NSUInteger startOfNationalNumber = 0;
  if ([self isNanpaNumberWithNationalPrefix_]) {
    startOfNationalNumber = 1;
    [self.prefixBeforeNationalNumber_ appendFormat:@"1%@", NBSeparatorBeforeNationalNumber];
    self.isCompleteNumber_ = YES;
  } else if (self.currentMetaData_.nationalPrefixForParsing != nil &&
             self.currentMetaData_.nationalPrefixForParsing.length > 0) {
    NSString *nationalPrefixForParsing =
        [NSString stringWithFormat:@"^(?:%@)", self.currentMetaData_.nationalPrefixForParsing];
    NSArray *m =
        [self.phoneUtil_ matchedStringByRegex:nationalNumber regex:nationalPrefixForParsing];
    NSString *firstString = [m nb_safeStringAtIndex:0];
    if (m != nil && firstString != nil && firstString.length > 0) {
      self.isCompleteNumber_ = YES;
      startOfNationalNumber = firstString.length;
      [self.prefixBeforeNationalNumber_
          appendString:[nationalNumber substringWithRange:NSMakeRange(0, startOfNationalNumber)]];
    }
  }
  self.nationalNumber_ = [[nationalNumber substringFromIndex:startOfNationalNumber] mutableCopy];
  return [nationalNumber substringWithRange:NSMakeRange(0, startOfNationalNumber)];
}
- (BOOL)attemptToExtractIdd_ {
  NSString *accruedInputWithoutFormatting = [self.accruedInputWithoutFormatting_ copy];
  NSString *internationalPrefix =
      [NSString stringWithFormat:@"^(?:\\+|%@)", self.currentMetaData_.internationalPrefix];
  NSArray *m = [self.phoneUtil_ matchedStringByRegex:accruedInputWithoutFormatting
                                               regex:internationalPrefix];
  NSString *firstString = [m nb_safeStringAtIndex:0];
  if (m != nil && firstString != nil && firstString.length > 0) {
    self.isCompleteNumber_ = YES;
    NSUInteger startOfCountryCallingCode = firstString.length;
    self.nationalNumber_ =
        [[accruedInputWithoutFormatting substringFromIndex:startOfCountryCallingCode] mutableCopy];
    self.prefixBeforeNationalNumber_ = [[accruedInputWithoutFormatting
        substringWithRange:NSMakeRange(0, startOfCountryCallingCode)] mutableCopy];
    if ([accruedInputWithoutFormatting characterAtIndex:0] != '+') {
      [self.prefixBeforeNationalNumber_ appendString:NBSeparatorBeforeNationalNumber];
    }
    return YES;
  }
  return NO;
}
- (BOOL)attemptToExtractCountryCallingCode_ {
  if (self.nationalNumber_.length == 0) {
    return NO;
  }
  NSString *numberWithoutCountryCallingCode = @"";
  NSNumber *countryCode = [self.phoneUtil_ extractCountryCode:self.nationalNumber_
                                               nationalNumber:&numberWithoutCountryCallingCode];
  if ([countryCode isEqualToNumber:@0]) {
    return NO;
  }
  self.nationalNumber_ = [numberWithoutCountryCallingCode mutableCopy];
  NSString *newRegionCode = [self.phoneUtil_ getRegionCodeForCountryCode:countryCode];
  if ([NB_REGION_CODE_FOR_NON_GEO_ENTITY isEqualToString:newRegionCode]) {
    NBMetadataHelper *helper = [[NBMetadataHelper alloc] init];
    self.currentMetaData_ = [helper getMetadataForNonGeographicalRegion:countryCode];
  } else if (newRegionCode != self.defaultCountry_) {
    self.currentMetaData_ = [self getMetadataForRegion_:newRegionCode];
  }
  [self.prefixBeforeNationalNumber_
      appendFormat:@"%@%@", countryCode, NBSeparatorBeforeNationalNumber];
  return YES;
}
- (NSString *)normalizeAndAccrueDigitsAndPlusSign_:(NSString *)nextChar
                                  rememberPosition:(BOOL)rememberPosition {
  NSString *normalizedChar;
  if ([nextChar isEqualToString:@"+"]) {
    normalizedChar = nextChar;
    [self.accruedInputWithoutFormatting_ appendString:nextChar];
  } else {
    normalizedChar = [[self.phoneUtil_ DIGIT_MAPPINGS] objectForKey:nextChar];
    if (!normalizedChar) return @"";
    [self.accruedInputWithoutFormatting_ appendString:normalizedChar];
    [self.nationalNumber_ appendString:normalizedChar];
  }
  if (rememberPosition) {
    self.positionToRemember_ = self.accruedInputWithoutFormatting_.length;
  }
  return normalizedChar;
}
- (NSString *)inputDigitHelper_:(NSString *)nextChar {
  NSString *formattingTemplate = [self.formattingTemplate_ copy];
  NSString *subedString = @"";
  if (formattingTemplate.length > self.lastMatchPosition_) {
    subedString = [formattingTemplate substringFromIndex:self.lastMatchPosition_];
  }
  if ([self.phoneUtil_ stringPositionByRegex:subedString regex:NBDigitPlaceHolder] >= 0) {
    int digitPatternStart =
        [self.phoneUtil_ stringPositionByRegex:formattingTemplate regex:NBDigitPlaceHolder];
    NSRange tempRange = [formattingTemplate rangeOfString:NBDigitPlaceHolder];
    NSString *tempTemplate =
        [formattingTemplate stringByReplacingOccurrencesOfString:NBDigitPlaceHolder
                                                      withString:nextChar
                                                         options:NSLiteralSearch
                                                           range:tempRange];
    self.formattingTemplate_ = [tempTemplate mutableCopy];
    self.lastMatchPosition_ = digitPatternStart;
    return [tempTemplate substringWithRange:NSMakeRange(0, self.lastMatchPosition_ + 1)];
  } else {
    if (self.possibleFormats_.count == 1) {
      self.ableToFormat_ = NO;
    }  
    self.currentFormattingPattern_ = @"";
    return self.accruedInput_;
  }
}
- (NSString *)description {
  return self.currentOutput_;
}
@end