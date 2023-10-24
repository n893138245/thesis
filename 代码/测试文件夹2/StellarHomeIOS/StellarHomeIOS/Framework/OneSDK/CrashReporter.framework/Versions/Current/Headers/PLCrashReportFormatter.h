#import <Foundation/Foundation.h>
#import "PLCrashReport.h"
@protocol PLCrashReportFormatter
- (NSData *) formatReport: (PLCrashReport *) report error: (NSError **) outError;
@end