#import <Foundation/Foundation.h>
@protocol TBCrashReporterAbortDelegate <NSObject>
@optional
- (void)abortCallBack:(NSString *)state;
- (NSString*)getCurrentView ;
@end
@interface AliAppInfo : NSObject{
}
@property (nonatomic, strong) id<TBCrashReporterAbortDelegate> delegate;
@property (nonatomic,strong) NSString* appVersion;
@property (nonatomic,strong) NSString* crashThreadStack;
@property (nonatomic,strong) NSString* currentView;
@property (nonatomic,strong) NSString* hpVersion;
@property  BOOL isGenerateLiveReport;
+ (instancetype)shareInstance;
@end