#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ALCLogManager : NSObject
@property (nonatomic, copy) NSString *bizId;
+ (instancetype)sharedManager;
- (void)addBizId:(NSString *)bizId;
- (void)clickSwitchToBackgroundPoint;
- (void)addLog:(NSString *)timeStampStr;
- (NSString *)unUploadTimeStamp;
- (void)clearTimeStamps;
- (NSString *)filterLog:(NSString *)timeStamps count:(int)count;
- (void)updateCache:(NSString *)startUps;
- (void)uploadLog;
@end
NS_ASSUME_NONNULL_END