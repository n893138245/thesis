#import <Foundation/Foundation.h>
@class MOBFLogService;
@protocol MOBFLogServiceDelegate <NSObject>
- (BOOL)logService:(MOBFLogService *)logService
     needsSendLogs:(NSArray *)logs;
- (void)logService:(MOBFLogService *)logService
       didSendLogs:(NSArray *)logs
            result:(void (^)(BOOL succeed, NSArray *sentLogs))result;
@end
@interface MOBFLogService : NSObject
@property (nonatomic, weak) id<MOBFLogServiceDelegate> delegate;
@property (nonatomic) NSInteger failRetryMaxCount;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name
                   secretKey:(NSString *)secretKey;
- (void)writeData:(id<NSCoding>)data;
- (void)writeDatas:(NSArray *)data;
- (void)syncWriteData:(id<NSCoding>)data;
- (void)needsSendLog;
- (void)needsSendLogAfterTime:(NSTimeInterval)time;
@end