#import <Foundation/Foundation.h>
@protocol AliHADataHubSubscriber <NSObject>
- (void)handleBizData:(NSString*)bizId data:(NSDictionary*)data;
- (void)handleABTestData:(NSString*)bizId data:(NSDictionary*)data;
- (void)handleCurrentBiz:(NSString*)currentBiz;
- (void)onBizDataReadyStage;
- (void)handleStage:(NSString*)bizId stage:(NSString*)stage;
- (void)handleStage:(NSString *)bizId stage:(NSString *)stage timestamp:(NSTimeInterval)timestamp;
@end
@interface AliHADataHub : NSObject
+ (void)initWithDataHandler:(id<AliHADataHubSubscriber>)dataHandler;
#pragma biz messages
+ (void)setCurrentBiz:(NSString*)bizId;
+ (void)setCurrentBiz:(NSString*)bizId subBiz:(NSString*)subBizId;
+ (void)publish:(NSString*)bizId properties:(NSDictionary<NSString*, NSString*>*)properties;
+ (void)publishABTest:(NSString*)bizId properties:(NSDictionary<NSString*, NSString*>*)properties;
+ (void)onBizDataReadyStage;
+ (void)onStage:(NSString*)bizId stage:(NSString*)stage;
+ (void)onStage:(NSString*)bizId stage:(NSString*)stage timestamp:(NSTimeInterval)timestamp;
@end