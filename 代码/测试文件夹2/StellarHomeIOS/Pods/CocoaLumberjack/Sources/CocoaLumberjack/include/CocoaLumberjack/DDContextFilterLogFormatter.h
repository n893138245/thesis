#import <Foundation/Foundation.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
NS_ASSUME_NONNULL_BEGIN
@interface DDContextAllowlistFilterLogFormatter : NSObject <DDLogFormatter>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)addToAllowlist:(NSInteger)loggingContext;
- (void)removeFromAllowlist:(NSInteger)loggingContext;
@property (nonatomic, readonly, copy) NSArray<NSNumber *> *allowlist;
- (BOOL)isOnAllowlist:(NSInteger)loggingContext;
@end
@interface DDContextDenylistFilterLogFormatter : NSObject <DDLogFormatter>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)addToDenylist:(NSInteger)loggingContext;
- (void)removeFromDenylist:(NSInteger)loggingContext;
@property (readonly, copy) NSArray<NSNumber *> *denylist;
- (BOOL)isOnDenylist:(NSInteger)loggingContext;
@end
NS_ASSUME_NONNULL_END