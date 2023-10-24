#import <Foundation/Foundation.h>
typedef NSDictionary* (^AliAdditionalCrashInfoHandler)(void);
@interface AliCrashRecord : NSObject
@property (nonatomic, assign) NSTimeInterval timestamp;         
@property (nonatomic, copy) NSString* page;
@end
@protocol AliCrashReporterInterface <NSObject>
- (void)appendAdditionalInformation:(AliAdditionalCrashInfoHandler)handler;
- (NSArray<AliCrashRecord*>*)getHistoryCrashRecords;
@end
#define AliCrashReporterService getAliCrashReporterService()
#ifdef __cplusplus
extern "C" {
#endif 
    id<AliCrashReporterInterface> getAliCrashReporterService(void);
    void setAliCrashReporterService(id<AliCrashReporterInterface> service);
#ifdef __cplusplus
}
#endif 