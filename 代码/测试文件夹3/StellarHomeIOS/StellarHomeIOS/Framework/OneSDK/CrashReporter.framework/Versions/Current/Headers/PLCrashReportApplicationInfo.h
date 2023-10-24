#import <Foundation/Foundation.h>
@interface PLCrashReportApplicationInfo : NSObject {
@private
    NSString *_applicationIdentifier;
    NSString *_applicationVersion;
    NSString *_applicationMarketingVersion;
}
- (id) initWithApplicationIdentifier: (NSString *) applicationIdentifier 
                  applicationVersion: (NSString *) applicationVersion
         applicationMarketingVersion: (NSString *) applicationMarketingVersion;
@property(nonatomic, readonly) NSString *applicationIdentifier;
@property(nonatomic, readonly) NSString *applicationVersion;
@property(nonatomic, readonly) NSString *applicationMarketingVersion;
@end