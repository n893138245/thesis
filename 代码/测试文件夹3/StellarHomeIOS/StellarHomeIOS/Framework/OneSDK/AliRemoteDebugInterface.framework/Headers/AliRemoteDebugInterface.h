#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, AliRemoteDebugLogLevel) {
    AliRemoteDebugLogLevel_Off,
    AliRemoteDebugLogLevel_Error,
    AliRemoteDebugLogLevel_Warn,
    AliRemoteDebugLogLevel_Info,
    AliRemoteDebugLogLevel_Debug
};
@protocol AliRemoteDebugInterface <NSObject>
- (void)debug:(NSString *)message module:(NSString*)module exception:(NSException *)exception;
- (void)info:(NSString *)message module:(NSString*)module exception:(NSException *)exception;
- (void)warn:(NSString *)message module:(NSString*)module exception:(NSException *)exception;
- (void)error:(NSString *)message module:(NSString*)module exception:(NSException *)exception;
- (void)uploadLogFile:(NSDictionary*)extraInfo;
- (AliRemoteDebugLogLevel)currentLogLevel;
@end
#define AliRemoteDebugService getAliRemoteDebugService()
#ifdef __cplusplus
extern "C" {
#endif 
    id<AliRemoteDebugInterface> getAliRemoteDebugService(void);
    void setAliRemoteDebugService(id<AliRemoteDebugInterface>);
#ifdef __cplusplus
}
#endif 