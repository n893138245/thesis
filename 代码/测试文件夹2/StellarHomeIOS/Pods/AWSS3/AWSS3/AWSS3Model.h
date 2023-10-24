#import <Foundation/Foundation.h>
#import <AWSCore/AWSNetworking.h>
#import <AWSCore/AWSModel.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const AWSS3ErrorDomain;
typedef NS_ENUM(NSInteger, AWSS3ErrorType) {
    AWSS3ErrorUnknown,
    AWSS3ErrorBucketAlreadyExists,
    AWSS3ErrorBucketAlreadyOwnedByYou,
    AWSS3ErrorNoSuchBucket,
    AWSS3ErrorNoSuchKey,
    AWSS3ErrorNoSuchUpload,
    AWSS3ErrorObjectAlreadyInActiveTier,
    AWSS3ErrorObjectNotInActiveTier,
};
typedef NS_ENUM(NSInteger, AWSS3AnalyticsS3ExportFileFormat) {
    AWSS3AnalyticsS3ExportFileFormatUnknown,
    AWSS3AnalyticsS3ExportFileFormatCsv,
};
typedef NS_ENUM(NSInteger, AWSS3BucketAccelerateStatus) {
    AWSS3BucketAccelerateStatusUnknown,
    AWSS3BucketAccelerateStatusEnabled,
    AWSS3BucketAccelerateStatusSuspended,
};
typedef NS_ENUM(NSInteger, AWSS3BucketCannedACL) {
    AWSS3BucketCannedACLUnknown,
    AWSS3BucketCannedACLPrivate,
    AWSS3BucketCannedACLPublicRead,
    AWSS3BucketCannedACLPublicReadWrite,
    AWSS3BucketCannedACLAuthenticatedRead,
};
typedef NS_ENUM(NSInteger, AWSS3BucketLocationConstraint) {
    AWSS3BucketLocationConstraintBlank,
    AWSS3BucketLocationConstraintUnknown,
    AWSS3BucketLocationConstraintAFSouth1,
    AWSS3BucketLocationConstraintAPEast1,
    AWSS3BucketLocationConstraintAPNortheast1,
    AWSS3BucketLocationConstraintAPNortheast2,
    AWSS3BucketLocationConstraintAPNortheast3,
    AWSS3BucketLocationConstraintAPSouth1,
    AWSS3BucketLocationConstraintAPSoutheast1,
    AWSS3BucketLocationConstraintAPSoutheast2,
    AWSS3BucketLocationConstraintCACentral1,
    AWSS3BucketLocationConstraintCNNorth1,
    AWSS3BucketLocationConstraintCNNorthwest1,
    AWSS3BucketLocationConstraintEU,
    AWSS3BucketLocationConstraintEUCentral1,
    AWSS3BucketLocationConstraintEUNorth1,
    AWSS3BucketLocationConstraintEUSouth1,
    AWSS3BucketLocationConstraintEUWest1,
    AWSS3BucketLocationConstraintEUWest2,
    AWSS3BucketLocationConstraintEUWest3,
    AWSS3BucketLocationConstraintMESouth1,
    AWSS3BucketLocationConstraintSAEast1,
    AWSS3BucketLocationConstraintUSEast2,
    AWSS3BucketLocationConstraintUSGovEast1,
    AWSS3BucketLocationConstraintUSGovWest1,
    AWSS3BucketLocationConstraintUSWest1,
    AWSS3BucketLocationConstraintUSWest2,
};
typedef NS_ENUM(NSInteger, AWSS3BucketLogsPermission) {
    AWSS3BucketLogsPermissionUnknown,
    AWSS3BucketLogsPermissionFullControl,
    AWSS3BucketLogsPermissionRead,
    AWSS3BucketLogsPermissionWrite,
};
typedef NS_ENUM(NSInteger, AWSS3BucketVersioningStatus) {
    AWSS3BucketVersioningStatusUnknown,
    AWSS3BucketVersioningStatusEnabled,
    AWSS3BucketVersioningStatusSuspended,
};
typedef NS_ENUM(NSInteger, AWSS3CompressionType) {
    AWSS3CompressionTypeUnknown,
    AWSS3CompressionTypeNone,
    AWSS3CompressionTypeGzip,
    AWSS3CompressionTypeBzip2,
};
typedef NS_ENUM(NSInteger, AWSS3DeleteMarkerReplicationStatus) {
    AWSS3DeleteMarkerReplicationStatusUnknown,
    AWSS3DeleteMarkerReplicationStatusEnabled,
    AWSS3DeleteMarkerReplicationStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3EncodingType) {
    AWSS3EncodingTypeUnknown,
    AWSS3EncodingTypeURL,
};
typedef NS_ENUM(NSInteger, AWSS3Event) {
    AWSS3EventUnknown,
    AWSS3EventS3ReducedRedundancyLostObject,
    AWSS3EventS3ObjectCreated,
    AWSS3EventS3ObjectCreatedPut,
    AWSS3EventS3ObjectCreatedPost,
    AWSS3EventS3ObjectCreatedCopy,
    AWSS3EventS3ObjectCreatedCompleteMultipartUpload,
    AWSS3EventS3ObjectRemoved,
    AWSS3EventS3ObjectRemovedDelete,
    AWSS3EventS3ObjectRemovedDeleteMarkerCreated,
    AWSS3EventS3ObjectRestore,
    AWSS3EventS3ObjectRestorePost,
    AWSS3EventS3ObjectRestoreCompleted,
    AWSS3EventS3Replication,
    AWSS3EventS3ReplicationOperationFailedReplication,
    AWSS3EventS3ReplicationOperationNotTracked,
    AWSS3EventS3ReplicationOperationMissedThreshold,
    AWSS3EventS3ReplicationOperationReplicatedAfterThreshold,
};
typedef NS_ENUM(NSInteger, AWSS3ExistingObjectReplicationStatus) {
    AWSS3ExistingObjectReplicationStatusUnknown,
    AWSS3ExistingObjectReplicationStatusEnabled,
    AWSS3ExistingObjectReplicationStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3ExpirationStatus) {
    AWSS3ExpirationStatusUnknown,
    AWSS3ExpirationStatusEnabled,
    AWSS3ExpirationStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3ExpressionType) {
    AWSS3ExpressionTypeUnknown,
    AWSS3ExpressionTypeSql,
};
typedef NS_ENUM(NSInteger, AWSS3FileHeaderInfo) {
    AWSS3FileHeaderInfoUnknown,
    AWSS3FileHeaderInfoUse,
    AWSS3FileHeaderInfoIgnore,
    AWSS3FileHeaderInfoNone,
};
typedef NS_ENUM(NSInteger, AWSS3FilterRuleName) {
    AWSS3FilterRuleNameUnknown,
    AWSS3FilterRuleNamePrefix,
    AWSS3FilterRuleNameSuffix,
};
typedef NS_ENUM(NSInteger, AWSS3InventoryFormat) {
    AWSS3InventoryFormatUnknown,
    AWSS3InventoryFormatCsv,
    AWSS3InventoryFormatOrc,
    AWSS3InventoryFormatParquet,
};
typedef NS_ENUM(NSInteger, AWSS3InventoryFrequency) {
    AWSS3InventoryFrequencyUnknown,
    AWSS3InventoryFrequencyDaily,
    AWSS3InventoryFrequencyWeekly,
};
typedef NS_ENUM(NSInteger, AWSS3InventoryIncludedObjectVersions) {
    AWSS3InventoryIncludedObjectVersionsUnknown,
    AWSS3InventoryIncludedObjectVersionsAll,
    AWSS3InventoryIncludedObjectVersionsCurrent,
};
typedef NS_ENUM(NSInteger, AWSS3InventoryOptionalField) {
    AWSS3InventoryOptionalFieldUnknown,
    AWSS3InventoryOptionalFieldSize,
    AWSS3InventoryOptionalFieldLastModifiedDate,
    AWSS3InventoryOptionalFieldStorageClass,
    AWSS3InventoryOptionalFieldETag,
    AWSS3InventoryOptionalFieldIsMultipartUploaded,
    AWSS3InventoryOptionalFieldReplicationStatus,
    AWSS3InventoryOptionalFieldEncryptionStatus,
    AWSS3InventoryOptionalFieldObjectLockRetainUntilDate,
    AWSS3InventoryOptionalFieldObjectLockMode,
    AWSS3InventoryOptionalFieldObjectLockLegalHoldStatus,
    AWSS3InventoryOptionalFieldIntelligentTieringAccessTier,
};
typedef NS_ENUM(NSInteger, AWSS3JSONType) {
    AWSS3JSONTypeUnknown,
    AWSS3JSONTypeDocument,
    AWSS3JSONTypeLines,
};
typedef NS_ENUM(NSInteger, AWSS3MFADelete) {
    AWSS3MFADeleteUnknown,
    AWSS3MFADeleteEnabled,
    AWSS3MFADeleteDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3MFADeleteStatus) {
    AWSS3MFADeleteStatusUnknown,
    AWSS3MFADeleteStatusEnabled,
    AWSS3MFADeleteStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3MetadataDirective) {
    AWSS3MetadataDirectiveUnknown,
    AWSS3MetadataDirectiveCopy,
    AWSS3MetadataDirectiveReplace,
};
typedef NS_ENUM(NSInteger, AWSS3MetricsStatus) {
    AWSS3MetricsStatusUnknown,
    AWSS3MetricsStatusEnabled,
    AWSS3MetricsStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectCannedACL) {
    AWSS3ObjectCannedACLUnknown,
    AWSS3ObjectCannedACLPrivate,
    AWSS3ObjectCannedACLPublicRead,
    AWSS3ObjectCannedACLPublicReadWrite,
    AWSS3ObjectCannedACLAuthenticatedRead,
    AWSS3ObjectCannedACLAwsExecRead,
    AWSS3ObjectCannedACLBucketOwnerRead,
    AWSS3ObjectCannedACLBucketOwnerFullControl,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectLockEnabled) {
    AWSS3ObjectLockEnabledUnknown,
    AWSS3ObjectLockEnabledEnabled,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectLockLegalHoldStatus) {
    AWSS3ObjectLockLegalHoldStatusUnknown,
    AWSS3ObjectLockLegalHoldStatusOn,
    AWSS3ObjectLockLegalHoldStatusOff,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectLockMode) {
    AWSS3ObjectLockModeUnknown,
    AWSS3ObjectLockModeGovernance,
    AWSS3ObjectLockModeCompliance,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectLockRetentionMode) {
    AWSS3ObjectLockRetentionModeUnknown,
    AWSS3ObjectLockRetentionModeGovernance,
    AWSS3ObjectLockRetentionModeCompliance,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectOwnership) {
    AWSS3ObjectOwnershipUnknown,
    AWSS3ObjectOwnershipBucketOwnerPreferred,
    AWSS3ObjectOwnershipObjectWriter,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectStorageClass) {
    AWSS3ObjectStorageClassUnknown,
    AWSS3ObjectStorageClassStandard,
    AWSS3ObjectStorageClassReducedRedundancy,
    AWSS3ObjectStorageClassGlacier,
    AWSS3ObjectStorageClassStandardIa,
    AWSS3ObjectStorageClassOnezoneIa,
    AWSS3ObjectStorageClassIntelligentTiering,
    AWSS3ObjectStorageClassDeepArchive,
    AWSS3ObjectStorageClassOutposts,
};
typedef NS_ENUM(NSInteger, AWSS3ObjectVersionStorageClass) {
    AWSS3ObjectVersionStorageClassUnknown,
    AWSS3ObjectVersionStorageClassStandard,
};
typedef NS_ENUM(NSInteger, AWSS3OwnerOverride) {
    AWSS3OwnerOverrideUnknown,
    AWSS3OwnerOverrideDestination,
};
typedef NS_ENUM(NSInteger, AWSS3Payer) {
    AWSS3PayerUnknown,
    AWSS3PayerRequester,
    AWSS3PayerBucketOwner,
};
typedef NS_ENUM(NSInteger, AWSS3Permission) {
    AWSS3PermissionUnknown,
    AWSS3PermissionFullControl,
    AWSS3PermissionWrite,
    AWSS3PermissionWriteAcp,
    AWSS3PermissionRead,
    AWSS3PermissionReadAcp,
};
typedef NS_ENUM(NSInteger, AWSS3Protocols) {
    AWSS3ProtocolsUnknown,
    AWSS3ProtocolsHTTP,
    AWSS3ProtocolsHTTPS,
};
typedef NS_ENUM(NSInteger, AWSS3QuoteFields) {
    AWSS3QuoteFieldsUnknown,
    AWSS3QuoteFieldsAlways,
    AWSS3QuoteFieldsAsneeded,
};
typedef NS_ENUM(NSInteger, AWSS3ReplicationRuleStatus) {
    AWSS3ReplicationRuleStatusUnknown,
    AWSS3ReplicationRuleStatusEnabled,
    AWSS3ReplicationRuleStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3ReplicationStatus) {
    AWSS3ReplicationStatusUnknown,
    AWSS3ReplicationStatusComplete,
    AWSS3ReplicationStatusPending,
    AWSS3ReplicationStatusFailed,
    AWSS3ReplicationStatusReplica,
};
typedef NS_ENUM(NSInteger, AWSS3ReplicationTimeStatus) {
    AWSS3ReplicationTimeStatusUnknown,
    AWSS3ReplicationTimeStatusEnabled,
    AWSS3ReplicationTimeStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3RequestCharged) {
    AWSS3RequestChargedUnknown,
    AWSS3RequestChargedRequester,
};
typedef NS_ENUM(NSInteger, AWSS3RequestPayer) {
    AWSS3RequestPayerUnknown,
    AWSS3RequestPayerRequester,
};
typedef NS_ENUM(NSInteger, AWSS3RestoreRequestType) {
    AWSS3RestoreRequestTypeUnknown,
    AWSS3RestoreRequestTypeSelect,
};
typedef NS_ENUM(NSInteger, AWSS3ServerSideEncryption) {
    AWSS3ServerSideEncryptionUnknown,
    AWSS3ServerSideEncryptionAES256,
    AWSS3ServerSideEncryptionAwsKms,
};
typedef NS_ENUM(NSInteger, AWSS3SseKmsEncryptedObjectsStatus) {
    AWSS3SseKmsEncryptedObjectsStatusUnknown,
    AWSS3SseKmsEncryptedObjectsStatusEnabled,
    AWSS3SseKmsEncryptedObjectsStatusDisabled,
};
typedef NS_ENUM(NSInteger, AWSS3StorageClass) {
    AWSS3StorageClassUnknown,
    AWSS3StorageClassStandard,
    AWSS3StorageClassReducedRedundancy,
    AWSS3StorageClassStandardIa,
    AWSS3StorageClassOnezoneIa,
    AWSS3StorageClassIntelligentTiering,
    AWSS3StorageClassGlacier,
    AWSS3StorageClassDeepArchive,
    AWSS3StorageClassOutposts,
};
typedef NS_ENUM(NSInteger, AWSS3StorageClassAnalysisSchemaVersion) {
    AWSS3StorageClassAnalysisSchemaVersionUnknown,
    AWSS3StorageClassAnalysisSchemaVersionV1,
};
typedef NS_ENUM(NSInteger, AWSS3TaggingDirective) {
    AWSS3TaggingDirectiveUnknown,
    AWSS3TaggingDirectiveCopy,
    AWSS3TaggingDirectiveReplace,
};
typedef NS_ENUM(NSInteger, AWSS3Tier) {
    AWSS3TierUnknown,
    AWSS3TierStandard,
    AWSS3TierBulk,
    AWSS3TierExpedited,
};
typedef NS_ENUM(NSInteger, AWSS3TransitionStorageClass) {
    AWSS3TransitionStorageClassUnknown,
    AWSS3TransitionStorageClassGlacier,
    AWSS3TransitionStorageClassStandardIa,
    AWSS3TransitionStorageClassOnezoneIa,
    AWSS3TransitionStorageClassIntelligentTiering,
    AWSS3TransitionStorageClassDeepArchive,
};
typedef NS_ENUM(NSInteger, AWSS3Types) {
    AWSS3TypesUnknown,
    AWSS3TypesCanonicalUser,
    AWSS3TypesAmazonCustomerByEmail,
    AWSS3TypesGroup,
};
@class AWSS3AbortIncompleteMultipartUpload;
@class AWSS3AbortMultipartUploadOutput;
@class AWSS3AbortMultipartUploadRequest;
@class AWSS3AccelerateConfiguration;
@class AWSS3AccessControlPolicy;
@class AWSS3AccessControlTranslation;
@class AWSS3AnalyticsAndOperator;
@class AWSS3AnalyticsConfiguration;
@class AWSS3AnalyticsExportDestination;
@class AWSS3AnalyticsFilter;
@class AWSS3AnalyticsS3BucketDestination;
@class AWSS3Bucket;
@class AWSS3BucketLifecycleConfiguration;
@class AWSS3BucketLoggingStatus;
@class AWSS3CORSConfiguration;
@class AWSS3CORSRule;
@class AWSS3CSVInput;
@class AWSS3CSVOutput;
@class AWSS3CloudFunctionConfiguration;
@class AWSS3CommonPrefix;
@class AWSS3CompleteMultipartUploadOutput;
@class AWSS3CompleteMultipartUploadRequest;
@class AWSS3CompletedMultipartUpload;
@class AWSS3CompletedPart;
@class AWSS3Condition;
@class AWSS3ContinuationEvent;
@class AWSS3ReplicateObjectOutput;
@class AWSS3ReplicateObjectRequest;
@class AWSS3ReplicateObjectResult;
@class AWSS3ReplicatePartResult;
@class AWSS3CreateBucketConfiguration;
@class AWSS3CreateBucketOutput;
@class AWSS3CreateBucketRequest;
@class AWSS3CreateMultipartUploadOutput;
@class AWSS3CreateMultipartUploadRequest;
@class AWSS3DefaultRetention;
@class AWSS3Remove;
@class AWSS3DeleteBucketAnalyticsConfigurationRequest;
@class AWSS3DeleteBucketCorsRequest;
@class AWSS3DeleteBucketEncryptionRequest;
@class AWSS3DeleteBucketInventoryConfigurationRequest;
@class AWSS3DeleteBucketLifecycleRequest;
@class AWSS3DeleteBucketMetricsConfigurationRequest;
@class AWSS3DeleteBucketOwnershipControlsRequest;
@class AWSS3DeleteBucketPolicyRequest;
@class AWSS3DeleteBucketReplicationRequest;
@class AWSS3DeleteBucketRequest;
@class AWSS3DeleteBucketTaggingRequest;
@class AWSS3DeleteBucketWebsiteRequest;
@class AWSS3DeleteMarkerEntry;
@class AWSS3DeleteMarkerReplication;
@class AWSS3DeleteObjectOutput;
@class AWSS3DeleteObjectRequest;
@class AWSS3DeleteObjectTaggingOutput;
@class AWSS3DeleteObjectTaggingRequest;
@class AWSS3DeleteObjectsOutput;
@class AWSS3DeleteObjectsRequest;
@class AWSS3DeletePublicAccessBlockRequest;
@class AWSS3DeletedObject;
@class AWSS3Destination;
@class AWSS3Encryption;
@class AWSS3EncryptionConfiguration;
@class AWSS3EndEvent;
@class AWSS3Error;
@class AWSS3ErrorDocument;
@class AWSS3ExistingObjectReplication;
@class AWSS3FilterRule;
@class AWSS3GetBucketAccelerateConfigurationOutput;
@class AWSS3GetBucketAccelerateConfigurationRequest;
@class AWSS3GetBucketAclOutput;
@class AWSS3GetBucketAclRequest;
@class AWSS3GetBucketAnalyticsConfigurationOutput;
@class AWSS3GetBucketAnalyticsConfigurationRequest;
@class AWSS3GetBucketCorsOutput;
@class AWSS3GetBucketCorsRequest;
@class AWSS3GetBucketEncryptionOutput;
@class AWSS3GetBucketEncryptionRequest;
@class AWSS3GetBucketInventoryConfigurationOutput;
@class AWSS3GetBucketInventoryConfigurationRequest;
@class AWSS3GetBucketLifecycleConfigurationOutput;
@class AWSS3GetBucketLifecycleConfigurationRequest;
@class AWSS3GetBucketLifecycleOutput;
@class AWSS3GetBucketLifecycleRequest;
@class AWSS3GetBucketLocationOutput;
@class AWSS3GetBucketLocationRequest;
@class AWSS3GetBucketLoggingOutput;
@class AWSS3GetBucketLoggingRequest;
@class AWSS3GetBucketMetricsConfigurationOutput;
@class AWSS3GetBucketMetricsConfigurationRequest;
@class AWSS3GetBucketNotificationConfigurationRequest;
@class AWSS3GetBucketOwnershipControlsOutput;
@class AWSS3GetBucketOwnershipControlsRequest;
@class AWSS3GetBucketPolicyOutput;
@class AWSS3GetBucketPolicyRequest;
@class AWSS3GetBucketPolicyStatusOutput;
@class AWSS3GetBucketPolicyStatusRequest;
@class AWSS3GetBucketReplicationOutput;
@class AWSS3GetBucketReplicationRequest;
@class AWSS3GetBucketRequestPaymentOutput;
@class AWSS3GetBucketRequestPaymentRequest;
@class AWSS3GetBucketTaggingOutput;
@class AWSS3GetBucketTaggingRequest;
@class AWSS3GetBucketVersioningOutput;
@class AWSS3GetBucketVersioningRequest;
@class AWSS3GetBucketWebsiteOutput;
@class AWSS3GetBucketWebsiteRequest;
@class AWSS3GetObjectAclOutput;
@class AWSS3GetObjectAclRequest;
@class AWSS3GetObjectLegalHoldOutput;
@class AWSS3GetObjectLegalHoldRequest;
@class AWSS3GetObjectLockConfigurationOutput;
@class AWSS3GetObjectLockConfigurationRequest;
@class AWSS3GetObjectOutput;
@class AWSS3GetObjectRequest;
@class AWSS3GetObjectRetentionOutput;
@class AWSS3GetObjectRetentionRequest;
@class AWSS3GetObjectTaggingOutput;
@class AWSS3GetObjectTaggingRequest;
@class AWSS3GetObjectTorrentOutput;
@class AWSS3GetObjectTorrentRequest;
@class AWSS3GetPublicAccessBlockOutput;
@class AWSS3GetPublicAccessBlockRequest;
@class AWSS3GlacierJobParameters;
@class AWSS3Grant;
@class AWSS3Grantee;
@class AWSS3HeadBucketRequest;
@class AWSS3HeadObjectOutput;
@class AWSS3HeadObjectRequest;
@class AWSS3IndexDocument;
@class AWSS3Initiator;
@class AWSS3InputSerialization;
@class AWSS3InventoryConfiguration;
@class AWSS3InventoryDestination;
@class AWSS3InventoryEncryption;
@class AWSS3InventoryFilter;
@class AWSS3InventoryS3BucketDestination;
@class AWSS3InventorySchedule;
@class AWSS3JSONInput;
@class AWSS3JSONOutput;
@class AWSS3LambdaFunctionConfiguration;
@class AWSS3LifecycleConfiguration;
@class AWSS3LifecycleExpiration;
@class AWSS3LifecycleRule;
@class AWSS3LifecycleRuleAndOperator;
@class AWSS3LifecycleRuleFilter;
@class AWSS3ListBucketAnalyticsConfigurationsOutput;
@class AWSS3ListBucketAnalyticsConfigurationsRequest;
@class AWSS3ListBucketInventoryConfigurationsOutput;
@class AWSS3ListBucketInventoryConfigurationsRequest;
@class AWSS3ListBucketMetricsConfigurationsOutput;
@class AWSS3ListBucketMetricsConfigurationsRequest;
@class AWSS3ListBucketsOutput;
@class AWSS3ListMultipartUploadsOutput;
@class AWSS3ListMultipartUploadsRequest;
@class AWSS3ListObjectVersionsOutput;
@class AWSS3ListObjectVersionsRequest;
@class AWSS3ListObjectsOutput;
@class AWSS3ListObjectsRequest;
@class AWSS3ListObjectsV2Output;
@class AWSS3ListObjectsV2Request;
@class AWSS3ListPartsOutput;
@class AWSS3ListPartsRequest;
@class AWSS3LoggingEnabled;
@class AWSS3MetadataEntry;
@class AWSS3Metrics;
@class AWSS3MetricsAndOperator;
@class AWSS3MetricsConfiguration;
@class AWSS3MetricsFilter;
@class AWSS3MultipartUpload;
@class AWSS3NoncurrentVersionExpiration;
@class AWSS3NoncurrentVersionTransition;
@class AWSS3NotificationConfiguration;
@class AWSS3NotificationConfigurationDeprecated;
@class AWSS3NotificationConfigurationFilter;
@class AWSS3Object;
@class AWSS3ObjectIdentifier;
@class AWSS3ObjectLockConfiguration;
@class AWSS3ObjectLockLegalHold;
@class AWSS3ObjectLockRetention;
@class AWSS3ObjectLockRule;
@class AWSS3ObjectVersion;
@class AWSS3OutputLocation;
@class AWSS3OutputSerialization;
@class AWSS3Owner;
@class AWSS3OwnershipControls;
@class AWSS3OwnershipControlsRule;
@class AWSS3ParquetInput;
@class AWSS3Part;
@class AWSS3PolicyStatus;
@class AWSS3Progress;
@class AWSS3ProgressEvent;
@class AWSS3PublicAccessBlockConfiguration;
@class AWSS3PutBucketAccelerateConfigurationRequest;
@class AWSS3PutBucketAclRequest;
@class AWSS3PutBucketAnalyticsConfigurationRequest;
@class AWSS3PutBucketCorsRequest;
@class AWSS3PutBucketEncryptionRequest;
@class AWSS3PutBucketInventoryConfigurationRequest;
@class AWSS3PutBucketLifecycleConfigurationRequest;
@class AWSS3PutBucketLifecycleRequest;
@class AWSS3PutBucketLoggingRequest;
@class AWSS3PutBucketMetricsConfigurationRequest;
@class AWSS3PutBucketNotificationConfigurationRequest;
@class AWSS3PutBucketNotificationRequest;
@class AWSS3PutBucketOwnershipControlsRequest;
@class AWSS3PutBucketPolicyRequest;
@class AWSS3PutBucketReplicationRequest;
@class AWSS3PutBucketRequestPaymentRequest;
@class AWSS3PutBucketTaggingRequest;
@class AWSS3PutBucketVersioningRequest;
@class AWSS3PutBucketWebsiteRequest;
@class AWSS3PutObjectAclOutput;
@class AWSS3PutObjectAclRequest;
@class AWSS3PutObjectLegalHoldOutput;
@class AWSS3PutObjectLegalHoldRequest;
@class AWSS3PutObjectLockConfigurationOutput;
@class AWSS3PutObjectLockConfigurationRequest;
@class AWSS3PutObjectOutput;
@class AWSS3PutObjectRequest;
@class AWSS3PutObjectRetentionOutput;
@class AWSS3PutObjectRetentionRequest;
@class AWSS3PutObjectTaggingOutput;
@class AWSS3PutObjectTaggingRequest;
@class AWSS3PutPublicAccessBlockRequest;
@class AWSS3QueueConfiguration;
@class AWSS3QueueConfigurationDeprecated;
@class AWSS3RecordsEvent;
@class AWSS3Redirect;
@class AWSS3RedirectAllRequestsTo;
@class AWSS3ReplicationConfiguration;
@class AWSS3ReplicationRule;
@class AWSS3ReplicationRuleAndOperator;
@class AWSS3ReplicationRuleFilter;
@class AWSS3ReplicationTime;
@class AWSS3ReplicationTimeValue;
@class AWSS3RequestPaymentConfiguration;
@class AWSS3RequestProgress;
@class AWSS3RestoreObjectOutput;
@class AWSS3RestoreObjectRequest;
@class AWSS3RestoreRequest;
@class AWSS3RoutingRule;
@class AWSS3Rule;
@class AWSS3S3KeyFilter;
@class AWSS3S3Location;
@class AWSS3SSEKMS;
@class AWSS3SSES3;
@class AWSS3ScanRange;
@class AWSS3SelectObjectContentEventStream;
@class AWSS3SelectObjectContentOutput;
@class AWSS3SelectObjectContentRequest;
@class AWSS3SelectParameters;
@class AWSS3ServerSideEncryptionByDefault;
@class AWSS3ServerSideEncryptionConfiguration;
@class AWSS3ServerSideEncryptionRule;
@class AWSS3SourceSelectionCriteria;
@class AWSS3SseKmsEncryptedObjects;
@class AWSS3Stats;
@class AWSS3StatsEvent;
@class AWSS3StorageClassAnalysis;
@class AWSS3StorageClassAnalysisDataExport;
@class AWSS3Tag;
@class AWSS3Tagging;
@class AWSS3TargetGrant;
@class AWSS3TopicConfiguration;
@class AWSS3TopicConfigurationDeprecated;
@class AWSS3Transition;
@class AWSS3UploadPartCopyOutput;
@class AWSS3UploadPartCopyRequest;
@class AWSS3UploadPartOutput;
@class AWSS3UploadPartRequest;
@class AWSS3VersioningConfiguration;
@class AWSS3WebsiteConfiguration;
@interface AWSS3AbortIncompleteMultipartUpload : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable daysAfterInitiation;
@end
@interface AWSS3AbortMultipartUploadOutput : AWSModel
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3AbortMultipartUploadRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3AccelerateConfiguration : AWSModel
@property (nonatomic, assign) AWSS3BucketAccelerateStatus status;
@end
@interface AWSS3AccessControlPolicy : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Grant *> * _Nullable grants;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@end
@interface AWSS3AccessControlTranslation : AWSModel
@property (nonatomic, assign) AWSS3OwnerOverride owner;
@end
@interface AWSS3AnalyticsAndOperator : AWSModel
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tags;
@end
@interface AWSS3AnalyticsConfiguration : AWSModel
@property (nonatomic, strong) AWSS3AnalyticsFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSS3StorageClassAnalysis * _Nullable storageClassAnalysis;
@end
@interface AWSS3AnalyticsExportDestination : AWSModel
@property (nonatomic, strong) AWSS3AnalyticsS3BucketDestination * _Nullable s3BucketDestination;
@end
@interface AWSS3AnalyticsFilter : AWSModel
@property (nonatomic, strong) AWSS3AnalyticsAndOperator * _Nullable AND;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) AWSS3Tag * _Nullable tag;
@end
@interface AWSS3AnalyticsS3BucketDestination : AWSModel
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable bucketAccountId;
@property (nonatomic, assign) AWSS3AnalyticsS3ExportFileFormat format;
@property (nonatomic, strong) NSString * _Nullable prefix;
@end
@interface AWSS3Bucket : AWSModel
@property (nonatomic, strong) NSDate * _Nullable creationDate;
@property (nonatomic, strong) NSString * _Nullable name;
@end
@interface AWSS3BucketLifecycleConfiguration : AWSModel
@property (nonatomic, strong) NSArray<AWSS3LifecycleRule *> * _Nullable rules;
@end
@interface AWSS3BucketLoggingStatus : AWSModel
@property (nonatomic, strong) AWSS3LoggingEnabled * _Nullable loggingEnabled;
@end
@interface AWSS3CORSConfiguration : AWSModel
@property (nonatomic, strong) NSArray<AWSS3CORSRule *> * _Nullable CORSRules;
@end
@interface AWSS3CORSRule : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedHeaders;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedMethods;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable allowedOrigins;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable exposeHeaders;
@property (nonatomic, strong) NSNumber * _Nullable maxAgeSeconds;
@end
@interface AWSS3CSVInput : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable allowQuotedRecordDelimiter;
@property (nonatomic, strong) NSString * _Nullable comments;
@property (nonatomic, strong) NSString * _Nullable fieldDelimiter;
@property (nonatomic, assign) AWSS3FileHeaderInfo fileHeaderInfo;
@property (nonatomic, strong) NSString * _Nullable quoteCharacter;
@property (nonatomic, strong) NSString * _Nullable quoteEscapeCharacter;
@property (nonatomic, strong) NSString * _Nullable recordDelimiter;
@end
@interface AWSS3CSVOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable fieldDelimiter;
@property (nonatomic, strong) NSString * _Nullable quoteCharacter;
@property (nonatomic, strong) NSString * _Nullable quoteEscapeCharacter;
@property (nonatomic, assign) AWSS3QuoteFields quoteFields;
@property (nonatomic, strong) NSString * _Nullable recordDelimiter;
@end
@interface AWSS3CloudFunctionConfiguration : AWSModel
@property (nonatomic, strong) NSString * _Nullable cloudFunction;
@property (nonatomic, assign) AWSS3Event event;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable events;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable invocationRole;
@end
@interface AWSS3CommonPrefix : AWSModel
@property (nonatomic, strong) NSString * _Nullable prefix;
@end
@interface AWSS3CompleteMultipartUploadOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSString * _Nullable expiration;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable location;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3CompleteMultipartUploadRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) AWSS3CompletedMultipartUpload * _Nullable multipartUpload;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3CompletedMultipartUpload : AWSModel
@property (nonatomic, strong) NSArray<AWSS3CompletedPart *> * _Nullable parts;
@end
@interface AWSS3CompletedPart : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSNumber * _Nullable partNumber;
@end
@interface AWSS3Condition : AWSModel
@property (nonatomic, strong) NSString * _Nullable httpErrorCodeReturnedEquals;
@property (nonatomic, strong) NSString * _Nullable keyPrefixEquals;
@end
@interface AWSS3ContinuationEvent : AWSModel
@end
@interface AWSS3ReplicateObjectOutput : AWSModel
@property (nonatomic, strong) AWSS3ReplicateObjectResult * _Nullable replicateObjectResult;
@property (nonatomic, strong) NSString * _Nullable replicateSourceVersionId;
@property (nonatomic, strong) NSString * _Nullable expiration;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSEncryptionContext;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3ReplicateObjectRequest : AWSRequest
@property (nonatomic, assign) AWSS3ObjectCannedACL ACL;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable cacheControl;
@property (nonatomic, strong) NSString * _Nullable contentDisposition;
@property (nonatomic, strong) NSString * _Nullable contentEncoding;
@property (nonatomic, strong) NSString * _Nullable contentLanguage;
@property (nonatomic, strong) NSString * _Nullable contentType;
@property (nonatomic, strong) NSString * _Nullable replicateSource;
@property (nonatomic, strong) NSString * _Nullable replicateSourceIfMatch;
@property (nonatomic, strong) NSDate * _Nullable replicateSourceIfModifiedSince;
@property (nonatomic, strong) NSString * _Nullable replicateSourceIfNoneMatch;
@property (nonatomic, strong) NSDate * _Nullable replicateSourceIfUnmodifiedSince;
@property (nonatomic, strong) NSString * _Nullable replicateSourceSSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable replicateSourceSSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable replicateSourceSSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable expectedSourceBucketOwner;
@property (nonatomic, strong) NSDate * _Nullable expires;
@property (nonatomic, strong) NSString * _Nullable grantFullControl;
@property (nonatomic, strong) NSString * _Nullable grantRead;
@property (nonatomic, strong) NSString * _Nullable grantReadACP;
@property (nonatomic, strong) NSString * _Nullable grantWriteACP;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable metadata;
@property (nonatomic, assign) AWSS3MetadataDirective metadataDirective;
@property (nonatomic, assign) AWSS3ObjectLockLegalHoldStatus objectLockLegalHoldStatus;
@property (nonatomic, assign) AWSS3ObjectLockMode objectLockMode;
@property (nonatomic, strong) NSDate * _Nullable objectLockRetainUntilDate;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSEncryptionContext;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable tagging;
@property (nonatomic, assign) AWSS3TaggingDirective taggingDirective;
@property (nonatomic, strong) NSString * _Nullable websiteRedirectLocation;
@end
@interface AWSS3ReplicateObjectResult : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@end
@interface AWSS3ReplicatePartResult : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@end
@interface AWSS3CreateBucketConfiguration : AWSModel
@property (nonatomic, assign) AWSS3BucketLocationConstraint locationConstraint;
@end
@interface AWSS3CreateBucketOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable location;
@end
@interface AWSS3CreateBucketRequest : AWSRequest
@property (nonatomic, assign) AWSS3BucketCannedACL ACL;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) AWSS3CreateBucketConfiguration * _Nullable createBucketConfiguration;
@property (nonatomic, strong) NSString * _Nullable grantFullControl;
@property (nonatomic, strong) NSString * _Nullable grantRead;
@property (nonatomic, strong) NSString * _Nullable grantReadACP;
@property (nonatomic, strong) NSString * _Nullable grantWrite;
@property (nonatomic, strong) NSString * _Nullable grantWriteACP;
@property (nonatomic, strong) NSNumber * _Nullable objectLockEnabledForBucket;
@end
@interface AWSS3CreateMultipartUploadOutput : AWSModel
@property (nonatomic, strong) NSDate * _Nullable abortDate;
@property (nonatomic, strong) NSString * _Nullable abortRuleId;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSEncryptionContext;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3CreateMultipartUploadRequest : AWSRequest
@property (nonatomic, assign) AWSS3ObjectCannedACL ACL;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable cacheControl;
@property (nonatomic, strong) NSString * _Nullable contentDisposition;
@property (nonatomic, strong) NSString * _Nullable contentEncoding;
@property (nonatomic, strong) NSString * _Nullable contentLanguage;
@property (nonatomic, strong) NSString * _Nullable contentType;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSDate * _Nullable expires;
@property (nonatomic, strong) NSString * _Nullable grantFullControl;
@property (nonatomic, strong) NSString * _Nullable grantRead;
@property (nonatomic, strong) NSString * _Nullable grantReadACP;
@property (nonatomic, strong) NSString * _Nullable grantWriteACP;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable metadata;
@property (nonatomic, assign) AWSS3ObjectLockLegalHoldStatus objectLockLegalHoldStatus;
@property (nonatomic, assign) AWSS3ObjectLockMode objectLockMode;
@property (nonatomic, strong) NSDate * _Nullable objectLockRetainUntilDate;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSEncryptionContext;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable tagging;
@property (nonatomic, strong) NSString * _Nullable websiteRedirectLocation;
@end
@interface AWSS3DefaultRetention : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable days;
@property (nonatomic, assign) AWSS3ObjectLockRetentionMode mode;
@property (nonatomic, strong) NSNumber * _Nullable years;
@end
@interface AWSS3Remove : AWSModel
@property (nonatomic, strong) NSArray<AWSS3ObjectIdentifier *> * _Nullable objects;
@property (nonatomic, strong) NSNumber * _Nullable quiet;
@end
@interface AWSS3DeleteBucketAnalyticsConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3DeleteBucketCorsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketEncryptionRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketInventoryConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3DeleteBucketLifecycleRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketMetricsConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3DeleteBucketOwnershipControlsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketPolicyRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketReplicationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketTaggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteBucketWebsiteRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeleteMarkerEntry : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable isLatest;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3DeleteMarkerReplication : AWSModel
@property (nonatomic, assign) AWSS3DeleteMarkerReplicationStatus status;
@end
@interface AWSS3DeleteObjectOutput : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable deleteMarker;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3DeleteObjectRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSNumber * _Nullable bypassGovernanceRetention;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable MFA;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3DeleteObjectTaggingOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3DeleteObjectTaggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3DeleteObjectsOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3DeletedObject *> * _Nullable deleted;
@property (nonatomic, strong) NSArray<AWSS3Error *> * _Nullable errors;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3DeleteObjectsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSNumber * _Nullable bypassGovernanceRetention;
@property (nonatomic, strong) AWSS3Remove * _Nullable remove;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable MFA;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@end
@interface AWSS3DeletePublicAccessBlockRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3DeletedObject : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable deleteMarker;
@property (nonatomic, strong) NSString * _Nullable deleteMarkerVersionId;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3Destination : AWSModel
@property (nonatomic, strong) AWSS3AccessControlTranslation * _Nullable accessControlTranslation;
@property (nonatomic, strong) NSString * _Nullable account;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) AWSS3EncryptionConfiguration * _Nullable encryptionConfiguration;
@property (nonatomic, strong) AWSS3Metrics * _Nullable metrics;
@property (nonatomic, strong) AWSS3ReplicationTime * _Nullable replicationTime;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@end
@interface AWSS3Encryption : AWSModel
@property (nonatomic, assign) AWSS3ServerSideEncryption encryptionType;
@property (nonatomic, strong) NSString * _Nullable KMSContext;
@property (nonatomic, strong) NSString * _Nullable KMSKeyId;
@end
@interface AWSS3EncryptionConfiguration : AWSModel
@property (nonatomic, strong) NSString * _Nullable replicaKmsKeyID;
@end
@interface AWSS3EndEvent : AWSModel
@end
@interface AWSS3Error : AWSModel
@property (nonatomic, strong) NSString * _Nullable code;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable message;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3ErrorDocument : AWSModel
@property (nonatomic, strong) NSString * _Nullable key;
@end
@interface AWSS3ExistingObjectReplication : AWSModel
@property (nonatomic, assign) AWSS3ExistingObjectReplicationStatus status;
@end
@interface AWSS3FilterRule : AWSModel
@property (nonatomic, assign) AWSS3FilterRuleName name;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSS3GetBucketAccelerateConfigurationOutput : AWSModel
@property (nonatomic, assign) AWSS3BucketAccelerateStatus status;
@end
@interface AWSS3GetBucketAccelerateConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketAclOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Grant *> * _Nullable grants;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@end
@interface AWSS3GetBucketAclRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketAnalyticsConfigurationOutput : AWSModel
@property (nonatomic, strong) AWSS3AnalyticsConfiguration * _Nullable analyticsConfiguration;
@end
@interface AWSS3GetBucketAnalyticsConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3GetBucketCorsOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3CORSRule *> * _Nullable CORSRules;
@end
@interface AWSS3GetBucketCorsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketEncryptionOutput : AWSModel
@property (nonatomic, strong) AWSS3ServerSideEncryptionConfiguration * _Nullable serverSideEncryptionConfiguration;
@end
@interface AWSS3GetBucketEncryptionRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketInventoryConfigurationOutput : AWSModel
@property (nonatomic, strong) AWSS3InventoryConfiguration * _Nullable inventoryConfiguration;
@end
@interface AWSS3GetBucketInventoryConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3GetBucketLifecycleConfigurationOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3LifecycleRule *> * _Nullable rules;
@end
@interface AWSS3GetBucketLifecycleConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketLifecycleOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Rule *> * _Nullable rules;
@end
@interface AWSS3GetBucketLifecycleRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketLocationOutput : AWSModel
@property (nonatomic, assign) AWSS3BucketLocationConstraint locationConstraint;
@end
@interface AWSS3GetBucketLocationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketLoggingOutput : AWSModel
@property (nonatomic, strong) AWSS3LoggingEnabled * _Nullable loggingEnabled;
@end
@interface AWSS3GetBucketLoggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketMetricsConfigurationOutput : AWSModel
@property (nonatomic, strong) AWSS3MetricsConfiguration * _Nullable metricsConfiguration;
@end
@interface AWSS3GetBucketMetricsConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3GetBucketNotificationConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketOwnershipControlsOutput : AWSModel
@property (nonatomic, strong) AWSS3OwnershipControls * _Nullable ownershipControls;
@end
@interface AWSS3GetBucketOwnershipControlsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketPolicyOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable policy;
@end
@interface AWSS3GetBucketPolicyRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketPolicyStatusOutput : AWSModel
@property (nonatomic, strong) AWSS3PolicyStatus * _Nullable policyStatus;
@end
@interface AWSS3GetBucketPolicyStatusRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketReplicationOutput : AWSModel
@property (nonatomic, strong) AWSS3ReplicationConfiguration * _Nullable replicationConfiguration;
@end
@interface AWSS3GetBucketReplicationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketRequestPaymentOutput : AWSModel
@property (nonatomic, assign) AWSS3Payer payer;
@end
@interface AWSS3GetBucketRequestPaymentRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketTaggingOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tagSet;
@end
@interface AWSS3GetBucketTaggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketVersioningOutput : AWSModel
@property (nonatomic, assign) AWSS3MFADeleteStatus MFADelete;
@property (nonatomic, assign) AWSS3BucketVersioningStatus status;
@end
@interface AWSS3GetBucketVersioningRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetBucketWebsiteOutput : AWSModel
@property (nonatomic, strong) AWSS3ErrorDocument * _Nullable errorDocument;
@property (nonatomic, strong) AWSS3IndexDocument * _Nullable indexDocument;
@property (nonatomic, strong) AWSS3RedirectAllRequestsTo * _Nullable redirectAllRequestsTo;
@property (nonatomic, strong) NSArray<AWSS3RoutingRule *> * _Nullable routingRules;
@end
@interface AWSS3GetBucketWebsiteRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetObjectAclOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Grant *> * _Nullable grants;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3GetObjectAclRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3GetObjectLegalHoldOutput : AWSModel
@property (nonatomic, strong) AWSS3ObjectLockLegalHold * _Nullable legalHold;
@end
@interface AWSS3GetObjectLegalHoldRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3GetObjectLockConfigurationOutput : AWSModel
@property (nonatomic, strong) AWSS3ObjectLockConfiguration * _Nullable objectLockConfiguration;
@end
@interface AWSS3GetObjectLockConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GetObjectOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable acceptRanges;
@property (nonatomic, strong) id _Nullable body;
@property (nonatomic, strong) NSString * _Nullable cacheControl;
@property (nonatomic, strong) NSString * _Nullable contentDisposition;
@property (nonatomic, strong) NSString * _Nullable contentEncoding;
@property (nonatomic, strong) NSString * _Nullable contentLanguage;
@property (nonatomic, strong) NSNumber * _Nullable contentLength;
@property (nonatomic, strong) NSString * _Nullable contentRange;
@property (nonatomic, strong) NSString * _Nullable contentType;
@property (nonatomic, strong) NSNumber * _Nullable deleteMarker;
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSString * _Nullable expiration;
@property (nonatomic, strong) NSDate * _Nullable expires;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable metadata;
@property (nonatomic, strong) NSNumber * _Nullable missingMeta;
@property (nonatomic, assign) AWSS3ObjectLockLegalHoldStatus objectLockLegalHoldStatus;
@property (nonatomic, assign) AWSS3ObjectLockMode objectLockMode;
@property (nonatomic, strong) NSDate * _Nullable objectLockRetainUntilDate;
@property (nonatomic, strong) NSNumber * _Nullable partsCount;
@property (nonatomic, assign) AWSS3ReplicationStatus replicationStatus;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable restore;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSNumber * _Nullable tagCount;
@property (nonatomic, strong) NSString * _Nullable versionId;
@property (nonatomic, strong) NSString * _Nullable websiteRedirectLocation;
@end
@interface AWSS3GetObjectRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable ifMatch;
@property (nonatomic, strong) NSDate * _Nullable ifModifiedSince;
@property (nonatomic, strong) NSString * _Nullable ifNoneMatch;
@property (nonatomic, strong) NSDate * _Nullable ifUnmodifiedSince;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSNumber * _Nullable partNumber;
@property (nonatomic, strong) NSString * _Nullable range;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable responseCacheControl;
@property (nonatomic, strong) NSString * _Nullable responseContentDisposition;
@property (nonatomic, strong) NSString * _Nullable responseContentEncoding;
@property (nonatomic, strong) NSString * _Nullable responseContentLanguage;
@property (nonatomic, strong) NSString * _Nullable responseContentType;
@property (nonatomic, strong) NSDate * _Nullable responseExpires;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3GetObjectRetentionOutput : AWSModel
@property (nonatomic, strong) AWSS3ObjectLockRetention * _Nullable retention;
@end
@interface AWSS3GetObjectRetentionRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3GetObjectTaggingOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tagSet;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3GetObjectTaggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3GetObjectTorrentOutput : AWSModel
@property (nonatomic, strong) id _Nullable body;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3GetObjectTorrentRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@end
@interface AWSS3GetPublicAccessBlockOutput : AWSModel
@property (nonatomic, strong) AWSS3PublicAccessBlockConfiguration * _Nullable publicAccessBlockConfiguration;
@end
@interface AWSS3GetPublicAccessBlockRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3GlacierJobParameters : AWSModel
@property (nonatomic, assign) AWSS3Tier tier;
@end
@interface AWSS3Grant : AWSModel
@property (nonatomic, strong) AWSS3Grantee * _Nullable grantee;
@property (nonatomic, assign) AWSS3Permission permission;
@end
@interface AWSS3Grantee : AWSModel
@property (nonatomic, strong) NSString * _Nullable displayName;
@property (nonatomic, strong) NSString * _Nullable emailAddress;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, assign) AWSS3Types types;
@property (nonatomic, strong) NSString * _Nullable URI;
@end
@interface AWSS3HeadBucketRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3HeadObjectOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable acceptRanges;
@property (nonatomic, strong) NSString * _Nullable cacheControl;
@property (nonatomic, strong) NSString * _Nullable contentDisposition;
@property (nonatomic, strong) NSString * _Nullable contentEncoding;
@property (nonatomic, strong) NSString * _Nullable contentLanguage;
@property (nonatomic, strong) NSNumber * _Nullable contentLength;
@property (nonatomic, strong) NSString * _Nullable contentType;
@property (nonatomic, strong) NSNumber * _Nullable deleteMarker;
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSString * _Nullable expiration;
@property (nonatomic, strong) NSDate * _Nullable expires;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable metadata;
@property (nonatomic, strong) NSNumber * _Nullable missingMeta;
@property (nonatomic, assign) AWSS3ObjectLockLegalHoldStatus objectLockLegalHoldStatus;
@property (nonatomic, assign) AWSS3ObjectLockMode objectLockMode;
@property (nonatomic, strong) NSDate * _Nullable objectLockRetainUntilDate;
@property (nonatomic, strong) NSNumber * _Nullable partsCount;
@property (nonatomic, assign) AWSS3ReplicationStatus replicationStatus;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable restore;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable versionId;
@property (nonatomic, strong) NSString * _Nullable websiteRedirectLocation;
@end
@interface AWSS3HeadObjectRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable ifMatch;
@property (nonatomic, strong) NSDate * _Nullable ifModifiedSince;
@property (nonatomic, strong) NSString * _Nullable ifNoneMatch;
@property (nonatomic, strong) NSDate * _Nullable ifUnmodifiedSince;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSNumber * _Nullable partNumber;
@property (nonatomic, strong) NSString * _Nullable range;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3IndexDocument : AWSModel
@property (nonatomic, strong) NSString * _Nullable suffix;
@end
@interface AWSS3Initiator : AWSModel
@property (nonatomic, strong) NSString * _Nullable displayName;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3InputSerialization : AWSModel
@property (nonatomic, strong) AWSS3CSVInput * _Nullable CSV;
@property (nonatomic, assign) AWSS3CompressionType compressionType;
@property (nonatomic, strong) AWSS3JSONInput * _Nullable JSON;
@property (nonatomic, strong) AWSS3ParquetInput * _Nullable parquet;
@end
@interface AWSS3InventoryConfiguration : AWSModel
@property (nonatomic, strong) AWSS3InventoryDestination * _Nullable destination;
@property (nonatomic, strong) AWSS3InventoryFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, assign) AWSS3InventoryIncludedObjectVersions includedObjectVersions;
@property (nonatomic, strong) NSNumber * _Nullable isEnabled;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable optionalFields;
@property (nonatomic, strong) AWSS3InventorySchedule * _Nullable schedule;
@end
@interface AWSS3InventoryDestination : AWSModel
@property (nonatomic, strong) AWSS3InventoryS3BucketDestination * _Nullable s3BucketDestination;
@end
@interface AWSS3InventoryEncryption : AWSModel
@property (nonatomic, strong) AWSS3SSEKMS * _Nullable SSEKMS;
@property (nonatomic, strong) AWSS3SSES3 * _Nullable SSES3;
@end
@interface AWSS3InventoryFilter : AWSModel
@property (nonatomic, strong) NSString * _Nullable prefix;
@end
@interface AWSS3InventoryS3BucketDestination : AWSModel
@property (nonatomic, strong) NSString * _Nullable accountId;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) AWSS3InventoryEncryption * _Nullable encryption;
@property (nonatomic, assign) AWSS3InventoryFormat format;
@property (nonatomic, strong) NSString * _Nullable prefix;
@end
@interface AWSS3InventorySchedule : AWSModel
@property (nonatomic, assign) AWSS3InventoryFrequency frequency;
@end
@interface AWSS3JSONInput : AWSModel
@property (nonatomic, assign) AWSS3JSONType types;
@end
@interface AWSS3JSONOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable recordDelimiter;
@end
@interface AWSS3LambdaFunctionConfiguration : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable events;
@property (nonatomic, strong) AWSS3NotificationConfigurationFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable lambdaFunctionArn;
@end
@interface AWSS3LifecycleConfiguration : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Rule *> * _Nullable rules;
@end
@interface AWSS3LifecycleExpiration : AWSModel
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic, strong) NSNumber * _Nullable days;
@property (nonatomic, strong) NSNumber * _Nullable expiredObjectDeleteMarker;
@end
@interface AWSS3LifecycleRule : AWSModel
@property (nonatomic, strong) AWSS3AbortIncompleteMultipartUpload * _Nullable abortIncompleteMultipartUpload;
@property (nonatomic, strong) AWSS3LifecycleExpiration * _Nullable expiration;
@property (nonatomic, strong) AWSS3LifecycleRuleFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSS3NoncurrentVersionExpiration * _Nullable noncurrentVersionExpiration;
@property (nonatomic, strong) NSArray<AWSS3NoncurrentVersionTransition *> * _Nullable noncurrentVersionTransitions;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, assign) AWSS3ExpirationStatus status;
@property (nonatomic, strong) NSArray<AWSS3Transition *> * _Nullable transitions;
@end
@interface AWSS3LifecycleRuleAndOperator : AWSModel
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tags;
@end
@interface AWSS3LifecycleRuleFilter : AWSModel
@property (nonatomic, strong) AWSS3LifecycleRuleAndOperator * _Nullable AND;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) AWSS3Tag * _Nullable tag;
@end
@interface AWSS3ListBucketAnalyticsConfigurationsOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3AnalyticsConfiguration *> * _Nullable analyticsConfigurationList;
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSString * _Nullable nextContinuationToken;
@end
@interface AWSS3ListBucketAnalyticsConfigurationsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3ListBucketInventoryConfigurationsOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSArray<AWSS3InventoryConfiguration *> * _Nullable inventoryConfigurationList;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSString * _Nullable nextContinuationToken;
@end
@interface AWSS3ListBucketInventoryConfigurationsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3ListBucketMetricsConfigurationsOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSArray<AWSS3MetricsConfiguration *> * _Nullable metricsConfigurationList;
@property (nonatomic, strong) NSString * _Nullable nextContinuationToken;
@end
@interface AWSS3ListBucketMetricsConfigurationsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3ListBucketsOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Bucket *> * _Nullable buckets;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@end
@interface AWSS3ListMultipartUploadsOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSArray<AWSS3CommonPrefix *> * _Nullable commonPrefixes;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSString * _Nullable keyMarker;
@property (nonatomic, strong) NSNumber * _Nullable maxUploads;
@property (nonatomic, strong) NSString * _Nullable nextKeyMarker;
@property (nonatomic, strong) NSString * _Nullable nextUploadIdMarker;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSString * _Nullable uploadIdMarker;
@property (nonatomic, strong) NSArray<AWSS3MultipartUpload *> * _Nullable uploads;
@end
@interface AWSS3ListMultipartUploadsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable keyMarker;
@property (nonatomic, strong) NSNumber * _Nullable maxUploads;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSString * _Nullable uploadIdMarker;
@end
@interface AWSS3ListObjectVersionsOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3CommonPrefix *> * _Nullable commonPrefixes;
@property (nonatomic, strong) NSArray<AWSS3DeleteMarkerEntry *> * _Nullable deleteMarkers;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSString * _Nullable keyMarker;
@property (nonatomic, strong) NSNumber * _Nullable maxKeys;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSString * _Nullable nextKeyMarker;
@property (nonatomic, strong) NSString * _Nullable nextVersionIdMarker;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSString * _Nullable versionIdMarker;
@property (nonatomic, strong) NSArray<AWSS3ObjectVersion *> * _Nullable versions;
@end
@interface AWSS3ListObjectVersionsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable keyMarker;
@property (nonatomic, strong) NSNumber * _Nullable maxKeys;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSString * _Nullable versionIdMarker;
@end
@interface AWSS3ListObjectsOutput : AWSModel
@property (nonatomic, strong) NSArray<AWSS3CommonPrefix *> * _Nullable commonPrefixes;
@property (nonatomic, strong) NSArray<AWSS3Object *> * _Nullable contents;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSString * _Nullable marker;
@property (nonatomic, strong) NSNumber * _Nullable maxKeys;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSString * _Nullable nextMarker;
@property (nonatomic, strong) NSString * _Nullable prefix;
@end
@interface AWSS3ListObjectsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable marker;
@property (nonatomic, strong) NSNumber * _Nullable maxKeys;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@end
@interface AWSS3ListObjectsV2Output : AWSModel
@property (nonatomic, strong) NSArray<AWSS3CommonPrefix *> * _Nullable commonPrefixes;
@property (nonatomic, strong) NSArray<AWSS3Object *> * _Nullable contents;
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSNumber * _Nullable keyCount;
@property (nonatomic, strong) NSNumber * _Nullable maxKeys;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSString * _Nullable nextContinuationToken;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSString * _Nullable startAfter;
@end
@interface AWSS3ListObjectsV2Request : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable continuationToken;
@property (nonatomic, strong) NSString * _Nullable delimiter;
@property (nonatomic, assign) AWSS3EncodingType encodingType;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSNumber * _Nullable fetchOwner;
@property (nonatomic, strong) NSNumber * _Nullable maxKeys;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable startAfter;
@end
@interface AWSS3ListPartsOutput : AWSModel
@property (nonatomic, strong) NSDate * _Nullable abortDate;
@property (nonatomic, strong) NSString * _Nullable abortRuleId;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) AWSS3Initiator * _Nullable initiator;
@property (nonatomic, strong) NSNumber * _Nullable isTruncated;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSNumber * _Nullable maxParts;
@property (nonatomic, strong) NSNumber * _Nullable nextPartNumberMarker;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@property (nonatomic, strong) NSNumber * _Nullable partNumberMarker;
@property (nonatomic, strong) NSArray<AWSS3Part *> * _Nullable parts;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3ListPartsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSNumber * _Nullable maxParts;
@property (nonatomic, strong) NSNumber * _Nullable partNumberMarker;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3LoggingEnabled : AWSModel
@property (nonatomic, strong) NSString * _Nullable targetBucket;
@property (nonatomic, strong) NSArray<AWSS3TargetGrant *> * _Nullable targetGrants;
@property (nonatomic, strong) NSString * _Nullable targetPrefix;
@end
@interface AWSS3MetadataEntry : AWSModel
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSS3Metrics : AWSModel
@property (nonatomic, strong) AWSS3ReplicationTimeValue * _Nullable eventThreshold;
@property (nonatomic, assign) AWSS3MetricsStatus status;
@end
@interface AWSS3MetricsAndOperator : AWSModel
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tags;
@end
@interface AWSS3MetricsConfiguration : AWSModel
@property (nonatomic, strong) AWSS3MetricsFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3MetricsFilter : AWSModel
@property (nonatomic, strong) AWSS3MetricsAndOperator * _Nullable AND;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) AWSS3Tag * _Nullable tag;
@end
@interface AWSS3MultipartUpload : AWSModel
@property (nonatomic, strong) NSDate * _Nullable initiated;
@property (nonatomic, strong) AWSS3Initiator * _Nullable initiator;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3NoncurrentVersionExpiration : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable noncurrentDays;
@end
@interface AWSS3NoncurrentVersionTransition : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable noncurrentDays;
@property (nonatomic, assign) AWSS3TransitionStorageClass storageClass;
@end
@interface AWSS3NotificationConfiguration : AWSModel
@property (nonatomic, strong) NSArray<AWSS3LambdaFunctionConfiguration *> * _Nullable lambdaFunctionConfigurations;
@property (nonatomic, strong) NSArray<AWSS3QueueConfiguration *> * _Nullable queueConfigurations;
@property (nonatomic, strong) NSArray<AWSS3TopicConfiguration *> * _Nullable topicConfigurations;
@end
@interface AWSS3NotificationConfigurationDeprecated : AWSModel
@property (nonatomic, strong) AWSS3CloudFunctionConfiguration * _Nullable cloudFunctionConfiguration;
@property (nonatomic, strong) AWSS3QueueConfigurationDeprecated * _Nullable queueConfiguration;
@property (nonatomic, strong) AWSS3TopicConfigurationDeprecated * _Nullable topicConfiguration;
@end
@interface AWSS3NotificationConfigurationFilter : AWSModel
@property (nonatomic, strong) AWSS3S3KeyFilter * _Nullable key;
@end
@interface AWSS3Object : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@property (nonatomic, strong) NSNumber * _Nullable size;
@property (nonatomic, assign) AWSS3ObjectStorageClass storageClass;
@end
@interface AWSS3ObjectIdentifier : AWSModel
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3ObjectLockConfiguration : AWSModel
@property (nonatomic, assign) AWSS3ObjectLockEnabled objectLockEnabled;
@property (nonatomic, strong) AWSS3ObjectLockRule * _Nullable rule;
@end
@interface AWSS3ObjectLockLegalHold : AWSModel
@property (nonatomic, assign) AWSS3ObjectLockLegalHoldStatus status;
@end
@interface AWSS3ObjectLockRetention : AWSModel
@property (nonatomic, assign) AWSS3ObjectLockRetentionMode mode;
@property (nonatomic, strong) NSDate * _Nullable retainUntilDate;
@end
@interface AWSS3ObjectLockRule : AWSModel
@property (nonatomic, strong) AWSS3DefaultRetention * _Nullable defaultRetention;
@end
@interface AWSS3ObjectVersion : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSNumber * _Nullable isLatest;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@property (nonatomic, strong) AWSS3Owner * _Nullable owner;
@property (nonatomic, strong) NSNumber * _Nullable size;
@property (nonatomic, assign) AWSS3ObjectVersionStorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3OutputLocation : AWSModel
@property (nonatomic, strong) AWSS3S3Location * _Nullable s3;
@end
@interface AWSS3OutputSerialization : AWSModel
@property (nonatomic, strong) AWSS3CSVOutput * _Nullable CSV;
@property (nonatomic, strong) AWSS3JSONOutput * _Nullable JSON;
@end
@interface AWSS3Owner : AWSModel
@property (nonatomic, strong) NSString * _Nullable displayName;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3OwnershipControls : AWSModel
@property (nonatomic, strong) NSArray<AWSS3OwnershipControlsRule *> * _Nullable rules;
@end
@interface AWSS3OwnershipControlsRule : AWSModel
@property (nonatomic, assign) AWSS3ObjectOwnership objectOwnership;
@end
@interface AWSS3ParquetInput : AWSModel
@end
@interface AWSS3Part : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSDate * _Nullable lastModified;
@property (nonatomic, strong) NSNumber * _Nullable partNumber;
@property (nonatomic, strong) NSNumber * _Nullable size;
@end
@interface AWSS3PolicyStatus : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable isPublic;
@end
@interface AWSS3Progress : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable bytesProcessed;
@property (nonatomic, strong) NSNumber * _Nullable bytesReturned;
@property (nonatomic, strong) NSNumber * _Nullable bytesScanned;
@end
@interface AWSS3ProgressEvent : AWSModel
@property (nonatomic, strong) AWSS3Progress * _Nullable details;
@end
@interface AWSS3PublicAccessBlockConfiguration : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable blockPublicAcls;
@property (nonatomic, strong) NSNumber * _Nullable blockPublicPolicy;
@property (nonatomic, strong) NSNumber * _Nullable ignorePublicAcls;
@property (nonatomic, strong) NSNumber * _Nullable restrictPublicBuckets;
@end
@interface AWSS3PutBucketAccelerateConfigurationRequest : AWSRequest
@property (nonatomic, strong) AWSS3AccelerateConfiguration * _Nullable accelerateConfiguration;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3PutBucketAclRequest : AWSRequest
@property (nonatomic, assign) AWSS3BucketCannedACL ACL;
@property (nonatomic, strong) AWSS3AccessControlPolicy * _Nullable accessControlPolicy;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable grantFullControl;
@property (nonatomic, strong) NSString * _Nullable grantRead;
@property (nonatomic, strong) NSString * _Nullable grantReadACP;
@property (nonatomic, strong) NSString * _Nullable grantWrite;
@property (nonatomic, strong) NSString * _Nullable grantWriteACP;
@end
@interface AWSS3PutBucketAnalyticsConfigurationRequest : AWSRequest
@property (nonatomic, strong) AWSS3AnalyticsConfiguration * _Nullable analyticsConfiguration;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@end
@interface AWSS3PutBucketCorsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) AWSS3CORSConfiguration * _Nullable CORSConfiguration;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3PutBucketEncryptionRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3ServerSideEncryptionConfiguration * _Nullable serverSideEncryptionConfiguration;
@end
@interface AWSS3PutBucketInventoryConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSS3InventoryConfiguration * _Nullable inventoryConfiguration;
@end
@interface AWSS3PutBucketLifecycleConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3BucketLifecycleConfiguration * _Nullable lifecycleConfiguration;
@end
@interface AWSS3PutBucketLifecycleRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3LifecycleConfiguration * _Nullable lifecycleConfiguration;
@end
@interface AWSS3PutBucketLoggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) AWSS3BucketLoggingStatus * _Nullable bucketLoggingStatus;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@end
@interface AWSS3PutBucketMetricsConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSS3MetricsConfiguration * _Nullable metricsConfiguration;
@end
@interface AWSS3PutBucketNotificationConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3NotificationConfiguration * _Nullable notificationConfiguration;
@end
@interface AWSS3PutBucketNotificationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3NotificationConfigurationDeprecated * _Nullable notificationConfiguration;
@end
@interface AWSS3PutBucketOwnershipControlsRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3OwnershipControls * _Nullable ownershipControls;
@end
@interface AWSS3PutBucketPolicyRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSNumber * _Nullable confirmRemoveSelfBucketAccess;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable policy;
@end
@interface AWSS3PutBucketReplicationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3ReplicationConfiguration * _Nullable replicationConfiguration;
@property (nonatomic, strong) NSString * _Nullable token;
@end
@interface AWSS3PutBucketRequestPaymentRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3RequestPaymentConfiguration * _Nullable requestPaymentConfiguration;
@end
@interface AWSS3PutBucketTaggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3Tagging * _Nullable tagging;
@end
@interface AWSS3PutBucketVersioningRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable MFA;
@property (nonatomic, strong) AWSS3VersioningConfiguration * _Nullable versioningConfiguration;
@end
@interface AWSS3PutBucketWebsiteRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3WebsiteConfiguration * _Nullable websiteConfiguration;
@end
@interface AWSS3PutObjectAclOutput : AWSModel
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3PutObjectAclRequest : AWSRequest
@property (nonatomic, assign) AWSS3ObjectCannedACL ACL;
@property (nonatomic, strong) AWSS3AccessControlPolicy * _Nullable accessControlPolicy;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable grantFullControl;
@property (nonatomic, strong) NSString * _Nullable grantRead;
@property (nonatomic, strong) NSString * _Nullable grantReadACP;
@property (nonatomic, strong) NSString * _Nullable grantWrite;
@property (nonatomic, strong) NSString * _Nullable grantWriteACP;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3PutObjectLegalHoldOutput : AWSModel
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3PutObjectLegalHoldRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) AWSS3ObjectLockLegalHold * _Nullable legalHold;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3PutObjectLockConfigurationOutput : AWSModel
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3PutObjectLockConfigurationRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3ObjectLockConfiguration * _Nullable objectLockConfiguration;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable token;
@end
@interface AWSS3PutObjectOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, strong) NSString * _Nullable expiration;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSEncryptionContext;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3PutObjectRequest : AWSRequest
@property (nonatomic, assign) AWSS3ObjectCannedACL ACL;
@property (nonatomic, strong) id _Nullable body;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable cacheControl;
@property (nonatomic, strong) NSString * _Nullable contentDisposition;
@property (nonatomic, strong) NSString * _Nullable contentEncoding;
@property (nonatomic, strong) NSString * _Nullable contentLanguage;
@property (nonatomic, strong) NSNumber * _Nullable contentLength;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable contentType;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSDate * _Nullable expires;
@property (nonatomic, strong) NSString * _Nullable grantFullControl;
@property (nonatomic, strong) NSString * _Nullable grantRead;
@property (nonatomic, strong) NSString * _Nullable grantReadACP;
@property (nonatomic, strong) NSString * _Nullable grantWriteACP;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable metadata;
@property (nonatomic, assign) AWSS3ObjectLockLegalHoldStatus objectLockLegalHoldStatus;
@property (nonatomic, assign) AWSS3ObjectLockMode objectLockMode;
@property (nonatomic, strong) NSDate * _Nullable objectLockRetainUntilDate;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSEncryptionContext;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) NSString * _Nullable tagging;
@property (nonatomic, strong) NSString * _Nullable websiteRedirectLocation;
@end
@interface AWSS3PutObjectRetentionOutput : AWSModel
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@end
@interface AWSS3PutObjectRetentionRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSNumber * _Nullable bypassGovernanceRetention;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) AWSS3ObjectLockRetention * _Nullable retention;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3PutObjectTaggingOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3PutObjectTaggingRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) AWSS3Tagging * _Nullable tagging;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3PutPublicAccessBlockRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) AWSS3PublicAccessBlockConfiguration * _Nullable publicAccessBlockConfiguration;
@end
@interface AWSS3QueueConfiguration : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable events;
@property (nonatomic, strong) AWSS3NotificationConfigurationFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable queueArn;
@end
@interface AWSS3QueueConfigurationDeprecated : AWSModel
@property (nonatomic, assign) AWSS3Event event;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable events;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable queue;
@end
@interface AWSS3RecordsEvent : AWSModel
@property (nonatomic, strong) id _Nullable payload;
@end
@interface AWSS3Redirect : AWSModel
@property (nonatomic, strong) NSString * _Nullable hostName;
@property (nonatomic, strong) NSString * _Nullable httpRedirectCode;
@property (nonatomic, assign) AWSS3Protocols protocols;
@property (nonatomic, strong) NSString * _Nullable replaceKeyPrefixWith;
@property (nonatomic, strong) NSString * _Nullable replaceKeyWith;
@end
@interface AWSS3RedirectAllRequestsTo : AWSModel
@property (nonatomic, strong) NSString * _Nullable hostName;
@property (nonatomic, assign) AWSS3Protocols protocols;
@end
@interface AWSS3ReplicationConfiguration : AWSModel
@property (nonatomic, strong) NSString * _Nullable role;
@property (nonatomic, strong) NSArray<AWSS3ReplicationRule *> * _Nullable rules;
@end
@interface AWSS3ReplicationRule : AWSModel
@property (nonatomic, strong) AWSS3DeleteMarkerReplication * _Nullable deleteMarkerReplication;
@property (nonatomic, strong) AWSS3Destination * _Nullable destination;
@property (nonatomic, strong) AWSS3ExistingObjectReplication * _Nullable existingObjectReplication;
@property (nonatomic, strong) AWSS3ReplicationRuleFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSNumber * _Nullable priority;
@property (nonatomic, strong) AWSS3SourceSelectionCriteria * _Nullable sourceSelectionCriteria;
@property (nonatomic, assign) AWSS3ReplicationRuleStatus status;
@end
@interface AWSS3ReplicationRuleAndOperator : AWSModel
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tags;
@end
@interface AWSS3ReplicationRuleFilter : AWSModel
@property (nonatomic, strong) AWSS3ReplicationRuleAndOperator * _Nullable AND;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, strong) AWSS3Tag * _Nullable tag;
@end
@interface AWSS3ReplicationTime : AWSModel
@property (nonatomic, assign) AWSS3ReplicationTimeStatus status;
@property (nonatomic, strong) AWSS3ReplicationTimeValue * _Nullable time;
@end
@interface AWSS3ReplicationTimeValue : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable minutes;
@end
@interface AWSS3RequestPaymentConfiguration : AWSModel
@property (nonatomic, assign) AWSS3Payer payer;
@end
@interface AWSS3RequestProgress : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable enabled;
@end
@interface AWSS3RestoreObjectOutput : AWSModel
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable restoreOutputPath;
@end
@interface AWSS3RestoreObjectRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) AWSS3RestoreRequest * _Nullable restoreRequest;
@property (nonatomic, strong) NSString * _Nullable versionId;
@end
@interface AWSS3RestoreRequest : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable days;
@property (nonatomic, strong) NSString * _Nullable detail;
@property (nonatomic, strong) AWSS3GlacierJobParameters * _Nullable glacierJobParameters;
@property (nonatomic, strong) AWSS3OutputLocation * _Nullable outputLocation;
@property (nonatomic, strong) AWSS3SelectParameters * _Nullable selectParameters;
@property (nonatomic, assign) AWSS3Tier tier;
@property (nonatomic, assign) AWSS3RestoreRequestType types;
@end
@interface AWSS3RoutingRule : AWSModel
@property (nonatomic, strong) AWSS3Condition * _Nullable condition;
@property (nonatomic, strong) AWSS3Redirect * _Nullable redirect;
@end
@interface AWSS3Rule : AWSModel
@property (nonatomic, strong) AWSS3AbortIncompleteMultipartUpload * _Nullable abortIncompleteMultipartUpload;
@property (nonatomic, strong) AWSS3LifecycleExpiration * _Nullable expiration;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) AWSS3NoncurrentVersionExpiration * _Nullable noncurrentVersionExpiration;
@property (nonatomic, strong) AWSS3NoncurrentVersionTransition * _Nullable noncurrentVersionTransition;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, assign) AWSS3ExpirationStatus status;
@property (nonatomic, strong) AWSS3Transition * _Nullable transition;
@end
@interface AWSS3S3KeyFilter : AWSModel
@property (nonatomic, strong) NSArray<AWSS3FilterRule *> * _Nullable filterRules;
@end
@interface AWSS3S3Location : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Grant *> * _Nullable accessControlList;
@property (nonatomic, strong) NSString * _Nullable bucketName;
@property (nonatomic, assign) AWSS3ObjectCannedACL cannedACL;
@property (nonatomic, strong) AWSS3Encryption * _Nullable encryption;
@property (nonatomic, strong) NSString * _Nullable prefix;
@property (nonatomic, assign) AWSS3StorageClass storageClass;
@property (nonatomic, strong) AWSS3Tagging * _Nullable tagging;
@property (nonatomic, strong) NSArray<AWSS3MetadataEntry *> * _Nullable userMetadata;
@end
@interface AWSS3SSEKMS : AWSModel
@property (nonatomic, strong) NSString * _Nullable keyId;
@end
@interface AWSS3SSES3 : AWSModel
@end
@interface AWSS3ScanRange : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable end;
@property (nonatomic, strong) NSNumber * _Nullable start;
@end
@interface AWSS3SelectObjectContentEventStream : AWSModel
@property (nonatomic, strong) AWSS3ContinuationEvent * _Nullable cont;
@property (nonatomic, strong) AWSS3EndEvent * _Nullable end;
@property (nonatomic, strong) AWSS3ProgressEvent * _Nullable progress;
@property (nonatomic, strong) AWSS3RecordsEvent * _Nullable records;
@property (nonatomic, strong) AWSS3StatsEvent * _Nullable stats;
@end
@interface AWSS3SelectObjectContentOutput : AWSModel
@property (nonatomic, strong) AWSS3SelectObjectContentEventStream * _Nullable payload;
@end
@interface AWSS3SelectObjectContentRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable expression;
@property (nonatomic, assign) AWSS3ExpressionType expressionType;
@property (nonatomic, strong) AWSS3InputSerialization * _Nullable inputSerialization;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) AWSS3OutputSerialization * _Nullable outputSerialization;
@property (nonatomic, strong) AWSS3RequestProgress * _Nullable requestProgress;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) AWSS3ScanRange * _Nullable scanRange;
@end
@interface AWSS3SelectParameters : AWSModel
@property (nonatomic, strong) NSString * _Nullable expression;
@property (nonatomic, assign) AWSS3ExpressionType expressionType;
@property (nonatomic, strong) AWSS3InputSerialization * _Nullable inputSerialization;
@property (nonatomic, strong) AWSS3OutputSerialization * _Nullable outputSerialization;
@end
@interface AWSS3ServerSideEncryptionByDefault : AWSModel
@property (nonatomic, strong) NSString * _Nullable KMSMasterKeyID;
@property (nonatomic, assign) AWSS3ServerSideEncryption SSEAlgorithm;
@end
@interface AWSS3ServerSideEncryptionConfiguration : AWSModel
@property (nonatomic, strong) NSArray<AWSS3ServerSideEncryptionRule *> * _Nullable rules;
@end
@interface AWSS3ServerSideEncryptionRule : AWSModel
@property (nonatomic, strong) AWSS3ServerSideEncryptionByDefault * _Nullable applyServerSideEncryptionByDefault;
@end
@interface AWSS3SourceSelectionCriteria : AWSModel
@property (nonatomic, strong) AWSS3SseKmsEncryptedObjects * _Nullable sseKmsEncryptedObjects;
@end
@interface AWSS3SseKmsEncryptedObjects : AWSModel
@property (nonatomic, assign) AWSS3SseKmsEncryptedObjectsStatus status;
@end
@interface AWSS3Stats : AWSModel
@property (nonatomic, strong) NSNumber * _Nullable bytesProcessed;
@property (nonatomic, strong) NSNumber * _Nullable bytesReturned;
@property (nonatomic, strong) NSNumber * _Nullable bytesScanned;
@end
@interface AWSS3StatsEvent : AWSModel
@property (nonatomic, strong) AWSS3Stats * _Nullable details;
@end
@interface AWSS3StorageClassAnalysis : AWSModel
@property (nonatomic, strong) AWSS3StorageClassAnalysisDataExport * _Nullable dataExport;
@end
@interface AWSS3StorageClassAnalysisDataExport : AWSModel
@property (nonatomic, strong) AWSS3AnalyticsExportDestination * _Nullable destination;
@property (nonatomic, assign) AWSS3StorageClassAnalysisSchemaVersion outputSchemaVersion;
@end
@interface AWSS3Tag : AWSModel
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSString * _Nullable value;
@end
@interface AWSS3Tagging : AWSModel
@property (nonatomic, strong) NSArray<AWSS3Tag *> * _Nullable tagSet;
@end
@interface AWSS3TargetGrant : AWSModel
@property (nonatomic, strong) AWSS3Grantee * _Nullable grantee;
@property (nonatomic, assign) AWSS3BucketLogsPermission permission;
@end
@interface AWSS3TopicConfiguration : AWSModel
@property (nonatomic, strong) NSArray<NSString *> * _Nullable events;
@property (nonatomic, strong) AWSS3NotificationConfigurationFilter * _Nullable filter;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable topicArn;
@end
@interface AWSS3TopicConfigurationDeprecated : AWSModel
@property (nonatomic, assign) AWSS3Event event;
@property (nonatomic, strong) NSArray<NSString *> * _Nullable events;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSString * _Nullable topic;
@end
@interface AWSS3Transition : AWSModel
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic, strong) NSNumber * _Nullable days;
@property (nonatomic, assign) AWSS3TransitionStorageClass storageClass;
@end
@interface AWSS3UploadPartCopyOutput : AWSModel
@property (nonatomic, strong) AWSS3ReplicatePartResult * _Nullable replicatePartResult;
@property (nonatomic, strong) NSString * _Nullable replicateSourceVersionId;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@end
@interface AWSS3UploadPartCopyRequest : AWSRequest
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSString * _Nullable replicateSource;
@property (nonatomic, strong) NSString * _Nullable replicateSourceIfMatch;
@property (nonatomic, strong) NSDate * _Nullable replicateSourceIfModifiedSince;
@property (nonatomic, strong) NSString * _Nullable replicateSourceIfNoneMatch;
@property (nonatomic, strong) NSDate * _Nullable replicateSourceIfUnmodifiedSince;
@property (nonatomic, strong) NSString * _Nullable replicateSourceRange;
@property (nonatomic, strong) NSString * _Nullable replicateSourceSSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable replicateSourceSSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable replicateSourceSSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable expectedSourceBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSNumber * _Nullable partNumber;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3UploadPartOutput : AWSModel
@property (nonatomic, strong) NSString * _Nullable ETag;
@property (nonatomic, assign) AWSS3RequestCharged requestCharged;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable SSEKMSKeyId;
@property (nonatomic, assign) AWSS3ServerSideEncryption serverSideEncryption;
@end
@interface AWSS3UploadPartRequest : AWSRequest
@property (nonatomic, strong) id _Nullable body;
@property (nonatomic, strong) NSString * _Nullable bucket;
@property (nonatomic, strong) NSNumber * _Nullable contentLength;
@property (nonatomic, strong) NSString * _Nullable contentMD5;
@property (nonatomic, strong) NSString * _Nullable expectedBucketOwner;
@property (nonatomic, strong) NSString * _Nullable key;
@property (nonatomic, strong) NSNumber * _Nullable partNumber;
@property (nonatomic, assign) AWSS3RequestPayer requestPayer;
@property (nonatomic, strong) NSString * _Nullable SSECustomerAlgorithm;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKey;
@property (nonatomic, strong) NSString * _Nullable SSECustomerKeyMD5;
@property (nonatomic, strong) NSString * _Nullable uploadId;
@end
@interface AWSS3VersioningConfiguration : AWSModel
@property (nonatomic, assign) AWSS3MFADelete MFADelete;
@property (nonatomic, assign) AWSS3BucketVersioningStatus status;
@end
@interface AWSS3WebsiteConfiguration : AWSModel
@property (nonatomic, strong) AWSS3ErrorDocument * _Nullable errorDocument;
@property (nonatomic, strong) AWSS3IndexDocument * _Nullable indexDocument;
@property (nonatomic, strong) AWSS3RedirectAllRequestsTo * _Nullable redirectAllRequestsTo;
@property (nonatomic, strong) NSArray<AWSS3RoutingRule *> * _Nullable routingRules;
@end
NS_ASSUME_NONNULL_END