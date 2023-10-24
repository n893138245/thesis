#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import "AWSCognitoSyncModel.h"
#import "AWSCognitoSyncResources.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSCognitoSyncSDKVersion;
@interface AWSCognitoSync : AWSService
@property (nonatomic, strong, readonly) AWSServiceConfiguration *configuration;
+ (instancetype)defaultCognitoSync;
+ (void)registerCognitoSyncWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;
+ (instancetype)CognitoSyncForKey:(NSString *)key;
+ (void)removeCognitoSyncForKey:(NSString *)key;
- (AWSTask<AWSCognitoSyncBulkPublishResponse *> *)bulkPublish:(AWSCognitoSyncBulkPublishRequest *)request;
- (void)bulkPublish:(AWSCognitoSyncBulkPublishRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncBulkPublishResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncDeleteDatasetResponse *> *)deleteDataset:(AWSCognitoSyncDeleteDatasetRequest *)request;
- (void)deleteDataset:(AWSCognitoSyncDeleteDatasetRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncDeleteDatasetResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncDescribeDatasetResponse *> *)describeDataset:(AWSCognitoSyncDescribeDatasetRequest *)request;
- (void)describeDataset:(AWSCognitoSyncDescribeDatasetRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncDescribeDatasetResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncDescribeIdentityPoolUsageResponse *> *)describeIdentityPoolUsage:(AWSCognitoSyncDescribeIdentityPoolUsageRequest *)request;
- (void)describeIdentityPoolUsage:(AWSCognitoSyncDescribeIdentityPoolUsageRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncDescribeIdentityPoolUsageResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncDescribeIdentityUsageResponse *> *)describeIdentityUsage:(AWSCognitoSyncDescribeIdentityUsageRequest *)request;
- (void)describeIdentityUsage:(AWSCognitoSyncDescribeIdentityUsageRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncDescribeIdentityUsageResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncGetBulkPublishDetailsResponse *> *)getBulkPublishDetails:(AWSCognitoSyncGetBulkPublishDetailsRequest *)request;
- (void)getBulkPublishDetails:(AWSCognitoSyncGetBulkPublishDetailsRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncGetBulkPublishDetailsResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncGetCognitoEventsResponse *> *)getCognitoEvents:(AWSCognitoSyncGetCognitoEventsRequest *)request;
- (void)getCognitoEvents:(AWSCognitoSyncGetCognitoEventsRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncGetCognitoEventsResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncGetIdentityPoolConfigurationResponse *> *)getIdentityPoolConfiguration:(AWSCognitoSyncGetIdentityPoolConfigurationRequest *)request;
- (void)getIdentityPoolConfiguration:(AWSCognitoSyncGetIdentityPoolConfigurationRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncGetIdentityPoolConfigurationResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncListDatasetsResponse *> *)listDatasets:(AWSCognitoSyncListDatasetsRequest *)request;
- (void)listDatasets:(AWSCognitoSyncListDatasetsRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncListDatasetsResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncListIdentityPoolUsageResponse *> *)listIdentityPoolUsage:(AWSCognitoSyncListIdentityPoolUsageRequest *)request;
- (void)listIdentityPoolUsage:(AWSCognitoSyncListIdentityPoolUsageRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncListIdentityPoolUsageResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncListRecordsResponse *> *)listRecords:(AWSCognitoSyncListRecordsRequest *)request;
- (void)listRecords:(AWSCognitoSyncListRecordsRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncListRecordsResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncRegisterDeviceResponse *> *)registerDevice:(AWSCognitoSyncRegisterDeviceRequest *)request;
- (void)registerDevice:(AWSCognitoSyncRegisterDeviceRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncRegisterDeviceResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask *)setCognitoEvents:(AWSCognitoSyncSetCognitoEventsRequest *)request;
- (void)setCognitoEvents:(AWSCognitoSyncSetCognitoEventsRequest *)request completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncSetIdentityPoolConfigurationResponse *> *)setIdentityPoolConfiguration:(AWSCognitoSyncSetIdentityPoolConfigurationRequest *)request;
- (void)setIdentityPoolConfiguration:(AWSCognitoSyncSetIdentityPoolConfigurationRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncSetIdentityPoolConfigurationResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncSubscribeToDatasetResponse *> *)subscribeToDataset:(AWSCognitoSyncSubscribeToDatasetRequest *)request;
- (void)subscribeToDataset:(AWSCognitoSyncSubscribeToDatasetRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncSubscribeToDatasetResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncUnsubscribeFromDatasetResponse *> *)unsubscribeFromDataset:(AWSCognitoSyncUnsubscribeFromDatasetRequest *)request;
- (void)unsubscribeFromDataset:(AWSCognitoSyncUnsubscribeFromDatasetRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncUnsubscribeFromDatasetResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (AWSTask<AWSCognitoSyncUpdateRecordsResponse *> *)updateRecords:(AWSCognitoSyncUpdateRecordsRequest *)request;
- (void)updateRecords:(AWSCognitoSyncUpdateRecordsRequest *)request completionHandler:(void (^ _Nullable)(AWSCognitoSyncUpdateRecordsResponse * _Nullable response, NSError * _Nullable error))completionHandler;
@end
NS_ASSUME_NONNULL_END