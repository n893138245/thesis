#import <Foundation/Foundation.h>
#import "Struct.h"
#import "Type.h"
namespace FB { namespace RetainCycleDetector { namespace Parser {
  Struct parseStructEncoding(const std::string &structEncodingString);
  Struct parseStructEncodingWithName(const std::string &structEncodingString,
                                     const std::string &structName);
} } }