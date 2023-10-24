#import <Foundation/Foundation.h>
#import <AWSCore/AWSNetworking.h>
#import <AWSCore/AWSModel.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoSyncErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoSyncErrorType) {
    AWSCognitoSyncErrorUnknown,
    AWSCognitoSyncErrorAlreadyStreamed,
    AWSCognitoSyncErrorConcurrentModification,
    AWSCognitoSyncErrorDuplicateRequest,
    AWSCognitoSyncErrorInternalError,
    AWSCognitoSyncErrorInvalidConfiguration,
    AWSCognitoSyncErrorInvalidLambdaFunctionOutput,
    AWSCognitoSyncErrorInvalidParameter,
    AWSCognitoSyncErrorLambdaThrottled,
    AWSCognitoSyncErrorLimitExceeded,
    AWSCognitoSyncErrorNotAuthorized,
    AWSCognitoSyncErrorResourceConflict,
    AWSCognitoSyncErrorResourceNotFound,
    AWSCognitoSyncErrorTooManyRequests,
};
typedef NS_ENUM(NSInteger, AWSCognitoSyncBulkPublishStatus) {
    AWSCognitoSyncBulkPublishStatusUnknown,
    AWSCognitoSyncBulkPublishStatusNotStarted,
    AWSCognitoSyncBulkPublishStatusInProgress,
    AWSCognitoSyncBulkPublishStatusFailed,
    AWSCognitoSyncBulkPublishStatusSucceeded,
};
typedef NS_ENUM(NSInteger, AWSCognitoSyncOperation) {
    AWSCognitoSyncOperationUnknown,
    AWSCognitoSyncOperationReplace,
    AWSCognitoSyncOperationRemove,
};
typedef NS_ENUM(NSInteger, AWSCognitoSyncPlatform) {
    AWSCognitoSyncPlatformUnknown,
    AWSCognitoSyncPlatformApns,
    AWSCognitoSyncPlatformApnsSandbox,
    AWSCognitoSyncPlatformGcm,
    AWSCognitoSyncPlatformAdm,
};
typedef NS_ENUM(NSInteger, AWSCognitoSyncStreamingStatus) {
    AWSCognitoSyncStreamingStatusUnknown,
    AWSCognitoSyncStreamingStatusEnabled,
    AWSCognitoSyncStreamingStatusDisabled,
};
@class AWSCognitoSyncBulkPublishRequest;
@class AWSCognitoSyncBulkPublishResponse;
@class AWSCognitoSyncCognitoStreams;
@class AWSCognitoSyncDataset;
@class AWSCognitoSyncDeleteDatasetRequest;
@class AWSCognitoSyncDeleteDatasetResponse;
@class AWSCognitoSyncDescribeDatasetRequest;
@class AWSCognitoSyncDescribeDatasetResponse;
@class AWSCognitoSyncDescribeIdentityPoolUsageRequest;
@class AWSCognitoSyncDescribeIdentityPoolUsageResponse;
@class AWSCognitoSyncDescribeIdentityUsageRequest;
@class AWSCognitoSyncDescribeIdentityUsageResponse;
@class AWSCognitoSyncGetBulkPublishDetailsRequest;
@class AWSCognitoSyncGetBulkPublishDetailsResponse;
@class AWSCognitoSyncGetCognitoEventsRequest;
@class AWSCognitoSyncGetCognitoEventsResponse;
@class AWSCognitoSyncGetIdentityPoolConfigurationRequest;
@class AWSCognitoSyncGetIdentityPoolConfigurationResponse;
@class AWSCognitoSyncIdentityPoolUsage;
@class AWSCognitoSyncIdentityUsage;
@class AWSCognitoSyncListDatasetsRequest;
@class AWSCognitoSyncListDatasetsResponse;
@class AWSCognitoSyncListIdentityPoolUsageRequest;
@class AWSCognitoSyncListIdentityPoolUsageResponse;
@class AWSCognitoSyncListRecordsRequest;
@class AWSCognitoSyncListRecordsResponse;
@class AWSCognitoSyncPushSync;
@class AWSCognitoSyncRecord;
@class AWSCognitoSyncRecordPatch;
@class AWSCognitoSyncRegisterDeviceRequest;
@class AWSCognitoSyncRegisterDeviceResponse;
@class AWSCognitoSyncSetCognitoEventsRequest;
@class AWSCognitoSyncSetIdentityPoolConfigurationRequest;
@class AWSCognitoSyncSetIdentityPoolConfigurationResponse;
@class AWSCognitoSyncSubscribeToDatasetRequest;
@class AWSCognitoSyncSubscribeToDatasetResponse;
@class AWSCognitoSyncUnsubscribeFromDatasetRequest;
@class AWSCognitoSyncUnsubscribeFromDatasetResponse;
@class AWSCognitoSyncUpdateRecordsRequest;
@class AWSCognitoSyncUpdateRecordsResponse;
@interface AWSCognitoSyncBulkPublishRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncBulkPublishResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncCognitoStreams : AWSModel
@property (nonatomic, strong) NSString * _Nullable roleArn;
@property (nonatomic, strong) NSString * _Nullable streamName;
@property (nonatomic, assign) AWSCognitoSyncStreamingStatus streamingStatus;
@end
@interface AWSCognitoSyncDataset : AWSModel
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSNumber * _Nullable dataStorage;
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable lastModifiedBy;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSNumber * _Nullable numRecords;
@end
@interface AWSCognitoSyncDeleteDatasetRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncDeleteDatasetResponse : AWSModel
@property (nonatomic, strong) AWSCognitoSyncDataset * _Nullable dataset;
@end
@interface AWSCognitoSyncDescribeDatasetRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncDescribeDatasetResponse : AWSModel
@property (nonatomic, strong) AWSCognitoSyncDataset * _Nullable dataset;
@end
@interface AWSCognitoSyncDescribeIdentityPoolUsageRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncDescribeIdentityPoolUsageResponse : AWSModel
@property (nonatomic, strong) AWSCognitoSyncIdentityPoolUsage * _Nullable identityPoolUsage;
@end
@interface AWSCognitoSyncDescribeIdentityUsageRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncDescribeIdentityUsageResponse : AWSModel
@property (nonatomic, strong) AWSCognitoSyncIdentityUsage * _Nullable identityUsage;
@end
@interface AWSCognitoSyncGetBulkPublishDetailsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncGetBulkPublishDetailsResponse : AWSModel
@property (nonatomic, strong) NSDate * _Nullable bulkPublishCompleteTime;
@property (nonatomic, strong) NSDate * _Nullable bulkPublishStartTime;
@property (nonatomic, assign) AWSCognitoSyncBulkPublishStatus bulkPublishStatus;
@property (nonatomic, strong) NSString * _Nullable failureMessage;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncGetCognitoEventsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncGetCognitoEventsResponse : AWSModel
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable events;
@end
@interface AWSCognitoSyncGetIdentityPoolConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncGetIdentityPoolConfigurationResponse : AWSModel
@property (nonatomic, strong) AWSCognitoSyncCognitoStreams * _Nullable cognitoStreams;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) AWSCognitoSyncPushSync * _Nullable pushSync;
@end
@interface AWSCognitoSyncIdentityPoolUsage : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable dataStorage;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSNumber * _Nullable syncSessionsCount;
@end
@interface AWSCognitoSyncIdentityUsage : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable dataStorage;
@property (nonatomic, strong) NSNumber * _Nullable datasetCount;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@end
@interface AWSCognitoSyncListDatasetsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoSyncListDatasetsResponse : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable count;
@property (nonatomic, strong) NSArray<AWSCognitoSyncDataset *> * _Nullable datasets;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoSyncListIdentityPoolUsageRequest : AWSRequest
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoSyncListIdentityPoolUsageResponse : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable count;
@property (nonatomic, strong) NSArray<AWSCognitoSyncIdentityPoolUsage *> * _Nullable identityPoolUsages;
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@end
@interface AWSCognitoSyncListRecordsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSNumber * _Nullable lastSyncCount;
@property (nonatomic, strong) NSNumber * _Nullable maxResults;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSString * _Nullable syncSessionToken;
@end
@interface AWSCognitoSyncListRecordsResponse : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable count;
@property (nonatomic, strong) NSNumber * _Nullable datasetDeletedAfterRequestedSyncCount;
@property (nonatomic, strong) NSNumber * _Nullable datasetExists;
@property (nonatomic, strong) NSNumber * _Nullable datasetSyncCount;
@property (nonatomic, strong) NSString * _Nullable lastModifiedBy;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable mergedDatasetNames;
@property (nonatomic, strong) NSString * _Nullable nextToken;
@property (nonatomic, strong) NSArray<AWSCognitoSyncRecord *> * _Nullable records;
@property (nonatomic, strong) NSString * _Nullable syncSessionToken;
@end
@interface AWSCognitoSyncPushSync : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable applicationArns;
@property (nonatomic, strong) NSString * _Nullable roleArn;
@end
@interface AWSCognitoSyncRecord : AWSModel
@property (nonatomic, strong) NSDate * _Nullable deviceLastModifiedDate;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable lastModifiedBy;
@property (nonatomic, strong) NSDate * _Nullable lastModifiedDate;
@property (nonatomic, strong) NSNumber * _Nullable syncCount;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSCognitoSyncRecordPatch : AWSModel
@property (nonatomic, strong) NSDate * _Nullable deviceLastModifiedDate;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSCognitoSyncOperation op;
@property (nonatomic, strong) NSNumber * _Nullable syncCount;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSCognitoSyncRegisterDeviceRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, assign) AWSCognitoSyncPlatform platform;
@property (nonatomic, strong) NSString * _Nullable token;
@end
@interface AWSCognitoSyncRegisterDeviceResponse : AWSModel
@property (nonatomic, strong) NSString * _Nullable deviceId;
@end
@interface AWSCognitoSyncSetCognitoEventsRequest : AWSRequest
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable events;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncSetIdentityPoolConfigurationRequest : AWSRequest
@property (nonatomic, strong) AWSCognitoSyncCognitoStreams * _Nullable cognitoStreams;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) AWSCognitoSyncPushSync * _Nullable pushSync;
@end
@interface AWSCognitoSyncSetIdentityPoolConfigurationResponse : AWSModel
@property (nonatomic, strong) AWSCognitoSyncCognitoStreams * _Nullable cognitoStreams;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) AWSCognitoSyncPushSync * _Nullable pushSync;
@end
@interface AWSCognitoSyncSubscribeToDatasetRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable deviceId;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncSubscribeToDatasetResponse : AWSModel
@end
@interface AWSCognitoSyncUnsubscribeFromDatasetRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable deviceId;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@end
@interface AWSCognitoSyncUnsubscribeFromDatasetResponse : AWSModel
@end
@interface AWSCognitoSyncUpdateRecordsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable clientContext;
@property (nonatomic, strong) NSString * _Nullable datasetName;
@property (nonatomic, strong) NSString * _Nullable deviceId;
@property (nonatomic, strong) NSString * _Nullable identityId;
@property (nonatomic, strong) NSString * _Nullable identityPoolId;
@property (nonatomic, strong) NSArray<AWSCognitoSyncRecordPatch *> * _Nullable recordPatches;
@property (nonatomic, strong) NSString * _Nullable syncSessionToken;
@end
@interface AWSCognitoSyncUpdateRecordsResponse : AWSModel
@property (nonatomic, strong) NSArray<AWSCognitoSyncRecord *> * _Nullable records;
@end
NS_ASSUME_NONNULL_END