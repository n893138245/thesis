#import <Foundation/Foundation.h>
#import "PLCrashReportFormatter.h"
typedef enum {
    PLCrashReportTextFormatiOS = 0
} PLCrashReportTextFormat;
@interface PLCrashReportTextFormatter : NSObject <PLCrashReportFormatter> {
@private
    PLCrashReportTextFormat _textFormat;
    NSStringEncoding _stringEncoding;
}
+ (NSString *) stringValueForCrashReport: (PLCrashReport *) report withTextFormat: (PLCrashReportTextFormat) textFormat;
- (id) initWithTextFormat: (PLCrashReportTextFormat) textFormat stringEncoding: (NSStringEncoding) stringEncoding;
@end