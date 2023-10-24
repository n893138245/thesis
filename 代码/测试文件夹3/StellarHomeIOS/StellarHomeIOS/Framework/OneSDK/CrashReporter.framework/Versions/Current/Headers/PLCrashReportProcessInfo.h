#import <Foundation/Foundation.h>
@interface PLCrashReportProcessInfo : NSObject {
@private
    NSString *_processName;
    NSUInteger _processID;
    NSString* _processPath;
    NSDate *_processStartTime;
    NSString *_parentProcessName;
    NSUInteger _parentProcessID;
    BOOL _native;
}
- (id) initWithProcessName: (NSString *) processName
                 processID: (NSUInteger) processID
               processPath: (NSString *) processPath
          processStartTime: (NSDate *) processStartTime
         parentProcessName: (NSString *) parentProcessName
           parentProcessID: (NSUInteger) parentProcessID
                    native: (BOOL) native;
@property(nonatomic, readonly) NSString *processName;
@property(nonatomic, readonly) NSUInteger processID;
@property(nonatomic, readonly) NSString *processPath;
@property(nonatomic, readonly) NSDate *processStartTime;
@property(nonatomic, readonly) NSString *parentProcessName;
@property(nonatomic, readonly) NSUInteger parentProcessID;
@property(nonatomic, readonly) BOOL native;
@end