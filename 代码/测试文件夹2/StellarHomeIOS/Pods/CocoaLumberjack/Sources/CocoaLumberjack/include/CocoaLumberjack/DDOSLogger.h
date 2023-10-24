#import <Foundation/Foundation.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
@interface DDOSLogger : DDAbstractLogger <DDLogger>
@property (nonatomic, class, readonly, strong) DDOSLogger *sharedInstance;
- (instancetype)initWithSubsystem:(nullable NSString *)subsystem category:(nullable NSString *)category NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END