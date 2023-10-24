#ifndef AlicloudReport_h
#define AlicloudReport_h
extern const NSString *EXT_INFO_KEY_VERSION;
extern const NSString *EXT_INFO_KEY_PACKAGE;
typedef NS_ENUM(NSInteger, AMSService) {
    AMSMAN  = 0,
    AMSHTTPDNS,
    AMSMPUSH,
    AMSMAC,
    AMSAPI,
    AMSHOTFIX,
    AMSFEEDBACK,
    AMSIM
};
typedef NS_ENUM(NSInteger, AMSReportStatus) {
    AMS_UNREPORTED_STATUS,
    AMS_REPORTED_STATUS
};
@interface AlicloudReport : NSObject
+ (void)statAsync:(AMSService)tag;
+ (void)statAsync:(AMSService)tag extInfo:(NSDictionary *)extInfo;
+ (AMSReportStatus)getReportStatus:(AMSService)tag;
+ (BOOL)isDeviceReported:(AMSService)tag;
@end
#endif 