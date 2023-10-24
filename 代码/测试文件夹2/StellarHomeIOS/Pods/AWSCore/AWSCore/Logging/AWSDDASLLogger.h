#import <Foundation/Foundation.h>
#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
extern const char* const kAWSDDASLKeyAWSDDLog;
extern const char* const kAWSDDASLAWSDDLogValue;
@interface AWSDDASLLogger : AWSDDAbstractLogger <AWSDDLogger>
@property (class, readonly, strong) AWSDDASLLogger *sharedInstance;
@end