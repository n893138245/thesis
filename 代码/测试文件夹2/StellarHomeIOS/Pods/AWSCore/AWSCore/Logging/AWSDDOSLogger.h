#import <Foundation/Foundation.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
API_AVAILABLE(ios(10.0), macos(10.12), tvos(10.0), watchos(3.0))
@interface AWSDDOSLogger : AWSDDAbstractLogger <AWSDDLogger>
@property (class, readonly, strong) AWSDDOSLogger *sharedInstance;
@end