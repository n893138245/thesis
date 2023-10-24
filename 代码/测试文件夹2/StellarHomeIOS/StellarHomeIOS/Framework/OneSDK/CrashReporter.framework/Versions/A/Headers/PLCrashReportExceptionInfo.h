#import <Foundation/Foundation.h>
#import "PLCrashReportThreadInfo.h"
@interface PLCrashReportExceptionInfo : NSObject {
@private
    NSString *_name;
    NSString *_reason;
    NSArray *_stackFrames;
}
- (id) initWithExceptionName: (NSString *) name reason: (NSString *) reason;
- (id) initWithExceptionName: (NSString *) name 
                      reason: (NSString *) reason
                 stackFrames: (NSArray *) stackFrames;
@property(nonatomic, readonly) NSString *exceptionName;
@property(nonatomic, readonly) NSString *exceptionReason;
@property(nonatomic, readonly) NSArray *stackFrames;
@end