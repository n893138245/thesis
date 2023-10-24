#import <Foundation/Foundation.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
NS_ASSUME_NONNULL_BEGIN
extern const char* const kDDASLKeyDDLog;
extern const char* const kDDASLDDLogValue;
API_DEPRECATED("Use DDOSLogger instead", macosx(10.4,10.12), ios(2.0,10.0), watchos(2.0,3.0), tvos(9.0,10.0))
@interface DDASLLogger : DDAbstractLogger <DDLogger>
@property (nonatomic, class, readonly, strong) DDASLLogger *sharedInstance;
@end
NS_ASSUME_NONNULL_END