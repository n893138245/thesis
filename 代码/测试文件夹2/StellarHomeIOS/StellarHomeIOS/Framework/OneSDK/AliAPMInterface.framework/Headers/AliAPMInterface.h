#import <Foundation/Foundation.h>
@protocol ProcedureTrackInteface <NSObject>
- (void)onDataContextBegin;
- (void)onDataContextEnd;
- (void)onProcedureBegin:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties uuid:(NSString*)uuid;
- (void)onProcedureEvent:(NSString*)procedureName event:(NSString*)event uuid:(NSString*)uuid;
- (void)onProcedureStage:(NSString*)procedureName stage:(NSString*)stage uuid:(NSString*)uuid;
- (void)onProcedureFailure:(NSString*)procedureName errorInfo:(NSDictionary<NSString*, NSString*>*)errorInfo uuid:(NSString*)uuid;
- (void)onProcedureSuccess:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties uuid:(NSString*)uuid;
- (void)onProcedurePause:(NSString*)procedureName uuid:(NSString*)uuid;
- (void)onProcedureResume:(NSString*)procedureName uuid:(NSString*)uuid;
- (void)addProcedureProperties:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties uuid:(NSString*)uuid;
- (void)addProcedureStatistic:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties uuid:(NSString*)uuid;
# pragma procedure with timestamp
- (void)onProcedureBegin:(NSString*)procedureName properties:(NSDictionary*)properties uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
- (void)onProcedureEvent:(NSString*)procedureName event:(NSString*)event uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
- (void)onProcedureStage:(NSString*)procedureName stage:(NSString*)stage uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
- (void)onProcedureFailure:(NSString*)procedureName errorInfo:(NSDictionary<NSString*, NSString*>*)errorInfo uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
- (void)onProcedureSuccess:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
- (void)onProcedurePause:(NSString*)procedureName uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
- (void)onProcedureResume:(NSString*)procedureName uuid:(NSString*)uuid timestamp:(NSTimeInterval)timestamp;
#pragma sub-procedures
- (void)onSubProcedureBegin:(NSString*)procedureName parentPrecedureName:(NSString*)parentPrecedureName parentUuid:(NSString*)parentUuid;
- (void)onSubProcedureFailure:(NSString*)procedureName parentPrecedureName:(NSString*)parentPrecedureName parentUuid:(NSString*)parentUuid;
- (void)onSubProcedureSuccess:(NSString*)procedureName parentPrecedureName:(NSString*)parentPrecedureName parentUuid:(NSString*)parentUuid;
- (void)onSubProcedureBegin:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties parentPrecedureName:(NSString*)parentPrecedureName parentUuid:(NSString*)parentUuid;
- (void)onSubProcedureFailure:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties parentPrecedureName:(NSString*)parentPrecedureName parentUuid:(NSString*)parentUuid;
- (void)onSubProcedureSuccess:(NSString*)procedureName properties:(NSDictionary<NSString*, NSString*>*)properties parentPrecedureName:(NSString*)parentPrecedureName parentUuid:(NSString*)parentUuid;
#pragma full-trace events
- (void)onFullTraceEvent:(NSString*)eventName extraDescription:(NSString*)extraDescription;
- (void)onFullTraceEvent:(NSString*)eventName extraDescription:(NSString*)extraDescription timestamp:(NSTimeInterval)timestamp;
@end
#ifdef __cplusplus
extern "C" {
#endif 
    id<ProcedureTrackInteface> getProcedureTrackService(void);
    void setProcedureTrackService(id<ProcedureTrackInteface> service);
#ifdef __cplusplus
}
#endif 