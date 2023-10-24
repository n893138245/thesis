//
//  NSData+Conversion.m
//  smartlight-ios
//
//  Created by qingpei on 12/31/14.
//  Copyright (c) 2014 edwardtoday. All rights reserved.
//

#import "NSData+Conversion.h"

@implementation NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString {
  /* Returns hexadecimal string of NSData. Empty string if data is empty.   */

  const unsigned char *dataBuffer = (const unsigned char *)[self bytes];

  if (!dataBuffer)
    return [NSString string];

  NSUInteger dataLength = [self length];
  NSMutableString *hexString =
      [NSMutableString stringWithCapacity:(dataLength * 2)];

  for (NSUInteger i = 0; i < dataLength; ++i)
    [hexString
        appendString:[NSString stringWithFormat:@"%02lx",
                                                (unsigned long)dataBuffer[i]]];

  return [NSString stringWithString:hexString];
}

+ (NSData *)dataFromHexString:(NSString *)string {
  NSCharacterSet *nonHex = [[NSCharacterSet
      characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"]
      invertedSet];
  NSRange nonHexRange = [string rangeOfCharacterFromSet:nonHex];
  BOOL isHex = (nonHexRange.location == NSNotFound);
  if (!isHex) {
    NSLog(@"Invalid hex string: %@", string);
    return nil;
  }

  string = [string lowercaseString];
  NSMutableData *data = [NSMutableData new];
  unsigned char whole_byte;
  char byte_chars[3] = {'\0', '\0', '\0'};
  unsigned long i = 0;
  unsigned long length = [string length];
  while (i < length - 1) {
    char c = (char)[string characterAtIndex:i++];
    if (c < '0' || (c > '9' && c < 'a') || c > 'f')
      continue;
    byte_chars[0] = c;
    byte_chars[1] = (char)[string characterAtIndex:i++];
    whole_byte = (unsigned char)strtol(byte_chars, NULL, 16);
    [data appendBytes:&whole_byte length:1];
  }
  return data;
}

@end
