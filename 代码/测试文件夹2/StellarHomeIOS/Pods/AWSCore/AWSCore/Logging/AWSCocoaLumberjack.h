#import <Foundation/Foundation.h>
#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
#import "AWSDDLogMacros.h"
#import "AWSDDAssertMacros.h"
#import "AWSDDASLLogCapture.h"
#import "AWSDDTTYLogger.h"
#import "AWSDDASLLogger.h"
#import "AWSDDFileLogger.h"
#import "AWSDDOSLogger.h"
#if __has_include("CLIColor.h") && TARGET_OS_OSX
#import "CLIColor.h"
#endif