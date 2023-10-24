#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import "AWSCognitoHandlers.h"
#import "AWSCognitoSyncService.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoSDKVersion;
@class AWSCognitoDataset;
@class AWSCognitoDatasetMetadata;
@class AWSCognitoCredentialsProvider;
@class AWSTask;
DEPRECATED_MSG_ATTRIBUTE("Use `AWSAppSync` for data synchronization.")
@interface AWSCognito : AWSService
extern NSString *const AWSCognitoDidStartSynchronizeNotification;
extern NSString *const AWSCognitoDidEndSynchronizeNotification;
extern NSString *const AWSCognitoDidChangeLocalValueFromRemoteNotification;
extern NSString *const AWSCognitoDidChangeRemoteValueNotification;
extern NSString *const AWSCognitoDidFailToSynchronizeNotification;
FOUNDATION_EXPORT NSString *const AWSCognitoErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoErrorType) {
    AWSCognitoErrorUnknown = 0,
    AWSCognitoErrorRemoteDataStorageFailed = -1000,
    AWSCognitoErrorInvalidDataValue = -1001,
    AWSCognitoErrorUserDataSizeLimitExceeded = -1002,
    AWSCognitoErrorLocalDataStorageFailed = -2000,
    AWSCognitoErrorIllegalArgument = -3000,
    AWSCognitoAuthenticationFailed = -4000,
    AWSCognitoErrorTaskCanceled = -5000,
    AWSCognitoErrorConflictRetriesExhausted = -6000,
    AWSCognitoErrorWiFiNotAvailable = -7000,
    AWSCognitoErrorDeviceNotRegistered = -8000,
    AWSCognitoErrorSyncAlreadyPending = -9000,
    AWSCognitoErrorTimedOutWaitingForInFlightSync = -10000,
};
@property (nonatomic, strong, readonly) AWSServiceConfiguration *configuration;
@property (nonatomic, strong) AWSCognitoRecordConflictHandler conflictHandler;
@property (nonatomic, strong) AWSCognitoDatasetDeletedHandler datasetDeletedHandler;
@property (nonatomic, strong) AWSCognitoDatasetMergedHandler datasetMergedHandler;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, assign) uint32_t synchronizeRetries;
@property (nonatomic, assign) BOOL synchronizeOnWiFiOnly;
+ (instancetype)defaultCognito;
+ (void)registerCognitoWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;
+ (instancetype)CognitoForKey:(NSString *)key;
+ (void)removeCognitoForKey:(NSString *)key;
- (AWSCognitoDataset *)openOrCreateDataset:(NSString *)datasetName;
- (NSArray<AWSCognitoDatasetMetadata *> *)listDatasets;
- (AWSTask<NSArray<AWSCognitoDatasetMetadata *> *> *)refreshDatasetMetadata;
- (void)wipe;
+ (AWSCognitoRecordConflictHandler) defaultConflictHandler;
- (AWSTask *)registerDevice: (NSData *) deviceToken;
+ (NSString *) cognitoDeviceId;
+ (void)setPushPlatform:(AWSCognitoSyncPlatform) pushPlatform;
+ (AWSCognitoSyncPlatform)pushPlatform;
- (AWSTask *)subscribe:(NSArray<NSString *> *) datasetNames;
- (AWSTask *)subscribeAll;
- (AWSTask *)unsubscribe:(NSArray<NSString *> *) datasetNames;
- (AWSTask *)unsubscribeAll;
@end
NS_ASSUME_NONNULL_END