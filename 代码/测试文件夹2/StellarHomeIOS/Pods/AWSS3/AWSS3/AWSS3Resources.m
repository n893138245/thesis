#import "AWSS3Resources.h"
#import <AWSCore/AWSCocoaLumberjack.h>
@interface AWSS3Resources ()
@property (nonatomic, strong) NSDictionary *definitionDictionary;
@end
@implementation AWSS3Resources
+ (instancetype)sharedInstance {
    static AWSS3Resources *_sharedResources = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _sharedResources = [AWSS3Resources new];
    });
    return _sharedResources;
}
- (NSDictionary *)JSONObject {
    return self.definitionDictionary;
}
- (instancetype)init {
    if (self = [super init]) {
        NSError *error = nil;
        _definitionDictionary = [NSJSONSerialization JSONObjectWithData:[[self definitionString] dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:kNilOptions
                                                                  error:&error];
        if (_definitionDictionary == nil) {
            if (error) {
                AWSDDLogError(@"Failed to parse JSON service definition: %@",error);
            }
        }
    }
    return self;
}
- (NSString *)definitionString {
    return @"{\
  \"version\":\"2.0\",\
  \"metadata\":{\
    \"apiVersion\":\"2006-03-01\",\
    \"checksumFormat\":\"md5\",\
    \"endpointPrefix\":\"s3\",\
    \"globalEndpoint\":\"s3.amazonaws.com\",\
    \"protocol\":\"rest-xml\",\
    \"serviceAbbreviation\":\"Amazon S3\",\
    \"serviceFullName\":\"Amazon Simple Storage Service\",\
    \"serviceId\":\"S3\",\
    \"signatureVersion\":\"s3\",\
    \"uid\":\"s3-2006-03-01\"\
  },\
  \"operations\":{\
    \"AbortMultipartUpload\":{\
      \"name\":\"AbortMultipartUpload\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}/{Key+}\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"AbortMultipartUploadRequest\"},\
      \"output\":{\"shape\":\"AbortMultipartUploadOutput\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchUpload\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This operation aborts a multipart upload. After a multipart upload is aborted, no additional parts can be uploaded using that upload ID. The storage consumed by any previously uploaded parts will be freed. However, if any part uploads are currently in progress, those part uploads might or might not succeed. As a result, it might be necessary to abort a given multipart upload multiple times in order to completely free all storage consumed by all parts. </p> <p>To verify that all parts have been removed, so you don't get charged for the part storage, you should call the <a href=\\\"https:
    },\
    \"CompleteMultipartUpload\":{\
      \"name\":\"CompleteMultipartUpload\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"CompleteMultipartUploadRequest\"},\
      \"output\":{\"shape\":\"CompleteMultipartUploadOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Completes a multipart upload by assembling previously uploaded parts.</p> <p>You first initiate the multipart upload and then upload all parts using the <a href=\\\"https:
    },\
    \"CopyObject\":{\
      \"name\":\"CopyObject\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"CopyObjectRequest\"},\
      \"output\":{\"shape\":\"CopyObjectOutput\"},\
      \"errors\":[\
        {\"shape\":\"ObjectNotInActiveTierError\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Creates a copy of an object that is already stored in Amazon S3.</p> <note> <p>You can store individual objects of up to 5 TB in Amazon S3. You create a copy of your object up to 5 GB in size in a single atomic operation using this API. However, to copy an object greater than 5 GB, you must use the multipart upload Upload Part - Copy API. For more information, see <a href=\\\"https:
      \"alias\":\"PutObjectCopy\"\
    },\
    \"CreateBucket\":{\
      \"name\":\"CreateBucket\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}\"\
      },\
      \"input\":{\"shape\":\"CreateBucketRequest\"},\
      \"output\":{\"shape\":\"CreateBucketOutput\"},\
      \"errors\":[\
        {\"shape\":\"BucketAlreadyExists\"},\
        {\"shape\":\"BucketAlreadyOwnedByYou\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Creates a new S3 bucket. To create a bucket, you must register with Amazon S3 and have a valid AWS Access Key ID to authenticate requests. Anonymous requests are never allowed to create buckets. By creating the bucket, you become the bucket owner.</p> <p>Not every string is an acceptable bucket name. For information about bucket naming restrictions, see <a href=\\\"https:
      \"alias\":\"PutBucket\"\
    },\
    \"CreateMultipartUpload\":{\
      \"name\":\"CreateMultipartUpload\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/{Bucket}/{Key+}?uploads\"\
      },\
      \"input\":{\"shape\":\"CreateMultipartUploadRequest\"},\
      \"output\":{\"shape\":\"CreateMultipartUploadOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This operation initiates a multipart upload and returns an upload ID. This upload ID is used to associate all of the parts in the specific multipart upload. You specify this upload ID in each of your subsequent upload part requests (see <a href=\\\"https:
      \"alias\":\"InitiateMultipartUpload\"\
    },\
    \"DeleteBucket\":{\
      \"name\":\"DeleteBucket\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Deletes the S3 bucket. All objects (including all object versions and delete markers) in the bucket must be deleted before the bucket itself can be deleted.</p> <p class=\\\"title\\\"> <b>Related Resources</b> </p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"DeleteBucketAnalyticsConfiguration\":{\
      \"name\":\"DeleteBucketAnalyticsConfiguration\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?analytics\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketAnalyticsConfigurationRequest\"},\
      \"documentation\":\"<p>Deletes an analytics configuration for the bucket (specified by the analytics configuration ID).</p> <p>To use this operation, you must have permissions to perform the <code>s3:PutAnalyticsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"DeleteBucketCors\":{\
      \"name\":\"DeleteBucketCors\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?cors\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketCorsRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Deletes the <code>cors</code> configuration information set for the bucket.</p> <p>To use this operation, you must have permission to perform the <code>s3:PutBucketCORS</code> action. The bucket owner has this permission by default and can grant this permission to others. </p> <p>For information about <code>cors</code>, see <a href=\\\"https:
    },\
    \"DeleteBucketEncryption\":{\
      \"name\":\"DeleteBucketEncryption\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?encryption\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketEncryptionRequest\"},\
      \"documentation\":\"<p>This implementation of the DELETE operation removes default encryption from the bucket. For information about the Amazon S3 default encryption feature, see <a href=\\\"https:
    },\
    \"DeleteBucketInventoryConfiguration\":{\
      \"name\":\"DeleteBucketInventoryConfiguration\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?inventory\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketInventoryConfigurationRequest\"},\
      \"documentation\":\"<p>Deletes an inventory configuration (identified by the inventory ID) from the bucket.</p> <p>To use this operation, you must have permissions to perform the <code>s3:PutInventoryConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"DeleteBucketLifecycle\":{\
      \"name\":\"DeleteBucketLifecycle\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?lifecycle\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketLifecycleRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Deletes the lifecycle configuration from the specified bucket. Amazon S3 removes all the lifecycle configuration rules in the lifecycle subresource associated with the bucket. Your objects never expire, and Amazon S3 no longer automatically deletes any objects on the basis of rules contained in the deleted lifecycle configuration.</p> <p>To use this operation, you must have permission to perform the <code>s3:PutLifecycleConfiguration</code> action. By default, the bucket owner has this permission and the bucket owner can grant this permission to others.</p> <p>There is usually some time lag before lifecycle configuration deletion is fully propagated to all the Amazon S3 systems.</p> <p>For more information about the object expiration, see <a href=\\\"https:
    },\
    \"DeleteBucketMetricsConfiguration\":{\
      \"name\":\"DeleteBucketMetricsConfiguration\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?metrics\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketMetricsConfigurationRequest\"},\
      \"documentation\":\"<p>Deletes a metrics configuration for the Amazon CloudWatch request metrics (specified by the metrics configuration ID) from the bucket. Note that this doesn't include the daily storage metrics.</p> <p> To use this operation, you must have permissions to perform the <code>s3:PutMetricsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"DeleteBucketOwnershipControls\":{\
      \"name\":\"DeleteBucketOwnershipControls\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?ownershipControls\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketOwnershipControlsRequest\"},\
      \"documentation\":\"<p>Removes <code>OwnershipControls</code> for an Amazon S3 bucket. To use this operation, you must have the <code>s3:PutBucketOwnershipControls</code> permission. For more information about Amazon S3 permissions, see <a href=\\\"https:
    },\
    \"DeleteBucketPolicy\":{\
      \"name\":\"DeleteBucketPolicy\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?policy\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketPolicyRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This implementation of the DELETE operation uses the policy subresource to delete the policy of a specified bucket. If you are using an identity other than the root user of the AWS account that owns the bucket, the calling identity must have the <code>DeleteBucketPolicy</code> permissions on the specified bucket and belong to the bucket owner's account to use this operation. </p> <p>If you don't have <code>DeleteBucketPolicy</code> permissions, Amazon S3 returns a <code>403 Access Denied</code> error. If you have the correct permissions, but you're not using an identity that belongs to the bucket owner's account, Amazon S3 returns a <code>405 Method Not Allowed</code> error. </p> <important> <p>As a security precaution, the root user of the AWS account that owns a bucket can always use this operation, even if the policy explicitly denies the root user the ability to perform this action.</p> </important> <p>For more information about bucket policies, see <a href=\\\" https:
    },\
    \"DeleteBucketReplication\":{\
      \"name\":\"DeleteBucketReplication\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?replication\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketReplicationRequest\"},\
      \"documentation\":\"<p> Deletes the replication configuration from the bucket.</p> <p>To use this operation, you must have permissions to perform the <code>s3:PutReplicationConfiguration</code> action. The bucket owner has these permissions by default and can grant it to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"DeleteBucketTagging\":{\
      \"name\":\"DeleteBucketTagging\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?tagging\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketTaggingRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Deletes the tags from the bucket.</p> <p>To use this operation, you must have permission to perform the <code>s3:PutBucketTagging</code> action. By default, the bucket owner has this permission and can grant this permission to others. </p> <p>The following operations are related to <code>DeleteBucketTagging</code>:</p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"DeleteBucketWebsite\":{\
      \"name\":\"DeleteBucketWebsite\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?website\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteBucketWebsiteRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This operation removes the website configuration for a bucket. Amazon S3 returns a <code>200 OK</code> response upon successfully deleting a website configuration on the specified bucket. You will get a <code>200 OK</code> response if the website configuration you are trying to delete does not exist on the bucket. Amazon S3 returns a <code>404</code> response if the bucket specified in the request does not exist.</p> <p>This DELETE operation requires the <code>S3:DeleteBucketWebsite</code> permission. By default, only the bucket owner can delete the website configuration attached to a bucket. However, bucket owners can grant other users permission to delete the website configuration by writing a bucket policy granting them the <code>S3:DeleteBucketWebsite</code> permission. </p> <p>For more information about hosting websites, see <a href=\\\"https:
    },\
    \"DeleteObject\":{\
      \"name\":\"DeleteObject\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}/{Key+}\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteObjectRequest\"},\
      \"output\":{\"shape\":\"DeleteObjectOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Removes the null version (if there is one) of an object and inserts a delete marker, which becomes the latest version of the object. If there isn't a null version, Amazon S3 does not remove any objects.</p> <p>To remove a specific version, you must be the bucket owner and you must use the version Id subresource. Using this subresource permanently deletes the version. If the object deleted is a delete marker, Amazon S3 sets the response header, <code>x-amz-delete-marker</code>, to true. </p> <p>If the object you want to delete is in a bucket where the bucket versioning configuration is MFA Delete enabled, you must include the <code>x-amz-mfa</code> request header in the DELETE <code>versionId</code> request. Requests that include <code>x-amz-mfa</code> must use HTTPS. </p> <p> For more information about MFA Delete, see <a href=\\\"https:
    },\
    \"DeleteObjectTagging\":{\
      \"name\":\"DeleteObjectTagging\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}/{Key+}?tagging\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeleteObjectTaggingRequest\"},\
      \"output\":{\"shape\":\"DeleteObjectTaggingOutput\"},\
      \"documentation\":\"<p>Removes the entire tag set from the specified object. For more information about managing object tags, see <a href=\\\"https:
    },\
    \"DeleteObjects\":{\
      \"name\":\"DeleteObjects\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/{Bucket}?delete\"\
      },\
      \"input\":{\"shape\":\"DeleteObjectsRequest\"},\
      \"output\":{\"shape\":\"DeleteObjectsOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This operation enables you to delete multiple objects from a bucket using a single HTTP request. If you know the object keys that you want to delete, then this operation provides a suitable alternative to sending individual delete requests, reducing per-request overhead.</p> <p>The request contains a list of up to 1000 keys that you want to delete. In the XML, you provide the object key names, and optionally, version IDs if you want to delete a specific version of the object from a versioning-enabled bucket. For each key, Amazon S3 performs a delete operation and returns the result of that delete, success, or failure, in the response. Note that if the object specified in the request is not found, Amazon S3 returns the result as deleted.</p> <p> The operation supports two modes for the response: verbose and quiet. By default, the operation uses verbose mode in which the response includes the result of deletion of each key in your request. In quiet mode the response includes only keys where the delete operation encountered an error. For a successful deletion, the operation does not return any information about the delete in the response body.</p> <p>When performing this operation on an MFA Delete enabled bucket, that attempts to delete any versioned objects, you must include an MFA token. If you do not provide one, the entire request will fail, even if there are non-versioned objects you are trying to delete. If you provide an invalid token, whether there are versioned keys in the request or not, the entire Multi-Object Delete request will fail. For information about MFA Delete, see <a href=\\\"https:
      \"alias\":\"DeleteMultipleObjects\",\
      \"httpChecksumRequired\":true\
    },\
    \"DeletePublicAccessBlock\":{\
      \"name\":\"DeletePublicAccessBlock\",\
      \"http\":{\
        \"method\":\"DELETE\",\
        \"requestUri\":\"/{Bucket}?publicAccessBlock\",\
        \"responseCode\":204\
      },\
      \"input\":{\"shape\":\"DeletePublicAccessBlockRequest\"},\
      \"documentation\":\"<p>Removes the <code>PublicAccessBlock</code> configuration for an Amazon S3 bucket. To use this operation, you must have the <code>s3:PutBucketPublicAccessBlock</code> permission. For more information about permissions, see <a href=\\\"https:
    },\
    \"GetBucketAccelerateConfiguration\":{\
      \"name\":\"GetBucketAccelerateConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?accelerate\"\
      },\
      \"input\":{\"shape\":\"GetBucketAccelerateConfigurationRequest\"},\
      \"output\":{\"shape\":\"GetBucketAccelerateConfigurationOutput\"},\
      \"documentation\":\"<p>This implementation of the GET operation uses the <code>accelerate</code> subresource to return the Transfer Acceleration state of a bucket, which is either <code>Enabled</code> or <code>Suspended</code>. Amazon S3 Transfer Acceleration is a bucket-level feature that enables you to perform faster data transfers to and from Amazon S3.</p> <p>To use this operation, you must have permission to perform the <code>s3:GetAccelerateConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"GetBucketAcl\":{\
      \"name\":\"GetBucketAcl\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?acl\"\
      },\
      \"input\":{\"shape\":\"GetBucketAclRequest\"},\
      \"output\":{\"shape\":\"GetBucketAclOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This implementation of the <code>GET</code> operation uses the <code>acl</code> subresource to return the access control list (ACL) of a bucket. To use <code>GET</code> to return the ACL of the bucket, you must have <code>READ_ACP</code> access to the bucket. If <code>READ_ACP</code> permission is granted to the anonymous user, you can return the ACL of the bucket without using an authorization header.</p> <p class=\\\"title\\\"> <b>Related Resources</b> </p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"GetBucketAnalyticsConfiguration\":{\
      \"name\":\"GetBucketAnalyticsConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?analytics\"\
      },\
      \"input\":{\"shape\":\"GetBucketAnalyticsConfigurationRequest\"},\
      \"output\":{\"shape\":\"GetBucketAnalyticsConfigurationOutput\"},\
      \"documentation\":\"<p>This implementation of the GET operation returns an analytics configuration (identified by the analytics configuration ID) from the bucket.</p> <p>To use this operation, you must have permissions to perform the <code>s3:GetAnalyticsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"GetBucketCors\":{\
      \"name\":\"GetBucketCors\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?cors\"\
      },\
      \"input\":{\"shape\":\"GetBucketCorsRequest\"},\
      \"output\":{\"shape\":\"GetBucketCorsOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the cors configuration information set for the bucket.</p> <p> To use this operation, you must have permission to perform the s3:GetBucketCORS action. By default, the bucket owner has this permission and can grant it to others.</p> <p> For more information about cors, see <a href=\\\"https:
    },\
    \"GetBucketEncryption\":{\
      \"name\":\"GetBucketEncryption\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?encryption\"\
      },\
      \"input\":{\"shape\":\"GetBucketEncryptionRequest\"},\
      \"output\":{\"shape\":\"GetBucketEncryptionOutput\"},\
      \"documentation\":\"<p>Returns the default encryption configuration for an Amazon S3 bucket. For information about the Amazon S3 default encryption feature, see <a href=\\\"https:
    },\
    \"GetBucketInventoryConfiguration\":{\
      \"name\":\"GetBucketInventoryConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?inventory\"\
      },\
      \"input\":{\"shape\":\"GetBucketInventoryConfigurationRequest\"},\
      \"output\":{\"shape\":\"GetBucketInventoryConfigurationOutput\"},\
      \"documentation\":\"<p>Returns an inventory configuration (identified by the inventory configuration ID) from the bucket.</p> <p>To use this operation, you must have permissions to perform the <code>s3:GetInventoryConfiguration</code> action. The bucket owner has this permission by default and can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"GetBucketLifecycle\":{\
      \"name\":\"GetBucketLifecycle\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?lifecycle\"\
      },\
      \"input\":{\"shape\":\"GetBucketLifecycleRequest\"},\
      \"output\":{\"shape\":\"GetBucketLifecycleOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<important> <p>For an updated version of this API, see <a href=\\\"https:
      \"deprecated\":true\
    },\
    \"GetBucketLifecycleConfiguration\":{\
      \"name\":\"GetBucketLifecycleConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?lifecycle\"\
      },\
      \"input\":{\"shape\":\"GetBucketLifecycleConfigurationRequest\"},\
      \"output\":{\"shape\":\"GetBucketLifecycleConfigurationOutput\"},\
      \"documentation\":\"<note> <p>Bucket lifecycle configuration now supports specifying a lifecycle rule using an object key name prefix, one or more object tags, or a combination of both. Accordingly, this section describes the latest API. The response describes the new filter element that you can use to specify a filter to select a subset of objects to which the rule applies. If you are using a previous version of the lifecycle configuration, it still works. For the earlier API description, see <a href=\\\"https:
    },\
    \"GetBucketLocation\":{\
      \"name\":\"GetBucketLocation\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?location\"\
      },\
      \"input\":{\"shape\":\"GetBucketLocationRequest\"},\
      \"output\":{\"shape\":\"GetBucketLocationOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the Region the bucket resides in. You set the bucket's Region using the <code>LocationConstraint</code> request parameter in a <code>CreateBucket</code> request. For more information, see <a href=\\\"https:
    },\
    \"GetBucketLogging\":{\
      \"name\":\"GetBucketLogging\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?logging\"\
      },\
      \"input\":{\"shape\":\"GetBucketLoggingRequest\"},\
      \"output\":{\"shape\":\"GetBucketLoggingOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the logging status of a bucket and the permissions users have to view and modify that status. To use GET, you must be the bucket owner.</p> <p>The following operations are related to <code>GetBucketLogging</code>:</p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"GetBucketMetricsConfiguration\":{\
      \"name\":\"GetBucketMetricsConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?metrics\"\
      },\
      \"input\":{\"shape\":\"GetBucketMetricsConfigurationRequest\"},\
      \"output\":{\"shape\":\"GetBucketMetricsConfigurationOutput\"},\
      \"documentation\":\"<p>Gets a metrics configuration (specified by the metrics configuration ID) from the bucket. Note that this doesn't include the daily storage metrics.</p> <p> To use this operation, you must have permissions to perform the <code>s3:GetMetricsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"GetBucketNotification\":{\
      \"name\":\"GetBucketNotification\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?notification\"\
      },\
      \"input\":{\"shape\":\"GetBucketNotificationConfigurationRequest\"},\
      \"output\":{\"shape\":\"NotificationConfigurationDeprecated\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p> No longer used, see <a href=\\\"https:
      \"deprecated\":true\
    },\
    \"GetBucketNotificationConfiguration\":{\
      \"name\":\"GetBucketNotificationConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?notification\"\
      },\
      \"input\":{\"shape\":\"GetBucketNotificationConfigurationRequest\"},\
      \"output\":{\"shape\":\"NotificationConfiguration\"},\
      \"documentation\":\"<p>Returns the notification configuration of a bucket.</p> <p>If notifications are not enabled on the bucket, the operation returns an empty <code>NotificationConfiguration</code> element.</p> <p>By default, you must be the bucket owner to read the notification configuration of a bucket. However, the bucket owner can use a bucket policy to grant permission to other users to read this configuration with the <code>s3:GetBucketNotification</code> permission.</p> <p>For more information about setting and reading the notification configuration on a bucket, see <a href=\\\"https:
    },\
    \"GetBucketOwnershipControls\":{\
      \"name\":\"GetBucketOwnershipControls\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?ownershipControls\"\
      },\
      \"input\":{\"shape\":\"GetBucketOwnershipControlsRequest\"},\
      \"output\":{\"shape\":\"GetBucketOwnershipControlsOutput\"},\
      \"documentation\":\"<p>Retrieves <code>OwnershipControls</code> for an Amazon S3 bucket. To use this operation, you must have the <code>s3:GetBucketOwnershipControls</code> permission. For more information about Amazon S3 permissions, see <a href=\\\"https:
    },\
    \"GetBucketPolicy\":{\
      \"name\":\"GetBucketPolicy\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?policy\"\
      },\
      \"input\":{\"shape\":\"GetBucketPolicyRequest\"},\
      \"output\":{\"shape\":\"GetBucketPolicyOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the policy of a specified bucket. If you are using an identity other than the root user of the AWS account that owns the bucket, the calling identity must have the <code>GetBucketPolicy</code> permissions on the specified bucket and belong to the bucket owner's account in order to use this operation.</p> <p>If you don't have <code>GetBucketPolicy</code> permissions, Amazon S3 returns a <code>403 Access Denied</code> error. If you have the correct permissions, but you're not using an identity that belongs to the bucket owner's account, Amazon S3 returns a <code>405 Method Not Allowed</code> error.</p> <important> <p>As a security precaution, the root user of the AWS account that owns a bucket can always use this operation, even if the policy explicitly denies the root user the ability to perform this action.</p> </important> <p>For more information about bucket policies, see <a href=\\\"https:
    },\
    \"GetBucketPolicyStatus\":{\
      \"name\":\"GetBucketPolicyStatus\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?policyStatus\"\
      },\
      \"input\":{\"shape\":\"GetBucketPolicyStatusRequest\"},\
      \"output\":{\"shape\":\"GetBucketPolicyStatusOutput\"},\
      \"documentation\":\"<p>Retrieves the policy status for an Amazon S3 bucket, indicating whether the bucket is public. In order to use this operation, you must have the <code>s3:GetBucketPolicyStatus</code> permission. For more information about Amazon S3 permissions, see <a href=\\\"https:
    },\
    \"GetBucketReplication\":{\
      \"name\":\"GetBucketReplication\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?replication\"\
      },\
      \"input\":{\"shape\":\"GetBucketReplicationRequest\"},\
      \"output\":{\"shape\":\"GetBucketReplicationOutput\"},\
      \"documentation\":\"<p>Returns the replication configuration of a bucket.</p> <note> <p> It can take a while to propagate the put or delete a replication configuration to all Amazon S3 systems. Therefore, a get request soon after put or delete can return a wrong result. </p> </note> <p> For information about replication configuration, see <a href=\\\"https:
    },\
    \"GetBucketRequestPayment\":{\
      \"name\":\"GetBucketRequestPayment\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?requestPayment\"\
      },\
      \"input\":{\"shape\":\"GetBucketRequestPaymentRequest\"},\
      \"output\":{\"shape\":\"GetBucketRequestPaymentOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the request payment configuration of a bucket. To use this version of the operation, you must be the bucket owner. For more information, see <a href=\\\"https:
    },\
    \"GetBucketTagging\":{\
      \"name\":\"GetBucketTagging\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?tagging\"\
      },\
      \"input\":{\"shape\":\"GetBucketTaggingRequest\"},\
      \"output\":{\"shape\":\"GetBucketTaggingOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the tag set associated with the bucket.</p> <p>To use this operation, you must have permission to perform the <code>s3:GetBucketTagging</code> action. By default, the bucket owner has this permission and can grant this permission to others.</p> <p> <code>GetBucketTagging</code> has the following special error:</p> <ul> <li> <p>Error code: <code>NoSuchTagSetError</code> </p> <ul> <li> <p>Description: There is no tag set associated with the bucket.</p> </li> </ul> </li> </ul> <p>The following operations are related to <code>GetBucketTagging</code>:</p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"GetBucketVersioning\":{\
      \"name\":\"GetBucketVersioning\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?versioning\"\
      },\
      \"input\":{\"shape\":\"GetBucketVersioningRequest\"},\
      \"output\":{\"shape\":\"GetBucketVersioningOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the versioning state of a bucket.</p> <p>To retrieve the versioning state of a bucket, you must be the bucket owner.</p> <p>This implementation also returns the MFA Delete status of the versioning state. If the MFA Delete status is <code>enabled</code>, the bucket owner must use an authentication device to change the versioning state of the bucket.</p> <p>The following operations are related to <code>GetBucketVersioning</code>:</p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"GetBucketWebsite\":{\
      \"name\":\"GetBucketWebsite\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?website\"\
      },\
      \"input\":{\"shape\":\"GetBucketWebsiteRequest\"},\
      \"output\":{\"shape\":\"GetBucketWebsiteOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the website configuration for a bucket. To host website on Amazon S3, you can configure a bucket as website by adding a website configuration. For more information about hosting websites, see <a href=\\\"https:
    },\
    \"GetObject\":{\
      \"name\":\"GetObject\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"GetObjectRequest\"},\
      \"output\":{\"shape\":\"GetObjectOutput\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchKey\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Retrieves objects from Amazon S3. To use <code>GET</code>, you must have <code>READ</code> access to the object. If you grant <code>READ</code> access to the anonymous user, you can return the object without using an authorization header.</p> <p>An Amazon S3 bucket has no directory hierarchy such as you would find in a typical computer file system. You can, however, create a logical hierarchy by using object key names that imply a folder structure. For example, instead of naming an object <code>sample.jpg</code>, you can name it <code>photos/2006/February/sample.jpg</code>.</p> <p>To get an object from such a logical hierarchy, specify the full key name for the object in the <code>GET</code> operation. For a virtual hosted-style request example, if you have the object <code>photos/2006/February/sample.jpg</code>, specify the resource as <code>/photos/2006/February/sample.jpg</code>. For a path-style request example, if you have the object <code>photos/2006/February/sample.jpg</code> in the bucket named <code>examplebucket</code>, specify the resource as <code>/examplebucket/photos/2006/February/sample.jpg</code>. For more information about request types, see <a href=\\\"https:
    },\
    \"GetObjectAcl\":{\
      \"name\":\"GetObjectAcl\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}?acl\"\
      },\
      \"input\":{\"shape\":\"GetObjectAclRequest\"},\
      \"output\":{\"shape\":\"GetObjectAclOutput\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchKey\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns the access control list (ACL) of an object. To use this operation, you must have <code>READ_ACP</code> access to the object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p> <p> <b>Versioning</b> </p> <p>By default, GET returns ACL information about the current version of an object. To return ACL information about a different version, use the versionId subresource.</p> <p>The following operations are related to <code>GetObjectAcl</code>:</p> <ul> <li> <p> <a href=\\\"https:
    },\
    \"GetObjectLegalHold\":{\
      \"name\":\"GetObjectLegalHold\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}?legal-hold\"\
      },\
      \"input\":{\"shape\":\"GetObjectLegalHoldRequest\"},\
      \"output\":{\"shape\":\"GetObjectLegalHoldOutput\"},\
      \"documentation\":\"<p>Gets an object's current Legal Hold status. For more information, see <a href=\\\"https:
    },\
    \"GetObjectLockConfiguration\":{\
      \"name\":\"GetObjectLockConfiguration\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?object-lock\"\
      },\
      \"input\":{\"shape\":\"GetObjectLockConfigurationRequest\"},\
      \"output\":{\"shape\":\"GetObjectLockConfigurationOutput\"},\
      \"documentation\":\"<p>Gets the Object Lock configuration for a bucket. The rule specified in the Object Lock configuration will be applied by default to every new object placed in the specified bucket. For more information, see <a href=\\\"https:
    },\
    \"GetObjectRetention\":{\
      \"name\":\"GetObjectRetention\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}?retention\"\
      },\
      \"input\":{\"shape\":\"GetObjectRetentionRequest\"},\
      \"output\":{\"shape\":\"GetObjectRetentionOutput\"},\
      \"documentation\":\"<p>Retrieves an object's retention settings. For more information, see <a href=\\\"https:
    },\
    \"GetObjectTagging\":{\
      \"name\":\"GetObjectTagging\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}?tagging\"\
      },\
      \"input\":{\"shape\":\"GetObjectTaggingRequest\"},\
      \"output\":{\"shape\":\"GetObjectTaggingOutput\"},\
      \"documentation\":\"<p>Returns the tag-set of an object. You send the GET request against the tagging subresource associated with the object.</p> <p>To use this operation, you must have permission to perform the <code>s3:GetObjectTagging</code> action. By default, the GET operation returns information about current version of an object. For a versioned bucket, you can have multiple versions of an object in your bucket. To retrieve tags of any other version, use the versionId query parameter. You also need permission for the <code>s3:GetObjectVersionTagging</code> action.</p> <p> By default, the bucket owner has this permission and can grant this permission to others.</p> <p> For information about the Amazon S3 object tagging feature, see <a href=\\\"https:
    },\
    \"GetObjectTorrent\":{\
      \"name\":\"GetObjectTorrent\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}?torrent\"\
      },\
      \"input\":{\"shape\":\"GetObjectTorrentRequest\"},\
      \"output\":{\"shape\":\"GetObjectTorrentOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns torrent files from a bucket. BitTorrent can save you bandwidth when you're distributing large files. For more information about BitTorrent, see <a href=\\\"https:
    },\
    \"GetPublicAccessBlock\":{\
      \"name\":\"GetPublicAccessBlock\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?publicAccessBlock\"\
      },\
      \"input\":{\"shape\":\"GetPublicAccessBlockRequest\"},\
      \"output\":{\"shape\":\"GetPublicAccessBlockOutput\"},\
      \"documentation\":\"<p>Retrieves the <code>PublicAccessBlock</code> configuration for an Amazon S3 bucket. To use this operation, you must have the <code>s3:GetBucketPublicAccessBlock</code> permission. For more information about Amazon S3 permissions, see <a href=\\\"https:
    },\
    \"HeadBucket\":{\
      \"name\":\"HeadBucket\",\
      \"http\":{\
        \"method\":\"HEAD\",\
        \"requestUri\":\"/{Bucket}\"\
      },\
      \"input\":{\"shape\":\"HeadBucketRequest\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchBucket\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This operation is useful to determine if a bucket exists and you have permission to access it. The operation returns a <code>200 OK</code> if the bucket exists and you have permission to access it. Otherwise, the operation might return responses such as <code>404 Not Found</code> and <code>403 Forbidden</code>. </p> <p>To use this operation, you must have permissions to perform the <code>s3:ListBucket</code> action. The bucket owner has this permission by default and can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"HeadObject\":{\
      \"name\":\"HeadObject\",\
      \"http\":{\
        \"method\":\"HEAD\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"HeadObjectRequest\"},\
      \"output\":{\"shape\":\"HeadObjectOutput\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchKey\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>The HEAD operation retrieves metadata from an object without returning the object itself. This operation is useful if you're only interested in an object's metadata. To use HEAD, you must have READ access to the object.</p> <p>A <code>HEAD</code> request has the same options as a <code>GET</code> operation on an object. The response is identical to the <code>GET</code> response except that there is no response body.</p> <p>If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you retrieve the metadata from the object, you must use the following headers:</p> <ul> <li> <p>x-amz-server-side-encryption-customer-algorithm</p> </li> <li> <p>x-amz-server-side-encryption-customer-key</p> </li> <li> <p>x-amz-server-side-encryption-customer-key-MD5</p> </li> </ul> <p>For more information about SSE-C, see <a href=\\\"https:
    },\
    \"ListBucketAnalyticsConfigurations\":{\
      \"name\":\"ListBucketAnalyticsConfigurations\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?analytics\"\
      },\
      \"input\":{\"shape\":\"ListBucketAnalyticsConfigurationsRequest\"},\
      \"output\":{\"shape\":\"ListBucketAnalyticsConfigurationsOutput\"},\
      \"documentation\":\"<p>Lists the analytics configurations for the bucket. You can have up to 1,000 analytics configurations per bucket.</p> <p>This operation supports list pagination and does not return more than 100 configurations at a time. You should always check the <code>IsTruncated</code> element in the response. If there are no more configurations to list, <code>IsTruncated</code> is set to false. If there are more configurations to list, <code>IsTruncated</code> is set to true, and there will be a value in <code>NextContinuationToken</code>. You use the <code>NextContinuationToken</code> value to continue the pagination of the list by passing the value in continuation-token in the request to <code>GET</code> the next page.</p> <p>To use this operation, you must have permissions to perform the <code>s3:GetAnalyticsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"ListBucketInventoryConfigurations\":{\
      \"name\":\"ListBucketInventoryConfigurations\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?inventory\"\
      },\
      \"input\":{\"shape\":\"ListBucketInventoryConfigurationsRequest\"},\
      \"output\":{\"shape\":\"ListBucketInventoryConfigurationsOutput\"},\
      \"documentation\":\"<p>Returns a list of inventory configurations for the bucket. You can have up to 1,000 analytics configurations per bucket.</p> <p>This operation supports list pagination and does not return more than 100 configurations at a time. Always check the <code>IsTruncated</code> element in the response. If there are no more configurations to list, <code>IsTruncated</code> is set to false. If there are more configurations to list, <code>IsTruncated</code> is set to true, and there is a value in <code>NextContinuationToken</code>. You use the <code>NextContinuationToken</code> value to continue the pagination of the list by passing the value in continuation-token in the request to <code>GET</code> the next page.</p> <p> To use this operation, you must have permissions to perform the <code>s3:GetInventoryConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"ListBucketMetricsConfigurations\":{\
      \"name\":\"ListBucketMetricsConfigurations\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?metrics\"\
      },\
      \"input\":{\"shape\":\"ListBucketMetricsConfigurationsRequest\"},\
      \"output\":{\"shape\":\"ListBucketMetricsConfigurationsOutput\"},\
      \"documentation\":\"<p>Lists the metrics configurations for the bucket. The metrics configurations are only for the request metrics of the bucket and do not provide information on daily storage metrics. You can have up to 1,000 configurations per bucket.</p> <p>This operation supports list pagination and does not return more than 100 configurations at a time. Always check the <code>IsTruncated</code> element in the response. If there are no more configurations to list, <code>IsTruncated</code> is set to false. If there are more configurations to list, <code>IsTruncated</code> is set to true, and there is a value in <code>NextContinuationToken</code>. You use the <code>NextContinuationToken</code> value to continue the pagination of the list by passing the value in <code>continuation-token</code> in the request to <code>GET</code> the next page.</p> <p>To use this operation, you must have permissions to perform the <code>s3:GetMetricsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"ListBuckets\":{\
      \"name\":\"ListBuckets\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/\"\
      },\
      \"output\":{\"shape\":\"ListBucketsOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns a list of all buckets owned by the authenticated sender of the request.</p>\",\
      \"alias\":\"GetService\"\
    },\
    \"ListMultipartUploads\":{\
      \"name\":\"ListMultipartUploads\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?uploads\"\
      },\
      \"input\":{\"shape\":\"ListMultipartUploadsRequest\"},\
      \"output\":{\"shape\":\"ListMultipartUploadsOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>This operation lists in-progress multipart uploads. An in-progress multipart upload is a multipart upload that has been initiated using the Initiate Multipart Upload request, but has not yet been completed or aborted.</p> <p>This operation returns at most 1,000 multipart uploads in the response. 1,000 multipart uploads is the maximum number of uploads a response can include, which is also the default value. You can further limit the number of uploads in a response by specifying the <code>max-uploads</code> parameter in the response. If additional multipart uploads satisfy the list criteria, the response will contain an <code>IsTruncated</code> element with the value true. To list the additional multipart uploads, use the <code>key-marker</code> and <code>upload-id-marker</code> request parameters.</p> <p>In the response, the uploads are sorted by key. If your application has initiated more than one multipart upload using the same object key, then uploads in the response are first sorted by key. Additionally, uploads are sorted in ascending order within each key by the upload initiation time.</p> <p>For more information on multipart uploads, see <a href=\\\"https:
    },\
    \"ListObjectVersions\":{\
      \"name\":\"ListObjectVersions\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?versions\"\
      },\
      \"input\":{\"shape\":\"ListObjectVersionsRequest\"},\
      \"output\":{\"shape\":\"ListObjectVersionsOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns metadata about all versions of the objects in a bucket. You can also use request parameters as selection criteria to return metadata about a subset of all the object versions. </p> <note> <p> A 200 OK response can contain valid or invalid XML. Make sure to design your application to parse the contents of the response and handle it appropriately.</p> </note> <p>To use this operation, you must have READ access to the bucket.</p> <p>This action is not supported by Amazon S3 on Outposts.</p> <p>The following operations are related to <code>ListObjectVersions</code>:</p> <ul> <li> <p> <a href=\\\"https:
      \"alias\":\"GetBucketObjectVersions\"\
    },\
    \"ListObjects\":{\
      \"name\":\"ListObjects\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}\"\
      },\
      \"input\":{\"shape\":\"ListObjectsRequest\"},\
      \"output\":{\"shape\":\"ListObjectsOutput\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchBucket\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Returns some or all (up to 1,000) of the objects in a bucket. You can use the request parameters as selection criteria to return a subset of the objects in a bucket. A 200 OK response can contain valid or invalid XML. Be sure to design your application to parse the contents of the response and handle it appropriately.</p> <important> <p>This API has been revised. We recommend that you use the newer version, <a href=\\\"https:
      \"alias\":\"GetBucket\"\
    },\
    \"ListObjectsV2\":{\
      \"name\":\"ListObjectsV2\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}?list-type=2\"\
      },\
      \"input\":{\"shape\":\"ListObjectsV2Request\"},\
      \"output\":{\"shape\":\"ListObjectsV2Output\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchBucket\"}\
      ],\
      \"documentation\":\"<p>Returns some or all (up to 1,000) of the objects in a bucket. You can use the request parameters as selection criteria to return a subset of the objects in a bucket. A <code>200 OK</code> response can contain valid or invalid XML. Make sure to design your application to parse the contents of the response and handle it appropriately.</p> <p>To use this operation, you must have READ access to the bucket.</p> <p>To use this operation in an AWS Identity and Access Management (IAM) policy, you must have permissions to perform the <code>s3:ListBucket</code> action. The bucket owner has this permission by default and can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"ListParts\":{\
      \"name\":\"ListParts\",\
      \"http\":{\
        \"method\":\"GET\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"ListPartsRequest\"},\
      \"output\":{\"shape\":\"ListPartsOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Lists the parts that have been uploaded for a specific multipart upload. This operation must include the upload ID, which you obtain by sending the initiate multipart upload request (see <a href=\\\"https:
    },\
    \"PutBucketAccelerateConfiguration\":{\
      \"name\":\"PutBucketAccelerateConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?accelerate\"\
      },\
      \"input\":{\"shape\":\"PutBucketAccelerateConfigurationRequest\"},\
      \"documentation\":\"<p>Sets the accelerate configuration of an existing bucket. Amazon S3 Transfer Acceleration is a bucket-level feature that enables you to perform faster data transfers to Amazon S3.</p> <p> To use this operation, you must have permission to perform the s3:PutAccelerateConfiguration action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"PutBucketAcl\":{\
      \"name\":\"PutBucketAcl\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?acl\"\
      },\
      \"input\":{\"shape\":\"PutBucketAclRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Sets the permissions on an existing bucket using access control lists (ACL). For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketAnalyticsConfiguration\":{\
      \"name\":\"PutBucketAnalyticsConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?analytics\"\
      },\
      \"input\":{\"shape\":\"PutBucketAnalyticsConfigurationRequest\"},\
      \"documentation\":\"<p>Sets an analytics configuration for the bucket (specified by the analytics configuration ID). You can have up to 1,000 analytics configurations per bucket.</p> <p>You can choose to have storage class analysis export analysis reports sent to a comma-separated values (CSV) flat file. See the <code>DataExport</code> request element. Reports are updated daily and are based on the object filters that you configure. When selecting data export, you specify a destination bucket and an optional destination prefix where the file is written. You can export the data to a destination bucket in a different account. However, the destination bucket must be in the same Region as the bucket that you are making the PUT analytics configuration to. For more information, see <a href=\\\"https:
    },\
    \"PutBucketCors\":{\
      \"name\":\"PutBucketCors\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?cors\"\
      },\
      \"input\":{\"shape\":\"PutBucketCorsRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Sets the <code>cors</code> configuration for your bucket. If the configuration exists, Amazon S3 replaces it.</p> <p>To use this operation, you must be allowed to perform the <code>s3:PutBucketCORS</code> action. By default, the bucket owner has this permission and can grant it to others.</p> <p>You set this configuration on a bucket so that the bucket can service cross-origin requests. For example, you might want to enable a request whose origin is <code>http:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketEncryption\":{\
      \"name\":\"PutBucketEncryption\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?encryption\"\
      },\
      \"input\":{\"shape\":\"PutBucketEncryptionRequest\"},\
      \"documentation\":\"<p>This implementation of the <code>PUT</code> operation uses the <code>encryption</code> subresource to set the default encryption state of an existing bucket.</p> <p>This implementation of the <code>PUT</code> operation sets default encryption for a bucket using server-side encryption with Amazon S3-managed keys SSE-S3 or AWS KMS customer master keys (CMKs) (SSE-KMS). For information about the Amazon S3 default encryption feature, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketInventoryConfiguration\":{\
      \"name\":\"PutBucketInventoryConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?inventory\"\
      },\
      \"input\":{\"shape\":\"PutBucketInventoryConfigurationRequest\"},\
      \"documentation\":\"<p>This implementation of the <code>PUT</code> operation adds an inventory configuration (identified by the inventory ID) to the bucket. You can have up to 1,000 inventory configurations per bucket. </p> <p>Amazon S3 inventory generates inventories of the objects in the bucket on a daily or weekly basis, and the results are published to a flat file. The bucket that is inventoried is called the <i>source</i> bucket, and the bucket where the inventory flat file is stored is called the <i>destination</i> bucket. The <i>destination</i> bucket must be in the same AWS Region as the <i>source</i> bucket. </p> <p>When you configure an inventory for a <i>source</i> bucket, you specify the <i>destination</i> bucket where you want the inventory to be stored, and whether to generate the inventory daily or weekly. You can also configure what object metadata to include and whether to inventory all object versions or only current versions. For more information, see <a href=\\\"https:
    },\
    \"PutBucketLifecycle\":{\
      \"name\":\"PutBucketLifecycle\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?lifecycle\"\
      },\
      \"input\":{\"shape\":\"PutBucketLifecycleRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<important> <p>For an updated version of this API, see <a href=\\\"https:
      \"deprecated\":true,\
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketLifecycleConfiguration\":{\
      \"name\":\"PutBucketLifecycleConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?lifecycle\"\
      },\
      \"input\":{\"shape\":\"PutBucketLifecycleConfigurationRequest\"},\
      \"documentation\":\"<p>Creates a new lifecycle configuration for the bucket or replaces an existing lifecycle configuration. For information about lifecycle configuration, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketLogging\":{\
      \"name\":\"PutBucketLogging\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?logging\"\
      },\
      \"input\":{\"shape\":\"PutBucketLoggingRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Set the logging parameters for a bucket and to specify permissions for who can view and modify the logging parameters. All logs are saved to buckets in the same AWS Region as the source bucket. To set the logging status of a bucket, you must be the bucket owner.</p> <p>The bucket owner is automatically granted FULL_CONTROL to all logs. You use the <code>Grantee</code> request element to grant access to other people. The <code>Permissions</code> request element specifies the kind of access the grantee has to the logs.</p> <p> <b>Grantee Values</b> </p> <p>You can specify the person (grantee) to whom you're assigning access rights (using request elements) in the following ways:</p> <ul> <li> <p>By the person's ID:</p> <p> <code>&lt;Grantee xmlns:xsi=\\\"http:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketMetricsConfiguration\":{\
      \"name\":\"PutBucketMetricsConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?metrics\"\
      },\
      \"input\":{\"shape\":\"PutBucketMetricsConfigurationRequest\"},\
      \"documentation\":\"<p>Sets a metrics configuration (specified by the metrics configuration ID) for the bucket. You can have up to 1,000 metrics configurations per bucket. If you're updating an existing metrics configuration, note that this is a full replacement of the existing metrics configuration. If you don't include the elements you want to keep, they are erased.</p> <p>To use this operation, you must have permissions to perform the <code>s3:PutMetricsConfiguration</code> action. The bucket owner has this permission by default. The bucket owner can grant this permission to others. For more information about permissions, see <a href=\\\"https:
    },\
    \"PutBucketNotification\":{\
      \"name\":\"PutBucketNotification\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?notification\"\
      },\
      \"input\":{\"shape\":\"PutBucketNotificationRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p> No longer used, see the <a href=\\\"https:
      \"deprecated\":true,\
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketNotificationConfiguration\":{\
      \"name\":\"PutBucketNotificationConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?notification\"\
      },\
      \"input\":{\"shape\":\"PutBucketNotificationConfigurationRequest\"},\
      \"documentation\":\"<p>Enables notifications of specified events for a bucket. For more information about event notifications, see <a href=\\\"https:
    },\
    \"PutBucketOwnershipControls\":{\
      \"name\":\"PutBucketOwnershipControls\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?ownershipControls\"\
      },\
      \"input\":{\"shape\":\"PutBucketOwnershipControlsRequest\"},\
      \"documentation\":\"<p>Creates or modifies <code>OwnershipControls</code> for an Amazon S3 bucket. To use this operation, you must have the <code>s3:GetBucketOwnershipControls</code> permission. For more information about Amazon S3 permissions, see <a href=\\\"https:
    },\
    \"PutBucketPolicy\":{\
      \"name\":\"PutBucketPolicy\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?policy\"\
      },\
      \"input\":{\"shape\":\"PutBucketPolicyRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Applies an Amazon S3 bucket policy to an Amazon S3 bucket. If you are using an identity other than the root user of the AWS account that owns the bucket, the calling identity must have the <code>PutBucketPolicy</code> permissions on the specified bucket and belong to the bucket owner's account in order to use this operation.</p> <p>If you don't have <code>PutBucketPolicy</code> permissions, Amazon S3 returns a <code>403 Access Denied</code> error. If you have the correct permissions, but you're not using an identity that belongs to the bucket owner's account, Amazon S3 returns a <code>405 Method Not Allowed</code> error.</p> <important> <p> As a security precaution, the root user of the AWS account that owns a bucket can always use this operation, even if the policy explicitly denies the root user the ability to perform this action. </p> </important> <p>For more information about bucket policies, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketReplication\":{\
      \"name\":\"PutBucketReplication\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?replication\"\
      },\
      \"input\":{\"shape\":\"PutBucketReplicationRequest\"},\
      \"documentation\":\"<p> Creates a replication configuration or replaces an existing one. For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketRequestPayment\":{\
      \"name\":\"PutBucketRequestPayment\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?requestPayment\"\
      },\
      \"input\":{\"shape\":\"PutBucketRequestPaymentRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Sets the request payment configuration for a bucket. By default, the bucket owner pays for downloads from the bucket. This configuration parameter enables the bucket owner (only) to specify that the person requesting the download will be charged for the download. For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketTagging\":{\
      \"name\":\"PutBucketTagging\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?tagging\"\
      },\
      \"input\":{\"shape\":\"PutBucketTaggingRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Sets the tags for a bucket.</p> <p>Use tags to organize your AWS bill to reflect your own cost structure. To do this, sign up to get your AWS account bill with tag key values included. Then, to see the cost of combined resources, organize your billing information according to resources with the same tag key values. For example, you can tag several resources with a specific application name, and then organize your billing information to see the total cost of that application across several services. For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketVersioning\":{\
      \"name\":\"PutBucketVersioning\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?versioning\"\
      },\
      \"input\":{\"shape\":\"PutBucketVersioningRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Sets the versioning state of an existing bucket. To set the versioning state, you must be the bucket owner.</p> <p>You can set the versioning state with one of the following values:</p> <p> <b>Enabled</b>âEnables versioning for the objects in the bucket. All objects added to the bucket receive a unique version ID.</p> <p> <b>Suspended</b>âDisables versioning for the objects in the bucket. All objects added to the bucket receive the version ID null.</p> <p>If the versioning state has never been set on a bucket, it has no versioning state; a <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutBucketWebsite\":{\
      \"name\":\"PutBucketWebsite\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?website\"\
      },\
      \"input\":{\"shape\":\"PutBucketWebsiteRequest\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Sets the configuration of the website that is specified in the <code>website</code> subresource. To configure a bucket as a website, you can add this subresource on the bucket with website configuration information such as the file name of the index document and any redirect rules. For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutObject\":{\
      \"name\":\"PutObject\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"PutObjectRequest\"},\
      \"output\":{\"shape\":\"PutObjectOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Adds an object to a bucket. You must have WRITE permissions on a bucket to add an object to it.</p> <p>Amazon S3 never adds partial objects; if you receive a success response, Amazon S3 added the entire object to the bucket.</p> <p>Amazon S3 is a distributed system. If it receives multiple write requests for the same object simultaneously, it overwrites all but the last object written. Amazon S3 does not provide object locking; if you need this, make sure to build it into your application layer or use versioning instead.</p> <p>To ensure that data is not corrupted traversing the network, use the <code>Content-MD5</code> header. When you use this header, Amazon S3 checks the object against the provided MD5 value and, if they do not match, returns an error. Additionally, you can calculate the MD5 while putting an object to Amazon S3 and compare the returned ETag to the calculated MD5 value.</p> <note> <p> The <code>Content-MD5</code> header is required for any request to upload an object with a retention period configured using Amazon S3 Object Lock. For more information about Amazon S3 Object Lock, see <a href=\\\"https:
    },\
    \"PutObjectAcl\":{\
      \"name\":\"PutObjectAcl\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}?acl\"\
      },\
      \"input\":{\"shape\":\"PutObjectAclRequest\"},\
      \"output\":{\"shape\":\"PutObjectAclOutput\"},\
      \"errors\":[\
        {\"shape\":\"NoSuchKey\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Uses the <code>acl</code> subresource to set the access control list (ACL) permissions for a new or existing object in an S3 bucket. You must have <code>WRITE_ACP</code> permission to set the ACL of an object. For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutObjectLegalHold\":{\
      \"name\":\"PutObjectLegalHold\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}?legal-hold\"\
      },\
      \"input\":{\"shape\":\"PutObjectLegalHoldRequest\"},\
      \"output\":{\"shape\":\"PutObjectLegalHoldOutput\"},\
      \"documentation\":\"<p>Applies a Legal Hold configuration to the specified object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p> <p class=\\\"title\\\"> <b>Related Resources</b> </p> <ul> <li> <p> <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutObjectLockConfiguration\":{\
      \"name\":\"PutObjectLockConfiguration\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?object-lock\"\
      },\
      \"input\":{\"shape\":\"PutObjectLockConfigurationRequest\"},\
      \"output\":{\"shape\":\"PutObjectLockConfigurationOutput\"},\
      \"documentation\":\"<p>Places an Object Lock configuration on the specified bucket. The rule specified in the Object Lock configuration will be applied by default to every new object placed in the specified bucket.</p> <note> <p> <code>DefaultRetention</code> requires either Days or Years. You can't specify both at the same time.</p> </note> <p class=\\\"title\\\"> <b>Related Resources</b> </p> <ul> <li> <p> <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutObjectRetention\":{\
      \"name\":\"PutObjectRetention\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}?retention\"\
      },\
      \"input\":{\"shape\":\"PutObjectRetentionRequest\"},\
      \"output\":{\"shape\":\"PutObjectRetentionOutput\"},\
      \"documentation\":\"<p>Places an Object Retention configuration on an object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p> <p class=\\\"title\\\"> <b>Related Resources</b> </p> <ul> <li> <p> <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutObjectTagging\":{\
      \"name\":\"PutObjectTagging\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}?tagging\"\
      },\
      \"input\":{\"shape\":\"PutObjectTaggingRequest\"},\
      \"output\":{\"shape\":\"PutObjectTaggingOutput\"},\
      \"documentation\":\"<p>Sets the supplied tag-set to an object that already exists in a bucket.</p> <p>A tag is a key-value pair. You can associate tags with an object by sending a PUT request against the tagging subresource that is associated with the object. You can retrieve tags by sending a GET request. For more information, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"PutPublicAccessBlock\":{\
      \"name\":\"PutPublicAccessBlock\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}?publicAccessBlock\"\
      },\
      \"input\":{\"shape\":\"PutPublicAccessBlockRequest\"},\
      \"documentation\":\"<p>Creates or modifies the <code>PublicAccessBlock</code> configuration for an Amazon S3 bucket. To use this operation, you must have the <code>s3:PutBucketPublicAccessBlock</code> permission. For more information about Amazon S3 permissions, see <a href=\\\"https:
      \"httpChecksumRequired\":true\
    },\
    \"RestoreObject\":{\
      \"name\":\"RestoreObject\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/{Bucket}/{Key+}?restore\"\
      },\
      \"input\":{\"shape\":\"RestoreObjectRequest\"},\
      \"output\":{\"shape\":\"RestoreObjectOutput\"},\
      \"errors\":[\
        {\"shape\":\"ObjectAlreadyInActiveTierError\"}\
      ],\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Restores an archived copy of an object back into Amazon S3</p> <p>This action is not supported by Amazon S3 on Outposts.</p> <p>This action performs the following types of requests: </p> <ul> <li> <p> <code>select</code> - Perform a select query on an archived object</p> </li> <li> <p> <code>restore an archive</code> - Restore an archived object</p> </li> </ul> <p>To use this operation, you must have permissions to perform the <code>s3:RestoreObject</code> action. The bucket owner has this permission by default and can grant this permission to others. For more information about permissions, see <a href=\\\"https:
      \"alias\":\"PostObjectRestore\"\
    },\
    \"SelectObjectContent\":{\
      \"name\":\"SelectObjectContent\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/{Bucket}/{Key+}?select&select-type=2\"\
      },\
      \"input\":{\
        \"shape\":\"SelectObjectContentRequest\",\
        \"locationName\":\"SelectObjectContentRequest\",\
        \"xmlNamespace\":{\"uri\":\"http:
      },\
      \"output\":{\"shape\":\"SelectObjectContentOutput\"},\
      \"documentation\":\"<p>This operation filters the contents of an Amazon S3 object based on a simple structured query language (SQL) statement. In the request, along with the SQL expression, you must also specify a data serialization format (JSON, CSV, or Apache Parquet) of the object. Amazon S3 uses this format to parse object data into records, and returns only records that match the specified SQL expression. You must also specify the data serialization format for the response.</p> <p>This action is not supported by Amazon S3 on Outposts.</p> <p>For more information about Amazon S3 Select, see <a href=\\\"https:
    },\
    \"UploadPart\":{\
      \"name\":\"UploadPart\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"UploadPartRequest\"},\
      \"output\":{\"shape\":\"UploadPartOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Uploads a part in a multipart upload.</p> <note> <p>In this operation, you provide part data in your request. However, you have an option to specify your existing Amazon S3 object as a data source for the part you are uploading. To upload a part from an existing object, you use the <a href=\\\"https:
    },\
    \"UploadPartCopy\":{\
      \"name\":\"UploadPartCopy\",\
      \"http\":{\
        \"method\":\"PUT\",\
        \"requestUri\":\"/{Bucket}/{Key+}\"\
      },\
      \"input\":{\"shape\":\"UploadPartCopyRequest\"},\
      \"output\":{\"shape\":\"UploadPartCopyOutput\"},\
      \"documentationUrl\":\"http:
      \"documentation\":\"<p>Uploads a part by copying data from an existing object as data source. You specify the data source by adding the request header <code>x-amz-copy-source</code> in your request and a byte range by adding the request header <code>x-amz-copy-source-range</code> in your request. </p> <p>The minimum allowable part size for a multipart upload is 5 MB. For more information about multipart upload limits, go to <a href=\\\"https:
    }\
  },\
  \"shapes\":{\
    \"AbortDate\":{\"type\":\"timestamp\"},\
    \"AbortIncompleteMultipartUpload\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DaysAfterInitiation\":{\
          \"shape\":\"DaysAfterInitiation\",\
          \"documentation\":\"<p>Specifies the number of days after which Amazon S3 aborts an incomplete multipart upload.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the days since the initiation of an incomplete multipart upload that Amazon S3 will wait before permanently removing all parts of the upload. For more information, see <a href=\\\"https:
    },\
    \"AbortMultipartUploadOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"AbortMultipartUploadRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\",\
        \"UploadId\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name to which the upload was taking place. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Key of the object for which the multipart upload was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>Upload ID that identifies the multipart upload.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"uploadId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"AbortRuleId\":{\"type\":\"string\"},\
    \"AccelerateConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"BucketAccelerateStatus\",\
          \"documentation\":\"<p>Specifies the transfer acceleration status of the bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Configures the transfer acceleration state for an Amazon S3 bucket. For more information, see <a href=\\\"https:
    },\
    \"AcceptRanges\":{\"type\":\"string\"},\
    \"AccessControlPolicy\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Grants\":{\
          \"shape\":\"Grants\",\
          \"documentation\":\"<p>A list of grants.</p>\",\
          \"locationName\":\"AccessControlList\"\
        },\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>Container for the bucket owner's display name and ID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the elements that set the ACL permissions for an object per grantee.</p>\"\
    },\
    \"AccessControlTranslation\":{\
      \"type\":\"structure\",\
      \"required\":[\"Owner\"],\
      \"members\":{\
        \"Owner\":{\
          \"shape\":\"OwnerOverride\",\
          \"documentation\":\"<p>Specifies the replica ownership. For default and valid values, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>A container for information about access control for replicas.</p>\"\
    },\
    \"AccountId\":{\"type\":\"string\"},\
    \"AllowQuotedRecordDelimiter\":{\"type\":\"boolean\"},\
    \"AllowedHeader\":{\"type\":\"string\"},\
    \"AllowedHeaders\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"AllowedHeader\"},\
      \"flattened\":true\
    },\
    \"AllowedMethod\":{\"type\":\"string\"},\
    \"AllowedMethods\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"AllowedMethod\"},\
      \"flattened\":true\
    },\
    \"AllowedOrigin\":{\"type\":\"string\"},\
    \"AllowedOrigins\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"AllowedOrigin\"},\
      \"flattened\":true\
    },\
    \"AnalyticsAndOperator\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix to use when evaluating an AND predicate: The prefix that an object must have to be included in the metrics results.</p>\"\
        },\
        \"Tags\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>The list of tags to use when evaluating an AND predicate.</p>\",\
          \"flattened\":true,\
          \"locationName\":\"Tag\"\
        }\
      },\
      \"documentation\":\"<p>A conjunction (logical AND) of predicates, which is used in evaluating a metrics filter. The operator must have at least two predicates in any combination, and an object must match all of the predicates for the filter to apply.</p>\"\
    },\
    \"AnalyticsConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Id\",\
        \"StorageClassAnalysis\"\
      ],\
      \"members\":{\
        \"Id\":{\
          \"shape\":\"AnalyticsId\",\
          \"documentation\":\"<p>The ID that identifies the analytics configuration.</p>\"\
        },\
        \"Filter\":{\
          \"shape\":\"AnalyticsFilter\",\
          \"documentation\":\"<p>The filter used to describe a set of objects for analyses. A filter must have exactly one prefix, one tag, or one conjunction (AnalyticsAndOperator). If no filter is provided, all objects will be considered in any analysis.</p>\"\
        },\
        \"StorageClassAnalysis\":{\
          \"shape\":\"StorageClassAnalysis\",\
          \"documentation\":\"<p> Contains data related to access patterns to be collected and made available to analyze the tradeoffs between different storage classes. </p>\"\
        }\
      },\
      \"documentation\":\"<p> Specifies the configuration and any analyses for the analytics filter of an Amazon S3 bucket.</p>\"\
    },\
    \"AnalyticsConfigurationList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"AnalyticsConfiguration\"},\
      \"flattened\":true\
    },\
    \"AnalyticsExportDestination\":{\
      \"type\":\"structure\",\
      \"required\":[\"S3BucketDestination\"],\
      \"members\":{\
        \"S3BucketDestination\":{\
          \"shape\":\"AnalyticsS3BucketDestination\",\
          \"documentation\":\"<p>A destination signifying output to an S3 bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Where to publish the analytics results.</p>\"\
    },\
    \"AnalyticsFilter\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix to use when evaluating an analytics filter.</p>\"\
        },\
        \"Tag\":{\
          \"shape\":\"Tag\",\
          \"documentation\":\"<p>The tag to use when evaluating an analytics filter.</p>\"\
        },\
        \"And\":{\
          \"shape\":\"AnalyticsAndOperator\",\
          \"documentation\":\"<p>A conjunction (logical AND) of predicates, which is used in evaluating an analytics filter. The operator must have at least two predicates.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The filter used to describe a set of objects for analyses. A filter must have exactly one prefix, one tag, or one conjunction (AnalyticsAndOperator). If no filter is provided, all objects will be considered in any analysis.</p>\"\
    },\
    \"AnalyticsId\":{\"type\":\"string\"},\
    \"AnalyticsS3BucketDestination\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Format\",\
        \"Bucket\"\
      ],\
      \"members\":{\
        \"Format\":{\
          \"shape\":\"AnalyticsS3ExportFileFormat\",\
          \"documentation\":\"<p>Specifies the file format used when exporting data to Amazon S3.</p>\"\
        },\
        \"BucketAccountId\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account ID that owns the destination S3 bucket. If no account ID is provided, the owner is not validated before exporting data.</p> <note> <p> Although this value is optional, we strongly recommend that you set it to help prevent problems if the destination bucket ownership changes. </p> </note>\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the bucket to which data is exported.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix to use when exporting data. The prefix is prepended to all results.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains information about where to publish the analytics results.</p>\"\
    },\
    \"AnalyticsS3ExportFileFormat\":{\
      \"type\":\"string\",\
      \"enum\":[\"CSV\"]\
    },\
    \"Body\":{\"type\":\"blob\"},\
    \"Bucket\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Name\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket.</p>\"\
        },\
        \"CreationDate\":{\
          \"shape\":\"CreationDate\",\
          \"documentation\":\"<p>Date the bucket was created.</p>\"\
        }\
      },\
      \"documentation\":\"<p> In terms of implementation, a Bucket is a resource. An Amazon S3 bucket name is globally unique, and the namespace is shared by all AWS accounts. </p>\"\
    },\
    \"BucketAccelerateStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Suspended\"\
      ]\
    },\
    \"BucketAlreadyExists\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>The requested bucket name is not available. The bucket namespace is shared by all users of the system. Select a different name and try again.</p>\",\
      \"exception\":true\
    },\
    \"BucketAlreadyOwnedByYou\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>The bucket you tried to create already exists, and you own it. Amazon S3 returns this error in all AWS Regions except in the North Virginia Region. For legacy compatibility, if you re-create an existing bucket that you already own in the North Virginia Region, Amazon S3 returns 200 OK and resets the bucket access control lists (ACLs).</p>\",\
      \"exception\":true\
    },\
    \"BucketCannedACL\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"private\",\
        \"public-read\",\
        \"public-read-write\",\
        \"authenticated-read\"\
      ]\
    },\
    \"BucketLifecycleConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\"Rules\"],\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"LifecycleRules\",\
          \"documentation\":\"<p>A lifecycle rule for individual objects in an Amazon S3 bucket.</p>\",\
          \"locationName\":\"Rule\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the lifecycle configuration for objects in an Amazon S3 bucket. For more information, see <a href=\\\"https:
    },\
    \"BucketLocationConstraint\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"af-south-1\",\
        \"ap-east-1\",\
        \"ap-northeast-1\",\
        \"ap-northeast-2\",\
        \"ap-northeast-3\",\
        \"ap-south-1\",\
        \"ap-southeast-1\",\
        \"ap-southeast-2\",\
        \"ca-central-1\",\
        \"cn-north-1\",\
        \"cn-northwest-1\",\
        \"EU\",\
        \"eu-central-1\",\
        \"eu-north-1\",\
        \"eu-south-1\",\
        \"eu-west-1\",\
        \"eu-west-2\",\
        \"eu-west-3\",\
        \"me-south-1\",\
        \"sa-east-1\",\
        \"us-east-2\",\
        \"us-gov-east-1\",\
        \"us-gov-west-1\",\
        \"us-west-1\",\
        \"us-west-2\"\
      ]\
    },\
    \"BucketLoggingStatus\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"LoggingEnabled\":{\"shape\":\"LoggingEnabled\"}\
      },\
      \"documentation\":\"<p>Container for logging status information.</p>\"\
    },\
    \"BucketLogsPermission\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"FULL_CONTROL\",\
        \"READ\",\
        \"WRITE\"\
      ]\
    },\
    \"BucketName\":{\"type\":\"string\"},\
    \"BucketVersioningStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Suspended\"\
      ]\
    },\
    \"Buckets\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"Bucket\",\
        \"locationName\":\"Bucket\"\
      }\
    },\
    \"BypassGovernanceRetention\":{\"type\":\"boolean\"},\
    \"BytesProcessed\":{\"type\":\"long\"},\
    \"BytesReturned\":{\"type\":\"long\"},\
    \"BytesScanned\":{\"type\":\"long\"},\
    \"CORSConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\"CORSRules\"],\
      \"members\":{\
        \"CORSRules\":{\
          \"shape\":\"CORSRules\",\
          \"documentation\":\"<p>A set of origins and methods (cross-origin access that you want to allow). You can add up to 100 rules to the configuration.</p>\",\
          \"locationName\":\"CORSRule\"\
        }\
      },\
      \"documentation\":\"<p>Describes the cross-origin access configuration for objects in an Amazon S3 bucket. For more information, see <a href=\\\"https:
    },\
    \"CORSRule\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"AllowedMethods\",\
        \"AllowedOrigins\"\
      ],\
      \"members\":{\
        \"AllowedHeaders\":{\
          \"shape\":\"AllowedHeaders\",\
          \"documentation\":\"<p>Headers that are specified in the <code>Access-Control-Request-Headers</code> header. These headers are allowed in a preflight OPTIONS request. In response to any preflight OPTIONS request, Amazon S3 returns any requested headers that are allowed.</p>\",\
          \"locationName\":\"AllowedHeader\"\
        },\
        \"AllowedMethods\":{\
          \"shape\":\"AllowedMethods\",\
          \"documentation\":\"<p>An HTTP method that you allow the origin to execute. Valid values are <code>GET</code>, <code>PUT</code>, <code>HEAD</code>, <code>POST</code>, and <code>DELETE</code>.</p>\",\
          \"locationName\":\"AllowedMethod\"\
        },\
        \"AllowedOrigins\":{\
          \"shape\":\"AllowedOrigins\",\
          \"documentation\":\"<p>One or more origins you want customers to be able to access the bucket from.</p>\",\
          \"locationName\":\"AllowedOrigin\"\
        },\
        \"ExposeHeaders\":{\
          \"shape\":\"ExposeHeaders\",\
          \"documentation\":\"<p>One or more headers in the response that you want customers to be able to access from their applications (for example, from a JavaScript <code>XMLHttpRequest</code> object).</p>\",\
          \"locationName\":\"ExposeHeader\"\
        },\
        \"MaxAgeSeconds\":{\
          \"shape\":\"MaxAgeSeconds\",\
          \"documentation\":\"<p>The time in seconds that your browser is to cache the preflight response for the specified resource.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies a cross-origin access rule for an Amazon S3 bucket.</p>\"\
    },\
    \"CORSRules\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"CORSRule\"},\
      \"flattened\":true\
    },\
    \"CSVInput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"FileHeaderInfo\":{\
          \"shape\":\"FileHeaderInfo\",\
          \"documentation\":\"<p>Describes the first line of input. Valid values are:</p> <ul> <li> <p> <code>NONE</code>: First line is not a header.</p> </li> <li> <p> <code>IGNORE</code>: First line is a header, but you can't use the header values to indicate the column in an expression. You can use column position (such as _1, _2, â¦) to indicate the column (<code>SELECT s._1 FROM OBJECT s</code>).</p> </li> <li> <p> <code>Use</code>: First line is a header, and you can use the header value to identify a column in an expression (<code>SELECT \\\"name\\\" FROM OBJECT</code>). </p> </li> </ul>\"\
        },\
        \"Comments\":{\
          \"shape\":\"Comments\",\
          \"documentation\":\"<p>A single character used to indicate that a row should be ignored when the character is present at the start of that row. You can specify any character to indicate a comment line.</p>\"\
        },\
        \"QuoteEscapeCharacter\":{\
          \"shape\":\"QuoteEscapeCharacter\",\
          \"documentation\":\"<p>A single character used for escaping the quotation mark character inside an already escaped value. For example, the value \\\"\\\"\\\" a , b \\\"\\\"\\\" is parsed as \\\" a , b \\\".</p>\"\
        },\
        \"RecordDelimiter\":{\
          \"shape\":\"RecordDelimiter\",\
          \"documentation\":\"<p>A single character used to separate individual records in the input. Instead of the default value, you can specify an arbitrary delimiter.</p>\"\
        },\
        \"FieldDelimiter\":{\
          \"shape\":\"FieldDelimiter\",\
          \"documentation\":\"<p>A single character used to separate individual fields in a record. You can specify an arbitrary delimiter.</p>\"\
        },\
        \"QuoteCharacter\":{\
          \"shape\":\"QuoteCharacter\",\
          \"documentation\":\"<p>A single character used for escaping when the field delimiter is part of the value. For example, if the value is <code>a, b</code>, Amazon S3 wraps this field value in quotation marks, as follows: <code>\\\" a , b \\\"</code>.</p> <p>Type: String</p> <p>Default: <code>\\\"</code> </p> <p>Ancestors: <code>CSV</code> </p>\"\
        },\
        \"AllowQuotedRecordDelimiter\":{\
          \"shape\":\"AllowQuotedRecordDelimiter\",\
          \"documentation\":\"<p>Specifies that CSV field values may contain quoted record delimiters and such records should be allowed. Default value is FALSE. Setting this value to TRUE may lower performance.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes how an uncompressed comma-separated values (CSV)-formatted input object is formatted.</p>\"\
    },\
    \"CSVOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"QuoteFields\":{\
          \"shape\":\"QuoteFields\",\
          \"documentation\":\"<p>Indicates whether to use quotation marks around output fields. </p> <ul> <li> <p> <code>ALWAYS</code>: Always use quotation marks for output fields.</p> </li> <li> <p> <code>ASNEEDED</code>: Use quotation marks for output fields when needed.</p> </li> </ul>\"\
        },\
        \"QuoteEscapeCharacter\":{\
          \"shape\":\"QuoteEscapeCharacter\",\
          \"documentation\":\"<p>The single character used for escaping the quote character inside an already escaped value.</p>\"\
        },\
        \"RecordDelimiter\":{\
          \"shape\":\"RecordDelimiter\",\
          \"documentation\":\"<p>A single character used to separate individual records in the output. Instead of the default value, you can specify an arbitrary delimiter.</p>\"\
        },\
        \"FieldDelimiter\":{\
          \"shape\":\"FieldDelimiter\",\
          \"documentation\":\"<p>The value used to separate individual fields in a record. You can specify an arbitrary delimiter.</p>\"\
        },\
        \"QuoteCharacter\":{\
          \"shape\":\"QuoteCharacter\",\
          \"documentation\":\"<p>A single character used for escaping when the field delimiter is part of the value. For example, if the value is <code>a, b</code>, Amazon S3 wraps this field value in quotation marks, as follows: <code>\\\" a , b \\\"</code>.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes how uncompressed comma-separated values (CSV)-formatted results are formatted.</p>\"\
    },\
    \"CacheControl\":{\"type\":\"string\"},\
    \"CloudFunction\":{\"type\":\"string\"},\
    \"CloudFunctionConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Id\":{\"shape\":\"NotificationId\"},\
        \"Event\":{\
          \"shape\":\"Event\",\
          \"deprecated\":true\
        },\
        \"Events\":{\
          \"shape\":\"EventList\",\
          \"documentation\":\"<p>Bucket events for which to send notifications.</p>\",\
          \"locationName\":\"Event\"\
        },\
        \"CloudFunction\":{\
          \"shape\":\"CloudFunction\",\
          \"documentation\":\"<p>Lambda cloud function ARN that Amazon S3 can invoke when it detects events of the specified type.</p>\"\
        },\
        \"InvocationRole\":{\
          \"shape\":\"CloudFunctionInvocationRole\",\
          \"documentation\":\"<p>The role supporting the invocation of the Lambda function</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for specifying the AWS Lambda notification configuration.</p>\"\
    },\
    \"CloudFunctionInvocationRole\":{\"type\":\"string\"},\
    \"Code\":{\"type\":\"string\"},\
    \"Comments\":{\"type\":\"string\"},\
    \"CommonPrefix\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Container for the specified common prefix.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for all (if there are any) keys between Prefix and the next occurrence of the string specified by a delimiter. CommonPrefixes lists keys that act like subdirectories in the directory specified by Prefix. For example, if the prefix is notes/ and the delimiter is a slash (/) as in notes/summer/july, the common prefix is notes/summer/. </p>\"\
    },\
    \"CommonPrefixList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"CommonPrefix\"},\
      \"flattened\":true\
    },\
    \"CompleteMultipartUploadOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Location\":{\
          \"shape\":\"Location\",\
          \"documentation\":\"<p>The URI that identifies the newly created object.</p>\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket that contains the newly created object.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key of the newly created object.</p>\"\
        },\
        \"Expiration\":{\
          \"shape\":\"Expiration\",\
          \"documentation\":\"<p>If the object expiration is configured, this will contain the expiration date (expiry-date) and rule ID (rule-id). The value of rule-id is URL encoded.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expiration\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Entity tag that identifies the newly created object's data. Objects with different object data will have different entity tags. The entity tag is an opaque string. The entity tag may or may not be an MD5 digest of the object data. If the entity tag is not an MD5 digest of the object data, it will contain one or more nonhexadecimal characters and/or will consist of less than 32 or more than 32 hexadecimal digits.</p>\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>If you specified server-side encryption either with an Amazon S3-managed encryption key or an AWS KMS customer master key (CMK) in your initiate multipart upload request, the response includes this header. It confirms the encryption algorithm that Amazon S3 used to encrypt the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version ID of the newly created object, in case the bucket has versioning turned on.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"CompleteMultipartUploadRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\",\
        \"UploadId\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Name of the bucket to which the multipart upload was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"MultipartUpload\":{\
          \"shape\":\"CompletedMultipartUpload\",\
          \"documentation\":\"<p>The container for the multipart upload request information.</p>\",\
          \"locationName\":\"CompleteMultipartUpload\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>ID for the initiated multipart upload.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"uploadId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"MultipartUpload\"\
    },\
    \"CompletedMultipartUpload\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Parts\":{\
          \"shape\":\"CompletedPartList\",\
          \"documentation\":\"<p>Array of CompletedPart data types.</p>\",\
          \"locationName\":\"Part\"\
        }\
      },\
      \"documentation\":\"<p>The container for the completed multipart upload details.</p>\"\
    },\
    \"CompletedPart\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Entity tag returned when the part was uploaded.</p>\"\
        },\
        \"PartNumber\":{\
          \"shape\":\"PartNumber\",\
          \"documentation\":\"<p>Part number that identifies the part. This is a positive integer between 1 and 10,000.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Details of the parts that were uploaded.</p>\"\
    },\
    \"CompletedPartList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"CompletedPart\"},\
      \"flattened\":true\
    },\
    \"CompressionType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"NONE\",\
        \"GZIP\",\
        \"BZIP2\"\
      ]\
    },\
    \"Condition\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"HttpErrorCodeReturnedEquals\":{\
          \"shape\":\"HttpErrorCodeReturnedEquals\",\
          \"documentation\":\"<p>The HTTP error code when the redirect is applied. In the event of an error, if the error code equals this value, then the specified redirect is applied. Required when parent element <code>Condition</code> is specified and sibling <code>KeyPrefixEquals</code> is not specified. If both are specified, then both must be true for the redirect to be applied.</p>\"\
        },\
        \"KeyPrefixEquals\":{\
          \"shape\":\"KeyPrefixEquals\",\
          \"documentation\":\"<p>The object key name prefix when the redirect is applied. For example, to redirect requests for <code>ExamplePage.html</code>, the key prefix will be <code>ExamplePage.html</code>. To redirect request for all pages with the prefix <code>docs/</code>, the key prefix will be <code>/docs</code>, which identifies all objects in the <code>docs/</code> folder. Required when the parent element <code>Condition</code> is specified and sibling <code>HttpErrorCodeReturnedEquals</code> is not specified. If both conditions are specified, both must be true for the redirect to be applied.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A container for describing a condition that must be met for the specified redirect to apply. For example, 1. If request is for pages in the <code>/docs</code> folder, redirect to the <code>/documents</code> folder. 2. If request results in HTTP error 4xx, redirect request to another host where you might process the error.</p>\"\
    },\
    \"ConfirmRemoveSelfBucketAccess\":{\"type\":\"boolean\"},\
    \"ContentDisposition\":{\"type\":\"string\"},\
    \"ContentEncoding\":{\"type\":\"string\"},\
    \"ContentLanguage\":{\"type\":\"string\"},\
    \"ContentLength\":{\"type\":\"long\"},\
    \"ContentMD5\":{\"type\":\"string\"},\
    \"ContentRange\":{\"type\":\"string\"},\
    \"ContentType\":{\"type\":\"string\"},\
    \"ContinuationEvent\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p/>\",\
      \"event\":true\
    },\
    \"CopyObjectOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"CopyObjectResult\":{\
          \"shape\":\"CopyObjectResult\",\
          \"documentation\":\"<p>Container for all response elements.</p>\"\
        },\
        \"Expiration\":{\
          \"shape\":\"Expiration\",\
          \"documentation\":\"<p>If the object expiration is configured, the response includes this header.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expiration\"\
        },\
        \"CopySourceVersionId\":{\
          \"shape\":\"CopySourceVersionId\",\
          \"documentation\":\"<p>Version of the copied object in the destination bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-version-id\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version ID of the newly created copy.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"SSEKMSEncryptionContext\":{\
          \"shape\":\"SSEKMSEncryptionContext\",\
          \"documentation\":\"<p>If present, specifies the AWS KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-context\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      },\
      \"payload\":\"CopyObjectResult\"\
    },\
    \"CopyObjectRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"CopySource\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"ACL\":{\
          \"shape\":\"ObjectCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-acl\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the destination bucket.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"CacheControl\":{\
          \"shape\":\"CacheControl\",\
          \"documentation\":\"<p>Specifies caching behavior along the request/reply chain.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Cache-Control\"\
        },\
        \"ContentDisposition\":{\
          \"shape\":\"ContentDisposition\",\
          \"documentation\":\"<p>Specifies presentational information for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Disposition\"\
        },\
        \"ContentEncoding\":{\
          \"shape\":\"ContentEncoding\",\
          \"documentation\":\"<p>Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Encoding\"\
        },\
        \"ContentLanguage\":{\
          \"shape\":\"ContentLanguage\",\
          \"documentation\":\"<p>The language the content is in.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Language\"\
        },\
        \"ContentType\":{\
          \"shape\":\"ContentType\",\
          \"documentation\":\"<p>A standard MIME type describing the format of the object data.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Type\"\
        },\
        \"CopySource\":{\
          \"shape\":\"CopySource\",\
          \"documentation\":\"<p>Specifies the source object for the copy operation. You specify the value in one of two formats, depending on whether you want to access the source object through an <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source\"\
        },\
        \"CopySourceIfMatch\":{\
          \"shape\":\"CopySourceIfMatch\",\
          \"documentation\":\"<p>Copies the object if its entity tag (ETag) matches the specified tag.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-match\"\
        },\
        \"CopySourceIfModifiedSince\":{\
          \"shape\":\"CopySourceIfModifiedSince\",\
          \"documentation\":\"<p>Copies the object if it has been modified since the specified time.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-modified-since\"\
        },\
        \"CopySourceIfNoneMatch\":{\
          \"shape\":\"CopySourceIfNoneMatch\",\
          \"documentation\":\"<p>Copies the object if its entity tag (ETag) is different than the specified ETag.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-none-match\"\
        },\
        \"CopySourceIfUnmodifiedSince\":{\
          \"shape\":\"CopySourceIfUnmodifiedSince\",\
          \"documentation\":\"<p>Copies the object if it hasn't been modified since the specified time.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-unmodified-since\"\
        },\
        \"Expires\":{\
          \"shape\":\"Expires\",\
          \"documentation\":\"<p>The date and time at which the object is no longer cacheable.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Expires\"\
        },\
        \"GrantFullControl\":{\
          \"shape\":\"GrantFullControl\",\
          \"documentation\":\"<p>Gives the grantee READ, READ_ACP, and WRITE_ACP permissions on the object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-full-control\"\
        },\
        \"GrantRead\":{\
          \"shape\":\"GrantRead\",\
          \"documentation\":\"<p>Allows grantee to read the object data and its metadata.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read\"\
        },\
        \"GrantReadACP\":{\
          \"shape\":\"GrantReadACP\",\
          \"documentation\":\"<p>Allows grantee to read the object ACL.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read-acp\"\
        },\
        \"GrantWriteACP\":{\
          \"shape\":\"GrantWriteACP\",\
          \"documentation\":\"<p>Allows grantee to write the ACL for the applicable object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write-acp\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The key of the destination object.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"Metadata\":{\
          \"shape\":\"Metadata\",\
          \"documentation\":\"<p>A map of metadata to store with the object in S3.</p>\",\
          \"location\":\"headers\",\
          \"locationName\":\"x-amz-meta-\"\
        },\
        \"MetadataDirective\":{\
          \"shape\":\"MetadataDirective\",\
          \"documentation\":\"<p>Specifies whether the metadata is copied from the source object or replaced with metadata provided in the request.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-metadata-directive\"\
        },\
        \"TaggingDirective\":{\
          \"shape\":\"TaggingDirective\",\
          \"documentation\":\"<p>Specifies whether the object tag-set are copied from the source object or replaced with tag-set provided in the request.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-tagging-directive\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>By default, Amazon S3 uses the STANDARD Storage Class to store newly created objects. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class. Amazon S3 on Outposts only uses the OUTPOSTS Storage Class. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-storage-class\"\
        },\
        \"WebsiteRedirectLocation\":{\
          \"shape\":\"WebsiteRedirectLocation\",\
          \"documentation\":\"<p>If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-website-redirect-location\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm</code> header.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>Specifies the AWS KMS key ID to use for object encryption. All GET and PUT requests for an object protected by AWS KMS will fail if not made via SSL or using SigV4. For information about configuring using any of the officially supported AWS SDKs and AWS CLI, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"SSEKMSEncryptionContext\":{\
          \"shape\":\"SSEKMSEncryptionContext\",\
          \"documentation\":\"<p>Specifies the AWS KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-context\"\
        },\
        \"CopySourceSSECustomerAlgorithm\":{\
          \"shape\":\"CopySourceSSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use when decrypting the source object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-server-side-encryption-customer-algorithm\"\
        },\
        \"CopySourceSSECustomerKey\":{\
          \"shape\":\"CopySourceSSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use to decrypt the source object. The encryption key provided in this header must be one that was used when the source object was created.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-server-side-encryption-customer-key\"\
        },\
        \"CopySourceSSECustomerKeyMD5\":{\
          \"shape\":\"CopySourceSSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-server-side-encryption-customer-key-MD5\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"Tagging\":{\
          \"shape\":\"TaggingHeader\",\
          \"documentation\":\"<p>The tag-set for the object destination object this value must be used in conjunction with the <code>TaggingDirective</code>. The tag-set must be encoded as URL Query parameters.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-tagging\"\
        },\
        \"ObjectLockMode\":{\
          \"shape\":\"ObjectLockMode\",\
          \"documentation\":\"<p>The Object Lock mode that you want to apply to the copied object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-mode\"\
        },\
        \"ObjectLockRetainUntilDate\":{\
          \"shape\":\"ObjectLockRetainUntilDate\",\
          \"documentation\":\"<p>The date and time when you want the copied object's Object Lock to expire.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-retain-until-date\"\
        },\
        \"ObjectLockLegalHoldStatus\":{\
          \"shape\":\"ObjectLockLegalHoldStatus\",\
          \"documentation\":\"<p>Specifies whether you want to apply a Legal Hold to the copied object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-legal-hold\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected destination bucket owner. If the destination bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        },\
        \"ExpectedSourceBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected source bucket owner. If the source bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-source-expected-bucket-owner\"\
        }\
      }\
    },\
    \"CopyObjectResult\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Returns the ETag of the new object. The ETag reflects only changes to the contents of an object, not its metadata. The source and destination ETag is identical for a successfully copied object.</p>\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Returns the date that the object was last modified.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for all response elements.</p>\"\
    },\
    \"CopyPartResult\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Entity tag of the object.</p>\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Date and time at which the object was uploaded.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for all response elements.</p>\"\
    },\
    \"CopySource\":{\
      \"type\":\"string\",\
      \"pattern\":\"\\\\/.+\\\\/.+\"\
    },\
    \"CopySourceIfMatch\":{\"type\":\"string\"},\
    \"CopySourceIfModifiedSince\":{\"type\":\"timestamp\"},\
    \"CopySourceIfNoneMatch\":{\"type\":\"string\"},\
    \"CopySourceIfUnmodifiedSince\":{\"type\":\"timestamp\"},\
    \"CopySourceRange\":{\"type\":\"string\"},\
    \"CopySourceSSECustomerAlgorithm\":{\"type\":\"string\"},\
    \"CopySourceSSECustomerKey\":{\
      \"type\":\"string\",\
      \"sensitive\":true\
    },\
    \"CopySourceSSECustomerKeyMD5\":{\"type\":\"string\"},\
    \"CopySourceVersionId\":{\"type\":\"string\"},\
    \"CreateBucketConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"LocationConstraint\":{\
          \"shape\":\"BucketLocationConstraint\",\
          \"documentation\":\"<p>Specifies the Region where the bucket will be created. If you don't specify a Region, the bucket is created in the US East (N. Virginia) Region (us-east-1).</p>\"\
        }\
      },\
      \"documentation\":\"<p>The configuration information for the bucket.</p>\"\
    },\
    \"CreateBucketOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Location\":{\
          \"shape\":\"Location\",\
          \"documentation\":\"<p>Specifies the Region where the bucket will be created. If you are creating a bucket on the US East (N. Virginia) Region (us-east-1), you do not need to specify the location.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Location\"\
        }\
      }\
    },\
    \"CreateBucketRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"ACL\":{\
          \"shape\":\"BucketCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-acl\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to create.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"CreateBucketConfiguration\":{\
          \"shape\":\"CreateBucketConfiguration\",\
          \"documentation\":\"<p>The configuration information for the bucket.</p>\",\
          \"locationName\":\"CreateBucketConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"GrantFullControl\":{\
          \"shape\":\"GrantFullControl\",\
          \"documentation\":\"<p>Allows grantee the read, write, read ACP, and write ACP permissions on the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-full-control\"\
        },\
        \"GrantRead\":{\
          \"shape\":\"GrantRead\",\
          \"documentation\":\"<p>Allows grantee to list the objects in the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read\"\
        },\
        \"GrantReadACP\":{\
          \"shape\":\"GrantReadACP\",\
          \"documentation\":\"<p>Allows grantee to read the bucket ACL.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read-acp\"\
        },\
        \"GrantWrite\":{\
          \"shape\":\"GrantWrite\",\
          \"documentation\":\"<p>Allows grantee to create, overwrite, and delete any object in the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write\"\
        },\
        \"GrantWriteACP\":{\
          \"shape\":\"GrantWriteACP\",\
          \"documentation\":\"<p>Allows grantee to write the ACL for the applicable bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write-acp\"\
        },\
        \"ObjectLockEnabledForBucket\":{\
          \"shape\":\"ObjectLockEnabledForBucket\",\
          \"documentation\":\"<p>Specifies whether you want S3 Object Lock to be enabled for the new bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-bucket-object-lock-enabled\"\
        }\
      },\
      \"payload\":\"CreateBucketConfiguration\"\
    },\
    \"CreateMultipartUploadOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"AbortDate\":{\
          \"shape\":\"AbortDate\",\
          \"documentation\":\"<p>If the bucket has a lifecycle rule configured with an action to abort incomplete multipart uploads and the prefix in the lifecycle rule matches the object name in the request, the response includes this header. The header indicates when the initiated multipart upload becomes eligible for an abort operation. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-abort-date\"\
        },\
        \"AbortRuleId\":{\
          \"shape\":\"AbortRuleId\",\
          \"documentation\":\"<p>This header is returned along with the <code>x-amz-abort-date</code> header. It identifies the applicable lifecycle configuration rule that defines the action to abort incomplete multipart uploads.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-abort-rule-id\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which the multipart upload was initiated. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload was initiated.</p>\"\
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>ID for the initiated multipart upload.</p>\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"SSEKMSEncryptionContext\":{\
          \"shape\":\"SSEKMSEncryptionContext\",\
          \"documentation\":\"<p>If present, specifies the AWS KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-context\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"CreateMultipartUploadRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"ACL\":{\
          \"shape\":\"ObjectCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-acl\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which to initiate the upload</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"CacheControl\":{\
          \"shape\":\"CacheControl\",\
          \"documentation\":\"<p>Specifies caching behavior along the request/reply chain.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Cache-Control\"\
        },\
        \"ContentDisposition\":{\
          \"shape\":\"ContentDisposition\",\
          \"documentation\":\"<p>Specifies presentational information for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Disposition\"\
        },\
        \"ContentEncoding\":{\
          \"shape\":\"ContentEncoding\",\
          \"documentation\":\"<p>Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Encoding\"\
        },\
        \"ContentLanguage\":{\
          \"shape\":\"ContentLanguage\",\
          \"documentation\":\"<p>The language the content is in.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Language\"\
        },\
        \"ContentType\":{\
          \"shape\":\"ContentType\",\
          \"documentation\":\"<p>A standard MIME type describing the format of the object data.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Type\"\
        },\
        \"Expires\":{\
          \"shape\":\"Expires\",\
          \"documentation\":\"<p>The date and time at which the object is no longer cacheable.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Expires\"\
        },\
        \"GrantFullControl\":{\
          \"shape\":\"GrantFullControl\",\
          \"documentation\":\"<p>Gives the grantee READ, READ_ACP, and WRITE_ACP permissions on the object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-full-control\"\
        },\
        \"GrantRead\":{\
          \"shape\":\"GrantRead\",\
          \"documentation\":\"<p>Allows grantee to read the object data and its metadata.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read\"\
        },\
        \"GrantReadACP\":{\
          \"shape\":\"GrantReadACP\",\
          \"documentation\":\"<p>Allows grantee to read the object ACL.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read-acp\"\
        },\
        \"GrantWriteACP\":{\
          \"shape\":\"GrantWriteACP\",\
          \"documentation\":\"<p>Allows grantee to write the ACL for the applicable object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write-acp\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload is to be initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"Metadata\":{\
          \"shape\":\"Metadata\",\
          \"documentation\":\"<p>A map of metadata to store with the object in S3.</p>\",\
          \"location\":\"headers\",\
          \"locationName\":\"x-amz-meta-\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>By default, Amazon S3 uses the STANDARD Storage Class to store newly created objects. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class. Amazon S3 on Outposts only uses the OUTPOSTS Storage Class. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-storage-class\"\
        },\
        \"WebsiteRedirectLocation\":{\
          \"shape\":\"WebsiteRedirectLocation\",\
          \"documentation\":\"<p>If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-website-redirect-location\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm</code> header.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>Specifies the ID of the symmetric customer managed AWS KMS CMK to use for object encryption. All GET and PUT requests for an object protected by AWS KMS will fail if not made via SSL or using SigV4. For information about configuring using any of the officially supported AWS SDKs and AWS CLI, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"SSEKMSEncryptionContext\":{\
          \"shape\":\"SSEKMSEncryptionContext\",\
          \"documentation\":\"<p>Specifies the AWS KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-context\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"Tagging\":{\
          \"shape\":\"TaggingHeader\",\
          \"documentation\":\"<p>The tag-set for the object. The tag-set must be encoded as URL Query parameters.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-tagging\"\
        },\
        \"ObjectLockMode\":{\
          \"shape\":\"ObjectLockMode\",\
          \"documentation\":\"<p>Specifies the Object Lock mode that you want to apply to the uploaded object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-mode\"\
        },\
        \"ObjectLockRetainUntilDate\":{\
          \"shape\":\"ObjectLockRetainUntilDate\",\
          \"documentation\":\"<p>Specifies the date and time when you want the Object Lock to expire.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-retain-until-date\"\
        },\
        \"ObjectLockLegalHoldStatus\":{\
          \"shape\":\"ObjectLockLegalHoldStatus\",\
          \"documentation\":\"<p>Specifies whether you want to apply a Legal Hold to the uploaded object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-legal-hold\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"CreationDate\":{\"type\":\"timestamp\"},\
    \"Date\":{\
      \"type\":\"timestamp\",\
      \"timestampFormat\":\"iso8601\"\
    },\
    \"Days\":{\"type\":\"integer\"},\
    \"DaysAfterInitiation\":{\"type\":\"integer\"},\
    \"DefaultRetention\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Mode\":{\
          \"shape\":\"ObjectLockRetentionMode\",\
          \"documentation\":\"<p>The default Object Lock retention mode you want to apply to new objects placed in the specified bucket.</p>\"\
        },\
        \"Days\":{\
          \"shape\":\"Days\",\
          \"documentation\":\"<p>The number of days that you want to specify for the default retention period.</p>\"\
        },\
        \"Years\":{\
          \"shape\":\"Years\",\
          \"documentation\":\"<p>The number of years that you want to specify for the default retention period.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The container element for specifying the default Object Lock retention settings for new objects placed in the specified bucket.</p>\"\
    },\
    \"Delete\":{\
      \"type\":\"structure\",\
      \"required\":[\"Objects\"],\
      \"members\":{\
        \"Objects\":{\
          \"shape\":\"ObjectIdentifierList\",\
          \"documentation\":\"<p>The objects to delete.</p>\",\
          \"locationName\":\"Object\"\
        },\
        \"Quiet\":{\
          \"shape\":\"Quiet\",\
          \"documentation\":\"<p>Element to enable quiet mode for the request. When you add this element, you must set its value to true.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the objects to delete.</p>\"\
    },\
    \"DeleteBucketAnalyticsConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket from which an analytics configuration is deleted.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"AnalyticsId\",\
          \"documentation\":\"<p>The ID that identifies the analytics configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketCorsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Specifies the bucket whose <code>cors</code> configuration is being deleted.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketEncryptionRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the server-side encryption configuration to delete.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketInventoryConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the inventory configuration to delete.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"InventoryId\",\
          \"documentation\":\"<p>The ID used to identify the inventory configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketLifecycleRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name of the lifecycle to delete.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketMetricsConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the metrics configuration to delete.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"MetricsId\",\
          \"documentation\":\"<p>The ID used to identify the metrics configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketOwnershipControlsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The Amazon S3 bucket whose <code>OwnershipControls</code> you want to delete. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketPolicyRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketReplicationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p> The bucket name. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Specifies the bucket being deleted.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketTaggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket that has the tag set to be removed.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteBucketWebsiteRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name for which you want to remove the website configuration. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteMarker\":{\"type\":\"boolean\"},\
    \"DeleteMarkerEntry\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>The account that created the delete marker.&gt;</p>\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key.</p>\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version ID of an object.</p>\"\
        },\
        \"IsLatest\":{\
          \"shape\":\"IsLatest\",\
          \"documentation\":\"<p>Specifies whether the object is (true) or is not (false) the latest version of an object.</p>\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Date and time the object was last modified.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Information about the delete marker.</p>\"\
    },\
    \"DeleteMarkerReplication\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"DeleteMarkerReplicationStatus\",\
          \"documentation\":\"<p>Indicates whether to replicate delete markers.</p> <note> <p> In the current implementation, Amazon S3 doesn't replicate the delete markers. The status must be <code>Disabled</code>. </p> </note>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies whether Amazon S3 replicates the delete markers. If you specify a <code>Filter</code>, you must specify this element. However, in the latest version of replication configuration (when <code>Filter</code> is specified), Amazon S3 doesn't replicate delete markers. Therefore, the <code>DeleteMarkerReplication</code> element can contain only &lt;Status&gt;Disabled&lt;/Status&gt;. For an example configuration, see <a href=\\\"https:
    },\
    \"DeleteMarkerReplicationStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"DeleteMarkerVersionId\":{\"type\":\"string\"},\
    \"DeleteMarkers\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"DeleteMarkerEntry\"},\
      \"flattened\":true\
    },\
    \"DeleteObjectOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DeleteMarker\":{\
          \"shape\":\"DeleteMarker\",\
          \"documentation\":\"<p>Specifies whether the versioned object that was permanently deleted was (true) or was not (false) a delete marker.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-delete-marker\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Returns the version ID of the delete marker created as a result of the DELETE operation.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"DeleteObjectRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name of the bucket containing the object. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Key name of the object to delete.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"MFA\":{\
          \"shape\":\"MFA\",\
          \"documentation\":\"<p>The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. Required to permanently delete a versioned object if versioning is configured with MFA delete enabled.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-mfa\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId used to reference a specific version of the object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"BypassGovernanceRetention\":{\
          \"shape\":\"BypassGovernanceRetention\",\
          \"documentation\":\"<p>Indicates whether S3 Object Lock should bypass Governance-mode restrictions to process this operation.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-bypass-governance-retention\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteObjectTaggingOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The versionId of the object the tag-set was removed from.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        }\
      }\
    },\
    \"DeleteObjectTaggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the objects from which to remove the tags. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Name of the object key.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The versionId of the object that the tag-set will be removed from.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeleteObjectsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Deleted\":{\
          \"shape\":\"DeletedObjects\",\
          \"documentation\":\"<p>Container element for a successful delete. It identifies the object that was successfully deleted.</p>\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        },\
        \"Errors\":{\
          \"shape\":\"Errors\",\
          \"documentation\":\"<p>Container for a failed delete operation that describes the object that Amazon S3 attempted to delete and the error it encountered.</p>\",\
          \"locationName\":\"Error\"\
        }\
      }\
    },\
    \"DeleteObjectsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Delete\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the objects to delete. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Delete\":{\
          \"shape\":\"Delete\",\
          \"documentation\":\"<p>Container for the request.</p>\",\
          \"locationName\":\"Delete\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"MFA\":{\
          \"shape\":\"MFA\",\
          \"documentation\":\"<p>The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. Required to permanently delete a versioned object if versioning is configured with MFA delete enabled.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-mfa\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"BypassGovernanceRetention\":{\
          \"shape\":\"BypassGovernanceRetention\",\
          \"documentation\":\"<p>Specifies whether you want to delete this object even if it has a Governance-type Object Lock in place. You must have sufficient permissions to perform this operation.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-bypass-governance-retention\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Delete\"\
    },\
    \"DeletePublicAccessBlockRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The Amazon S3 bucket whose <code>PublicAccessBlock</code> configuration you want to delete. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"DeletedObject\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The name of the deleted object.</p>\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The version ID of the deleted object.</p>\"\
        },\
        \"DeleteMarker\":{\
          \"shape\":\"DeleteMarker\",\
          \"documentation\":\"<p>Specifies whether the versioned object that was permanently deleted was (true) or was not (false) a delete marker. In a simple DELETE, this header indicates whether (true) or not (false) a delete marker was created.</p>\"\
        },\
        \"DeleteMarkerVersionId\":{\
          \"shape\":\"DeleteMarkerVersionId\",\
          \"documentation\":\"<p>The version ID of the delete marker created as a result of the DELETE operation. If you delete a specific object version, the value returned by this header is the version ID of the object version deleted.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Information about the deleted object.</p>\"\
    },\
    \"DeletedObjects\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"DeletedObject\"},\
      \"flattened\":true\
    },\
    \"Delimiter\":{\"type\":\"string\"},\
    \"Description\":{\"type\":\"string\"},\
    \"Destination\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p> The Amazon Resource Name (ARN) of the bucket where you want Amazon S3 to store the results.</p>\"\
        },\
        \"Account\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>Destination bucket owner account ID. In a cross-account scenario, if you direct Amazon S3 to change replica ownership to the AWS account that owns the destination bucket by specifying the <code>AccessControlTranslation</code> property, this is the account ID of the destination bucket owner. For more information, see <a href=\\\"https:
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p> The storage class to use when replicating objects, such as S3 Standard or reduced redundancy. By default, Amazon S3 uses the storage class of the source object to create the object replica. </p> <p>For valid values, see the <code>StorageClass</code> element of the <a href=\\\"https:
        },\
        \"AccessControlTranslation\":{\
          \"shape\":\"AccessControlTranslation\",\
          \"documentation\":\"<p>Specify this only in a cross-account scenario (where source and destination bucket owners are not the same), and you want to change replica ownership to the AWS account that owns the destination bucket. If this is not specified in the replication configuration, the replicas are owned by same AWS account that owns the source object.</p>\"\
        },\
        \"EncryptionConfiguration\":{\
          \"shape\":\"EncryptionConfiguration\",\
          \"documentation\":\"<p>A container that provides information about encryption. If <code>SourceSelectionCriteria</code> is specified, you must specify this element.</p>\"\
        },\
        \"ReplicationTime\":{\
          \"shape\":\"ReplicationTime\",\
          \"documentation\":\"<p> A container specifying S3 Replication Time Control (S3 RTC), including whether S3 RTC is enabled and the time when all objects and operations on objects must be replicated. Must be specified together with a <code>Metrics</code> block. </p>\"\
        },\
        \"Metrics\":{\
          \"shape\":\"Metrics\",\
          \"documentation\":\"<p> A container specifying replication metrics-related settings enabling metrics and Amazon S3 events for S3 Replication Time Control (S3 RTC). Must be specified together with a <code>ReplicationTime</code> block. </p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies information about where to publish analysis or configuration results for an Amazon S3 bucket and S3 Replication Time Control (S3 RTC).</p>\"\
    },\
    \"DisplayName\":{\"type\":\"string\"},\
    \"ETag\":{\"type\":\"string\"},\
    \"EmailAddress\":{\"type\":\"string\"},\
    \"EnableRequestProgress\":{\"type\":\"boolean\"},\
    \"EncodingType\":{\
      \"type\":\"string\",\
      \"documentation\":\"<p>Requests Amazon S3 to encode the object keys in the response and specifies the encoding method to use. An object key may contain any Unicode character; however, XML 1.0 parser cannot parse some characters, such as characters with an ASCII value from 0 to 10. For characters that are not supported in XML 1.0, you can add this parameter to request that Amazon S3 encode the keys in the response.</p>\",\
      \"enum\":[\"url\"]\
    },\
    \"Encryption\":{\
      \"type\":\"structure\",\
      \"required\":[\"EncryptionType\"],\
      \"members\":{\
        \"EncryptionType\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing job results in Amazon S3 (for example, AES256, aws:kms).</p>\"\
        },\
        \"KMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If the encryption type is <code>aws:kms</code>, this optional value specifies the ID of the symmetric customer managed AWS KMS CMK to use for encryption of job results. Amazon S3 only supports symmetric CMKs. For more information, see <a href=\\\"https:
        },\
        \"KMSContext\":{\
          \"shape\":\"KMSContext\",\
          \"documentation\":\"<p>If the encryption type is <code>aws:kms</code>, this optional value can be used to specify the encryption context for the restore results.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the type of server-side encryption used.</p>\"\
    },\
    \"EncryptionConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ReplicaKmsKeyID\":{\
          \"shape\":\"ReplicaKmsKeyID\",\
          \"documentation\":\"<p>Specifies the ID (Key ARN or Alias ARN) of the customer managed customer master key (CMK) stored in AWS Key Management Service (KMS) for the destination bucket. Amazon S3 uses this key to encrypt replica objects. Amazon S3 only supports symmetric customer managed CMKs. For more information, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>Specifies encryption-related information for an Amazon S3 bucket that is a destination for replicated objects.</p>\"\
    },\
    \"End\":{\"type\":\"long\"},\
    \"EndEvent\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>A message that indicates the request is complete and no more messages will be sent. You should not assume that the request is complete until the client receives an <code>EndEvent</code>.</p>\",\
      \"event\":true\
    },\
    \"Error\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The error key.</p>\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The version ID of the error.</p>\"\
        },\
        \"Code\":{\
          \"shape\":\"Code\",\
          \"documentation\":\"<p>The error code is a string that uniquely identifies an error condition. It is meant to be read and understood by programs that detect and handle errors by type. </p> <p class=\\\"title\\\"> <b>Amazon S3 error codes</b> </p> <ul> <li> <ul> <li> <p> <i>Code:</i> AccessDenied </p> </li> <li> <p> <i>Description:</i> Access Denied</p> </li> <li> <p> <i>HTTP Status Code:</i> 403 Forbidden</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> AccountProblem</p> </li> <li> <p> <i>Description:</i> There is a problem with your AWS account that prevents the operation from completing successfully. Contact AWS Support for further assistance.</p> </li> <li> <p> <i>HTTP Status Code:</i> 403 Forbidden</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> AllAccessDisabled</p> </li> <li> <p> <i>Description:</i> All access to this Amazon S3 resource has been disabled. Contact AWS Support for further assistance.</p> </li> <li> <p> <i>HTTP Status Code:</i> 403 Forbidden</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> AmbiguousGrantByEmailAddress</p> </li> <li> <p> <i>Description:</i> The email address you provided is associated with more than one account.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> AuthorizationHeaderMalformed</p> </li> <li> <p> <i>Description:</i> The authorization header you provided is invalid.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>HTTP Status Code:</i> N/A</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> BadDigest</p> </li> <li> <p> <i>Description:</i> The Content-MD5 you specified did not match what we received.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> BucketAlreadyExists</p> </li> <li> <p> <i>Description:</i> The requested bucket name is not available. The bucket namespace is shared by all users of the system. Please select a different name and try again.</p> </li> <li> <p> <i>HTTP Status Code:</i> 409 Conflict</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> BucketAlreadyOwnedByYou</p> </li> <li> <p> <i>Description:</i> The bucket you tried to create already exists, and you own it. Amazon S3 returns this error in all AWS Regions except in the North Virginia Region. For legacy compatibility, if you re-create an existing bucket that you already own in the North Virginia Region, Amazon S3 returns 200 OK and resets the bucket access control lists (ACLs).</p> </li> <li> <p> <i>Code:</i> 409 Conflict (in all Regions except the North Virginia Region) </p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> BucketNotEmpty</p> </li> <li> <p> <i>Description:</i> The bucket you tried to delete is not empty.</p> </li> <li> <p> <i>HTTP Status Code:</i> 409 Conflict</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> CredentialsNotSupported</p> </li> <li> <p> <i>Description:</i> This request does not support credentials.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> CrossLocationLoggingProhibited</p> </li> <li> <p> <i>Description:</i> Cross-location logging not allowed. Buckets in one geographic location cannot log information to a bucket in another location.</p> </li> <li> <p> <i>HTTP Status Code:</i> 403 Forbidden</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> EntityTooSmall</p> </li> <li> <p> <i>Description:</i> Your proposed upload is smaller than the minimum allowed object size.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> EntityTooLarge</p> </li> <li> <p> <i>Description:</i> Your proposed upload exceeds the maximum allowed object size.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> ExpiredToken</p> </li> <li> <p> <i>Description:</i> The provided token has expired.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> IllegalVersioningConfigurationException </p> </li> <li> <p> <i>Description:</i> Indicates that the versioning configuration specified in the request is invalid.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> IncompleteBody</p> </li> <li> <p> <i>Description:</i> You did not provide the number of bytes specified by the Content-Length HTTP header</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> IncorrectNumberOfFilesInPostRequest</p> </li> <li> <p> <i>Description:</i> POST requires exactly one file upload per request.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InlineDataTooLarge</p> </li> <li> <p> <i>Description:</i> Inline data exceeds the maximum allowed size.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InternalError</p> </li> <li> <p> <i>Description:</i> We encountered an internal error. Please try again.</p> </li> <li> <p> <i>HTTP Status Code:</i> 500 Internal Server Error</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Server</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidAccessKeyId</p> </li> <li> <p> <i>Description:</i> The AWS access key ID you provided does not exist in our records.</p> </li> <li> <p> <i>HTTP Status Code:</i> 403 Forbidden</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidAddressingHeader</p> </li> <li> <p> <i>Description:</i> You must specify the Anonymous role.</p> </li> <li> <p> <i>HTTP Status Code:</i> N/A</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidArgument</p> </li> <li> <p> <i>Description:</i> Invalid Argument</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidBucketName</p> </li> <li> <p> <i>Description:</i> The specified bucket is not valid.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidBucketState</p> </li> <li> <p> <i>Description:</i> The request is not valid with the current state of the bucket.</p> </li> <li> <p> <i>HTTP Status Code:</i> 409 Conflict</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidDigest</p> </li> <li> <p> <i>Description:</i> The Content-MD5 you specified is not valid.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidEncryptionAlgorithmError</p> </li> <li> <p> <i>Description:</i> The encryption request you specified is not valid. The valid value is AES256.</p> </li> <li> <p> <i>HTTP Status Code:</i> 400 Bad Request</p> </li> <li> <p> <i>SOAP Fault Code Prefix:</i> Client</p> </li> </ul> </li> <li> <ul> <li> <p> <i>Code:</i> InvalidLocationConstraint</p> </li> <li> <p> <i>Description:</i> The specified location constraint is not valid. For more information about Regions, see <a href=\\\"https:
        },\
        \"Message\":{\
          \"shape\":\"Message\",\
          \"documentation\":\"<p>The error message contains a generic description of the error condition in English. It is intended for a human audience. Simple programs display the message directly to the end user if they encounter an error condition they don't know how or don't care to handle. Sophisticated programs with more exhaustive error handling and proper internationalization are more likely to ignore the error message.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for all error elements.</p>\"\
    },\
    \"ErrorDocument\":{\
      \"type\":\"structure\",\
      \"required\":[\"Key\"],\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key name to use when a 4XX class error occurs.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The error information.</p>\"\
    },\
    \"Errors\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Error\"},\
      \"flattened\":true\
    },\
    \"Event\":{\
      \"type\":\"string\",\
      \"documentation\":\"<p>The bucket event for which to send notifications.</p>\",\
      \"enum\":[\
        \"s3:ReducedRedundancyLostObject\",\
        \"s3:ObjectCreated:*\",\
        \"s3:ObjectCreated:Put\",\
        \"s3:ObjectCreated:Post\",\
        \"s3:ObjectCreated:Copy\",\
        \"s3:ObjectCreated:CompleteMultipartUpload\",\
        \"s3:ObjectRemoved:*\",\
        \"s3:ObjectRemoved:Delete\",\
        \"s3:ObjectRemoved:DeleteMarkerCreated\",\
        \"s3:ObjectRestore:*\",\
        \"s3:ObjectRestore:Post\",\
        \"s3:ObjectRestore:Completed\",\
        \"s3:Replication:*\",\
        \"s3:Replication:OperationFailedReplication\",\
        \"s3:Replication:OperationNotTracked\",\
        \"s3:Replication:OperationMissedThreshold\",\
        \"s3:Replication:OperationReplicatedAfterThreshold\"\
      ]\
    },\
    \"EventList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Event\"},\
      \"flattened\":true\
    },\
    \"ExistingObjectReplication\":{\
      \"type\":\"structure\",\
      \"required\":[\"Status\"],\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"ExistingObjectReplicationStatus\",\
          \"documentation\":\"<p/>\"\
        }\
      },\
      \"documentation\":\"<p>Optional configuration to replicate existing source bucket objects. For more information, see <a href=\\\" https:
    },\
    \"ExistingObjectReplicationStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"Expiration\":{\"type\":\"string\"},\
    \"ExpirationStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"ExpiredObjectDeleteMarker\":{\"type\":\"boolean\"},\
    \"Expires\":{\"type\":\"timestamp\"},\
    \"ExposeHeader\":{\"type\":\"string\"},\
    \"ExposeHeaders\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ExposeHeader\"},\
      \"flattened\":true\
    },\
    \"Expression\":{\"type\":\"string\"},\
    \"ExpressionType\":{\
      \"type\":\"string\",\
      \"enum\":[\"SQL\"]\
    },\
    \"FetchOwner\":{\"type\":\"boolean\"},\
    \"FieldDelimiter\":{\"type\":\"string\"},\
    \"FileHeaderInfo\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"USE\",\
        \"IGNORE\",\
        \"NONE\"\
      ]\
    },\
    \"FilterRule\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Name\":{\
          \"shape\":\"FilterRuleName\",\
          \"documentation\":\"<p>The object key name prefix or suffix identifying one or more objects to which the filtering rule applies. The maximum length is 1,024 characters. Overlapping prefixes and suffixes are not supported. For more information, see <a href=\\\"https:
        },\
        \"Value\":{\
          \"shape\":\"FilterRuleValue\",\
          \"documentation\":\"<p>The value that the filter searches for in object key names.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the Amazon S3 object key name to filter on and whether to filter on the suffix or prefix of the key name.</p>\"\
    },\
    \"FilterRuleList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"FilterRule\"},\
      \"documentation\":\"<p>A list of containers for the key-value pair that defines the criteria for the filter rule.</p>\",\
      \"flattened\":true\
    },\
    \"FilterRuleName\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"prefix\",\
        \"suffix\"\
      ]\
    },\
    \"FilterRuleValue\":{\"type\":\"string\"},\
    \"GetBucketAccelerateConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"BucketAccelerateStatus\",\
          \"documentation\":\"<p>The accelerate configuration of the bucket.</p>\"\
        }\
      }\
    },\
    \"GetBucketAccelerateConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which the accelerate configuration is retrieved.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketAclOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>Container for the bucket owner's display name and ID.</p>\"\
        },\
        \"Grants\":{\
          \"shape\":\"Grants\",\
          \"documentation\":\"<p>A list of grants.</p>\",\
          \"locationName\":\"AccessControlList\"\
        }\
      }\
    },\
    \"GetBucketAclRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Specifies the S3 bucket whose ACL is being requested.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketAnalyticsConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"AnalyticsConfiguration\":{\
          \"shape\":\"AnalyticsConfiguration\",\
          \"documentation\":\"<p>The configuration and any analyses for the analytics filter.</p>\"\
        }\
      },\
      \"payload\":\"AnalyticsConfiguration\"\
    },\
    \"GetBucketAnalyticsConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket from which an analytics configuration is retrieved.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"AnalyticsId\",\
          \"documentation\":\"<p>The ID that identifies the analytics configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketCorsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"CORSRules\":{\
          \"shape\":\"CORSRules\",\
          \"documentation\":\"<p>A set of origins and methods (cross-origin access that you want to allow). You can add up to 100 rules to the configuration.</p>\",\
          \"locationName\":\"CORSRule\"\
        }\
      }\
    },\
    \"GetBucketCorsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name for which to get the cors configuration.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketEncryptionOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ServerSideEncryptionConfiguration\":{\"shape\":\"ServerSideEncryptionConfiguration\"}\
      },\
      \"payload\":\"ServerSideEncryptionConfiguration\"\
    },\
    \"GetBucketEncryptionRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket from which the server-side encryption configuration is retrieved.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketInventoryConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"InventoryConfiguration\":{\
          \"shape\":\"InventoryConfiguration\",\
          \"documentation\":\"<p>Specifies the inventory configuration.</p>\"\
        }\
      },\
      \"payload\":\"InventoryConfiguration\"\
    },\
    \"GetBucketInventoryConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the inventory configuration to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"InventoryId\",\
          \"documentation\":\"<p>The ID used to identify the inventory configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketLifecycleConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"LifecycleRules\",\
          \"documentation\":\"<p>Container for a lifecycle rule.</p>\",\
          \"locationName\":\"Rule\"\
        }\
      }\
    },\
    \"GetBucketLifecycleConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the lifecycle information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketLifecycleOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"Rules\",\
          \"documentation\":\"<p>Container for a lifecycle rule.</p>\",\
          \"locationName\":\"Rule\"\
        }\
      }\
    },\
    \"GetBucketLifecycleRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the lifecycle information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketLocationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"LocationConstraint\":{\
          \"shape\":\"BucketLocationConstraint\",\
          \"documentation\":\"<p>Specifies the Region where the bucket resides. For a list of all the Amazon S3 supported location constraints by Region, see <a href=\\\"https:
        }\
      }\
    },\
    \"GetBucketLocationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the location.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketLoggingOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"LoggingEnabled\":{\"shape\":\"LoggingEnabled\"}\
      }\
    },\
    \"GetBucketLoggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name for which to get the logging information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketMetricsConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"MetricsConfiguration\":{\
          \"shape\":\"MetricsConfiguration\",\
          \"documentation\":\"<p>Specifies the metrics configuration.</p>\"\
        }\
      },\
      \"payload\":\"MetricsConfiguration\"\
    },\
    \"GetBucketMetricsConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the metrics configuration to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"MetricsId\",\
          \"documentation\":\"<p>The ID used to identify the metrics configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketNotificationConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the notification configuration.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketOwnershipControlsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"OwnershipControls\":{\
          \"shape\":\"OwnershipControls\",\
          \"documentation\":\"<p>The <code>OwnershipControls</code> (BucketOwnerPreferred or ObjectWriter) currently in effect for this Amazon S3 bucket.</p>\"\
        }\
      },\
      \"payload\":\"OwnershipControls\"\
    },\
    \"GetBucketOwnershipControlsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the Amazon S3 bucket whose <code>OwnershipControls</code> you want to retrieve. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketPolicyOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Policy\":{\
          \"shape\":\"Policy\",\
          \"documentation\":\"<p>The bucket policy as a JSON document.</p>\"\
        }\
      },\
      \"payload\":\"Policy\"\
    },\
    \"GetBucketPolicyRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name for which to get the bucket policy.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketPolicyStatusOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"PolicyStatus\":{\
          \"shape\":\"PolicyStatus\",\
          \"documentation\":\"<p>The policy status for the specified bucket.</p>\"\
        }\
      },\
      \"payload\":\"PolicyStatus\"\
    },\
    \"GetBucketPolicyStatusRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the Amazon S3 bucket whose policy status you want to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketReplicationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ReplicationConfiguration\":{\"shape\":\"ReplicationConfiguration\"}\
      },\
      \"payload\":\"ReplicationConfiguration\"\
    },\
    \"GetBucketReplicationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name for which to get the replication information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketRequestPaymentOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Payer\":{\
          \"shape\":\"Payer\",\
          \"documentation\":\"<p>Specifies who pays for the download and request fees.</p>\"\
        }\
      }\
    },\
    \"GetBucketRequestPaymentRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the payment request configuration</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketTaggingOutput\":{\
      \"type\":\"structure\",\
      \"required\":[\"TagSet\"],\
      \"members\":{\
        \"TagSet\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>Contains the tag set.</p>\"\
        }\
      }\
    },\
    \"GetBucketTaggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the tagging information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketVersioningOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"BucketVersioningStatus\",\
          \"documentation\":\"<p>The versioning state of the bucket.</p>\"\
        },\
        \"MFADelete\":{\
          \"shape\":\"MFADeleteStatus\",\
          \"documentation\":\"<p>Specifies whether MFA delete is enabled in the bucket versioning configuration. This element is only returned if the bucket has been configured with MFA delete. If the bucket has never been so configured, this element is not returned.</p>\",\
          \"locationName\":\"MfaDelete\"\
        }\
      }\
    },\
    \"GetBucketVersioningRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to get the versioning information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetBucketWebsiteOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RedirectAllRequestsTo\":{\
          \"shape\":\"RedirectAllRequestsTo\",\
          \"documentation\":\"<p>Specifies the redirect behavior of all requests to a website endpoint of an Amazon S3 bucket.</p>\"\
        },\
        \"IndexDocument\":{\
          \"shape\":\"IndexDocument\",\
          \"documentation\":\"<p>The name of the index document for the website (for example <code>index.html</code>).</p>\"\
        },\
        \"ErrorDocument\":{\
          \"shape\":\"ErrorDocument\",\
          \"documentation\":\"<p>The object key name of the website error document to use for 4XX class errors.</p>\"\
        },\
        \"RoutingRules\":{\
          \"shape\":\"RoutingRules\",\
          \"documentation\":\"<p>Rules that define when a redirect is applied and the redirect behavior.</p>\"\
        }\
      }\
    },\
    \"GetBucketWebsiteRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name for which to get the website configuration.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectAclOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p> Container for the bucket owner's display name and ID.</p>\"\
        },\
        \"Grants\":{\
          \"shape\":\"Grants\",\
          \"documentation\":\"<p>A list of grants.</p>\",\
          \"locationName\":\"AccessControlList\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"GetObjectAclRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name that contains the object for which to get the ACL information. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The key of the object for which to get the ACL information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId used to reference a specific version of the object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectLegalHoldOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"LegalHold\":{\
          \"shape\":\"ObjectLockLegalHold\",\
          \"documentation\":\"<p>The current Legal Hold status for the specified object.</p>\"\
        }\
      },\
      \"payload\":\"LegalHold\"\
    },\
    \"GetObjectLegalHoldRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the object whose Legal Hold status you want to retrieve. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The key name for the object whose Legal Hold status you want to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The version ID of the object whose Legal Hold status you want to retrieve.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectLockConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ObjectLockConfiguration\":{\
          \"shape\":\"ObjectLockConfiguration\",\
          \"documentation\":\"<p>The specified bucket's Object Lock configuration.</p>\"\
        }\
      },\
      \"payload\":\"ObjectLockConfiguration\"\
    },\
    \"GetObjectLockConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket whose Object Lock configuration you want to retrieve.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Body\":{\
          \"shape\":\"Body\",\
          \"documentation\":\"<p>Object data.</p>\",\
          \"streaming\":true\
        },\
        \"DeleteMarker\":{\
          \"shape\":\"DeleteMarker\",\
          \"documentation\":\"<p>Specifies whether the object retrieved was (true) or was not (false) a Delete Marker. If false, this response header does not appear in the response.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-delete-marker\"\
        },\
        \"AcceptRanges\":{\
          \"shape\":\"AcceptRanges\",\
          \"documentation\":\"<p>Indicates that a range of bytes was specified.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"accept-ranges\"\
        },\
        \"Expiration\":{\
          \"shape\":\"Expiration\",\
          \"documentation\":\"<p>If the object expiration is configured (see PUT Bucket lifecycle), the response includes this header. It includes the expiry-date and rule-id key-value pairs providing object expiration information. The value of the rule-id is URL encoded.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expiration\"\
        },\
        \"Restore\":{\
          \"shape\":\"Restore\",\
          \"documentation\":\"<p>Provides information about object restoration operation and expiration time of the restored object copy.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-restore\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Last modified date of the object</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Last-Modified\"\
        },\
        \"ContentLength\":{\
          \"shape\":\"ContentLength\",\
          \"documentation\":\"<p>Size of the body in bytes.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Length\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>An ETag is an opaque identifier assigned by a web server to a specific version of a resource found at a URL.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"ETag\"\
        },\
        \"MissingMeta\":{\
          \"shape\":\"MissingMeta\",\
          \"documentation\":\"<p>This is set to the number of metadata entries not returned in <code>x-amz-meta</code> headers. This can happen if you create metadata using an API like SOAP that supports more flexible metadata than the REST API. For example, using SOAP, you can create metadata whose values are not legal HTTP headers.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-missing-meta\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version of the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"CacheControl\":{\
          \"shape\":\"CacheControl\",\
          \"documentation\":\"<p>Specifies caching behavior along the request/reply chain.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Cache-Control\"\
        },\
        \"ContentDisposition\":{\
          \"shape\":\"ContentDisposition\",\
          \"documentation\":\"<p>Specifies presentational information for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Disposition\"\
        },\
        \"ContentEncoding\":{\
          \"shape\":\"ContentEncoding\",\
          \"documentation\":\"<p>Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Encoding\"\
        },\
        \"ContentLanguage\":{\
          \"shape\":\"ContentLanguage\",\
          \"documentation\":\"<p>The language the content is in.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Language\"\
        },\
        \"ContentRange\":{\
          \"shape\":\"ContentRange\",\
          \"documentation\":\"<p>The portion of the object returned in the response.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Range\"\
        },\
        \"ContentType\":{\
          \"shape\":\"ContentType\",\
          \"documentation\":\"<p>A standard MIME type describing the format of the object data.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Type\"\
        },\
        \"Expires\":{\
          \"shape\":\"Expires\",\
          \"documentation\":\"<p>The date and time at which the object is no longer cacheable.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Expires\"\
        },\
        \"WebsiteRedirectLocation\":{\
          \"shape\":\"WebsiteRedirectLocation\",\
          \"documentation\":\"<p>If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-website-redirect-location\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"Metadata\":{\
          \"shape\":\"Metadata\",\
          \"documentation\":\"<p>A map of metadata to store with the object in S3.</p>\",\
          \"location\":\"headers\",\
          \"locationName\":\"x-amz-meta-\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>Provides storage class information of the object. Amazon S3 returns this header for all objects except for S3 Standard storage class objects.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-storage-class\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        },\
        \"ReplicationStatus\":{\
          \"shape\":\"ReplicationStatus\",\
          \"documentation\":\"<p>Amazon S3 can return this if your request involves a bucket that is either a source or destination in a replication rule.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-replication-status\"\
        },\
        \"PartsCount\":{\
          \"shape\":\"PartsCount\",\
          \"documentation\":\"<p>The count of parts this object has.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-mp-parts-count\"\
        },\
        \"TagCount\":{\
          \"shape\":\"TagCount\",\
          \"documentation\":\"<p>The number of tags, if any, on the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-tagging-count\"\
        },\
        \"ObjectLockMode\":{\
          \"shape\":\"ObjectLockMode\",\
          \"documentation\":\"<p>The Object Lock mode currently in place for this object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-mode\"\
        },\
        \"ObjectLockRetainUntilDate\":{\
          \"shape\":\"ObjectLockRetainUntilDate\",\
          \"documentation\":\"<p>The date and time when this object's Object Lock will expire.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-retain-until-date\"\
        },\
        \"ObjectLockLegalHoldStatus\":{\
          \"shape\":\"ObjectLockLegalHoldStatus\",\
          \"documentation\":\"<p>Indicates whether this object has an active legal hold. This field is only returned if you have permission to view an object's legal hold status. </p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-legal-hold\"\
        }\
      },\
      \"payload\":\"Body\"\
    },\
    \"GetObjectRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the object. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"IfMatch\":{\
          \"shape\":\"IfMatch\",\
          \"documentation\":\"<p>Return the object only if its entity tag (ETag) is the same as the one specified, otherwise return a 412 (precondition failed).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-Match\"\
        },\
        \"IfModifiedSince\":{\
          \"shape\":\"IfModifiedSince\",\
          \"documentation\":\"<p>Return the object only if it has been modified since the specified time, otherwise return a 304 (not modified).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-Modified-Since\"\
        },\
        \"IfNoneMatch\":{\
          \"shape\":\"IfNoneMatch\",\
          \"documentation\":\"<p>Return the object only if its entity tag (ETag) is different from the one specified, otherwise return a 304 (not modified).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-None-Match\"\
        },\
        \"IfUnmodifiedSince\":{\
          \"shape\":\"IfUnmodifiedSince\",\
          \"documentation\":\"<p>Return the object only if it has not been modified since the specified time, otherwise return a 412 (precondition failed).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-Unmodified-Since\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Key of the object to get.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"Range\":{\
          \"shape\":\"Range\",\
          \"documentation\":\"<p>Downloads the specified range bytes of an object. For more information about the HTTP Range header, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"Range\"\
        },\
        \"ResponseCacheControl\":{\
          \"shape\":\"ResponseCacheControl\",\
          \"documentation\":\"<p>Sets the <code>Cache-Control</code> header of the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"response-cache-control\"\
        },\
        \"ResponseContentDisposition\":{\
          \"shape\":\"ResponseContentDisposition\",\
          \"documentation\":\"<p>Sets the <code>Content-Disposition</code> header of the response</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"response-content-disposition\"\
        },\
        \"ResponseContentEncoding\":{\
          \"shape\":\"ResponseContentEncoding\",\
          \"documentation\":\"<p>Sets the <code>Content-Encoding</code> header of the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"response-content-encoding\"\
        },\
        \"ResponseContentLanguage\":{\
          \"shape\":\"ResponseContentLanguage\",\
          \"documentation\":\"<p>Sets the <code>Content-Language</code> header of the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"response-content-language\"\
        },\
        \"ResponseContentType\":{\
          \"shape\":\"ResponseContentType\",\
          \"documentation\":\"<p>Sets the <code>Content-Type</code> header of the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"response-content-type\"\
        },\
        \"ResponseExpires\":{\
          \"shape\":\"ResponseExpires\",\
          \"documentation\":\"<p>Sets the <code>Expires</code> header of the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"response-expires\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId used to reference a specific version of the object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm</code> header.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"PartNumber\":{\
          \"shape\":\"PartNumber\",\
          \"documentation\":\"<p>Part number of the object being read. This is a positive integer between 1 and 10,000. Effectively performs a 'ranged' GET request for the part specified. Useful for downloading just a part of an object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"partNumber\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectRetentionOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Retention\":{\
          \"shape\":\"ObjectLockRetention\",\
          \"documentation\":\"<p>The container element for an object's retention settings.</p>\"\
        }\
      },\
      \"payload\":\"Retention\"\
    },\
    \"GetObjectRetentionRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the object whose retention settings you want to retrieve. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The key name for the object whose retention settings you want to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The version ID for the object whose retention settings you want to retrieve.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectTaggingOutput\":{\
      \"type\":\"structure\",\
      \"required\":[\"TagSet\"],\
      \"members\":{\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The versionId of the object for which you got the tagging information.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"TagSet\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>Contains the tag set.</p>\"\
        }\
      }\
    },\
    \"GetObjectTaggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the object for which to get the tagging information. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which to get the tagging information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The versionId of the object for which to get the tagging information.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetObjectTorrentOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Body\":{\
          \"shape\":\"Body\",\
          \"documentation\":\"<p>A Bencoded dictionary as defined by the BitTorrent specification</p>\",\
          \"streaming\":true\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      },\
      \"payload\":\"Body\"\
    },\
    \"GetObjectTorrentRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the object for which to get the torrent files.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key for which to get the information.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GetPublicAccessBlockOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"PublicAccessBlockConfiguration\":{\
          \"shape\":\"PublicAccessBlockConfiguration\",\
          \"documentation\":\"<p>The <code>PublicAccessBlock</code> configuration currently in effect for this Amazon S3 bucket.</p>\"\
        }\
      },\
      \"payload\":\"PublicAccessBlockConfiguration\"\
    },\
    \"GetPublicAccessBlockRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the Amazon S3 bucket whose <code>PublicAccessBlock</code> configuration you want to retrieve. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"GlacierJobParameters\":{\
      \"type\":\"structure\",\
      \"required\":[\"Tier\"],\
      \"members\":{\
        \"Tier\":{\
          \"shape\":\"Tier\",\
          \"documentation\":\"<p>S3 Glacier retrieval tier at which the restore will be processed.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for S3 Glacier job parameters.</p>\"\
    },\
    \"Grant\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Grantee\":{\
          \"shape\":\"Grantee\",\
          \"documentation\":\"<p>The person being granted permissions.</p>\"\
        },\
        \"Permission\":{\
          \"shape\":\"Permission\",\
          \"documentation\":\"<p>Specifies the permission given to the grantee.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for grant information.</p>\"\
    },\
    \"GrantFullControl\":{\"type\":\"string\"},\
    \"GrantRead\":{\"type\":\"string\"},\
    \"GrantReadACP\":{\"type\":\"string\"},\
    \"GrantWrite\":{\"type\":\"string\"},\
    \"GrantWriteACP\":{\"type\":\"string\"},\
    \"Grantee\":{\
      \"type\":\"structure\",\
      \"required\":[\"Type\"],\
      \"members\":{\
        \"DisplayName\":{\
          \"shape\":\"DisplayName\",\
          \"documentation\":\"<p>Screen name of the grantee.</p>\"\
        },\
        \"EmailAddress\":{\
          \"shape\":\"EmailAddress\",\
          \"documentation\":\"<p>Email address of the grantee.</p> <note> <p>Using email addresses to specify a grantee is only supported in the following AWS Regions: </p> <ul> <li> <p>US East (N. Virginia)</p> </li> <li> <p>US West (N. California)</p> </li> <li> <p> US West (Oregon)</p> </li> <li> <p> Asia Pacific (Singapore)</p> </li> <li> <p>Asia Pacific (Sydney)</p> </li> <li> <p>Asia Pacific (Tokyo)</p> </li> <li> <p>Europe (Ireland)</p> </li> <li> <p>South America (SÃ£o Paulo)</p> </li> </ul> <p>For a list of all the Amazon S3 supported Regions and endpoints, see <a href=\\\"https:
        },\
        \"ID\":{\
          \"shape\":\"ID\",\
          \"documentation\":\"<p>The canonical user ID of the grantee.</p>\"\
        },\
        \"Type\":{\
          \"shape\":\"Type\",\
          \"documentation\":\"<p>Type of grantee</p>\",\
          \"locationName\":\"xsi:type\",\
          \"xmlAttribute\":true\
        },\
        \"URI\":{\
          \"shape\":\"URI\",\
          \"documentation\":\"<p>URI of the grantee group.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the person being granted permissions.</p>\",\
      \"xmlNamespace\":{\
        \"prefix\":\"xsi\",\
        \"uri\":\"http:
      }\
    },\
    \"Grants\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"Grant\",\
        \"locationName\":\"Grant\"\
      }\
    },\
    \"HeadBucketRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"HeadObjectOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DeleteMarker\":{\
          \"shape\":\"DeleteMarker\",\
          \"documentation\":\"<p>Specifies whether the object retrieved was (true) or was not (false) a Delete Marker. If false, this response header does not appear in the response.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-delete-marker\"\
        },\
        \"AcceptRanges\":{\
          \"shape\":\"AcceptRanges\",\
          \"documentation\":\"<p>Indicates that a range of bytes was specified.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"accept-ranges\"\
        },\
        \"Expiration\":{\
          \"shape\":\"Expiration\",\
          \"documentation\":\"<p>If the object expiration is configured (see PUT Bucket lifecycle), the response includes this header. It includes the expiry-date and rule-id key-value pairs providing object expiration information. The value of the rule-id is URL encoded.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expiration\"\
        },\
        \"Restore\":{\
          \"shape\":\"Restore\",\
          \"documentation\":\"<p>If the object is an archived object (an object whose storage class is GLACIER), the response includes this header if either the archive restoration is in progress (see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-restore\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Last modified date of the object</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Last-Modified\"\
        },\
        \"ContentLength\":{\
          \"shape\":\"ContentLength\",\
          \"documentation\":\"<p>Size of the body in bytes.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Length\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>An ETag is an opaque identifier assigned by a web server to a specific version of a resource found at a URL.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"ETag\"\
        },\
        \"MissingMeta\":{\
          \"shape\":\"MissingMeta\",\
          \"documentation\":\"<p>This is set to the number of metadata entries not returned in <code>x-amz-meta</code> headers. This can happen if you create metadata using an API like SOAP that supports more flexible metadata than the REST API. For example, using SOAP, you can create metadata whose values are not legal HTTP headers.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-missing-meta\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version of the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"CacheControl\":{\
          \"shape\":\"CacheControl\",\
          \"documentation\":\"<p>Specifies caching behavior along the request/reply chain.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Cache-Control\"\
        },\
        \"ContentDisposition\":{\
          \"shape\":\"ContentDisposition\",\
          \"documentation\":\"<p>Specifies presentational information for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Disposition\"\
        },\
        \"ContentEncoding\":{\
          \"shape\":\"ContentEncoding\",\
          \"documentation\":\"<p>Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Encoding\"\
        },\
        \"ContentLanguage\":{\
          \"shape\":\"ContentLanguage\",\
          \"documentation\":\"<p>The language the content is in.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Language\"\
        },\
        \"ContentType\":{\
          \"shape\":\"ContentType\",\
          \"documentation\":\"<p>A standard MIME type describing the format of the object data.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Type\"\
        },\
        \"Expires\":{\
          \"shape\":\"Expires\",\
          \"documentation\":\"<p>The date and time at which the object is no longer cacheable.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Expires\"\
        },\
        \"WebsiteRedirectLocation\":{\
          \"shape\":\"WebsiteRedirectLocation\",\
          \"documentation\":\"<p>If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-website-redirect-location\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>If the object is stored using server-side encryption either with an AWS KMS customer master key (CMK) or an Amazon S3-managed encryption key, the response includes this header with the value of the server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"Metadata\":{\
          \"shape\":\"Metadata\",\
          \"documentation\":\"<p>A map of metadata to store with the object in S3.</p>\",\
          \"location\":\"headers\",\
          \"locationName\":\"x-amz-meta-\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>Provides storage class information of the object. Amazon S3 returns this header for all objects except for S3 Standard storage class objects.</p> <p>For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-storage-class\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        },\
        \"ReplicationStatus\":{\
          \"shape\":\"ReplicationStatus\",\
          \"documentation\":\"<p>Amazon S3 can return this header if your request involves a bucket that is either a source or destination in a replication rule.</p> <p>In replication, you have a source bucket on which you configure replication and destination bucket where Amazon S3 stores object replicas. When you request an object (<code>GetObject</code>) or object metadata (<code>HeadObject</code>) from these buckets, Amazon S3 will return the <code>x-amz-replication-status</code> header in the response as follows:</p> <ul> <li> <p>If requesting an object from the source bucket â Amazon S3 will return the <code>x-amz-replication-status</code> header if the object in your request is eligible for replication.</p> <p> For example, suppose that in your replication configuration, you specify object prefix <code>TaxDocs</code> requesting Amazon S3 to replicate objects with key prefix <code>TaxDocs</code>. Any objects you upload with this key name prefix, for example <code>TaxDocs/document1.pdf</code>, are eligible for replication. For any object request with this key name prefix, Amazon S3 will return the <code>x-amz-replication-status</code> header with value PENDING, COMPLETED or FAILED indicating object replication status.</p> </li> <li> <p>If requesting an object from the destination bucket â Amazon S3 will return the <code>x-amz-replication-status</code> header with value REPLICA if the object in your request is a replica that Amazon S3 created.</p> </li> </ul> <p>For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-replication-status\"\
        },\
        \"PartsCount\":{\
          \"shape\":\"PartsCount\",\
          \"documentation\":\"<p>The count of parts this object has.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-mp-parts-count\"\
        },\
        \"ObjectLockMode\":{\
          \"shape\":\"ObjectLockMode\",\
          \"documentation\":\"<p>The Object Lock mode, if any, that's in effect for this object. This header is only returned if the requester has the <code>s3:GetObjectRetention</code> permission. For more information about S3 Object Lock, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-mode\"\
        },\
        \"ObjectLockRetainUntilDate\":{\
          \"shape\":\"ObjectLockRetainUntilDate\",\
          \"documentation\":\"<p>The date and time when the Object Lock retention period expires. This header is only returned if the requester has the <code>s3:GetObjectRetention</code> permission.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-retain-until-date\"\
        },\
        \"ObjectLockLegalHoldStatus\":{\
          \"shape\":\"ObjectLockLegalHoldStatus\",\
          \"documentation\":\"<p>Specifies whether a legal hold is in effect for this object. This header is only returned if the requester has the <code>s3:GetObjectLegalHold</code> permission. This header is not returned if the specified version of this object has never had a legal hold applied. For more information about S3 Object Lock, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-legal-hold\"\
        }\
      }\
    },\
    \"HeadObjectRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the object.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"IfMatch\":{\
          \"shape\":\"IfMatch\",\
          \"documentation\":\"<p>Return the object only if its entity tag (ETag) is the same as the one specified, otherwise return a 412 (precondition failed).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-Match\"\
        },\
        \"IfModifiedSince\":{\
          \"shape\":\"IfModifiedSince\",\
          \"documentation\":\"<p>Return the object only if it has been modified since the specified time, otherwise return a 304 (not modified).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-Modified-Since\"\
        },\
        \"IfNoneMatch\":{\
          \"shape\":\"IfNoneMatch\",\
          \"documentation\":\"<p>Return the object only if its entity tag (ETag) is different from the one specified, otherwise return a 304 (not modified).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-None-Match\"\
        },\
        \"IfUnmodifiedSince\":{\
          \"shape\":\"IfUnmodifiedSince\",\
          \"documentation\":\"<p>Return the object only if it has not been modified since the specified time, otherwise return a 412 (precondition failed).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"If-Unmodified-Since\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"Range\":{\
          \"shape\":\"Range\",\
          \"documentation\":\"<p>Downloads the specified range bytes of an object. For more information about the HTTP Range header, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Range\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId used to reference a specific version of the object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm</code> header.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"PartNumber\":{\
          \"shape\":\"PartNumber\",\
          \"documentation\":\"<p>Part number of the object being read. This is a positive integer between 1 and 10,000. Effectively performs a 'ranged' HEAD request for the part specified. Useful querying about the size of the part and the number of parts in this object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"partNumber\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"HostName\":{\"type\":\"string\"},\
    \"HttpErrorCodeReturnedEquals\":{\"type\":\"string\"},\
    \"HttpRedirectCode\":{\"type\":\"string\"},\
    \"ID\":{\"type\":\"string\"},\
    \"IfMatch\":{\"type\":\"string\"},\
    \"IfModifiedSince\":{\"type\":\"timestamp\"},\
    \"IfNoneMatch\":{\"type\":\"string\"},\
    \"IfUnmodifiedSince\":{\"type\":\"timestamp\"},\
    \"IndexDocument\":{\
      \"type\":\"structure\",\
      \"required\":[\"Suffix\"],\
      \"members\":{\
        \"Suffix\":{\
          \"shape\":\"Suffix\",\
          \"documentation\":\"<p>A suffix that is appended to a request that is for a directory on the website endpoint (for example,if the suffix is index.html and you make a request to samplebucket/images/ the data that is returned will be for the object with the key name images/index.html) The suffix must not be empty and must not include a slash character.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the <code>Suffix</code> element.</p>\"\
    },\
    \"Initiated\":{\"type\":\"timestamp\"},\
    \"Initiator\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ID\":{\
          \"shape\":\"ID\",\
          \"documentation\":\"<p>If the principal is an AWS account, it provides the Canonical User ID. If the principal is an IAM User, it provides a user ARN value.</p>\"\
        },\
        \"DisplayName\":{\
          \"shape\":\"DisplayName\",\
          \"documentation\":\"<p>Name of the Principal.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container element that identifies who initiated the multipart upload. </p>\"\
    },\
    \"InputSerialization\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"CSV\":{\
          \"shape\":\"CSVInput\",\
          \"documentation\":\"<p>Describes the serialization of a CSV-encoded object.</p>\"\
        },\
        \"CompressionType\":{\
          \"shape\":\"CompressionType\",\
          \"documentation\":\"<p>Specifies object's compression format. Valid values: NONE, GZIP, BZIP2. Default Value: NONE.</p>\"\
        },\
        \"JSON\":{\
          \"shape\":\"JSONInput\",\
          \"documentation\":\"<p>Specifies JSON as object's input serialization format.</p>\"\
        },\
        \"Parquet\":{\
          \"shape\":\"ParquetInput\",\
          \"documentation\":\"<p>Specifies Parquet as object's input serialization format.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes the serialization format of the object.</p>\"\
    },\
    \"InventoryConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Destination\",\
        \"IsEnabled\",\
        \"Id\",\
        \"IncludedObjectVersions\",\
        \"Schedule\"\
      ],\
      \"members\":{\
        \"Destination\":{\
          \"shape\":\"InventoryDestination\",\
          \"documentation\":\"<p>Contains information about where to publish the inventory results.</p>\"\
        },\
        \"IsEnabled\":{\
          \"shape\":\"IsEnabled\",\
          \"documentation\":\"<p>Specifies whether the inventory is enabled or disabled. If set to <code>True</code>, an inventory list is generated. If set to <code>False</code>, no inventory list is generated.</p>\"\
        },\
        \"Filter\":{\
          \"shape\":\"InventoryFilter\",\
          \"documentation\":\"<p>Specifies an inventory filter. The inventory only includes objects that meet the filter's criteria.</p>\"\
        },\
        \"Id\":{\
          \"shape\":\"InventoryId\",\
          \"documentation\":\"<p>The ID used to identify the inventory configuration.</p>\"\
        },\
        \"IncludedObjectVersions\":{\
          \"shape\":\"InventoryIncludedObjectVersions\",\
          \"documentation\":\"<p>Object versions to include in the inventory list. If set to <code>All</code>, the list includes all the object versions, which adds the version-related fields <code>VersionId</code>, <code>IsLatest</code>, and <code>DeleteMarker</code> to the list. If set to <code>Current</code>, the list does not contain these version-related fields.</p>\"\
        },\
        \"OptionalFields\":{\
          \"shape\":\"InventoryOptionalFields\",\
          \"documentation\":\"<p>Contains the optional fields that are included in the inventory results.</p>\"\
        },\
        \"Schedule\":{\
          \"shape\":\"InventorySchedule\",\
          \"documentation\":\"<p>Specifies the schedule for generating inventory results.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the inventory configuration for an Amazon S3 bucket. For more information, see <a href=\\\"https:
    },\
    \"InventoryConfigurationList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"InventoryConfiguration\"},\
      \"flattened\":true\
    },\
    \"InventoryDestination\":{\
      \"type\":\"structure\",\
      \"required\":[\"S3BucketDestination\"],\
      \"members\":{\
        \"S3BucketDestination\":{\
          \"shape\":\"InventoryS3BucketDestination\",\
          \"documentation\":\"<p>Contains the bucket name, file format, bucket owner (optional), and prefix (optional) where inventory results are published.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the inventory configuration for an Amazon S3 bucket.</p>\"\
    },\
    \"InventoryEncryption\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"SSES3\":{\
          \"shape\":\"SSES3\",\
          \"documentation\":\"<p>Specifies the use of SSE-S3 to encrypt delivered inventory reports.</p>\",\
          \"locationName\":\"SSE-S3\"\
        },\
        \"SSEKMS\":{\
          \"shape\":\"SSEKMS\",\
          \"documentation\":\"<p>Specifies the use of SSE-KMS to encrypt delivered inventory reports.</p>\",\
          \"locationName\":\"SSE-KMS\"\
        }\
      },\
      \"documentation\":\"<p>Contains the type of server-side encryption used to encrypt the inventory results.</p>\"\
    },\
    \"InventoryFilter\":{\
      \"type\":\"structure\",\
      \"required\":[\"Prefix\"],\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix that an object must have to be included in the inventory results.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies an inventory filter. The inventory only includes objects that meet the filter's criteria.</p>\"\
    },\
    \"InventoryFormat\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"CSV\",\
        \"ORC\",\
        \"Parquet\"\
      ]\
    },\
    \"InventoryFrequency\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Daily\",\
        \"Weekly\"\
      ]\
    },\
    \"InventoryId\":{\"type\":\"string\"},\
    \"InventoryIncludedObjectVersions\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"All\",\
        \"Current\"\
      ]\
    },\
    \"InventoryOptionalField\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Size\",\
        \"LastModifiedDate\",\
        \"StorageClass\",\
        \"ETag\",\
        \"IsMultipartUploaded\",\
        \"ReplicationStatus\",\
        \"EncryptionStatus\",\
        \"ObjectLockRetainUntilDate\",\
        \"ObjectLockMode\",\
        \"ObjectLockLegalHoldStatus\",\
        \"IntelligentTieringAccessTier\"\
      ]\
    },\
    \"InventoryOptionalFields\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"InventoryOptionalField\",\
        \"locationName\":\"Field\"\
      }\
    },\
    \"InventoryS3BucketDestination\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Format\"\
      ],\
      \"members\":{\
        \"AccountId\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account ID that owns the destination S3 bucket. If no account ID is provided, the owner is not validated before exporting data. </p> <note> <p> Although this value is optional, we strongly recommend that you set it to help prevent problems if the destination bucket ownership changes. </p> </note>\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the bucket where inventory results will be published.</p>\"\
        },\
        \"Format\":{\
          \"shape\":\"InventoryFormat\",\
          \"documentation\":\"<p>Specifies the output format of the inventory results.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix that is prepended to all inventory results.</p>\"\
        },\
        \"Encryption\":{\
          \"shape\":\"InventoryEncryption\",\
          \"documentation\":\"<p>Contains the type of server-side encryption used to encrypt the inventory results.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the bucket name, file format, bucket owner (optional), and prefix (optional) where inventory results are published.</p>\"\
    },\
    \"InventorySchedule\":{\
      \"type\":\"structure\",\
      \"required\":[\"Frequency\"],\
      \"members\":{\
        \"Frequency\":{\
          \"shape\":\"InventoryFrequency\",\
          \"documentation\":\"<p>Specifies how frequently inventory results are produced.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the schedule for generating inventory results.</p>\"\
    },\
    \"IsEnabled\":{\"type\":\"boolean\"},\
    \"IsLatest\":{\"type\":\"boolean\"},\
    \"IsPublic\":{\"type\":\"boolean\"},\
    \"IsTruncated\":{\"type\":\"boolean\"},\
    \"JSONInput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Type\":{\
          \"shape\":\"JSONType\",\
          \"documentation\":\"<p>The type of JSON. Valid values: Document, Lines.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies JSON as object's input serialization format.</p>\"\
    },\
    \"JSONOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RecordDelimiter\":{\
          \"shape\":\"RecordDelimiter\",\
          \"documentation\":\"<p>The value used to separate individual records in the output. If no value is specified, Amazon S3 uses a newline character ('\\\\n').</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies JSON as request's output serialization format.</p>\"\
    },\
    \"JSONType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"DOCUMENT\",\
        \"LINES\"\
      ]\
    },\
    \"KMSContext\":{\"type\":\"string\"},\
    \"KeyCount\":{\"type\":\"integer\"},\
    \"KeyMarker\":{\"type\":\"string\"},\
    \"KeyPrefixEquals\":{\"type\":\"string\"},\
    \"LambdaFunctionArn\":{\"type\":\"string\"},\
    \"LambdaFunctionConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"LambdaFunctionArn\",\
        \"Events\"\
      ],\
      \"members\":{\
        \"Id\":{\"shape\":\"NotificationId\"},\
        \"LambdaFunctionArn\":{\
          \"shape\":\"LambdaFunctionArn\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the AWS Lambda function that Amazon S3 invokes when the specified event type occurs.</p>\",\
          \"locationName\":\"CloudFunction\"\
        },\
        \"Events\":{\
          \"shape\":\"EventList\",\
          \"documentation\":\"<p>The Amazon S3 bucket event for which to invoke the AWS Lambda function. For more information, see <a href=\\\"https:
          \"locationName\":\"Event\"\
        },\
        \"Filter\":{\"shape\":\"NotificationConfigurationFilter\"}\
      },\
      \"documentation\":\"<p>A container for specifying the configuration for AWS Lambda notifications.</p>\"\
    },\
    \"LambdaFunctionConfigurationList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"LambdaFunctionConfiguration\"},\
      \"flattened\":true\
    },\
    \"LastModified\":{\"type\":\"timestamp\"},\
    \"LifecycleConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\"Rules\"],\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"Rules\",\
          \"documentation\":\"<p>Specifies lifecycle configuration rules for an Amazon S3 bucket. </p>\",\
          \"locationName\":\"Rule\"\
        }\
      },\
      \"documentation\":\"<p>Container for lifecycle rules. You can add as many as 1000 rules.</p>\"\
    },\
    \"LifecycleExpiration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Date\":{\
          \"shape\":\"Date\",\
          \"documentation\":\"<p>Indicates at what date the object is to be moved or deleted. Should be in GMT ISO 8601 Format.</p>\"\
        },\
        \"Days\":{\
          \"shape\":\"Days\",\
          \"documentation\":\"<p>Indicates the lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer.</p>\"\
        },\
        \"ExpiredObjectDeleteMarker\":{\
          \"shape\":\"ExpiredObjectDeleteMarker\",\
          \"documentation\":\"<p>Indicates whether Amazon S3 will remove a delete marker with no noncurrent versions. If set to true, the delete marker will be expired; if set to false the policy takes no action. This cannot be specified with Days or Date in a Lifecycle Expiration Policy.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the expiration for the lifecycle of the object.</p>\"\
    },\
    \"LifecycleRule\":{\
      \"type\":\"structure\",\
      \"required\":[\"Status\"],\
      \"members\":{\
        \"Expiration\":{\
          \"shape\":\"LifecycleExpiration\",\
          \"documentation\":\"<p>Specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker.</p>\"\
        },\
        \"ID\":{\
          \"shape\":\"ID\",\
          \"documentation\":\"<p>Unique identifier for the rule. The value cannot be longer than 255 characters.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Prefix identifying one or more objects to which the rule applies. This is No longer used; use <code>Filter</code> instead.</p>\",\
          \"deprecated\":true\
        },\
        \"Filter\":{\"shape\":\"LifecycleRuleFilter\"},\
        \"Status\":{\
          \"shape\":\"ExpirationStatus\",\
          \"documentation\":\"<p>If 'Enabled', the rule is currently being applied. If 'Disabled', the rule is not currently being applied.</p>\"\
        },\
        \"Transitions\":{\
          \"shape\":\"TransitionList\",\
          \"documentation\":\"<p>Specifies when an Amazon S3 object transitions to a specified storage class.</p>\",\
          \"locationName\":\"Transition\"\
        },\
        \"NoncurrentVersionTransitions\":{\
          \"shape\":\"NoncurrentVersionTransitionList\",\
          \"documentation\":\"<p> Specifies the transition rule for the lifecycle rule that describes when noncurrent objects transition to a specific storage class. If your bucket is versioning-enabled (or versioning is suspended), you can set this action to request that Amazon S3 transition noncurrent object versions to a specific storage class at a set period in the object's lifetime. </p>\",\
          \"locationName\":\"NoncurrentVersionTransition\"\
        },\
        \"NoncurrentVersionExpiration\":{\"shape\":\"NoncurrentVersionExpiration\"},\
        \"AbortIncompleteMultipartUpload\":{\"shape\":\"AbortIncompleteMultipartUpload\"}\
      },\
      \"documentation\":\"<p>A lifecycle rule for individual objects in an Amazon S3 bucket.</p>\"\
    },\
    \"LifecycleRuleAndOperator\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Prefix identifying one or more objects to which the rule applies.</p>\"\
        },\
        \"Tags\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>All of these tags must exist in the object's tag set in order for the rule to apply.</p>\",\
          \"flattened\":true,\
          \"locationName\":\"Tag\"\
        }\
      },\
      \"documentation\":\"<p>This is used in a Lifecycle Rule Filter to apply a logical AND to two or more predicates. The Lifecycle Rule will apply to any object matching all of the predicates configured inside the And operator.</p>\"\
    },\
    \"LifecycleRuleFilter\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Prefix identifying one or more objects to which the rule applies.</p>\"\
        },\
        \"Tag\":{\
          \"shape\":\"Tag\",\
          \"documentation\":\"<p>This tag must exist in the object's tag set in order for the rule to apply.</p>\"\
        },\
        \"And\":{\"shape\":\"LifecycleRuleAndOperator\"}\
      },\
      \"documentation\":\"<p>The <code>Filter</code> is used to identify objects that a Lifecycle Rule applies to. A <code>Filter</code> must have exactly one of <code>Prefix</code>, <code>Tag</code>, or <code>And</code> specified.</p>\"\
    },\
    \"LifecycleRules\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"LifecycleRule\"},\
      \"flattened\":true\
    },\
    \"ListBucketAnalyticsConfigurationsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>Indicates whether the returned list of analytics configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken will be provided for a subsequent request.</p>\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>The marker that is used as a starting point for this analytics configuration list response. This value is present if it was sent in the request.</p>\"\
        },\
        \"NextContinuationToken\":{\
          \"shape\":\"NextToken\",\
          \"documentation\":\"<p> <code>NextContinuationToken</code> is sent when <code>isTruncated</code> is true, which indicates that there are more analytics configurations to list. The next request must include this <code>NextContinuationToken</code>. The token is obfuscated and is not a usable value.</p>\"\
        },\
        \"AnalyticsConfigurationList\":{\
          \"shape\":\"AnalyticsConfigurationList\",\
          \"documentation\":\"<p>The list of analytics configurations for a bucket.</p>\",\
          \"locationName\":\"AnalyticsConfiguration\"\
        }\
      }\
    },\
    \"ListBucketAnalyticsConfigurationsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket from which analytics configurations are retrieved.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>The ContinuationToken that represents a placeholder from where this request should begin.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"continuation-token\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListBucketInventoryConfigurationsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>If sent in the request, the marker that is used as a starting point for this inventory configuration list response.</p>\"\
        },\
        \"InventoryConfigurationList\":{\
          \"shape\":\"InventoryConfigurationList\",\
          \"documentation\":\"<p>The list of inventory configurations for a bucket.</p>\",\
          \"locationName\":\"InventoryConfiguration\"\
        },\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>Tells whether the returned list of inventory configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken is provided for a subsequent request.</p>\"\
        },\
        \"NextContinuationToken\":{\
          \"shape\":\"NextToken\",\
          \"documentation\":\"<p>The marker used to continue this inventory configuration listing. Use the <code>NextContinuationToken</code> from this response to continue the listing in a subsequent request. The continuation token is an opaque value that Amazon S3 understands.</p>\"\
        }\
      }\
    },\
    \"ListBucketInventoryConfigurationsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the inventory configurations to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>The marker used to continue an inventory configuration listing that has been truncated. Use the NextContinuationToken from a previously truncated list response to continue the listing. The continuation token is an opaque value that Amazon S3 understands.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"continuation-token\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListBucketMetricsConfigurationsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>Indicates whether the returned list of metrics configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken will be provided for a subsequent request.</p>\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>The marker that is used as a starting point for this metrics configuration list response. This value is present if it was sent in the request.</p>\"\
        },\
        \"NextContinuationToken\":{\
          \"shape\":\"NextToken\",\
          \"documentation\":\"<p>The marker used to continue a metrics configuration listing that has been truncated. Use the <code>NextContinuationToken</code> from a previously truncated list response to continue the listing. The continuation token is an opaque value that Amazon S3 understands.</p>\"\
        },\
        \"MetricsConfigurationList\":{\
          \"shape\":\"MetricsConfigurationList\",\
          \"documentation\":\"<p>The list of metrics configurations for a bucket.</p>\",\
          \"locationName\":\"MetricsConfiguration\"\
        }\
      }\
    },\
    \"ListBucketMetricsConfigurationsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the metrics configurations to retrieve.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>The marker that is used to continue a metrics configuration listing that has been truncated. Use the NextContinuationToken from a previously truncated list response to continue the listing. The continuation token is an opaque value that Amazon S3 understands.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"continuation-token\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListBucketsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Buckets\":{\
          \"shape\":\"Buckets\",\
          \"documentation\":\"<p>The list of buckets owned by the requestor.</p>\"\
        },\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>The owner of the buckets listed.</p>\"\
        }\
      }\
    },\
    \"ListMultipartUploadsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which the multipart upload was initiated.</p>\"\
        },\
        \"KeyMarker\":{\
          \"shape\":\"KeyMarker\",\
          \"documentation\":\"<p>The key at or after which the listing began.</p>\"\
        },\
        \"UploadIdMarker\":{\
          \"shape\":\"UploadIdMarker\",\
          \"documentation\":\"<p>Upload ID after which listing began.</p>\"\
        },\
        \"NextKeyMarker\":{\
          \"shape\":\"NextKeyMarker\",\
          \"documentation\":\"<p>When a list is truncated, this element specifies the value that should be used for the key-marker request parameter in a subsequent request.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>When a prefix is provided in the request, this field contains the specified prefix. The result contains only keys starting with the specified prefix.</p>\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>Contains the delimiter you specified in the request. If you don't specify a delimiter in your request, this element is absent from the response.</p>\"\
        },\
        \"NextUploadIdMarker\":{\
          \"shape\":\"NextUploadIdMarker\",\
          \"documentation\":\"<p>When a list is truncated, this element specifies the value that should be used for the <code>upload-id-marker</code> request parameter in a subsequent request.</p>\"\
        },\
        \"MaxUploads\":{\
          \"shape\":\"MaxUploads\",\
          \"documentation\":\"<p>Maximum number of multipart uploads that could have been included in the response.</p>\"\
        },\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>Indicates whether the returned list of multipart uploads is truncated. A value of true indicates that the list was truncated. The list can be truncated if the number of multipart uploads exceeds the limit allowed or specified by max uploads.</p>\"\
        },\
        \"Uploads\":{\
          \"shape\":\"MultipartUploadList\",\
          \"documentation\":\"<p>Container for elements related to a particular multipart upload. A response can contain zero or more <code>Upload</code> elements.</p>\",\
          \"locationName\":\"Upload\"\
        },\
        \"CommonPrefixes\":{\
          \"shape\":\"CommonPrefixList\",\
          \"documentation\":\"<p>If you specify a delimiter in the request, then the result returns each distinct key prefix containing the delimiter in a <code>CommonPrefixes</code> element. The distinct key prefixes are returned in the <code>Prefix</code> child element.</p>\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"documentation\":\"<p>Encoding type used by Amazon S3 to encode object keys in the response.</p> <p>If you specify <code>encoding-type</code> request parameter, Amazon S3 includes this element in the response, and returns encoded key name values in the following response elements:</p> <p> <code>Delimiter</code>, <code>KeyMarker</code>, <code>Prefix</code>, <code>NextKeyMarker</code>, <code>Key</code>.</p>\"\
        }\
      }\
    },\
    \"ListMultipartUploadsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which the multipart upload was initiated. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>Character you use to group keys.</p> <p>All keys that contain the same string between the prefix, if specified, and the first occurrence of the delimiter after the prefix are grouped under a single result element, <code>CommonPrefixes</code>. If you don't specify the prefix parameter, then the substring starts at the beginning of the key. The keys that are grouped under <code>CommonPrefixes</code> result element are not returned elsewhere in the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"delimiter\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"location\":\"querystring\",\
          \"locationName\":\"encoding-type\"\
        },\
        \"KeyMarker\":{\
          \"shape\":\"KeyMarker\",\
          \"documentation\":\"<p>Together with upload-id-marker, this parameter specifies the multipart upload after which listing should begin.</p> <p>If <code>upload-id-marker</code> is not specified, only the keys lexicographically greater than the specified <code>key-marker</code> will be included in the list.</p> <p>If <code>upload-id-marker</code> is specified, any multipart uploads for a key equal to the <code>key-marker</code> might also be included, provided those multipart uploads have upload IDs lexicographically greater than the specified <code>upload-id-marker</code>.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"key-marker\"\
        },\
        \"MaxUploads\":{\
          \"shape\":\"MaxUploads\",\
          \"documentation\":\"<p>Sets the maximum number of multipart uploads, from 1 to 1,000, to return in the response body. 1,000 is the maximum number of uploads that can be returned in a response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"max-uploads\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Lists in-progress uploads only for those keys that begin with the specified prefix. You can use prefixes to separate a bucket into different grouping of keys. (You can think of using prefix to make groups in the same way you'd use a folder in a file system.)</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"prefix\"\
        },\
        \"UploadIdMarker\":{\
          \"shape\":\"UploadIdMarker\",\
          \"documentation\":\"<p>Together with key-marker, specifies the multipart upload after which listing should begin. If key-marker is not specified, the upload-id-marker parameter is ignored. Otherwise, any multipart uploads for a key equal to the key-marker might be included in the list only if they have an upload ID lexicographically greater than the specified <code>upload-id-marker</code>.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"upload-id-marker\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListObjectVersionsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>A flag that indicates whether Amazon S3 returned all of the results that satisfied the search criteria. If your results were truncated, you can make a follow-up paginated request using the NextKeyMarker and NextVersionIdMarker response parameters as a starting place in another request to return the rest of the results.</p>\"\
        },\
        \"KeyMarker\":{\
          \"shape\":\"KeyMarker\",\
          \"documentation\":\"<p>Marks the last key returned in a truncated response.</p>\"\
        },\
        \"VersionIdMarker\":{\
          \"shape\":\"VersionIdMarker\",\
          \"documentation\":\"<p>Marks the last version of the key returned in a truncated response.</p>\"\
        },\
        \"NextKeyMarker\":{\
          \"shape\":\"NextKeyMarker\",\
          \"documentation\":\"<p>When the number of responses exceeds the value of <code>MaxKeys</code>, <code>NextKeyMarker</code> specifies the first key not returned that satisfies the search criteria. Use this value for the key-marker request parameter in a subsequent request.</p>\"\
        },\
        \"NextVersionIdMarker\":{\
          \"shape\":\"NextVersionIdMarker\",\
          \"documentation\":\"<p>When the number of responses exceeds the value of <code>MaxKeys</code>, <code>NextVersionIdMarker</code> specifies the first object version not returned that satisfies the search criteria. Use this value for the version-id-marker request parameter in a subsequent request.</p>\"\
        },\
        \"Versions\":{\
          \"shape\":\"ObjectVersionList\",\
          \"documentation\":\"<p>Container for version information.</p>\",\
          \"locationName\":\"Version\"\
        },\
        \"DeleteMarkers\":{\
          \"shape\":\"DeleteMarkers\",\
          \"documentation\":\"<p>Container for an object that is a delete marker.</p>\",\
          \"locationName\":\"DeleteMarker\"\
        },\
        \"Name\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Selects objects that start with the value supplied by this parameter.</p>\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>The delimiter grouping the included keys. A delimiter is a character that you specify to group keys. All keys that contain the same string between the prefix and the first occurrence of the delimiter are grouped under a single result element in <code>CommonPrefixes</code>. These groups are counted as one result against the max-keys limitation. These keys are not returned elsewhere in the response.</p>\"\
        },\
        \"MaxKeys\":{\
          \"shape\":\"MaxKeys\",\
          \"documentation\":\"<p>Specifies the maximum number of objects to return.</p>\"\
        },\
        \"CommonPrefixes\":{\
          \"shape\":\"CommonPrefixList\",\
          \"documentation\":\"<p>All of the keys rolled up into a common prefix count as a single return when calculating the number of returns.</p>\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"documentation\":\"<p> Encoding type used by Amazon S3 to encode object key names in the XML response.</p> <p>If you specify encoding-type request parameter, Amazon S3 includes this element in the response, and returns encoded key name values in the following response elements:</p> <p> <code>KeyMarker, NextKeyMarker, Prefix, Key</code>, and <code>Delimiter</code>.</p>\"\
        }\
      }\
    },\
    \"ListObjectVersionsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name that contains the objects. </p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>A delimiter is a character that you specify to group keys. All keys that contain the same string between the <code>prefix</code> and the first occurrence of the delimiter are grouped under a single result element in CommonPrefixes. These groups are counted as one result against the max-keys limitation. These keys are not returned elsewhere in the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"delimiter\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"location\":\"querystring\",\
          \"locationName\":\"encoding-type\"\
        },\
        \"KeyMarker\":{\
          \"shape\":\"KeyMarker\",\
          \"documentation\":\"<p>Specifies the key to start with when listing objects in a bucket.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"key-marker\"\
        },\
        \"MaxKeys\":{\
          \"shape\":\"MaxKeys\",\
          \"documentation\":\"<p>Sets the maximum number of keys returned in the response. By default the API returns up to 1,000 key names. The response might contain fewer keys but will never contain more. If additional keys satisfy the search criteria, but were not returned because max-keys was exceeded, the response contains &lt;isTruncated&gt;true&lt;/isTruncated&gt;. To return the additional keys, see key-marker and version-id-marker.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"max-keys\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Use this parameter to select only those keys that begin with the specified prefix. You can use prefixes to separate a bucket into different groupings of keys. (You can think of using prefix to make groups in the same way you'd use a folder in a file system.) You can use prefix with delimiter to roll up numerous objects into a single result under CommonPrefixes. </p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"prefix\"\
        },\
        \"VersionIdMarker\":{\
          \"shape\":\"VersionIdMarker\",\
          \"documentation\":\"<p>Specifies the object version you want to start listing from.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"version-id-marker\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListObjectsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>A flag that indicates whether Amazon S3 returned all of the results that satisfied the search criteria.</p>\"\
        },\
        \"Marker\":{\
          \"shape\":\"Marker\",\
          \"documentation\":\"<p>Indicates where in the bucket listing begins. Marker is included in the response if it was sent with the request.</p>\"\
        },\
        \"NextMarker\":{\
          \"shape\":\"NextMarker\",\
          \"documentation\":\"<p>When response is truncated (the IsTruncated element value in the response is true), you can use the key name in this field as marker in the subsequent request to get next set of objects. Amazon S3 lists objects in alphabetical order Note: This element is returned only if you have delimiter request parameter specified. If response does not include the NextMarker and it is truncated, you can use the value of the last Key in the response as the marker in the subsequent request to get the next set of object keys.</p>\"\
        },\
        \"Contents\":{\
          \"shape\":\"ObjectList\",\
          \"documentation\":\"<p>Metadata about each object returned.</p>\"\
        },\
        \"Name\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Keys that begin with the indicated prefix.</p>\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>Causes keys that contain the same string between the prefix and the first occurrence of the delimiter to be rolled up into a single result element in the <code>CommonPrefixes</code> collection. These rolled-up keys are not returned elsewhere in the response. Each rolled-up result counts as only one return against the <code>MaxKeys</code> value.</p>\"\
        },\
        \"MaxKeys\":{\
          \"shape\":\"MaxKeys\",\
          \"documentation\":\"<p>The maximum number of keys returned in the response body.</p>\"\
        },\
        \"CommonPrefixes\":{\
          \"shape\":\"CommonPrefixList\",\
          \"documentation\":\"<p>All of the keys rolled up in a common prefix count as a single return when calculating the number of returns. </p> <p>A response can contain CommonPrefixes only if you specify a delimiter.</p> <p>CommonPrefixes contains all (if there are any) keys between Prefix and the next occurrence of the string specified by the delimiter.</p> <p> CommonPrefixes lists keys that act like subdirectories in the directory specified by Prefix.</p> <p>For example, if the prefix is notes/ and the delimiter is a slash (/) as in notes/summer/july, the common prefix is notes/summer/. All of the keys that roll up into a common prefix count as a single return when calculating the number of returns.</p>\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"documentation\":\"<p>Encoding type used by Amazon S3 to encode object keys in the response.</p>\"\
        }\
      }\
    },\
    \"ListObjectsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket containing the objects.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>A delimiter is a character you use to group keys.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"delimiter\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"location\":\"querystring\",\
          \"locationName\":\"encoding-type\"\
        },\
        \"Marker\":{\
          \"shape\":\"Marker\",\
          \"documentation\":\"<p>Specifies the key to start with when listing objects in a bucket.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"marker\"\
        },\
        \"MaxKeys\":{\
          \"shape\":\"MaxKeys\",\
          \"documentation\":\"<p>Sets the maximum number of keys returned in the response. By default the API returns up to 1,000 key names. The response might contain fewer keys but will never contain more. </p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"max-keys\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Limits the response to keys that begin with the specified prefix.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"prefix\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"documentation\":\"<p>Confirms that the requester knows that she or he will be charged for the list objects request. Bucket owners need not specify this parameter in their requests.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListObjectsV2Output\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p>Set to false if all of the results were returned. Set to true if more keys are available to return. If the number of results exceeds that specified by MaxKeys, all of the results might not be returned.</p>\"\
        },\
        \"Contents\":{\
          \"shape\":\"ObjectList\",\
          \"documentation\":\"<p>Metadata about each object returned.</p>\"\
        },\
        \"Name\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p> Keys that begin with the indicated prefix.</p>\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>Causes keys that contain the same string between the prefix and the first occurrence of the delimiter to be rolled up into a single result element in the CommonPrefixes collection. These rolled-up keys are not returned elsewhere in the response. Each rolled-up result counts as only one return against the <code>MaxKeys</code> value.</p>\"\
        },\
        \"MaxKeys\":{\
          \"shape\":\"MaxKeys\",\
          \"documentation\":\"<p>Sets the maximum number of keys returned in the response. By default the API returns up to 1,000 key names. The response might contain fewer keys but will never contain more.</p>\"\
        },\
        \"CommonPrefixes\":{\
          \"shape\":\"CommonPrefixList\",\
          \"documentation\":\"<p>All of the keys rolled up into a common prefix count as a single return when calculating the number of returns.</p> <p>A response can contain <code>CommonPrefixes</code> only if you specify a delimiter.</p> <p> <code>CommonPrefixes</code> contains all (if there are any) keys between <code>Prefix</code> and the next occurrence of the string specified by a delimiter.</p> <p> <code>CommonPrefixes</code> lists keys that act like subdirectories in the directory specified by <code>Prefix</code>.</p> <p>For example, if the prefix is <code>notes/</code> and the delimiter is a slash (<code>/</code>) as in <code>notes/summer/july</code>, the common prefix is <code>notes/summer/</code>. All of the keys that roll up into a common prefix count as a single return when calculating the number of returns. </p>\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"documentation\":\"<p>Encoding type used by Amazon S3 to encode object key names in the XML response.</p> <p>If you specify the encoding-type request parameter, Amazon S3 includes this element in the response, and returns encoded key name values in the following response elements:</p> <p> <code>Delimiter, Prefix, Key,</code> and <code>StartAfter</code>.</p>\"\
        },\
        \"KeyCount\":{\
          \"shape\":\"KeyCount\",\
          \"documentation\":\"<p>KeyCount is the number of keys returned with this request. KeyCount will always be less than equals to MaxKeys field. Say you ask for 50 keys, your result will include less than equals 50 keys </p>\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p> If ContinuationToken was sent with the request, it is included in the response.</p>\"\
        },\
        \"NextContinuationToken\":{\
          \"shape\":\"NextToken\",\
          \"documentation\":\"<p> <code>NextContinuationToken</code> is sent when <code>isTruncated</code> is true, which means there are more keys in the bucket that can be listed. The next list requests to Amazon S3 can be continued with this <code>NextContinuationToken</code>. <code>NextContinuationToken</code> is obfuscated and is not a real key</p>\"\
        },\
        \"StartAfter\":{\
          \"shape\":\"StartAfter\",\
          \"documentation\":\"<p>If StartAfter was sent with the request, it is included in the response.</p>\"\
        }\
      }\
    },\
    \"ListObjectsV2Request\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Bucket name to list. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Delimiter\":{\
          \"shape\":\"Delimiter\",\
          \"documentation\":\"<p>A delimiter is a character you use to group keys.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"delimiter\"\
        },\
        \"EncodingType\":{\
          \"shape\":\"EncodingType\",\
          \"documentation\":\"<p>Encoding type used by Amazon S3 to encode object keys in the response.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"encoding-type\"\
        },\
        \"MaxKeys\":{\
          \"shape\":\"MaxKeys\",\
          \"documentation\":\"<p>Sets the maximum number of keys returned in the response. By default the API returns up to 1,000 key names. The response might contain fewer keys but will never contain more.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"max-keys\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Limits the response to keys that begin with the specified prefix.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"prefix\"\
        },\
        \"ContinuationToken\":{\
          \"shape\":\"Token\",\
          \"documentation\":\"<p>ContinuationToken indicates Amazon S3 that the list is being continued on this bucket with a token. ContinuationToken is obfuscated and is not a real key.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"continuation-token\"\
        },\
        \"FetchOwner\":{\
          \"shape\":\"FetchOwner\",\
          \"documentation\":\"<p>The owner field is not present in listV2 by default, if you want to return owner field with each key in the result then set the fetch owner field to true.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"fetch-owner\"\
        },\
        \"StartAfter\":{\
          \"shape\":\"StartAfter\",\
          \"documentation\":\"<p>StartAfter is where you want Amazon S3 to start listing from. Amazon S3 starts listing after this specified key. StartAfter can be any key in the bucket.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"start-after\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"documentation\":\"<p>Confirms that the requester knows that she or he will be charged for the list objects request in V2 style. Bucket owners need not specify this parameter in their requests.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"ListPartsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"AbortDate\":{\
          \"shape\":\"AbortDate\",\
          \"documentation\":\"<p>If the bucket has a lifecycle rule configured with an action to abort incomplete multipart uploads and the prefix in the lifecycle rule matches the object name in the request, then the response includes this header indicating when the initiated multipart upload will become eligible for abort operation. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-abort-date\"\
        },\
        \"AbortRuleId\":{\
          \"shape\":\"AbortRuleId\",\
          \"documentation\":\"<p>This header is returned along with the <code>x-amz-abort-date</code> header. It identifies applicable lifecycle configuration rule that defines the action to abort incomplete multipart uploads.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-abort-rule-id\"\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which the multipart upload was initiated.</p>\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload was initiated.</p>\"\
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>Upload ID identifying the multipart upload whose parts are being listed.</p>\"\
        },\
        \"PartNumberMarker\":{\
          \"shape\":\"PartNumberMarker\",\
          \"documentation\":\"<p>When a list is truncated, this element specifies the last part in the list, as well as the value to use for the part-number-marker request parameter in a subsequent request.</p>\"\
        },\
        \"NextPartNumberMarker\":{\
          \"shape\":\"NextPartNumberMarker\",\
          \"documentation\":\"<p>When a list is truncated, this element specifies the last part in the list, as well as the value to use for the part-number-marker request parameter in a subsequent request.</p>\"\
        },\
        \"MaxParts\":{\
          \"shape\":\"MaxParts\",\
          \"documentation\":\"<p>Maximum number of parts that were allowed in the response.</p>\"\
        },\
        \"IsTruncated\":{\
          \"shape\":\"IsTruncated\",\
          \"documentation\":\"<p> Indicates whether the returned list of parts is truncated. A true value indicates that the list was truncated. A list can be truncated if the number of parts exceeds the limit returned in the MaxParts element.</p>\"\
        },\
        \"Parts\":{\
          \"shape\":\"Parts\",\
          \"documentation\":\"<p> Container for elements related to a particular part. A response can contain zero or more <code>Part</code> elements.</p>\",\
          \"locationName\":\"Part\"\
        },\
        \"Initiator\":{\
          \"shape\":\"Initiator\",\
          \"documentation\":\"<p>Container element that identifies who initiated the multipart upload. If the initiator is an AWS account, this element provides the same information as the <code>Owner</code> element. If the initiator is an IAM User, this element provides the user ARN and display name.</p>\"\
        },\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p> Container element that identifies the object owner, after the object is created. If multipart upload is initiated by an IAM user, this element provides the parent account ID and display name.</p>\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>Class of storage (STANDARD or REDUCED_REDUNDANCY) used to store the uploaded object.</p>\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"ListPartsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\",\
        \"UploadId\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which the parts are being uploaded. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"MaxParts\":{\
          \"shape\":\"MaxParts\",\
          \"documentation\":\"<p>Sets the maximum number of parts to return.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"max-parts\"\
        },\
        \"PartNumberMarker\":{\
          \"shape\":\"PartNumberMarker\",\
          \"documentation\":\"<p>Specifies the part after which listing should begin. Only parts with higher part numbers will be listed.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"part-number-marker\"\
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>Upload ID identifying the multipart upload whose parts are being listed.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"uploadId\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      }\
    },\
    \"Location\":{\"type\":\"string\"},\
    \"LocationPrefix\":{\"type\":\"string\"},\
    \"LoggingEnabled\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"TargetBucket\",\
        \"TargetPrefix\"\
      ],\
      \"members\":{\
        \"TargetBucket\":{\
          \"shape\":\"TargetBucket\",\
          \"documentation\":\"<p>Specifies the bucket where you want Amazon S3 to store server access logs. You can have your logs delivered to any bucket that you own, including the same bucket that is being logged. You can also configure multiple buckets to deliver their logs to the same target bucket. In this case, you should choose a different <code>TargetPrefix</code> for each source bucket so that the delivered log files can be distinguished by key.</p>\"\
        },\
        \"TargetGrants\":{\
          \"shape\":\"TargetGrants\",\
          \"documentation\":\"<p>Container for granting information.</p>\"\
        },\
        \"TargetPrefix\":{\
          \"shape\":\"TargetPrefix\",\
          \"documentation\":\"<p>A prefix for all log object keys. If you store log files from multiple Amazon S3 buckets in a single bucket, you can use a prefix to distinguish which log files came from which bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes where logs are stored and the prefix that Amazon S3 assigns to all log object keys for a bucket. For more information, see <a href=\\\"https:
    },\
    \"MFA\":{\"type\":\"string\"},\
    \"MFADelete\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"MFADeleteStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"Marker\":{\"type\":\"string\"},\
    \"MaxAgeSeconds\":{\"type\":\"integer\"},\
    \"MaxKeys\":{\"type\":\"integer\"},\
    \"MaxParts\":{\"type\":\"integer\"},\
    \"MaxUploads\":{\"type\":\"integer\"},\
    \"Message\":{\"type\":\"string\"},\
    \"Metadata\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"MetadataKey\"},\
      \"value\":{\"shape\":\"MetadataValue\"}\
    },\
    \"MetadataDirective\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"COPY\",\
        \"REPLACE\"\
      ]\
    },\
    \"MetadataEntry\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Name\":{\
          \"shape\":\"MetadataKey\",\
          \"documentation\":\"<p>Name of the Object.</p>\"\
        },\
        \"Value\":{\
          \"shape\":\"MetadataValue\",\
          \"documentation\":\"<p>Value of the Object.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A metadata key-value pair to store with an object.</p>\"\
    },\
    \"MetadataKey\":{\"type\":\"string\"},\
    \"MetadataValue\":{\"type\":\"string\"},\
    \"Metrics\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Status\",\
        \"EventThreshold\"\
      ],\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"MetricsStatus\",\
          \"documentation\":\"<p> Specifies whether the replication metrics are enabled. </p>\"\
        },\
        \"EventThreshold\":{\
          \"shape\":\"ReplicationTimeValue\",\
          \"documentation\":\"<p> A container specifying the time threshold for emitting the <code>s3:Replication:OperationMissedThreshold</code> event. </p>\"\
        }\
      },\
      \"documentation\":\"<p> A container specifying replication metrics-related settings enabling metrics and Amazon S3 events for S3 Replication Time Control (S3 RTC). Must be specified together with a <code>ReplicationTime</code> block. </p>\"\
    },\
    \"MetricsAndOperator\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix used when evaluating an AND predicate.</p>\"\
        },\
        \"Tags\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>The list of tags used when evaluating an AND predicate.</p>\",\
          \"flattened\":true,\
          \"locationName\":\"Tag\"\
        }\
      },\
      \"documentation\":\"<p>A conjunction (logical AND) of predicates, which is used in evaluating a metrics filter. The operator must have at least two predicates, and an object must match all of the predicates in order for the filter to apply.</p>\"\
    },\
    \"MetricsConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\"Id\"],\
      \"members\":{\
        \"Id\":{\
          \"shape\":\"MetricsId\",\
          \"documentation\":\"<p>The ID used to identify the metrics configuration.</p>\"\
        },\
        \"Filter\":{\
          \"shape\":\"MetricsFilter\",\
          \"documentation\":\"<p>Specifies a metrics configuration filter. The metrics configuration will only include objects that meet the filter's criteria. A filter must be a prefix, a tag, or a conjunction (MetricsAndOperator).</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies a metrics configuration for the CloudWatch request metrics (specified by the metrics configuration ID) from an Amazon S3 bucket. If you're updating an existing metrics configuration, note that this is a full replacement of the existing metrics configuration. If you don't include the elements you want to keep, they are erased. For more information, see <a href=\\\"https:
    },\
    \"MetricsConfigurationList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"MetricsConfiguration\"},\
      \"flattened\":true\
    },\
    \"MetricsFilter\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>The prefix used when evaluating a metrics filter.</p>\"\
        },\
        \"Tag\":{\
          \"shape\":\"Tag\",\
          \"documentation\":\"<p>The tag used when evaluating a metrics filter.</p>\"\
        },\
        \"And\":{\
          \"shape\":\"MetricsAndOperator\",\
          \"documentation\":\"<p>A conjunction (logical AND) of predicates, which is used in evaluating a metrics filter. The operator must have at least two predicates, and an object must match all of the predicates in order for the filter to apply.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies a metrics configuration filter. The metrics configuration only includes objects that meet the filter's criteria. A filter must be a prefix, a tag, or a conjunction (MetricsAndOperator).</p>\"\
    },\
    \"MetricsId\":{\"type\":\"string\"},\
    \"MetricsStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"Minutes\":{\"type\":\"integer\"},\
    \"MissingMeta\":{\"type\":\"integer\"},\
    \"MultipartUpload\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>Upload ID that identifies the multipart upload.</p>\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Key of the object for which the multipart upload was initiated.</p>\"\
        },\
        \"Initiated\":{\
          \"shape\":\"Initiated\",\
          \"documentation\":\"<p>Date and time at which the multipart upload was initiated.</p>\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>The class of storage used to store the object.</p>\"\
        },\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>Specifies the owner of the object that is part of the multipart upload. </p>\"\
        },\
        \"Initiator\":{\
          \"shape\":\"Initiator\",\
          \"documentation\":\"<p>Identifies who initiated the multipart upload.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the <code>MultipartUpload</code> for the Amazon S3 object.</p>\"\
    },\
    \"MultipartUploadId\":{\"type\":\"string\"},\
    \"MultipartUploadList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"MultipartUpload\"},\
      \"flattened\":true\
    },\
    \"NextKeyMarker\":{\"type\":\"string\"},\
    \"NextMarker\":{\"type\":\"string\"},\
    \"NextPartNumberMarker\":{\"type\":\"integer\"},\
    \"NextToken\":{\"type\":\"string\"},\
    \"NextUploadIdMarker\":{\"type\":\"string\"},\
    \"NextVersionIdMarker\":{\"type\":\"string\"},\
    \"NoSuchBucket\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>The specified bucket does not exist.</p>\",\
      \"exception\":true\
    },\
    \"NoSuchKey\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>The specified key does not exist.</p>\",\
      \"exception\":true\
    },\
    \"NoSuchUpload\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>The specified multipart upload does not exist.</p>\",\
      \"exception\":true\
    },\
    \"NoncurrentVersionExpiration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"NoncurrentDays\":{\
          \"shape\":\"Days\",\
          \"documentation\":\"<p>Specifies the number of days an object is noncurrent before Amazon S3 can perform the associated action. For information about the noncurrent days calculations, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>Specifies when noncurrent object versions expire. Upon expiration, Amazon S3 permanently deletes the noncurrent object versions. You set this lifecycle configuration action on a bucket that has versioning enabled (or suspended) to request that Amazon S3 delete noncurrent object versions at a specific period in the object's lifetime.</p>\"\
    },\
    \"NoncurrentVersionTransition\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"NoncurrentDays\":{\
          \"shape\":\"Days\",\
          \"documentation\":\"<p>Specifies the number of days an object is noncurrent before Amazon S3 can perform the associated action. For information about the noncurrent days calculations, see <a href=\\\"https:
        },\
        \"StorageClass\":{\
          \"shape\":\"TransitionStorageClass\",\
          \"documentation\":\"<p>The class of storage used to store the object.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the transition rule that describes when noncurrent objects transition to the <code>STANDARD_IA</code>, <code>ONEZONE_IA</code>, <code>INTELLIGENT_TIERING</code>, <code>GLACIER</code>, or <code>DEEP_ARCHIVE</code> storage class. If your bucket is versioning-enabled (or versioning is suspended), you can set this action to request that Amazon S3 transition noncurrent object versions to the <code>STANDARD_IA</code>, <code>ONEZONE_IA</code>, <code>INTELLIGENT_TIERING</code>, <code>GLACIER</code>, or <code>DEEP_ARCHIVE</code> storage class at a specific period in the object's lifetime.</p>\"\
    },\
    \"NoncurrentVersionTransitionList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"NoncurrentVersionTransition\"},\
      \"flattened\":true\
    },\
    \"NotificationConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"TopicConfigurations\":{\
          \"shape\":\"TopicConfigurationList\",\
          \"documentation\":\"<p>The topic to which notifications are sent and the events for which notifications are generated.</p>\",\
          \"locationName\":\"TopicConfiguration\"\
        },\
        \"QueueConfigurations\":{\
          \"shape\":\"QueueConfigurationList\",\
          \"documentation\":\"<p>The Amazon Simple Queue Service queues to publish messages to and the events for which to publish messages.</p>\",\
          \"locationName\":\"QueueConfiguration\"\
        },\
        \"LambdaFunctionConfigurations\":{\
          \"shape\":\"LambdaFunctionConfigurationList\",\
          \"documentation\":\"<p>Describes the AWS Lambda functions to invoke and the events for which to invoke them.</p>\",\
          \"locationName\":\"CloudFunctionConfiguration\"\
        }\
      },\
      \"documentation\":\"<p>A container for specifying the notification configuration of the bucket. If this element is empty, notifications are turned off for the bucket.</p>\"\
    },\
    \"NotificationConfigurationDeprecated\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"TopicConfiguration\":{\
          \"shape\":\"TopicConfigurationDeprecated\",\
          \"documentation\":\"<p>This data type is deprecated. A container for specifying the configuration for publication of messages to an Amazon Simple Notification Service (Amazon SNS) topic when Amazon S3 detects specified events. </p>\"\
        },\
        \"QueueConfiguration\":{\
          \"shape\":\"QueueConfigurationDeprecated\",\
          \"documentation\":\"<p>This data type is deprecated. This data type specifies the configuration for publishing messages to an Amazon Simple Queue Service (Amazon SQS) queue when Amazon S3 detects specified events. </p>\"\
        },\
        \"CloudFunctionConfiguration\":{\
          \"shape\":\"CloudFunctionConfiguration\",\
          \"documentation\":\"<p>Container for specifying the AWS Lambda notification configuration.</p>\"\
        }\
      }\
    },\
    \"NotificationConfigurationFilter\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"S3KeyFilter\",\
          \"locationName\":\"S3Key\"\
        }\
      },\
      \"documentation\":\"<p>Specifies object key name filtering rules. For information about key name filtering, see <a href=\\\"https:
    },\
    \"NotificationId\":{\
      \"type\":\"string\",\
      \"documentation\":\"<p>An optional unique identifier for configurations in a notification configuration. If you don't provide one, Amazon S3 will assign an ID.</p>\"\
    },\
    \"Object\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The name that you assign to an object. You use the object key to retrieve the object.</p>\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>The date the Object was Last Modified</p>\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>The entity tag is a hash of the object. The ETag reflects changes only to the contents of an object, not its metadata. The ETag may or may not be an MD5 digest of the object data. Whether or not it is depends on how the object was created and how it is encrypted as described below:</p> <ul> <li> <p>Objects created by the PUT Object, POST Object, or Copy operation, or through the AWS Management Console, and are encrypted by SSE-S3 or plaintext, have ETags that are an MD5 digest of their object data.</p> </li> <li> <p>Objects created by the PUT Object, POST Object, or Copy operation, or through the AWS Management Console, and are encrypted by SSE-C or SSE-KMS, have ETags that are not an MD5 digest of their object data.</p> </li> <li> <p>If an object is created by either the Multipart Upload or Part Copy operation, the ETag is not an MD5 digest, regardless of the method of encryption.</p> </li> </ul>\"\
        },\
        \"Size\":{\
          \"shape\":\"Size\",\
          \"documentation\":\"<p>Size in bytes of the object</p>\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"ObjectStorageClass\",\
          \"documentation\":\"<p>The class of storage used to store the object.</p>\"\
        },\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>The owner of the object</p>\"\
        }\
      },\
      \"documentation\":\"<p>An object consists of data and its descriptive metadata.</p>\"\
    },\
    \"ObjectAlreadyInActiveTierError\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>This operation is not allowed against this storage tier.</p>\",\
      \"exception\":true\
    },\
    \"ObjectCannedACL\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"private\",\
        \"public-read\",\
        \"public-read-write\",\
        \"authenticated-read\",\
        \"aws-exec-read\",\
        \"bucket-owner-read\",\
        \"bucket-owner-full-control\"\
      ]\
    },\
    \"ObjectIdentifier\":{\
      \"type\":\"structure\",\
      \"required\":[\"Key\"],\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Key name of the object to delete.</p>\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId for the specific version of the object to delete.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Object Identifier is unique value to identify objects.</p>\"\
    },\
    \"ObjectIdentifierList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ObjectIdentifier\"},\
      \"flattened\":true\
    },\
    \"ObjectKey\":{\
      \"type\":\"string\",\
      \"min\":1\
    },\
    \"ObjectList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Object\"},\
      \"flattened\":true\
    },\
    \"ObjectLockConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ObjectLockEnabled\":{\
          \"shape\":\"ObjectLockEnabled\",\
          \"documentation\":\"<p>Indicates whether this bucket has an Object Lock configuration enabled.</p>\"\
        },\
        \"Rule\":{\
          \"shape\":\"ObjectLockRule\",\
          \"documentation\":\"<p>The Object Lock rule in place for the specified object.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The container element for Object Lock configuration parameters.</p>\"\
    },\
    \"ObjectLockEnabled\":{\
      \"type\":\"string\",\
      \"enum\":[\"Enabled\"]\
    },\
    \"ObjectLockEnabledForBucket\":{\"type\":\"boolean\"},\
    \"ObjectLockLegalHold\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"ObjectLockLegalHoldStatus\",\
          \"documentation\":\"<p>Indicates whether the specified object has a Legal Hold in place.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A Legal Hold configuration for an object.</p>\"\
    },\
    \"ObjectLockLegalHoldStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"ON\",\
        \"OFF\"\
      ]\
    },\
    \"ObjectLockMode\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"GOVERNANCE\",\
        \"COMPLIANCE\"\
      ]\
    },\
    \"ObjectLockRetainUntilDate\":{\
      \"type\":\"timestamp\",\
      \"timestampFormat\":\"iso8601\"\
    },\
    \"ObjectLockRetention\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Mode\":{\
          \"shape\":\"ObjectLockRetentionMode\",\
          \"documentation\":\"<p>Indicates the Retention mode for the specified object.</p>\"\
        },\
        \"RetainUntilDate\":{\
          \"shape\":\"Date\",\
          \"documentation\":\"<p>The date on which this Object Lock Retention will expire.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A Retention configuration for an object.</p>\"\
    },\
    \"ObjectLockRetentionMode\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"GOVERNANCE\",\
        \"COMPLIANCE\"\
      ]\
    },\
    \"ObjectLockRule\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DefaultRetention\":{\
          \"shape\":\"DefaultRetention\",\
          \"documentation\":\"<p>The default retention period that you want to apply to new objects placed in the specified bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The container element for an Object Lock rule.</p>\"\
    },\
    \"ObjectLockToken\":{\"type\":\"string\"},\
    \"ObjectNotInActiveTierError\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>The source object of the COPY operation is not in the active tier and is only stored in Amazon S3 Glacier.</p>\",\
      \"exception\":true\
    },\
    \"ObjectOwnership\":{\
      \"type\":\"string\",\
      \"documentation\":\"<p>The container element for object ownership for a bucket's ownership controls.</p> <p>BucketOwnerPreferred - Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the <code>bucket-owner-full-control</code> canned ACL.</p> <p>ObjectWriter - The uploading account will own the object if the object is uploaded with the <code>bucket-owner-full-control</code> canned ACL.</p>\",\
      \"enum\":[\
        \"BucketOwnerPreferred\",\
        \"ObjectWriter\"\
      ]\
    },\
    \"ObjectStorageClass\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"STANDARD\",\
        \"REDUCED_REDUNDANCY\",\
        \"GLACIER\",\
        \"STANDARD_IA\",\
        \"ONEZONE_IA\",\
        \"INTELLIGENT_TIERING\",\
        \"DEEP_ARCHIVE\",\
        \"OUTPOSTS\"\
      ]\
    },\
    \"ObjectVersion\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>The entity tag is an MD5 hash of that version of the object.</p>\"\
        },\
        \"Size\":{\
          \"shape\":\"Size\",\
          \"documentation\":\"<p>Size in bytes of the object.</p>\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"ObjectVersionStorageClass\",\
          \"documentation\":\"<p>The class of storage used to store the object.</p>\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key.</p>\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version ID of an object.</p>\"\
        },\
        \"IsLatest\":{\
          \"shape\":\"IsLatest\",\
          \"documentation\":\"<p>Specifies whether the object is (true) or is not (false) the latest version of an object.</p>\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Date and time the object was last modified.</p>\"\
        },\
        \"Owner\":{\
          \"shape\":\"Owner\",\
          \"documentation\":\"<p>Specifies the owner of the object.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The version of an object.</p>\"\
    },\
    \"ObjectVersionId\":{\"type\":\"string\"},\
    \"ObjectVersionList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ObjectVersion\"},\
      \"flattened\":true\
    },\
    \"ObjectVersionStorageClass\":{\
      \"type\":\"string\",\
      \"enum\":[\"STANDARD\"]\
    },\
    \"OutputLocation\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"S3\":{\
          \"shape\":\"S3Location\",\
          \"documentation\":\"<p>Describes an S3 location that will receive the results of the restore request.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes the location where the restore job's output is stored.</p>\"\
    },\
    \"OutputSerialization\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"CSV\":{\
          \"shape\":\"CSVOutput\",\
          \"documentation\":\"<p>Describes the serialization of CSV-encoded Select results.</p>\"\
        },\
        \"JSON\":{\
          \"shape\":\"JSONOutput\",\
          \"documentation\":\"<p>Specifies JSON as request's output serialization format.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes how results of the Select job are serialized.</p>\"\
    },\
    \"Owner\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DisplayName\":{\
          \"shape\":\"DisplayName\",\
          \"documentation\":\"<p>Container for the display name of the owner.</p>\"\
        },\
        \"ID\":{\
          \"shape\":\"ID\",\
          \"documentation\":\"<p>Container for the ID of the owner.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the owner's display name and ID.</p>\"\
    },\
    \"OwnerOverride\":{\
      \"type\":\"string\",\
      \"enum\":[\"Destination\"]\
    },\
    \"OwnershipControls\":{\
      \"type\":\"structure\",\
      \"required\":[\"Rules\"],\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"OwnershipControlsRules\",\
          \"documentation\":\"<p>The container element for an ownership control rule.</p>\",\
          \"locationName\":\"Rule\"\
        }\
      },\
      \"documentation\":\"<p>The container element for a bucket's ownership controls.</p>\"\
    },\
    \"OwnershipControlsRule\":{\
      \"type\":\"structure\",\
      \"required\":[\"ObjectOwnership\"],\
      \"members\":{\
        \"ObjectOwnership\":{\"shape\":\"ObjectOwnership\"}\
      },\
      \"documentation\":\"<p>The container element for an ownership control rule.</p>\"\
    },\
    \"OwnershipControlsRules\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"OwnershipControlsRule\"},\
      \"flattened\":true\
    },\
    \"ParquetInput\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>Container for Parquet.</p>\"\
    },\
    \"Part\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"PartNumber\":{\
          \"shape\":\"PartNumber\",\
          \"documentation\":\"<p>Part number identifying the part. This is a positive integer between 1 and 10,000.</p>\"\
        },\
        \"LastModified\":{\
          \"shape\":\"LastModified\",\
          \"documentation\":\"<p>Date and time at which the part was uploaded.</p>\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Entity tag returned when the part was uploaded.</p>\"\
        },\
        \"Size\":{\
          \"shape\":\"Size\",\
          \"documentation\":\"<p>Size in bytes of the uploaded part data.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for elements related to a part.</p>\"\
    },\
    \"PartNumber\":{\"type\":\"integer\"},\
    \"PartNumberMarker\":{\"type\":\"integer\"},\
    \"Parts\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Part\"},\
      \"flattened\":true\
    },\
    \"PartsCount\":{\"type\":\"integer\"},\
    \"Payer\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Requester\",\
        \"BucketOwner\"\
      ]\
    },\
    \"Permission\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"FULL_CONTROL\",\
        \"WRITE\",\
        \"WRITE_ACP\",\
        \"READ\",\
        \"READ_ACP\"\
      ]\
    },\
    \"Policy\":{\"type\":\"string\"},\
    \"PolicyStatus\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IsPublic\":{\
          \"shape\":\"IsPublic\",\
          \"documentation\":\"<p>The policy status for this bucket. <code>TRUE</code> indicates that this bucket is public. <code>FALSE</code> indicates that the bucket is not public.</p>\",\
          \"locationName\":\"IsPublic\"\
        }\
      },\
      \"documentation\":\"<p>The container element for a bucket's policy status.</p>\"\
    },\
    \"Prefix\":{\"type\":\"string\"},\
    \"Priority\":{\"type\":\"integer\"},\
    \"Progress\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"BytesScanned\":{\
          \"shape\":\"BytesScanned\",\
          \"documentation\":\"<p>The current number of object bytes scanned.</p>\"\
        },\
        \"BytesProcessed\":{\
          \"shape\":\"BytesProcessed\",\
          \"documentation\":\"<p>The current number of uncompressed object bytes processed.</p>\"\
        },\
        \"BytesReturned\":{\
          \"shape\":\"BytesReturned\",\
          \"documentation\":\"<p>The current number of bytes of records payload data returned.</p>\"\
        }\
      },\
      \"documentation\":\"<p>This data type contains information about progress of an operation.</p>\"\
    },\
    \"ProgressEvent\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Details\":{\
          \"shape\":\"Progress\",\
          \"documentation\":\"<p>The Progress event details.</p>\",\
          \"eventpayload\":true\
        }\
      },\
      \"documentation\":\"<p>This data type contains information about the progress event of an operation.</p>\",\
      \"event\":true\
    },\
    \"Protocol\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"http\",\
        \"https\"\
      ]\
    },\
    \"PublicAccessBlockConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"BlockPublicAcls\":{\
          \"shape\":\"Setting\",\
          \"documentation\":\"<p>Specifies whether Amazon S3 should block public access control lists (ACLs) for this bucket and objects in this bucket. Setting this element to <code>TRUE</code> causes the following behavior:</p> <ul> <li> <p>PUT Bucket acl and PUT Object acl calls fail if the specified ACL is public.</p> </li> <li> <p>PUT Object calls fail if the request includes a public ACL.</p> </li> <li> <p>PUT Bucket calls fail if the request includes a public ACL.</p> </li> </ul> <p>Enabling this setting doesn't affect existing policies or ACLs.</p>\",\
          \"locationName\":\"BlockPublicAcls\"\
        },\
        \"IgnorePublicAcls\":{\
          \"shape\":\"Setting\",\
          \"documentation\":\"<p>Specifies whether Amazon S3 should ignore public ACLs for this bucket and objects in this bucket. Setting this element to <code>TRUE</code> causes Amazon S3 to ignore all public ACLs on this bucket and objects in this bucket.</p> <p>Enabling this setting doesn't affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set.</p>\",\
          \"locationName\":\"IgnorePublicAcls\"\
        },\
        \"BlockPublicPolicy\":{\
          \"shape\":\"Setting\",\
          \"documentation\":\"<p>Specifies whether Amazon S3 should block public bucket policies for this bucket. Setting this element to <code>TRUE</code> causes Amazon S3 to reject calls to PUT Bucket policy if the specified bucket policy allows public access. </p> <p>Enabling this setting doesn't affect existing bucket policies.</p>\",\
          \"locationName\":\"BlockPublicPolicy\"\
        },\
        \"RestrictPublicBuckets\":{\
          \"shape\":\"Setting\",\
          \"documentation\":\"<p>Specifies whether Amazon S3 should restrict public bucket policies for this bucket. Setting this element to <code>TRUE</code> restricts access to this bucket to only AWS services and authorized users within this account if the bucket has a public policy.</p> <p>Enabling this setting doesn't affect previously stored bucket policies, except that public and cross-account access within any public bucket policy, including non-public delegation to specific accounts, is blocked.</p>\",\
          \"locationName\":\"RestrictPublicBuckets\"\
        }\
      },\
      \"documentation\":\"<p>The PublicAccessBlock configuration that you want to apply to this Amazon S3 bucket. You can enable the configuration options in any combination. For more information about when Amazon S3 considers a bucket or object public, see <a href=\\\"https:
    },\
    \"PutBucketAccelerateConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"AccelerateConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which the accelerate configuration is set.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"AccelerateConfiguration\":{\
          \"shape\":\"AccelerateConfiguration\",\
          \"documentation\":\"<p>Container for setting the transfer acceleration state.</p>\",\
          \"locationName\":\"AccelerateConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"AccelerateConfiguration\"\
    },\
    \"PutBucketAclRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"ACL\":{\
          \"shape\":\"BucketCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-acl\"\
        },\
        \"AccessControlPolicy\":{\
          \"shape\":\"AccessControlPolicy\",\
          \"documentation\":\"<p>Contains the elements that set the ACL permissions for an object per grantee.</p>\",\
          \"locationName\":\"AccessControlPolicy\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket to which to apply the ACL.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the data. This header must be used as a message integrity check to verify that the request body was not corrupted in transit. For more information, go to <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"GrantFullControl\":{\
          \"shape\":\"GrantFullControl\",\
          \"documentation\":\"<p>Allows grantee the read, write, read ACP, and write ACP permissions on the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-full-control\"\
        },\
        \"GrantRead\":{\
          \"shape\":\"GrantRead\",\
          \"documentation\":\"<p>Allows grantee to list the objects in the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read\"\
        },\
        \"GrantReadACP\":{\
          \"shape\":\"GrantReadACP\",\
          \"documentation\":\"<p>Allows grantee to read the bucket ACL.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read-acp\"\
        },\
        \"GrantWrite\":{\
          \"shape\":\"GrantWrite\",\
          \"documentation\":\"<p>Allows grantee to create, overwrite, and delete any object in the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write\"\
        },\
        \"GrantWriteACP\":{\
          \"shape\":\"GrantWriteACP\",\
          \"documentation\":\"<p>Allows grantee to write the ACL for the applicable bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write-acp\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"AccessControlPolicy\"\
    },\
    \"PutBucketAnalyticsConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\",\
        \"AnalyticsConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which an analytics configuration is stored.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"AnalyticsId\",\
          \"documentation\":\"<p>The ID that identifies the analytics configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"AnalyticsConfiguration\":{\
          \"shape\":\"AnalyticsConfiguration\",\
          \"documentation\":\"<p>The configuration and any analyses for the analytics filter.</p>\",\
          \"locationName\":\"AnalyticsConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"AnalyticsConfiguration\"\
    },\
    \"PutBucketCorsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"CORSConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Specifies the bucket impacted by the <code>cors</code>configuration.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"CORSConfiguration\":{\
          \"shape\":\"CORSConfiguration\",\
          \"documentation\":\"<p>Describes the cross-origin access configuration for objects in an Amazon S3 bucket. For more information, see <a href=\\\"https:
          \"locationName\":\"CORSConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the data. This header must be used as a message integrity check to verify that the request body was not corrupted in transit. For more information, go to <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"CORSConfiguration\"\
    },\
    \"PutBucketEncryptionRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"ServerSideEncryptionConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>Specifies default encryption for a bucket using server-side encryption with Amazon S3-managed keys (SSE-S3) or customer master keys stored in AWS KMS (SSE-KMS). For information about the Amazon S3 default encryption feature, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the server-side encryption configuration. This parameter is auto-populated when using the command from the CLI.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ServerSideEncryptionConfiguration\":{\
          \"shape\":\"ServerSideEncryptionConfiguration\",\
          \"locationName\":\"ServerSideEncryptionConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"ServerSideEncryptionConfiguration\"\
    },\
    \"PutBucketInventoryConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\",\
        \"InventoryConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket where the inventory configuration will be stored.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"InventoryId\",\
          \"documentation\":\"<p>The ID used to identify the inventory configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"InventoryConfiguration\":{\
          \"shape\":\"InventoryConfiguration\",\
          \"documentation\":\"<p>Specifies the inventory configuration.</p>\",\
          \"locationName\":\"InventoryConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"InventoryConfiguration\"\
    },\
    \"PutBucketLifecycleConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to set the configuration.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"LifecycleConfiguration\":{\
          \"shape\":\"BucketLifecycleConfiguration\",\
          \"documentation\":\"<p>Container for lifecycle rules. You can add as many as 1,000 rules.</p>\",\
          \"locationName\":\"LifecycleConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"LifecycleConfiguration\"\
    },\
    \"PutBucketLifecycleRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p/>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p/>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"LifecycleConfiguration\":{\
          \"shape\":\"LifecycleConfiguration\",\
          \"documentation\":\"<p/>\",\
          \"locationName\":\"LifecycleConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"LifecycleConfiguration\"\
    },\
    \"PutBucketLoggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"BucketLoggingStatus\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which to set the logging parameters.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"BucketLoggingStatus\":{\
          \"shape\":\"BucketLoggingStatus\",\
          \"documentation\":\"<p>Container for logging status information.</p>\",\
          \"locationName\":\"BucketLoggingStatus\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash of the <code>PutBucketLogging</code> request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"BucketLoggingStatus\"\
    },\
    \"PutBucketMetricsConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Id\",\
        \"MetricsConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket for which the metrics configuration is set.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Id\":{\
          \"shape\":\"MetricsId\",\
          \"documentation\":\"<p>The ID used to identify the metrics configuration.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"id\"\
        },\
        \"MetricsConfiguration\":{\
          \"shape\":\"MetricsConfiguration\",\
          \"documentation\":\"<p>Specifies the metrics configuration.</p>\",\
          \"locationName\":\"MetricsConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"MetricsConfiguration\"\
    },\
    \"PutBucketNotificationConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"NotificationConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"NotificationConfiguration\":{\
          \"shape\":\"NotificationConfiguration\",\
          \"locationName\":\"NotificationConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"NotificationConfiguration\"\
    },\
    \"PutBucketNotificationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"NotificationConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash of the <code>PutPublicAccessBlock</code> request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"NotificationConfiguration\":{\
          \"shape\":\"NotificationConfigurationDeprecated\",\
          \"documentation\":\"<p>The container for the configuration.</p>\",\
          \"locationName\":\"NotificationConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"NotificationConfiguration\"\
    },\
    \"PutBucketOwnershipControlsRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"OwnershipControls\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the Amazon S3 bucket whose <code>OwnershipControls</code> you want to set.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash of the <code>OwnershipControls</code> request body. </p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        },\
        \"OwnershipControls\":{\
          \"shape\":\"OwnershipControls\",\
          \"documentation\":\"<p>The <code>OwnershipControls</code> (BucketOwnerPreferred or ObjectWriter) that you want to apply to this Amazon S3 bucket.</p>\",\
          \"locationName\":\"OwnershipControls\",\
          \"xmlNamespace\":{\"uri\":\"http:
        }\
      },\
      \"payload\":\"OwnershipControls\"\
    },\
    \"PutBucketPolicyRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Policy\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash of the request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ConfirmRemoveSelfBucketAccess\":{\
          \"shape\":\"ConfirmRemoveSelfBucketAccess\",\
          \"documentation\":\"<p>Set this parameter to true to confirm that you want to remove your permissions to change this bucket policy in the future.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-confirm-remove-self-bucket-access\"\
        },\
        \"Policy\":{\
          \"shape\":\"Policy\",\
          \"documentation\":\"<p>The bucket policy as a JSON document.</p>\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Policy\"\
    },\
    \"PutBucketReplicationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"ReplicationConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ReplicationConfiguration\":{\
          \"shape\":\"ReplicationConfiguration\",\
          \"locationName\":\"ReplicationConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"Token\":{\
          \"shape\":\"ObjectLockToken\",\
          \"documentation\":\"<p/>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-bucket-object-lock-token\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"ReplicationConfiguration\"\
    },\
    \"PutBucketRequestPaymentRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"RequestPaymentConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>&gt;The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"RequestPaymentConfiguration\":{\
          \"shape\":\"RequestPaymentConfiguration\",\
          \"documentation\":\"<p>Container for Payer.</p>\",\
          \"locationName\":\"RequestPaymentConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"RequestPaymentConfiguration\"\
    },\
    \"PutBucketTaggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Tagging\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"Tagging\":{\
          \"shape\":\"Tagging\",\
          \"documentation\":\"<p>Container for the <code>TagSet</code> and <code>Tag</code> elements.</p>\",\
          \"locationName\":\"Tagging\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Tagging\"\
    },\
    \"PutBucketVersioningRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"VersioningConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>&gt;The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"MFA\":{\
          \"shape\":\"MFA\",\
          \"documentation\":\"<p>The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-mfa\"\
        },\
        \"VersioningConfiguration\":{\
          \"shape\":\"VersioningConfiguration\",\
          \"documentation\":\"<p>Container for setting the versioning state.</p>\",\
          \"locationName\":\"VersioningConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"VersioningConfiguration\"\
    },\
    \"PutBucketWebsiteRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"WebsiteConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"WebsiteConfiguration\":{\
          \"shape\":\"WebsiteConfiguration\",\
          \"documentation\":\"<p>Container for the request.</p>\",\
          \"locationName\":\"WebsiteConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"WebsiteConfiguration\"\
    },\
    \"PutObjectAclOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"PutObjectAclRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"ACL\":{\
          \"shape\":\"ObjectCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the object. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-acl\"\
        },\
        \"AccessControlPolicy\":{\
          \"shape\":\"AccessControlPolicy\",\
          \"documentation\":\"<p>Contains the elements that set the ACL permissions for an object per grantee.</p>\",\
          \"locationName\":\"AccessControlPolicy\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name that contains the object to which you want to attach the ACL. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the data. This header must be used as a message integrity check to verify that the request body was not corrupted in transit. For more information, go to <a href=\\\"http:
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"GrantFullControl\":{\
          \"shape\":\"GrantFullControl\",\
          \"documentation\":\"<p>Allows grantee the read, write, read ACP, and write ACP permissions on the bucket.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-full-control\"\
        },\
        \"GrantRead\":{\
          \"shape\":\"GrantRead\",\
          \"documentation\":\"<p>Allows grantee to list the objects in the bucket.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read\"\
        },\
        \"GrantReadACP\":{\
          \"shape\":\"GrantReadACP\",\
          \"documentation\":\"<p>Allows grantee to read the bucket ACL.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read-acp\"\
        },\
        \"GrantWrite\":{\
          \"shape\":\"GrantWrite\",\
          \"documentation\":\"<p>Allows grantee to create, overwrite, and delete any object in the bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write\"\
        },\
        \"GrantWriteACP\":{\
          \"shape\":\"GrantWriteACP\",\
          \"documentation\":\"<p>Allows grantee to write the ACL for the applicable bucket.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write-acp\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Key for which the PUT operation was initiated.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId used to reference a specific version of the object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"AccessControlPolicy\"\
    },\
    \"PutObjectLegalHoldOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"PutObjectLegalHoldRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the object that you want to place a Legal Hold on. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The key name for the object that you want to place a Legal Hold on.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"LegalHold\":{\
          \"shape\":\"ObjectLockLegalHold\",\
          \"documentation\":\"<p>Container element for the Legal Hold configuration you want to apply to the specified object.</p>\",\
          \"locationName\":\"LegalHold\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The version ID of the object that you want to place a Legal Hold on.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash for the request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"LegalHold\"\
    },\
    \"PutObjectLockConfigurationOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"PutObjectLockConfigurationRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Bucket\"],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket whose Object Lock configuration you want to create or replace.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ObjectLockConfiguration\":{\
          \"shape\":\"ObjectLockConfiguration\",\
          \"documentation\":\"<p>The Object Lock configuration that you want to apply to the specified bucket.</p>\",\
          \"locationName\":\"ObjectLockConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"Token\":{\
          \"shape\":\"ObjectLockToken\",\
          \"documentation\":\"<p>A token to allow Object Lock to be enabled for an existing bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-bucket-object-lock-token\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash for the request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"ObjectLockConfiguration\"\
    },\
    \"PutObjectOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Expiration\":{\
          \"shape\":\"Expiration\",\
          \"documentation\":\"<p> If the expiration is configured for the object (see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expiration\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Entity tag for the uploaded object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"ETag\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>If you specified server-side encryption either with an AWS KMS customer master key (CMK) or Amazon S3-managed encryption key in your PUT request, the response includes this header. It confirms the encryption algorithm that Amazon S3 used to encrypt the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>Version of the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If <code>x-amz-server-side-encryption</code> is present and has the value of <code>aws:kms</code>, this header specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object. </p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"SSEKMSEncryptionContext\":{\
          \"shape\":\"SSEKMSEncryptionContext\",\
          \"documentation\":\"<p>If present, specifies the AWS KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-context\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"PutObjectRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"ACL\":{\
          \"shape\":\"ObjectCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the object. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-acl\"\
        },\
        \"Body\":{\
          \"shape\":\"Body\",\
          \"documentation\":\"<p>Object data.</p>\",\
          \"streaming\":true\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name to which the PUT operation was initiated. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"CacheControl\":{\
          \"shape\":\"CacheControl\",\
          \"documentation\":\"<p> Can be used to specify caching behavior along the request/reply chain. For more information, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Cache-Control\"\
        },\
        \"ContentDisposition\":{\
          \"shape\":\"ContentDisposition\",\
          \"documentation\":\"<p>Specifies presentational information for the object. For more information, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Content-Disposition\"\
        },\
        \"ContentEncoding\":{\
          \"shape\":\"ContentEncoding\",\
          \"documentation\":\"<p>Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field. For more information, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Content-Encoding\"\
        },\
        \"ContentLanguage\":{\
          \"shape\":\"ContentLanguage\",\
          \"documentation\":\"<p>The language the content is in.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Language\"\
        },\
        \"ContentLength\":{\
          \"shape\":\"ContentLength\",\
          \"documentation\":\"<p>Size of the body in bytes. This parameter is useful when the size of the body cannot be determined automatically. For more information, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Content-Length\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the message (without the headers) according to RFC 1864. This header can be used as a message integrity check to verify that the data is the same data that was originally sent. Although it is optional, we recommend using the Content-MD5 mechanism as an end-to-end integrity check. For more information about REST request authentication, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ContentType\":{\
          \"shape\":\"ContentType\",\
          \"documentation\":\"<p>A standard MIME type describing the format of the contents. For more information, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Content-Type\"\
        },\
        \"Expires\":{\
          \"shape\":\"Expires\",\
          \"documentation\":\"<p>The date and time at which the object is no longer cacheable. For more information, see <a href=\\\"http:
          \"location\":\"header\",\
          \"locationName\":\"Expires\"\
        },\
        \"GrantFullControl\":{\
          \"shape\":\"GrantFullControl\",\
          \"documentation\":\"<p>Gives the grantee READ, READ_ACP, and WRITE_ACP permissions on the object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-full-control\"\
        },\
        \"GrantRead\":{\
          \"shape\":\"GrantRead\",\
          \"documentation\":\"<p>Allows grantee to read the object data and its metadata.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read\"\
        },\
        \"GrantReadACP\":{\
          \"shape\":\"GrantReadACP\",\
          \"documentation\":\"<p>Allows grantee to read the object ACL.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-read-acp\"\
        },\
        \"GrantWriteACP\":{\
          \"shape\":\"GrantWriteACP\",\
          \"documentation\":\"<p>Allows grantee to write the ACL for the applicable object.</p> <p>This action is not supported by Amazon S3 on Outposts.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-grant-write-acp\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the PUT operation was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"Metadata\":{\
          \"shape\":\"Metadata\",\
          \"documentation\":\"<p>A map of metadata to store with the object in S3.</p>\",\
          \"location\":\"headers\",\
          \"locationName\":\"x-amz-meta-\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>By default, Amazon S3 uses the STANDARD Storage Class to store newly created objects. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class. Amazon S3 on Outposts only uses the OUTPOSTS Storage Class. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-storage-class\"\
        },\
        \"WebsiteRedirectLocation\":{\
          \"shape\":\"WebsiteRedirectLocation\",\
          \"documentation\":\"<p>If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata. For information about object metadata, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-website-redirect-location\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm</code> header.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If <code>x-amz-server-side-encryption</code> is present and has the value of <code>aws:kms</code>, this header specifies the ID of the AWS Key Management Service (AWS KMS) symmetrical customer managed customer master key (CMK) that was used for the object.</p> <p> If the value of <code>x-amz-server-side-encryption</code> is <code>aws:kms</code>, this header specifies the ID of the symmetric customer managed AWS KMS CMK that will be used for the object. If you specify <code>x-amz-server-side-encryption:aws:kms</code>, but do not provide<code> x-amz-server-side-encryption-aws-kms-key-id</code>, Amazon S3 uses the AWS managed CMK in AWS to protect the data.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"SSEKMSEncryptionContext\":{\
          \"shape\":\"SSEKMSEncryptionContext\",\
          \"documentation\":\"<p>Specifies the AWS KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-context\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"Tagging\":{\
          \"shape\":\"TaggingHeader\",\
          \"documentation\":\"<p>The tag-set for the object. The tag-set must be encoded as URL Query parameters. (For example, \\\"Key1=Value1\\\")</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-tagging\"\
        },\
        \"ObjectLockMode\":{\
          \"shape\":\"ObjectLockMode\",\
          \"documentation\":\"<p>The Object Lock mode that you want to apply to this object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-mode\"\
        },\
        \"ObjectLockRetainUntilDate\":{\
          \"shape\":\"ObjectLockRetainUntilDate\",\
          \"documentation\":\"<p>The date and time when you want this object's Object Lock to expire.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-retain-until-date\"\
        },\
        \"ObjectLockLegalHoldStatus\":{\
          \"shape\":\"ObjectLockLegalHoldStatus\",\
          \"documentation\":\"<p>Specifies whether a legal hold will be applied to this object. For more information about S3 Object Lock, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-object-lock-legal-hold\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Body\"\
    },\
    \"PutObjectRetentionOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"PutObjectRetentionRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name that contains the object you want to apply this Object Retention configuration to. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The key name for the object that you want to apply this Object Retention configuration to.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"Retention\":{\
          \"shape\":\"ObjectLockRetention\",\
          \"documentation\":\"<p>The container element for the Object Retention configuration.</p>\",\
          \"locationName\":\"Retention\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The version ID for the object that you want to apply this Object Retention configuration to.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"BypassGovernanceRetention\":{\
          \"shape\":\"BypassGovernanceRetention\",\
          \"documentation\":\"<p>Indicates whether this operation should bypass Governance-mode restrictions.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-bypass-governance-retention\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash for the request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Retention\"\
    },\
    \"PutObjectTaggingOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The versionId of the object the tag-set was added to.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-version-id\"\
        }\
      }\
    },\
    \"PutObjectTaggingRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\",\
        \"Tagging\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name containing the object. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Name of the object key.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>The versionId of the object that the tag-set will be added to.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash for the request body.</p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"Tagging\":{\
          \"shape\":\"Tagging\",\
          \"documentation\":\"<p>Container for the <code>TagSet</code> and <code>Tag</code> elements</p>\",\
          \"locationName\":\"Tagging\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Tagging\"\
    },\
    \"PutPublicAccessBlockRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"PublicAccessBlockConfiguration\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the Amazon S3 bucket whose <code>PublicAccessBlock</code> configuration you want to set.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The MD5 hash of the <code>PutPublicAccessBlock</code> request body. </p>\",\
          \"deprecated\":true,\
          \"deprecatedMessage\":\"Content-MD5 header will now be automatically computed and injected in associated operation's Http request.\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"PublicAccessBlockConfiguration\":{\
          \"shape\":\"PublicAccessBlockConfiguration\",\
          \"documentation\":\"<p>The <code>PublicAccessBlock</code> configuration that you want to apply to this Amazon S3 bucket. You can enable the configuration options in any combination. For more information about when Amazon S3 considers a bucket or object public, see <a href=\\\"https:
          \"locationName\":\"PublicAccessBlockConfiguration\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"PublicAccessBlockConfiguration\"\
    },\
    \"QueueArn\":{\"type\":\"string\"},\
    \"QueueConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"QueueArn\",\
        \"Events\"\
      ],\
      \"members\":{\
        \"Id\":{\"shape\":\"NotificationId\"},\
        \"QueueArn\":{\
          \"shape\":\"QueueArn\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the Amazon SQS queue to which Amazon S3 publishes a message when it detects events of the specified type.</p>\",\
          \"locationName\":\"Queue\"\
        },\
        \"Events\":{\
          \"shape\":\"EventList\",\
          \"documentation\":\"<p>A collection of bucket events for which to send notifications</p>\",\
          \"locationName\":\"Event\"\
        },\
        \"Filter\":{\"shape\":\"NotificationConfigurationFilter\"}\
      },\
      \"documentation\":\"<p>Specifies the configuration for publishing messages to an Amazon Simple Queue Service (Amazon SQS) queue when Amazon S3 detects specified events.</p>\"\
    },\
    \"QueueConfigurationDeprecated\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Id\":{\"shape\":\"NotificationId\"},\
        \"Event\":{\
          \"shape\":\"Event\",\
          \"deprecated\":true\
        },\
        \"Events\":{\
          \"shape\":\"EventList\",\
          \"documentation\":\"<p>A collection of bucket events for which to send notifications</p>\",\
          \"locationName\":\"Event\"\
        },\
        \"Queue\":{\
          \"shape\":\"QueueArn\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the Amazon SQS queue to which Amazon S3 publishes a message when it detects events of the specified type. </p>\"\
        }\
      },\
      \"documentation\":\"<p>This data type is deprecated. Use <a href=\\\"https:
    },\
    \"QueueConfigurationList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"QueueConfiguration\"},\
      \"flattened\":true\
    },\
    \"Quiet\":{\"type\":\"boolean\"},\
    \"QuoteCharacter\":{\"type\":\"string\"},\
    \"QuoteEscapeCharacter\":{\"type\":\"string\"},\
    \"QuoteFields\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"ALWAYS\",\
        \"ASNEEDED\"\
      ]\
    },\
    \"Range\":{\"type\":\"string\"},\
    \"RecordDelimiter\":{\"type\":\"string\"},\
    \"RecordsEvent\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Payload\":{\
          \"shape\":\"Body\",\
          \"documentation\":\"<p>The byte array of partial, one or more result records.</p>\",\
          \"eventpayload\":true\
        }\
      },\
      \"documentation\":\"<p>The container for the records event.</p>\",\
      \"event\":true\
    },\
    \"Redirect\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"HostName\":{\
          \"shape\":\"HostName\",\
          \"documentation\":\"<p>The host name to use in the redirect request.</p>\"\
        },\
        \"HttpRedirectCode\":{\
          \"shape\":\"HttpRedirectCode\",\
          \"documentation\":\"<p>The HTTP redirect code to use on the response. Not required if one of the siblings is present.</p>\"\
        },\
        \"Protocol\":{\
          \"shape\":\"Protocol\",\
          \"documentation\":\"<p>Protocol to use when redirecting requests. The default is the protocol that is used in the original request.</p>\"\
        },\
        \"ReplaceKeyPrefixWith\":{\
          \"shape\":\"ReplaceKeyPrefixWith\",\
          \"documentation\":\"<p>The object key prefix to use in the redirect request. For example, to redirect requests for all pages with prefix <code>docs/</code> (objects in the <code>docs/</code> folder) to <code>documents/</code>, you can set a condition block with <code>KeyPrefixEquals</code> set to <code>docs/</code> and in the Redirect set <code>ReplaceKeyPrefixWith</code> to <code>/documents</code>. Not required if one of the siblings is present. Can be present only if <code>ReplaceKeyWith</code> is not provided.</p>\"\
        },\
        \"ReplaceKeyWith\":{\
          \"shape\":\"ReplaceKeyWith\",\
          \"documentation\":\"<p>The specific object key to use in the redirect request. For example, redirect request to <code>error.html</code>. Not required if one of the siblings is present. Can be present only if <code>ReplaceKeyPrefixWith</code> is not provided.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies how requests are redirected. In the event of an error, you can specify a different error code to return.</p>\"\
    },\
    \"RedirectAllRequestsTo\":{\
      \"type\":\"structure\",\
      \"required\":[\"HostName\"],\
      \"members\":{\
        \"HostName\":{\
          \"shape\":\"HostName\",\
          \"documentation\":\"<p>Name of the host where requests are redirected.</p>\"\
        },\
        \"Protocol\":{\
          \"shape\":\"Protocol\",\
          \"documentation\":\"<p>Protocol to use when redirecting requests. The default is the protocol that is used in the original request.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the redirect behavior of all requests to a website endpoint of an Amazon S3 bucket.</p>\"\
    },\
    \"ReplaceKeyPrefixWith\":{\"type\":\"string\"},\
    \"ReplaceKeyWith\":{\"type\":\"string\"},\
    \"ReplicaKmsKeyID\":{\"type\":\"string\"},\
    \"ReplicationConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Role\",\
        \"Rules\"\
      ],\
      \"members\":{\
        \"Role\":{\
          \"shape\":\"Role\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the AWS Identity and Access Management (IAM) role that Amazon S3 assumes when replicating objects. For more information, see <a href=\\\"https:
        },\
        \"Rules\":{\
          \"shape\":\"ReplicationRules\",\
          \"documentation\":\"<p>A container for one or more replication rules. A replication configuration must have at least one rule and can contain a maximum of 1,000 rules. </p>\",\
          \"locationName\":\"Rule\"\
        }\
      },\
      \"documentation\":\"<p>A container for replication rules. You can add up to 1,000 rules. The maximum size of a replication configuration is 2 MB.</p>\"\
    },\
    \"ReplicationRule\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Status\",\
        \"Destination\"\
      ],\
      \"members\":{\
        \"ID\":{\
          \"shape\":\"ID\",\
          \"documentation\":\"<p>A unique identifier for the rule. The maximum value is 255 characters.</p>\"\
        },\
        \"Priority\":{\
          \"shape\":\"Priority\",\
          \"documentation\":\"<p>The priority associated with the rule. If you specify multiple rules in a replication configuration, Amazon S3 prioritizes the rules to prevent conflicts when filtering. If two or more rules identify the same object based on a specified filter, the rule with higher priority takes precedence. For example:</p> <ul> <li> <p>Same object quality prefix-based filter criteria if prefixes you specified in multiple rules overlap </p> </li> <li> <p>Same object qualify tag-based filter criteria specified in multiple rules</p> </li> </ul> <p>For more information, see <a href=\\\" https:
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>An object key name prefix that identifies the object or objects to which the rule applies. The maximum prefix length is 1,024 characters. To include all objects in a bucket, specify an empty string. </p>\",\
          \"deprecated\":true\
        },\
        \"Filter\":{\"shape\":\"ReplicationRuleFilter\"},\
        \"Status\":{\
          \"shape\":\"ReplicationRuleStatus\",\
          \"documentation\":\"<p>Specifies whether the rule is enabled.</p>\"\
        },\
        \"SourceSelectionCriteria\":{\
          \"shape\":\"SourceSelectionCriteria\",\
          \"documentation\":\"<p>A container that describes additional filters for identifying the source objects that you want to replicate. You can choose to enable or disable the replication of these objects. Currently, Amazon S3 supports only the filter that you can specify for objects created with server-side encryption using a customer master key (CMK) stored in AWS Key Management Service (SSE-KMS).</p>\"\
        },\
        \"ExistingObjectReplication\":{\
          \"shape\":\"ExistingObjectReplication\",\
          \"documentation\":\"<p/>\"\
        },\
        \"Destination\":{\
          \"shape\":\"Destination\",\
          \"documentation\":\"<p>A container for information about the replication destination and its configurations including enabling the S3 Replication Time Control (S3 RTC).</p>\"\
        },\
        \"DeleteMarkerReplication\":{\"shape\":\"DeleteMarkerReplication\"}\
      },\
      \"documentation\":\"<p>Specifies which Amazon S3 objects to replicate and where to store the replicas.</p>\"\
    },\
    \"ReplicationRuleAndOperator\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>An object key name prefix that identifies the subset of objects to which the rule applies.</p>\"\
        },\
        \"Tags\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>An array of tags containing key and value pairs.</p>\",\
          \"flattened\":true,\
          \"locationName\":\"Tag\"\
        }\
      },\
      \"documentation\":\"<p>A container for specifying rule filters. The filters determine the subset of objects to which the rule applies. This element is required only if you specify more than one filter. </p> <p>For example:</p> <ul> <li> <p>If you specify both a <code>Prefix</code> and a <code>Tag</code> filter, wrap these filters in an <code>And</code> tag. </p> </li> <li> <p>If you specify a filter based on multiple tags, wrap the <code>Tag</code> elements in an <code>And</code> tag</p> </li> </ul>\"\
    },\
    \"ReplicationRuleFilter\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>An object key name prefix that identifies the subset of objects to which the rule applies.</p>\"\
        },\
        \"Tag\":{\
          \"shape\":\"Tag\",\
          \"documentation\":\"<p>A container for specifying a tag key and value. </p> <p>The rule applies only to objects that have the tag in their tag set.</p>\"\
        },\
        \"And\":{\
          \"shape\":\"ReplicationRuleAndOperator\",\
          \"documentation\":\"<p>A container for specifying rule filters. The filters determine the subset of objects to which the rule applies. This element is required only if you specify more than one filter. For example: </p> <ul> <li> <p>If you specify both a <code>Prefix</code> and a <code>Tag</code> filter, wrap these filters in an <code>And</code> tag.</p> </li> <li> <p>If you specify a filter based on multiple tags, wrap the <code>Tag</code> elements in an <code>And</code> tag.</p> </li> </ul>\"\
        }\
      },\
      \"documentation\":\"<p>A filter that identifies the subset of objects to which the replication rule applies. A <code>Filter</code> must specify exactly one <code>Prefix</code>, <code>Tag</code>, or an <code>And</code> child element.</p>\"\
    },\
    \"ReplicationRuleStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"ReplicationRules\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ReplicationRule\"},\
      \"flattened\":true\
    },\
    \"ReplicationStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"COMPLETE\",\
        \"PENDING\",\
        \"FAILED\",\
        \"REPLICA\"\
      ]\
    },\
    \"ReplicationTime\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Status\",\
        \"Time\"\
      ],\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"ReplicationTimeStatus\",\
          \"documentation\":\"<p> Specifies whether the replication time is enabled. </p>\"\
        },\
        \"Time\":{\
          \"shape\":\"ReplicationTimeValue\",\
          \"documentation\":\"<p> A container specifying the time by which replication should be complete for all objects and operations on objects. </p>\"\
        }\
      },\
      \"documentation\":\"<p> A container specifying S3 Replication Time Control (S3 RTC) related information, including whether S3 RTC is enabled and the time when all objects and operations on objects must be replicated. Must be specified together with a <code>Metrics</code> block. </p>\"\
    },\
    \"ReplicationTimeStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"ReplicationTimeValue\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Minutes\":{\
          \"shape\":\"Minutes\",\
          \"documentation\":\"<p> Contains an integer specifying time in minutes. </p> <p> Valid values: 15 minutes. </p>\"\
        }\
      },\
      \"documentation\":\"<p> A container specifying the time value for S3 Replication Time Control (S3 RTC) and replication metrics <code>EventThreshold</code>. </p>\"\
    },\
    \"RequestCharged\":{\
      \"type\":\"string\",\
      \"documentation\":\"<p>If present, indicates that the requester was successfully charged for the request.</p>\",\
      \"enum\":[\"requester\"]\
    },\
    \"RequestPayer\":{\
      \"type\":\"string\",\
      \"documentation\":\"<p>Confirms that the requester knows that they will be charged for the request. Bucket owners need not specify this parameter in their requests. For information about downloading objects from requester pays buckets, see <a href=\\\"https:
      \"enum\":[\"requester\"]\
    },\
    \"RequestPaymentConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\"Payer\"],\
      \"members\":{\
        \"Payer\":{\
          \"shape\":\"Payer\",\
          \"documentation\":\"<p>Specifies who pays for the download and request fees.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for Payer.</p>\"\
    },\
    \"RequestProgress\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Enabled\":{\
          \"shape\":\"EnableRequestProgress\",\
          \"documentation\":\"<p>Specifies whether periodic QueryProgress frames should be sent. Valid values: TRUE, FALSE. Default value: FALSE.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for specifying if periodic <code>QueryProgress</code> messages should be sent.</p>\"\
    },\
    \"ResponseCacheControl\":{\"type\":\"string\"},\
    \"ResponseContentDisposition\":{\"type\":\"string\"},\
    \"ResponseContentEncoding\":{\"type\":\"string\"},\
    \"ResponseContentLanguage\":{\"type\":\"string\"},\
    \"ResponseContentType\":{\"type\":\"string\"},\
    \"ResponseExpires\":{\"type\":\"timestamp\"},\
    \"Restore\":{\"type\":\"string\"},\
    \"RestoreObjectOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        },\
        \"RestoreOutputPath\":{\
          \"shape\":\"RestoreOutputPath\",\
          \"documentation\":\"<p>Indicates the path in the provided S3 output location where Select results will be restored to.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-restore-output-path\"\
        }\
      }\
    },\
    \"RestoreObjectRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name or containing the object to restore. </p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the operation was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"VersionId\":{\
          \"shape\":\"ObjectVersionId\",\
          \"documentation\":\"<p>VersionId used to reference a specific version of the object.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"versionId\"\
        },\
        \"RestoreRequest\":{\
          \"shape\":\"RestoreRequest\",\
          \"locationName\":\"RestoreRequest\",\
          \"xmlNamespace\":{\"uri\":\"http:
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"RestoreRequest\"\
    },\
    \"RestoreOutputPath\":{\"type\":\"string\"},\
    \"RestoreRequest\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Days\":{\
          \"shape\":\"Days\",\
          \"documentation\":\"<p>Lifetime of the active copy in days. Do not use with restores that specify <code>OutputLocation</code>.</p>\"\
        },\
        \"GlacierJobParameters\":{\
          \"shape\":\"GlacierJobParameters\",\
          \"documentation\":\"<p>S3 Glacier related parameters pertaining to this job. Do not use with restores that specify <code>OutputLocation</code>.</p>\"\
        },\
        \"Type\":{\
          \"shape\":\"RestoreRequestType\",\
          \"documentation\":\"<p>Type of restore request.</p>\"\
        },\
        \"Tier\":{\
          \"shape\":\"Tier\",\
          \"documentation\":\"<p>S3 Glacier retrieval tier at which the restore will be processed.</p>\"\
        },\
        \"Description\":{\
          \"shape\":\"Description\",\
          \"documentation\":\"<p>The optional description for the job.</p>\"\
        },\
        \"SelectParameters\":{\
          \"shape\":\"SelectParameters\",\
          \"documentation\":\"<p>Describes the parameters for Select job types.</p>\"\
        },\
        \"OutputLocation\":{\
          \"shape\":\"OutputLocation\",\
          \"documentation\":\"<p>Describes the location where the restore job's output is stored.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for restore job parameters.</p>\"\
    },\
    \"RestoreRequestType\":{\
      \"type\":\"string\",\
      \"enum\":[\"SELECT\"]\
    },\
    \"Role\":{\"type\":\"string\"},\
    \"RoutingRule\":{\
      \"type\":\"structure\",\
      \"required\":[\"Redirect\"],\
      \"members\":{\
        \"Condition\":{\
          \"shape\":\"Condition\",\
          \"documentation\":\"<p>A container for describing a condition that must be met for the specified redirect to apply. For example, 1. If request is for pages in the <code>/docs</code> folder, redirect to the <code>/documents</code> folder. 2. If request results in HTTP error 4xx, redirect request to another host where you might process the error.</p>\"\
        },\
        \"Redirect\":{\
          \"shape\":\"Redirect\",\
          \"documentation\":\"<p>Container for redirect information. You can redirect requests to another host, to another page, or with another protocol. In the event of an error, you can specify a different error code to return.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the redirect behavior and when a redirect is applied. For more information about routing rules, see <a href=\\\"https:
    },\
    \"RoutingRules\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"RoutingRule\",\
        \"locationName\":\"RoutingRule\"\
      }\
    },\
    \"Rule\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Prefix\",\
        \"Status\"\
      ],\
      \"members\":{\
        \"Expiration\":{\
          \"shape\":\"LifecycleExpiration\",\
          \"documentation\":\"<p>Specifies the expiration for the lifecycle of the object.</p>\"\
        },\
        \"ID\":{\
          \"shape\":\"ID\",\
          \"documentation\":\"<p>Unique identifier for the rule. The value can't be longer than 255 characters.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"Prefix\",\
          \"documentation\":\"<p>Object key prefix that identifies one or more objects to which this rule applies.</p>\"\
        },\
        \"Status\":{\
          \"shape\":\"ExpirationStatus\",\
          \"documentation\":\"<p>If <code>Enabled</code>, the rule is currently being applied. If <code>Disabled</code>, the rule is not currently being applied.</p>\"\
        },\
        \"Transition\":{\
          \"shape\":\"Transition\",\
          \"documentation\":\"<p>Specifies when an object transitions to a specified storage class. For more information about Amazon S3 lifecycle configuration rules, see <a href=\\\"https:
        },\
        \"NoncurrentVersionTransition\":{\"shape\":\"NoncurrentVersionTransition\"},\
        \"NoncurrentVersionExpiration\":{\"shape\":\"NoncurrentVersionExpiration\"},\
        \"AbortIncompleteMultipartUpload\":{\"shape\":\"AbortIncompleteMultipartUpload\"}\
      },\
      \"documentation\":\"<p>Specifies lifecycle rules for an Amazon S3 bucket. For more information, see <a href=\\\"https:
    },\
    \"Rules\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Rule\"},\
      \"flattened\":true\
    },\
    \"S3KeyFilter\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"FilterRules\":{\
          \"shape\":\"FilterRuleList\",\
          \"locationName\":\"FilterRule\"\
        }\
      },\
      \"documentation\":\"<p>A container for object key name prefix and suffix filtering rules.</p>\"\
    },\
    \"S3Location\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"BucketName\",\
        \"Prefix\"\
      ],\
      \"members\":{\
        \"BucketName\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket where the restore results will be placed.</p>\"\
        },\
        \"Prefix\":{\
          \"shape\":\"LocationPrefix\",\
          \"documentation\":\"<p>The prefix that is prepended to the restore results for this request.</p>\"\
        },\
        \"Encryption\":{\"shape\":\"Encryption\"},\
        \"CannedACL\":{\
          \"shape\":\"ObjectCannedACL\",\
          \"documentation\":\"<p>The canned ACL to apply to the restore results.</p>\"\
        },\
        \"AccessControlList\":{\
          \"shape\":\"Grants\",\
          \"documentation\":\"<p>A list of grants that control access to the staged results.</p>\"\
        },\
        \"Tagging\":{\
          \"shape\":\"Tagging\",\
          \"documentation\":\"<p>The tag-set that is applied to the restore results.</p>\"\
        },\
        \"UserMetadata\":{\
          \"shape\":\"UserMetadata\",\
          \"documentation\":\"<p>A list of metadata to store with the restore results in S3.</p>\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"StorageClass\",\
          \"documentation\":\"<p>The class of storage used to store the restore results.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes an Amazon S3 location that will receive the results of the restore request.</p>\"\
    },\
    \"SSECustomerAlgorithm\":{\"type\":\"string\"},\
    \"SSECustomerKey\":{\
      \"type\":\"string\",\
      \"sensitive\":true\
    },\
    \"SSECustomerKeyMD5\":{\"type\":\"string\"},\
    \"SSEKMS\":{\
      \"type\":\"structure\",\
      \"required\":[\"KeyId\"],\
      \"members\":{\
        \"KeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>Specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) to use for encrypting inventory reports.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the use of SSE-KMS to encrypt delivered inventory reports.</p>\",\
      \"locationName\":\"SSE-KMS\"\
    },\
    \"SSEKMSEncryptionContext\":{\
      \"type\":\"string\",\
      \"sensitive\":true\
    },\
    \"SSEKMSKeyId\":{\
      \"type\":\"string\",\
      \"sensitive\":true\
    },\
    \"SSES3\":{\
      \"type\":\"structure\",\
      \"members\":{\
      },\
      \"documentation\":\"<p>Specifies the use of SSE-S3 to encrypt delivered inventory reports.</p>\",\
      \"locationName\":\"SSE-S3\"\
    },\
    \"ScanRange\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Start\":{\
          \"shape\":\"Start\",\
          \"documentation\":\"<p>Specifies the start of the byte range. This parameter is optional. Valid values: non-negative integers. The default value is 0. If only start is supplied, it means scan from that point to the end of the file.For example; <code>&lt;scanrange&gt;&lt;start&gt;50&lt;/start&gt;&lt;/scanrange&gt;</code> means scan from byte 50 until the end of the file.</p>\"\
        },\
        \"End\":{\
          \"shape\":\"End\",\
          \"documentation\":\"<p>Specifies the end of the byte range. This parameter is optional. Valid values: non-negative integers. The default value is one less than the size of the object being queried. If only the End parameter is supplied, it is interpreted to mean scan the last N bytes of the file. For example, <code>&lt;scanrange&gt;&lt;end&gt;50&lt;/end&gt;&lt;/scanrange&gt;</code> means scan the last 50 bytes.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the byte range of the object to get the records from. A record is processed when its first byte is contained by the range. This parameter is optional, but when specified, it must not be empty. See RFC 2616, Section 14.35.1 about how to specify the start and end of the range.</p>\"\
    },\
    \"SelectObjectContentEventStream\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Records\":{\
          \"shape\":\"RecordsEvent\",\
          \"documentation\":\"<p>The Records Event.</p>\"\
        },\
        \"Stats\":{\
          \"shape\":\"StatsEvent\",\
          \"documentation\":\"<p>The Stats Event.</p>\"\
        },\
        \"Progress\":{\
          \"shape\":\"ProgressEvent\",\
          \"documentation\":\"<p>The Progress Event.</p>\"\
        },\
        \"Cont\":{\
          \"shape\":\"ContinuationEvent\",\
          \"documentation\":\"<p>The Continuation Event.</p>\"\
        },\
        \"End\":{\
          \"shape\":\"EndEvent\",\
          \"documentation\":\"<p>The End Event.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The container for selecting objects from a content event stream.</p>\",\
      \"eventstream\":true\
    },\
    \"SelectObjectContentOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Payload\":{\
          \"shape\":\"SelectObjectContentEventStream\",\
          \"documentation\":\"<p>The array of results.</p>\"\
        }\
      },\
      \"payload\":\"Payload\"\
    },\
    \"SelectObjectContentRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\",\
        \"Expression\",\
        \"ExpressionType\",\
        \"InputSerialization\",\
        \"OutputSerialization\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The S3 bucket.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>The object key.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>The SSE Algorithm used to encrypt the object. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>The SSE Customer Key. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>The SSE Customer Key MD5. For more information, see <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"Expression\":{\
          \"shape\":\"Expression\",\
          \"documentation\":\"<p>The expression that is used to query the object.</p>\"\
        },\
        \"ExpressionType\":{\
          \"shape\":\"ExpressionType\",\
          \"documentation\":\"<p>The type of the provided expression (for example, SQL).</p>\"\
        },\
        \"RequestProgress\":{\
          \"shape\":\"RequestProgress\",\
          \"documentation\":\"<p>Specifies if periodic request progress information should be enabled.</p>\"\
        },\
        \"InputSerialization\":{\
          \"shape\":\"InputSerialization\",\
          \"documentation\":\"<p>Describes the format of the data in the object that is being queried.</p>\"\
        },\
        \"OutputSerialization\":{\
          \"shape\":\"OutputSerialization\",\
          \"documentation\":\"<p>Describes the format of the data that you want Amazon S3 to return in response.</p>\"\
        },\
        \"ScanRange\":{\
          \"shape\":\"ScanRange\",\
          \"documentation\":\"<p>Specifies the byte range of the object to get the records from. A record is processed when its first byte is contained by the range. This parameter is optional, but when specified, it must not be empty. See RFC 2616, Section 14.35.1 about how to specify the start and end of the range.</p> <p> <code>ScanRange</code>may be used in the following ways:</p> <ul> <li> <p> <code>&lt;scanrange&gt;&lt;start&gt;50&lt;/start&gt;&lt;end&gt;100&lt;/end&gt;&lt;/scanrange&gt;</code> - process only the records starting between the bytes 50 and 100 (inclusive, counting from zero)</p> </li> <li> <p> <code>&lt;scanrange&gt;&lt;start&gt;50&lt;/start&gt;&lt;/scanrange&gt;</code> - process only the records starting after the byte 50</p> </li> <li> <p> <code>&lt;scanrange&gt;&lt;end&gt;50&lt;/end&gt;&lt;/scanrange&gt;</code> - process only the records within the last 50 bytes of the file.</p> </li> </ul>\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"documentation\":\"<p>Request to filter the contents of an Amazon S3 object based on a simple Structured Query Language (SQL) statement. In the request, along with the SQL expression, you must specify a data serialization format (JSON or CSV) of the object. Amazon S3 uses this to parse object data into records. It returns only records that match the specified SQL expression. You must also specify the data serialization format for the response. For more information, see <a href=\\\"https:
    },\
    \"SelectParameters\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"InputSerialization\",\
        \"ExpressionType\",\
        \"Expression\",\
        \"OutputSerialization\"\
      ],\
      \"members\":{\
        \"InputSerialization\":{\
          \"shape\":\"InputSerialization\",\
          \"documentation\":\"<p>Describes the serialization format of the object.</p>\"\
        },\
        \"ExpressionType\":{\
          \"shape\":\"ExpressionType\",\
          \"documentation\":\"<p>The type of the provided expression (for example, SQL).</p>\"\
        },\
        \"Expression\":{\
          \"shape\":\"Expression\",\
          \"documentation\":\"<p>The expression that is used to query the object.</p>\"\
        },\
        \"OutputSerialization\":{\
          \"shape\":\"OutputSerialization\",\
          \"documentation\":\"<p>Describes how the results of the Select job are serialized.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes the parameters for Select job types.</p>\"\
    },\
    \"ServerSideEncryption\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"AES256\",\
        \"aws:kms\"\
      ]\
    },\
    \"ServerSideEncryptionByDefault\":{\
      \"type\":\"structure\",\
      \"required\":[\"SSEAlgorithm\"],\
      \"members\":{\
        \"SSEAlgorithm\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>Server-side encryption algorithm to use for the default encryption.</p>\"\
        },\
        \"KMSMasterKeyID\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>AWS Key Management Service (KMS) customer master key ID to use for the default encryption. This parameter is allowed if and only if <code>SSEAlgorithm</code> is set to <code>aws:kms</code>.</p> <p>You can specify the key ID or the Amazon Resource Name (ARN) of the CMK. However, if you are using encryption with cross-account operations, you must use a fully qualified CMK ARN. For more information, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>Describes the default server-side encryption to apply to new objects in the bucket. If a PUT Object request doesn't specify any server-side encryption, this default encryption will be applied. For more information, see <a href=\\\"https:
    },\
    \"ServerSideEncryptionConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\"Rules\"],\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"ServerSideEncryptionRules\",\
          \"documentation\":\"<p>Container for information about a particular server-side encryption configuration rule.</p>\",\
          \"locationName\":\"Rule\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the default server-side-encryption configuration.</p>\"\
    },\
    \"ServerSideEncryptionRule\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ApplyServerSideEncryptionByDefault\":{\
          \"shape\":\"ServerSideEncryptionByDefault\",\
          \"documentation\":\"<p>Specifies the default server-side encryption to apply to new objects in the bucket. If a PUT Object request doesn't specify any server-side encryption, this default encryption will be applied.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies the default server-side encryption configuration.</p>\"\
    },\
    \"ServerSideEncryptionRules\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ServerSideEncryptionRule\"},\
      \"flattened\":true\
    },\
    \"Setting\":{\"type\":\"boolean\"},\
    \"Size\":{\"type\":\"integer\"},\
    \"SourceSelectionCriteria\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"SseKmsEncryptedObjects\":{\
          \"shape\":\"SseKmsEncryptedObjects\",\
          \"documentation\":\"<p> A container for filter information for the selection of Amazon S3 objects encrypted with AWS KMS. If you include <code>SourceSelectionCriteria</code> in the replication configuration, this element is required. </p>\"\
        }\
      },\
      \"documentation\":\"<p>A container that describes additional filters for identifying the source objects that you want to replicate. You can choose to enable or disable the replication of these objects. Currently, Amazon S3 supports only the filter that you can specify for objects created with server-side encryption using a customer master key (CMK) stored in AWS Key Management Service (SSE-KMS).</p>\"\
    },\
    \"SseKmsEncryptedObjects\":{\
      \"type\":\"structure\",\
      \"required\":[\"Status\"],\
      \"members\":{\
        \"Status\":{\
          \"shape\":\"SseKmsEncryptedObjectsStatus\",\
          \"documentation\":\"<p>Specifies whether Amazon S3 replicates objects created with server-side encryption using a customer master key (CMK) stored in AWS Key Management Service.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A container for filter information for the selection of S3 objects encrypted with AWS KMS.</p>\"\
    },\
    \"SseKmsEncryptedObjectsStatus\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Enabled\",\
        \"Disabled\"\
      ]\
    },\
    \"Start\":{\"type\":\"long\"},\
    \"StartAfter\":{\"type\":\"string\"},\
    \"Stats\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"BytesScanned\":{\
          \"shape\":\"BytesScanned\",\
          \"documentation\":\"<p>The total number of object bytes scanned.</p>\"\
        },\
        \"BytesProcessed\":{\
          \"shape\":\"BytesProcessed\",\
          \"documentation\":\"<p>The total number of uncompressed object bytes processed.</p>\"\
        },\
        \"BytesReturned\":{\
          \"shape\":\"BytesReturned\",\
          \"documentation\":\"<p>The total number of bytes of records payload data returned.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for the stats details.</p>\"\
    },\
    \"StatsEvent\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Details\":{\
          \"shape\":\"Stats\",\
          \"documentation\":\"<p>The Stats event details.</p>\",\
          \"eventpayload\":true\
        }\
      },\
      \"documentation\":\"<p>Container for the Stats Event.</p>\",\
      \"event\":true\
    },\
    \"StorageClass\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"STANDARD\",\
        \"REDUCED_REDUNDANCY\",\
        \"STANDARD_IA\",\
        \"ONEZONE_IA\",\
        \"INTELLIGENT_TIERING\",\
        \"GLACIER\",\
        \"DEEP_ARCHIVE\",\
        \"OUTPOSTS\"\
      ]\
    },\
    \"StorageClassAnalysis\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DataExport\":{\
          \"shape\":\"StorageClassAnalysisDataExport\",\
          \"documentation\":\"<p>Specifies how data related to the storage class analysis for an Amazon S3 bucket should be exported.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies data related to access patterns to be collected and made available to analyze the tradeoffs between different storage classes for an Amazon S3 bucket.</p>\"\
    },\
    \"StorageClassAnalysisDataExport\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"OutputSchemaVersion\",\
        \"Destination\"\
      ],\
      \"members\":{\
        \"OutputSchemaVersion\":{\
          \"shape\":\"StorageClassAnalysisSchemaVersion\",\
          \"documentation\":\"<p>The version of the output schema to use when exporting data. Must be <code>V_1</code>.</p>\"\
        },\
        \"Destination\":{\
          \"shape\":\"AnalyticsExportDestination\",\
          \"documentation\":\"<p>The place to store the data for an analysis.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for data related to the storage class analysis for an Amazon S3 bucket for export.</p>\"\
    },\
    \"StorageClassAnalysisSchemaVersion\":{\
      \"type\":\"string\",\
      \"enum\":[\"V_1\"]\
    },\
    \"Suffix\":{\"type\":\"string\"},\
    \"Tag\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Key\",\
        \"Value\"\
      ],\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Name of the object key.</p>\"\
        },\
        \"Value\":{\
          \"shape\":\"Value\",\
          \"documentation\":\"<p>Value of the tag.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A container of a key value name pair.</p>\"\
    },\
    \"TagCount\":{\"type\":\"integer\"},\
    \"TagSet\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"Tag\",\
        \"locationName\":\"Tag\"\
      }\
    },\
    \"Tagging\":{\
      \"type\":\"structure\",\
      \"required\":[\"TagSet\"],\
      \"members\":{\
        \"TagSet\":{\
          \"shape\":\"TagSet\",\
          \"documentation\":\"<p>A collection for a set of tags</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for <code>TagSet</code> elements.</p>\"\
    },\
    \"TaggingDirective\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"COPY\",\
        \"REPLACE\"\
      ]\
    },\
    \"TaggingHeader\":{\"type\":\"string\"},\
    \"TargetBucket\":{\"type\":\"string\"},\
    \"TargetGrant\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Grantee\":{\
          \"shape\":\"Grantee\",\
          \"documentation\":\"<p>Container for the person being granted permissions.</p>\"\
        },\
        \"Permission\":{\
          \"shape\":\"BucketLogsPermission\",\
          \"documentation\":\"<p>Logging permissions assigned to the grantee for the bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Container for granting information.</p>\"\
    },\
    \"TargetGrants\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"TargetGrant\",\
        \"locationName\":\"Grant\"\
      }\
    },\
    \"TargetPrefix\":{\"type\":\"string\"},\
    \"Tier\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Standard\",\
        \"Bulk\",\
        \"Expedited\"\
      ]\
    },\
    \"Token\":{\"type\":\"string\"},\
    \"TopicArn\":{\"type\":\"string\"},\
    \"TopicConfiguration\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"TopicArn\",\
        \"Events\"\
      ],\
      \"members\":{\
        \"Id\":{\"shape\":\"NotificationId\"},\
        \"TopicArn\":{\
          \"shape\":\"TopicArn\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the Amazon SNS topic to which Amazon S3 publishes a message when it detects events of the specified type.</p>\",\
          \"locationName\":\"Topic\"\
        },\
        \"Events\":{\
          \"shape\":\"EventList\",\
          \"documentation\":\"<p>The Amazon S3 bucket event about which to send notifications. For more information, see <a href=\\\"https:
          \"locationName\":\"Event\"\
        },\
        \"Filter\":{\"shape\":\"NotificationConfigurationFilter\"}\
      },\
      \"documentation\":\"<p>A container for specifying the configuration for publication of messages to an Amazon Simple Notification Service (Amazon SNS) topic when Amazon S3 detects specified events.</p>\"\
    },\
    \"TopicConfigurationDeprecated\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Id\":{\"shape\":\"NotificationId\"},\
        \"Events\":{\
          \"shape\":\"EventList\",\
          \"documentation\":\"<p>A collection of events related to objects</p>\",\
          \"locationName\":\"Event\"\
        },\
        \"Event\":{\
          \"shape\":\"Event\",\
          \"documentation\":\"<p>Bucket event for which to send notifications.</p>\",\
          \"deprecated\":true\
        },\
        \"Topic\":{\
          \"shape\":\"TopicArn\",\
          \"documentation\":\"<p>Amazon SNS topic to which Amazon S3 will publish a message to report the specified events for the bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A container for specifying the configuration for publication of messages to an Amazon Simple Notification Service (Amazon SNS) topic when Amazon S3 detects specified events. This data type is deprecated. Use <a href=\\\"https:
    },\
    \"TopicConfigurationList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"TopicConfiguration\"},\
      \"flattened\":true\
    },\
    \"Transition\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Date\":{\
          \"shape\":\"Date\",\
          \"documentation\":\"<p>Indicates when objects are transitioned to the specified storage class. The date value must be in ISO 8601 format. The time is always midnight UTC.</p>\"\
        },\
        \"Days\":{\
          \"shape\":\"Days\",\
          \"documentation\":\"<p>Indicates the number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer.</p>\"\
        },\
        \"StorageClass\":{\
          \"shape\":\"TransitionStorageClass\",\
          \"documentation\":\"<p>The storage class to which you want the object to transition.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies when an object transitions to a specified storage class. For more information about Amazon S3 lifecycle configuration rules, see <a href=\\\"https:
    },\
    \"TransitionList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Transition\"},\
      \"flattened\":true\
    },\
    \"TransitionStorageClass\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"GLACIER\",\
        \"STANDARD_IA\",\
        \"ONEZONE_IA\",\
        \"INTELLIGENT_TIERING\",\
        \"DEEP_ARCHIVE\"\
      ]\
    },\
    \"Type\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"CanonicalUser\",\
        \"AmazonCustomerByEmail\",\
        \"Group\"\
      ]\
    },\
    \"URI\":{\"type\":\"string\"},\
    \"UploadIdMarker\":{\"type\":\"string\"},\
    \"UploadPartCopyOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"CopySourceVersionId\":{\
          \"shape\":\"CopySourceVersionId\",\
          \"documentation\":\"<p>The version of the source object that was copied, if you have enabled versioning on the source bucket.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-version-id\"\
        },\
        \"CopyPartResult\":{\
          \"shape\":\"CopyPartResult\",\
          \"documentation\":\"<p>Container for all response elements.</p>\"\
        },\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) that was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      },\
      \"payload\":\"CopyPartResult\"\
    },\
    \"UploadPartCopyRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"CopySource\",\
        \"Key\",\
        \"PartNumber\",\
        \"UploadId\"\
      ],\
      \"members\":{\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The bucket name.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"CopySource\":{\
          \"shape\":\"CopySource\",\
          \"documentation\":\"<p>Specifies the source object for the copy operation. You specify the value in one of two formats, depending on whether you want to access the source object through an <a href=\\\"https:
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source\"\
        },\
        \"CopySourceIfMatch\":{\
          \"shape\":\"CopySourceIfMatch\",\
          \"documentation\":\"<p>Copies the object if its entity tag (ETag) matches the specified tag.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-match\"\
        },\
        \"CopySourceIfModifiedSince\":{\
          \"shape\":\"CopySourceIfModifiedSince\",\
          \"documentation\":\"<p>Copies the object if it has been modified since the specified time.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-modified-since\"\
        },\
        \"CopySourceIfNoneMatch\":{\
          \"shape\":\"CopySourceIfNoneMatch\",\
          \"documentation\":\"<p>Copies the object if its entity tag (ETag) is different than the specified ETag.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-none-match\"\
        },\
        \"CopySourceIfUnmodifiedSince\":{\
          \"shape\":\"CopySourceIfUnmodifiedSince\",\
          \"documentation\":\"<p>Copies the object if it hasn't been modified since the specified time.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-if-unmodified-since\"\
        },\
        \"CopySourceRange\":{\
          \"shape\":\"CopySourceRange\",\
          \"documentation\":\"<p>The range of bytes to copy from the source object. The range value must use the form bytes=first-last, where the first and last are the zero-based byte offsets to copy. For example, bytes=0-9 indicates that you want to copy the first 10 bytes of the source. You can copy a range only if the source object is greater than 5 MB.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-range\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"PartNumber\":{\
          \"shape\":\"PartNumber\",\
          \"documentation\":\"<p>Part number of part being copied. This is a positive integer between 1 and 10,000.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"partNumber\"\
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>Upload ID identifying the multipart upload whose part is being copied.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"uploadId\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm</code> header. This must be the same encryption key specified in the initiate multipart upload request.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"CopySourceSSECustomerAlgorithm\":{\
          \"shape\":\"CopySourceSSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use when decrypting the source object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-server-side-encryption-customer-algorithm\"\
        },\
        \"CopySourceSSECustomerKey\":{\
          \"shape\":\"CopySourceSSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use to decrypt the source object. The encryption key provided in this header must be one that was used when the source object was created.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-server-side-encryption-customer-key\"\
        },\
        \"CopySourceSSECustomerKeyMD5\":{\
          \"shape\":\"CopySourceSSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-copy-source-server-side-encryption-customer-key-MD5\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected destination bucket owner. If the destination bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        },\
        \"ExpectedSourceBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected source bucket owner. If the source bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-source-expected-bucket-owner\"\
        }\
      }\
    },\
    \"UploadPartOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ServerSideEncryption\":{\
          \"shape\":\"ServerSideEncryption\",\
          \"documentation\":\"<p>The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption\"\
        },\
        \"ETag\":{\
          \"shape\":\"ETag\",\
          \"documentation\":\"<p>Entity tag for the uploaded object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"ETag\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header confirming the encryption algorithm used.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide round-trip message integrity verification of the customer-provided encryption key.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"SSEKMSKeyId\":{\
          \"shape\":\"SSEKMSKeyId\",\
          \"documentation\":\"<p>If present, specifies the ID of the AWS Key Management Service (AWS KMS) symmetric customer managed customer master key (CMK) was used for the object.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-aws-kms-key-id\"\
        },\
        \"RequestCharged\":{\
          \"shape\":\"RequestCharged\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-charged\"\
        }\
      }\
    },\
    \"UploadPartRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Bucket\",\
        \"Key\",\
        \"PartNumber\",\
        \"UploadId\"\
      ],\
      \"members\":{\
        \"Body\":{\
          \"shape\":\"Body\",\
          \"documentation\":\"<p>Object data.</p>\",\
          \"streaming\":true\
        },\
        \"Bucket\":{\
          \"shape\":\"BucketName\",\
          \"documentation\":\"<p>The name of the bucket to which the multipart upload was initiated.</p> <p>When using this API with an access point, you must direct requests to the access point hostname. The access point hostname takes the form <i>AccessPointName</i>-<i>AccountId</i>.s3-accesspoint.<i>Region</i>.amazonaws.com. When using this operation with an access point through the AWS SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see <a href=\\\"https:
          \"location\":\"uri\",\
          \"locationName\":\"Bucket\"\
        },\
        \"ContentLength\":{\
          \"shape\":\"ContentLength\",\
          \"documentation\":\"<p>Size of the body in bytes. This parameter is useful when the size of the body cannot be determined automatically.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Length\"\
        },\
        \"ContentMD5\":{\
          \"shape\":\"ContentMD5\",\
          \"documentation\":\"<p>The base64-encoded 128-bit MD5 digest of the part data. This parameter is auto-populated when using the command from the CLI. This parameter is required if object lock parameters are specified.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-MD5\"\
        },\
        \"Key\":{\
          \"shape\":\"ObjectKey\",\
          \"documentation\":\"<p>Object key for which the multipart upload was initiated.</p>\",\
          \"location\":\"uri\",\
          \"locationName\":\"Key\"\
        },\
        \"PartNumber\":{\
          \"shape\":\"PartNumber\",\
          \"documentation\":\"<p>Part number of part being uploaded. This is a positive integer between 1 and 10,000.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"partNumber\"\
        },\
        \"UploadId\":{\
          \"shape\":\"MultipartUploadId\",\
          \"documentation\":\"<p>Upload ID identifying the multipart upload whose part is being uploaded.</p>\",\
          \"location\":\"querystring\",\
          \"locationName\":\"uploadId\"\
        },\
        \"SSECustomerAlgorithm\":{\
          \"shape\":\"SSECustomerAlgorithm\",\
          \"documentation\":\"<p>Specifies the algorithm to use to when encrypting the object (for example, AES256).</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-algorithm\"\
        },\
        \"SSECustomerKey\":{\
          \"shape\":\"SSECustomerKey\",\
          \"documentation\":\"<p>Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the <code>x-amz-server-side-encryption-customer-algorithm header</code>. This must be the same encryption key specified in the initiate multipart upload request.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key\"\
        },\
        \"SSECustomerKeyMD5\":{\
          \"shape\":\"SSECustomerKeyMD5\",\
          \"documentation\":\"<p>Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-server-side-encryption-customer-key-MD5\"\
        },\
        \"RequestPayer\":{\
          \"shape\":\"RequestPayer\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-request-payer\"\
        },\
        \"ExpectedBucketOwner\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>The account id of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP <code>403 (Access Denied)</code> error.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"x-amz-expected-bucket-owner\"\
        }\
      },\
      \"payload\":\"Body\"\
    },\
    \"UserMetadata\":{\
      \"type\":\"list\",\
      \"member\":{\
        \"shape\":\"MetadataEntry\",\
        \"locationName\":\"MetadataEntry\"\
      }\
    },\
    \"Value\":{\"type\":\"string\"},\
    \"VersionIdMarker\":{\"type\":\"string\"},\
    \"VersioningConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"MFADelete\":{\
          \"shape\":\"MFADelete\",\
          \"documentation\":\"<p>Specifies whether MFA delete is enabled in the bucket versioning configuration. This element is only returned if the bucket has been configured with MFA delete. If the bucket has never been so configured, this element is not returned.</p>\",\
          \"locationName\":\"MfaDelete\"\
        },\
        \"Status\":{\
          \"shape\":\"BucketVersioningStatus\",\
          \"documentation\":\"<p>The versioning state of the bucket.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes the versioning state of an Amazon S3 bucket. For more information, see <a href=\\\"https:
    },\
    \"WebsiteConfiguration\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ErrorDocument\":{\
          \"shape\":\"ErrorDocument\",\
          \"documentation\":\"<p>The name of the error document for the website.</p>\"\
        },\
        \"IndexDocument\":{\
          \"shape\":\"IndexDocument\",\
          \"documentation\":\"<p>The name of the index document for the website.</p>\"\
        },\
        \"RedirectAllRequestsTo\":{\
          \"shape\":\"RedirectAllRequestsTo\",\
          \"documentation\":\"<p>The redirect behavior for every request to this bucket's website endpoint.</p> <important> <p>If you specify this property, you can't specify any other property.</p> </important>\"\
        },\
        \"RoutingRules\":{\
          \"shape\":\"RoutingRules\",\
          \"documentation\":\"<p>Rules that define when a redirect is applied and the redirect behavior.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Specifies website configuration parameters for an Amazon S3 bucket.</p>\"\
    },\
    \"WebsiteRedirectLocation\":{\"type\":\"string\"},\
    \"Years\":{\"type\":\"integer\"}\
  },\
  \"documentation\":\"<p/>\"\
}\
";
}
@end