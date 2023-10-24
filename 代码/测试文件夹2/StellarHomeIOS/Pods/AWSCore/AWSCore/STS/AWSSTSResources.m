#import "AWSSTSResources.h"
#import "AWSCocoaLumberjack.h"
@interface AWSSTSResources ()
@property (nonatomic, strong) NSDictionary *definitionDictionary;
@end
@implementation AWSSTSResources
+ (instancetype)sharedInstance {
    static AWSSTSResources *_sharedResources = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _sharedResources = [AWSSTSResources new];
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
    \"apiVersion\":\"2011-06-15\",\
    \"endpointPrefix\":\"sts\",\
    \"globalEndpoint\":\"sts.amazonaws.com\",\
    \"protocol\":\"query\",\
    \"serviceAbbreviation\":\"AWS STS\",\
    \"serviceFullName\":\"AWS Security Token Service\",\
    \"serviceId\":\"STS\",\
    \"signatureVersion\":\"v4\",\
    \"uid\":\"sts-2011-06-15\",\
    \"xmlNamespace\":\"https:
  },\
  \"operations\":{\
    \"AssumeRole\":{\
      \"name\":\"AssumeRole\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"AssumeRoleRequest\"},\
      \"output\":{\
        \"shape\":\"AssumeRoleResponse\",\
        \"resultWrapper\":\"AssumeRoleResult\"\
      },\
      \"errors\":[\
        {\"shape\":\"MalformedPolicyDocumentException\"},\
        {\"shape\":\"PackedPolicyTooLargeException\"},\
        {\"shape\":\"RegionDisabledException\"},\
        {\"shape\":\"ExpiredTokenException\"}\
      ],\
      \"documentation\":\"<p>Returns a set of temporary security credentials that you can use to access AWS resources that you might not normally have access to. These temporary credentials consist of an access key ID, a secret access key, and a security token. Typically, you use <code>AssumeRole</code> within your account or for cross-account access. For a comparison of <code>AssumeRole</code> with other API operations that produce temporary credentials, see <a href=\\\"https:
    },\
    \"AssumeRoleWithSAML\":{\
      \"name\":\"AssumeRoleWithSAML\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"AssumeRoleWithSAMLRequest\"},\
      \"output\":{\
        \"shape\":\"AssumeRoleWithSAMLResponse\",\
        \"resultWrapper\":\"AssumeRoleWithSAMLResult\"\
      },\
      \"errors\":[\
        {\"shape\":\"MalformedPolicyDocumentException\"},\
        {\"shape\":\"PackedPolicyTooLargeException\"},\
        {\"shape\":\"IDPRejectedClaimException\"},\
        {\"shape\":\"InvalidIdentityTokenException\"},\
        {\"shape\":\"ExpiredTokenException\"},\
        {\"shape\":\"RegionDisabledException\"}\
      ],\
      \"documentation\":\"<p>Returns a set of temporary security credentials for users who have been authenticated via a SAML authentication response. This operation provides a mechanism for tying an enterprise identity store or directory to role-based AWS access without user-specific credentials or configuration. For a comparison of <code>AssumeRoleWithSAML</code> with the other API operations that produce temporary credentials, see <a href=\\\"https:
    },\
    \"AssumeRoleWithWebIdentity\":{\
      \"name\":\"AssumeRoleWithWebIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"AssumeRoleWithWebIdentityRequest\"},\
      \"output\":{\
        \"shape\":\"AssumeRoleWithWebIdentityResponse\",\
        \"resultWrapper\":\"AssumeRoleWithWebIdentityResult\"\
      },\
      \"errors\":[\
        {\"shape\":\"MalformedPolicyDocumentException\"},\
        {\"shape\":\"PackedPolicyTooLargeException\"},\
        {\"shape\":\"IDPRejectedClaimException\"},\
        {\"shape\":\"IDPCommunicationErrorException\"},\
        {\"shape\":\"InvalidIdentityTokenException\"},\
        {\"shape\":\"ExpiredTokenException\"},\
        {\"shape\":\"RegionDisabledException\"}\
      ],\
      \"documentation\":\"<p>Returns a set of temporary security credentials for users who have been authenticated in a mobile or web application with a web identity provider. Example providers include Amazon Cognito, Login with Amazon, Facebook, Google, or any OpenID Connect-compatible identity provider.</p> <note> <p>For mobile applications, we recommend that you use Amazon Cognito. You can use Amazon Cognito with the <a href=\\\"http:
    },\
    \"DecodeAuthorizationMessage\":{\
      \"name\":\"DecodeAuthorizationMessage\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"DecodeAuthorizationMessageRequest\"},\
      \"output\":{\
        \"shape\":\"DecodeAuthorizationMessageResponse\",\
        \"resultWrapper\":\"DecodeAuthorizationMessageResult\"\
      },\
      \"errors\":[\
        {\"shape\":\"InvalidAuthorizationMessageException\"}\
      ],\
      \"documentation\":\"<p>Decodes additional information about the authorization status of a request from an encoded message returned in response to an AWS request.</p> <p>For example, if a user is not authorized to perform an operation that he or she has requested, the request returns a <code>Client.UnauthorizedOperation</code> response (an HTTP 403 response). Some AWS operations additionally return an encoded message that can provide details about this authorization failure. </p> <note> <p>Only certain AWS operations return an encoded authorization message. The documentation for an individual operation indicates whether that operation returns an encoded message in addition to returning an HTTP code.</p> </note> <p>The message is encoded because the details of the authorization status can constitute privileged information that the user who requested the operation should not see. To decode an authorization status message, a user must be granted permissions via an IAM policy to request the <code>DecodeAuthorizationMessage</code> (<code>sts:DecodeAuthorizationMessage</code>) action. </p> <p>The decoded message includes the following type of information:</p> <ul> <li> <p>Whether the request was denied due to an explicit deny or due to the absence of an explicit allow. For more information, see <a href=\\\"https:
    },\
    \"GetAccessKeyInfo\":{\
      \"name\":\"GetAccessKeyInfo\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetAccessKeyInfoRequest\"},\
      \"output\":{\
        \"shape\":\"GetAccessKeyInfoResponse\",\
        \"resultWrapper\":\"GetAccessKeyInfoResult\"\
      },\
      \"documentation\":\"<p>Returns the account identifier for the specified access key ID.</p> <p>Access keys consist of two parts: an access key ID (for example, <code>AKIAIOSFODNN7EXAMPLE</code>) and a secret access key (for example, <code>wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY</code>). For more information about access keys, see <a href=\\\"https:
    },\
    \"GetCallerIdentity\":{\
      \"name\":\"GetCallerIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetCallerIdentityRequest\"},\
      \"output\":{\
        \"shape\":\"GetCallerIdentityResponse\",\
        \"resultWrapper\":\"GetCallerIdentityResult\"\
      },\
      \"documentation\":\"<p>Returns details about the IAM user or role whose credentials are used to call the operation.</p> <note> <p>No permissions are required to perform this operation. If an administrator adds a policy to your IAM user or role that explicitly denies access to the <code>sts:GetCallerIdentity</code> action, you can still perform this operation. Permissions are not required because the same information is returned when an IAM user or role is denied access. To view an example response, see <a href=\\\"https:
    },\
    \"GetFederationToken\":{\
      \"name\":\"GetFederationToken\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetFederationTokenRequest\"},\
      \"output\":{\
        \"shape\":\"GetFederationTokenResponse\",\
        \"resultWrapper\":\"GetFederationTokenResult\"\
      },\
      \"errors\":[\
        {\"shape\":\"MalformedPolicyDocumentException\"},\
        {\"shape\":\"PackedPolicyTooLargeException\"},\
        {\"shape\":\"RegionDisabledException\"}\
      ],\
      \"documentation\":\"<p>Returns a set of temporary security credentials (consisting of an access key ID, a secret access key, and a security token) for a federated user. A typical use is in a proxy application that gets temporary security credentials on behalf of distributed applications inside a corporate network. You must call the <code>GetFederationToken</code> operation using the long-term security credentials of an IAM user. As a result, this call is appropriate in contexts where those credentials can be safely stored, usually in a server-based application. For a comparison of <code>GetFederationToken</code> with the other API operations that produce temporary credentials, see <a href=\\\"https:
    },\
    \"GetSessionToken\":{\
      \"name\":\"GetSessionToken\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetSessionTokenRequest\"},\
      \"output\":{\
        \"shape\":\"GetSessionTokenResponse\",\
        \"resultWrapper\":\"GetSessionTokenResult\"\
      },\
      \"errors\":[\
        {\"shape\":\"RegionDisabledException\"}\
      ],\
      \"documentation\":\"<p>Returns a set of temporary credentials for an AWS account or IAM user. The credentials consist of an access key ID, a secret access key, and a security token. Typically, you use <code>GetSessionToken</code> if you want to use MFA to protect programmatic calls to specific AWS API operations like Amazon EC2 <code>StopInstances</code>. MFA-enabled IAM users would need to call <code>GetSessionToken</code> and submit an MFA code that is associated with their MFA device. Using the temporary security credentials that are returned from the call, IAM users can then make programmatic calls to API operations that require MFA authentication. If you do not supply a correct MFA code, then the API returns an access denied error. For a comparison of <code>GetSessionToken</code> with the other API operations that produce temporary credentials, see <a href=\\\"https:
    }\
  },\
  \"shapes\":{\
    \"AssumeRoleRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"RoleArn\",\
        \"RoleSessionName\"\
      ],\
      \"members\":{\
        \"RoleArn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the role to assume.</p>\"\
        },\
        \"RoleSessionName\":{\
          \"shape\":\"roleSessionNameType\",\
          \"documentation\":\"<p>An identifier for the assumed role session.</p> <p>Use the role session name to uniquely identify a session when the same role is assumed by different principals or for different reasons. In cross-account scenarios, the role session name is visible to, and can be logged by the account that owns the role. The role session name is also used in the ARN of the assumed role principal. This means that subsequent cross-account API requests that use the temporary security credentials will expose the role session name to the external account in their AWS CloudTrail logs.</p> <p>The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-</p>\"\
        },\
        \"PolicyArns\":{\
          \"shape\":\"policyDescriptorListType\",\
          \"documentation\":\"<p>The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as managed session policies. The policies must exist in the same account as the role.</p> <p>This parameter is optional. You can provide up to 10 managed policy ARNs. However, the plain text that you use for both inline and managed session policies can't exceed 2,048 characters. For more information about ARNs, see <a href=\\\"https:
        },\
        \"Policy\":{\
          \"shape\":\"sessionPolicyDocumentType\",\
          \"documentation\":\"<p>An IAM policy in JSON format that you want to use as an inline session policy.</p> <p>This parameter is optional. Passing policies to this operation returns new temporary credentials. The resulting session's permissions are the intersection of the role's identity-based policy and the session policies. You can use the role's temporary credentials in subsequent AWS API calls to access resources in the account that owns the role. You cannot use session policies to grant more permissions than those allowed by the identity-based policy of the role that is being assumed. For more information, see <a href=\\\"https:
        },\
        \"DurationSeconds\":{\
          \"shape\":\"roleDurationSecondsType\",\
          \"documentation\":\"<p>The duration, in seconds, of the role session. The value can range from 900 seconds (15 minutes) up to the maximum session duration setting for the role. This setting can have a value from 1 hour to 12 hours. If you specify a value higher than this setting, the operation fails. For example, if you specify a session duration of 12 hours, but your administrator set the maximum session duration to 6 hours, your operation fails. To learn how to view the maximum value for your role, see <a href=\\\"https:
        },\
        \"Tags\":{\
          \"shape\":\"tagListType\",\
          \"documentation\":\"<p>A list of session tags that you want to pass. Each session tag consists of a key name and an associated value. For more information about session tags, see <a href=\\\"https:
        },\
        \"TransitiveTagKeys\":{\
          \"shape\":\"tagKeyListType\",\
          \"documentation\":\"<p>A list of keys for session tags that you want to set as transitive. If you set a tag key as transitive, the corresponding key and value passes to subsequent sessions in a role chain. For more information, see <a href=\\\"https:
        },\
        \"ExternalId\":{\
          \"shape\":\"externalIdType\",\
          \"documentation\":\"<p>A unique identifier that might be required when you assume a role in another account. If the administrator of the account to which the role belongs provided you with an external ID, then provide that value in the <code>ExternalId</code> parameter. This value can be any string, such as a passphrase or account number. A cross-account role is usually set up to trust everyone in an account. Therefore, the administrator of the trusting account might send an external ID to the administrator of the trusted account. That way, only someone with the ID can assume the role, rather than everyone in the account. For more information about the external ID, see <a href=\\\"https:
        },\
        \"SerialNumber\":{\
          \"shape\":\"serialNumberType\",\
          \"documentation\":\"<p>The identification number of the MFA device that is associated with the user who is making the <code>AssumeRole</code> call. Specify this value if the trust policy of the role being assumed includes a condition that requires MFA authentication. The value is either the serial number for a hardware device (such as <code>GAHT12345678</code>) or an Amazon Resource Name (ARN) for a virtual device (such as <code>arn:aws:iam::123456789012:mfa/user</code>).</p> <p>The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-</p>\"\
        },\
        \"TokenCode\":{\
          \"shape\":\"tokenCodeType\",\
          \"documentation\":\"<p>The value provided by the MFA device, if the trust policy of the role being assumed requires MFA (that is, if the policy includes a condition that tests for MFA). If the role being assumed requires MFA and if the <code>TokenCode</code> value is missing or expired, the <code>AssumeRole</code> call returns an \\\"access denied\\\" error.</p> <p>The format for this parameter, as described by its regex pattern, is a sequence of six numeric digits.</p>\"\
        }\
      }\
    },\
    \"AssumeRoleResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Credentials\":{\
          \"shape\":\"Credentials\",\
          \"documentation\":\"<p>The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.</p> <note> <p>The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.</p> </note>\"\
        },\
        \"AssumedRoleUser\":{\
          \"shape\":\"AssumedRoleUser\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) and the assumed role ID, which are identifiers that you can use to refer to the resulting temporary security credentials. For example, you can reference these credentials as a principal in a resource-based policy by using the ARN or assumed role ID. The ARN and ID include the <code>RoleSessionName</code> that you specified when you called <code>AssumeRole</code>. </p>\"\
        },\
        \"PackedPolicySize\":{\
          \"shape\":\"nonNegativeIntegerType\",\
          \"documentation\":\"<p>A percentage value that indicates the packed size of the session policies and session tags combined passed in the request. The request fails if the packed size is greater than 100 percent, which means the policies and tags exceeded the allowed space.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the response to a successful <a>AssumeRole</a> request, including temporary AWS credentials that can be used to make AWS requests. </p>\"\
    },\
    \"AssumeRoleWithSAMLRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"RoleArn\",\
        \"PrincipalArn\",\
        \"SAMLAssertion\"\
      ],\
      \"members\":{\
        \"RoleArn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the role that the caller is assuming.</p>\"\
        },\
        \"PrincipalArn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the SAML provider in IAM that describes the IdP.</p>\"\
        },\
        \"SAMLAssertion\":{\
          \"shape\":\"SAMLAssertionType\",\
          \"documentation\":\"<p>The base-64 encoded SAML authentication response provided by the IdP.</p> <p>For more information, see <a href=\\\"https:
        },\
        \"PolicyArns\":{\
          \"shape\":\"policyDescriptorListType\",\
          \"documentation\":\"<p>The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as managed session policies. The policies must exist in the same account as the role.</p> <p>This parameter is optional. You can provide up to 10 managed policy ARNs. However, the plain text that you use for both inline and managed session policies can't exceed 2,048 characters. For more information about ARNs, see <a href=\\\"https:
        },\
        \"Policy\":{\
          \"shape\":\"sessionPolicyDocumentType\",\
          \"documentation\":\"<p>An IAM policy in JSON format that you want to use as an inline session policy.</p> <p>This parameter is optional. Passing policies to this operation returns new temporary credentials. The resulting session's permissions are the intersection of the role's identity-based policy and the session policies. You can use the role's temporary credentials in subsequent AWS API calls to access resources in the account that owns the role. You cannot use session policies to grant more permissions than those allowed by the identity-based policy of the role that is being assumed. For more information, see <a href=\\\"https:
        },\
        \"DurationSeconds\":{\
          \"shape\":\"roleDurationSecondsType\",\
          \"documentation\":\"<p>The duration, in seconds, of the role session. Your role session lasts for the duration that you specify for the <code>DurationSeconds</code> parameter, or until the time specified in the SAML authentication response's <code>SessionNotOnOrAfter</code> value, whichever is shorter. You can provide a <code>DurationSeconds</code> value from 900 seconds (15 minutes) up to the maximum session duration setting for the role. This setting can have a value from 1 hour to 12 hours. If you specify a value higher than this setting, the operation fails. For example, if you specify a session duration of 12 hours, but your administrator set the maximum session duration to 6 hours, your operation fails. To learn how to view the maximum value for your role, see <a href=\\\"https:
        }\
      }\
    },\
    \"AssumeRoleWithSAMLResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Credentials\":{\
          \"shape\":\"Credentials\",\
          \"documentation\":\"<p>The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.</p> <note> <p>The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.</p> </note>\"\
        },\
        \"AssumedRoleUser\":{\
          \"shape\":\"AssumedRoleUser\",\
          \"documentation\":\"<p>The identifiers for the temporary security credentials that the operation returns.</p>\"\
        },\
        \"PackedPolicySize\":{\
          \"shape\":\"nonNegativeIntegerType\",\
          \"documentation\":\"<p>A percentage value that indicates the packed size of the session policies and session tags combined passed in the request. The request fails if the packed size is greater than 100 percent, which means the policies and tags exceeded the allowed space.</p>\"\
        },\
        \"Subject\":{\
          \"shape\":\"Subject\",\
          \"documentation\":\"<p>The value of the <code>NameID</code> element in the <code>Subject</code> element of the SAML assertion.</p>\"\
        },\
        \"SubjectType\":{\
          \"shape\":\"SubjectType\",\
          \"documentation\":\"<p> The format of the name ID, as defined by the <code>Format</code> attribute in the <code>NameID</code> element of the SAML assertion. Typical examples of the format are <code>transient</code> or <code>persistent</code>. </p> <p> If the format includes the prefix <code>urn:oasis:names:tc:SAML:2.0:nameid-format</code>, that prefix is removed. For example, <code>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</code> is returned as <code>transient</code>. If the format includes any other prefix, the format is returned with no modifications.</p>\"\
        },\
        \"Issuer\":{\
          \"shape\":\"Issuer\",\
          \"documentation\":\"<p>The value of the <code>Issuer</code> element of the SAML assertion.</p>\"\
        },\
        \"Audience\":{\
          \"shape\":\"Audience\",\
          \"documentation\":\"<p> The value of the <code>Recipient</code> attribute of the <code>SubjectConfirmationData</code> element of the SAML assertion. </p>\"\
        },\
        \"NameQualifier\":{\
          \"shape\":\"NameQualifier\",\
          \"documentation\":\"<p>A hash value based on the concatenation of the <code>Issuer</code> response value, the AWS account ID, and the friendly name (the last part of the ARN) of the SAML provider in IAM. The combination of <code>NameQualifier</code> and <code>Subject</code> can be used to uniquely identify a federated user. </p> <p>The following pseudocode shows how the hash value is calculated:</p> <p> <code>BASE64 ( SHA1 ( \\\"https:
        }\
      },\
      \"documentation\":\"<p>Contains the response to a successful <a>AssumeRoleWithSAML</a> request, including temporary AWS credentials that can be used to make AWS requests. </p>\"\
    },\
    \"AssumeRoleWithWebIdentityRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"RoleArn\",\
        \"RoleSessionName\",\
        \"WebIdentityToken\"\
      ],\
      \"members\":{\
        \"RoleArn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the role that the caller is assuming.</p>\"\
        },\
        \"RoleSessionName\":{\
          \"shape\":\"roleSessionNameType\",\
          \"documentation\":\"<p>An identifier for the assumed role session. Typically, you pass the name or identifier that is associated with the user who is using your application. That way, the temporary security credentials that your application will use are associated with that user. This session name is included as part of the ARN and assumed role ID in the <code>AssumedRoleUser</code> response element.</p> <p>The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-</p>\"\
        },\
        \"WebIdentityToken\":{\
          \"shape\":\"clientTokenType\",\
          \"documentation\":\"<p>The OAuth 2.0 access token or OpenID Connect ID token that is provided by the identity provider. Your application must get this token by authenticating the user who is using your application with a web identity provider before the application makes an <code>AssumeRoleWithWebIdentity</code> call. </p>\"\
        },\
        \"ProviderId\":{\
          \"shape\":\"urlType\",\
          \"documentation\":\"<p>The fully qualified host component of the domain name of the identity provider.</p> <p>Specify this value only for OAuth 2.0 access tokens. Currently <code>www.amazon.com</code> and <code>graph.facebook.com</code> are the only supported identity providers for OAuth 2.0 access tokens. Do not include URL schemes and port numbers.</p> <p>Do not specify this value for OpenID Connect ID tokens.</p>\"\
        },\
        \"PolicyArns\":{\
          \"shape\":\"policyDescriptorListType\",\
          \"documentation\":\"<p>The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as managed session policies. The policies must exist in the same account as the role.</p> <p>This parameter is optional. You can provide up to 10 managed policy ARNs. However, the plain text that you use for both inline and managed session policies can't exceed 2,048 characters. For more information about ARNs, see <a href=\\\"https:
        },\
        \"Policy\":{\
          \"shape\":\"sessionPolicyDocumentType\",\
          \"documentation\":\"<p>An IAM policy in JSON format that you want to use as an inline session policy.</p> <p>This parameter is optional. Passing policies to this operation returns new temporary credentials. The resulting session's permissions are the intersection of the role's identity-based policy and the session policies. You can use the role's temporary credentials in subsequent AWS API calls to access resources in the account that owns the role. You cannot use session policies to grant more permissions than those allowed by the identity-based policy of the role that is being assumed. For more information, see <a href=\\\"https:
        },\
        \"DurationSeconds\":{\
          \"shape\":\"roleDurationSecondsType\",\
          \"documentation\":\"<p>The duration, in seconds, of the role session. The value can range from 900 seconds (15 minutes) up to the maximum session duration setting for the role. This setting can have a value from 1 hour to 12 hours. If you specify a value higher than this setting, the operation fails. For example, if you specify a session duration of 12 hours, but your administrator set the maximum session duration to 6 hours, your operation fails. To learn how to view the maximum value for your role, see <a href=\\\"https:
        }\
      }\
    },\
    \"AssumeRoleWithWebIdentityResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Credentials\":{\
          \"shape\":\"Credentials\",\
          \"documentation\":\"<p>The temporary security credentials, which include an access key ID, a secret access key, and a security token.</p> <note> <p>The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.</p> </note>\"\
        },\
        \"SubjectFromWebIdentityToken\":{\
          \"shape\":\"webIdentitySubjectType\",\
          \"documentation\":\"<p>The unique user identifier that is returned by the identity provider. This identifier is associated with the <code>WebIdentityToken</code> that was submitted with the <code>AssumeRoleWithWebIdentity</code> call. The identifier is typically unique to the user and the application that acquired the <code>WebIdentityToken</code> (pairwise identifier). For OpenID Connect ID tokens, this field contains the value returned by the identity provider as the token's <code>sub</code> (Subject) claim. </p>\"\
        },\
        \"AssumedRoleUser\":{\
          \"shape\":\"AssumedRoleUser\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) and the assumed role ID, which are identifiers that you can use to refer to the resulting temporary security credentials. For example, you can reference these credentials as a principal in a resource-based policy by using the ARN or assumed role ID. The ARN and ID include the <code>RoleSessionName</code> that you specified when you called <code>AssumeRole</code>. </p>\"\
        },\
        \"PackedPolicySize\":{\
          \"shape\":\"nonNegativeIntegerType\",\
          \"documentation\":\"<p>A percentage value that indicates the packed size of the session policies and session tags combined passed in the request. The request fails if the packed size is greater than 100 percent, which means the policies and tags exceeded the allowed space.</p>\"\
        },\
        \"Provider\":{\
          \"shape\":\"Issuer\",\
          \"documentation\":\"<p> The issuing authority of the web identity token presented. For OpenID Connect ID tokens, this contains the value of the <code>iss</code> field. For OAuth 2.0 access tokens, this contains the value of the <code>ProviderId</code> parameter that was passed in the <code>AssumeRoleWithWebIdentity</code> request.</p>\"\
        },\
        \"Audience\":{\
          \"shape\":\"Audience\",\
          \"documentation\":\"<p>The intended audience (also known as client ID) of the web identity token. This is traditionally the client identifier issued to the application that requested the web identity token.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the response to a successful <a>AssumeRoleWithWebIdentity</a> request, including temporary AWS credentials that can be used to make AWS requests. </p>\"\
    },\
    \"AssumedRoleUser\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"AssumedRoleId\",\
        \"Arn\"\
      ],\
      \"members\":{\
        \"AssumedRoleId\":{\
          \"shape\":\"assumedRoleIdType\",\
          \"documentation\":\"<p>A unique identifier that contains the role ID and the role session name of the role that is being assumed. The role ID is generated by AWS when the role is created.</p>\"\
        },\
        \"Arn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The ARN of the temporary security credentials that are returned from the <a>AssumeRole</a> action. For more information about ARNs and how to use them in policies, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>The identifiers for the temporary security credentials that the operation returns.</p>\"\
    },\
    \"Audience\":{\"type\":\"string\"},\
    \"Credentials\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"AccessKeyId\",\
        \"SecretAccessKey\",\
        \"SessionToken\",\
        \"Expiration\"\
      ],\
      \"members\":{\
        \"AccessKeyId\":{\
          \"shape\":\"accessKeyIdType\",\
          \"documentation\":\"<p>The access key ID that identifies the temporary security credentials.</p>\"\
        },\
        \"SecretAccessKey\":{\
          \"shape\":\"accessKeySecretType\",\
          \"documentation\":\"<p>The secret access key that can be used to sign requests.</p>\"\
        },\
        \"SessionToken\":{\
          \"shape\":\"tokenType\",\
          \"documentation\":\"<p>The token that users must pass to the service API to use the temporary credentials.</p>\"\
        },\
        \"Expiration\":{\
          \"shape\":\"dateType\",\
          \"documentation\":\"<p>The date on which the current credentials expire.</p>\"\
        }\
      },\
      \"documentation\":\"<p>AWS credentials for API authentication.</p>\"\
    },\
    \"DecodeAuthorizationMessageRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"EncodedMessage\"],\
      \"members\":{\
        \"EncodedMessage\":{\
          \"shape\":\"encodedMessageType\",\
          \"documentation\":\"<p>The encoded message that was returned with the response.</p>\"\
        }\
      }\
    },\
    \"DecodeAuthorizationMessageResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DecodedMessage\":{\
          \"shape\":\"decodedMessageType\",\
          \"documentation\":\"<p>An XML document that contains the decoded message.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A document that contains additional information about the authorization status of a request from an encoded message that is returned in response to an AWS request.</p>\"\
    },\
    \"ExpiredTokenException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"expiredIdentityTokenMessage\"}\
      },\
      \"documentation\":\"<p>The web identity token that was passed is expired or is not valid. Get a new identity token from the identity provider and then retry the request.</p>\",\
      \"error\":{\
        \"code\":\"ExpiredTokenException\",\
        \"httpStatusCode\":400,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"FederatedUser\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"FederatedUserId\",\
        \"Arn\"\
      ],\
      \"members\":{\
        \"FederatedUserId\":{\
          \"shape\":\"federatedIdType\",\
          \"documentation\":\"<p>The string that identifies the federated user associated with the credentials, similar to the unique ID of an IAM user.</p>\"\
        },\
        \"Arn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The ARN that specifies the federated user that is associated with the credentials. For more information about ARNs and how to use them in policies, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>Identifiers for the federated user that is associated with the credentials.</p>\"\
    },\
    \"GetAccessKeyInfoRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"AccessKeyId\"],\
      \"members\":{\
        \"AccessKeyId\":{\
          \"shape\":\"accessKeyIdType\",\
          \"documentation\":\"<p>The identifier of an access key.</p> <p>This parameter allows (through its regex pattern) a string of characters that can consist of any upper- or lowercase letter or digit.</p>\"\
        }\
      }\
    },\
    \"GetAccessKeyInfoResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Account\":{\
          \"shape\":\"accountType\",\
          \"documentation\":\"<p>The number used to identify the AWS account.</p>\"\
        }\
      }\
    },\
    \"GetCallerIdentityRequest\":{\
      \"type\":\"structure\",\
      \"members\":{\
      }\
    },\
    \"GetCallerIdentityResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"UserId\":{\
          \"shape\":\"userIdType\",\
          \"documentation\":\"<p>The unique identifier of the calling entity. The exact value depends on the type of entity that is making the call. The values returned are those listed in the <b>aws:userid</b> column in the <a href=\\\"https:
        },\
        \"Account\":{\
          \"shape\":\"accountType\",\
          \"documentation\":\"<p>The AWS account ID number of the account that owns or contains the calling entity.</p>\"\
        },\
        \"Arn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The AWS ARN associated with the calling entity.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the response to a successful <a>GetCallerIdentity</a> request, including information about the entity making the request.</p>\"\
    },\
    \"GetFederationTokenRequest\":{\
      \"type\":\"structure\",\
      \"required\":[\"Name\"],\
      \"members\":{\
        \"Name\":{\
          \"shape\":\"userNameType\",\
          \"documentation\":\"<p>The name of the federated user. The name is used as an identifier for the temporary security credentials (such as <code>Bob</code>). For example, you can reference the federated user name in a resource-based policy, such as in an Amazon S3 bucket policy.</p> <p>The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-</p>\"\
        },\
        \"Policy\":{\
          \"shape\":\"sessionPolicyDocumentType\",\
          \"documentation\":\"<p>An IAM policy in JSON format that you want to use as an inline session policy.</p> <p>You must pass an inline or managed <a href=\\\"https:
        },\
        \"PolicyArns\":{\
          \"shape\":\"policyDescriptorListType\",\
          \"documentation\":\"<p>The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as a managed session policy. The policies must exist in the same account as the IAM user that is requesting federated access.</p> <p>You must pass an inline or managed <a href=\\\"https:
        },\
        \"DurationSeconds\":{\
          \"shape\":\"durationSecondsType\",\
          \"documentation\":\"<p>The duration, in seconds, that the session should last. Acceptable durations for federation sessions range from 900 seconds (15 minutes) to 129,600 seconds (36 hours), with 43,200 seconds (12 hours) as the default. Sessions obtained using AWS account root user credentials are restricted to a maximum of 3,600 seconds (one hour). If the specified duration is longer than one hour, the session obtained by using root user credentials defaults to one hour.</p>\"\
        },\
        \"Tags\":{\
          \"shape\":\"tagListType\",\
          \"documentation\":\"<p>A list of session tags. Each session tag consists of a key name and an associated value. For more information about session tags, see <a href=\\\"https:
        }\
      }\
    },\
    \"GetFederationTokenResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Credentials\":{\
          \"shape\":\"Credentials\",\
          \"documentation\":\"<p>The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.</p> <note> <p>The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.</p> </note>\"\
        },\
        \"FederatedUser\":{\
          \"shape\":\"FederatedUser\",\
          \"documentation\":\"<p>Identifiers for the federated user associated with the credentials (such as <code>arn:aws:sts::123456789012:federated-user/Bob</code> or <code>123456789012:Bob</code>). You can use the federated user's ARN in your resource-based policies, such as an Amazon S3 bucket policy. </p>\"\
        },\
        \"PackedPolicySize\":{\
          \"shape\":\"nonNegativeIntegerType\",\
          \"documentation\":\"<p>A percentage value that indicates the packed size of the session policies and session tags combined passed in the request. The request fails if the packed size is greater than 100 percent, which means the policies and tags exceeded the allowed space.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the response to a successful <a>GetFederationToken</a> request, including temporary AWS credentials that can be used to make AWS requests. </p>\"\
    },\
    \"GetSessionTokenRequest\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"DurationSeconds\":{\
          \"shape\":\"durationSecondsType\",\
          \"documentation\":\"<p>The duration, in seconds, that the credentials should remain valid. Acceptable durations for IAM user sessions range from 900 seconds (15 minutes) to 129,600 seconds (36 hours), with 43,200 seconds (12 hours) as the default. Sessions for AWS account owners are restricted to a maximum of 3,600 seconds (one hour). If the duration is longer than one hour, the session for AWS account owners defaults to one hour.</p>\"\
        },\
        \"SerialNumber\":{\
          \"shape\":\"serialNumberType\",\
          \"documentation\":\"<p>The identification number of the MFA device that is associated with the IAM user who is making the <code>GetSessionToken</code> call. Specify this value if the IAM user has a policy that requires MFA authentication. The value is either the serial number for a hardware device (such as <code>GAHT12345678</code>) or an Amazon Resource Name (ARN) for a virtual device (such as <code>arn:aws:iam::123456789012:mfa/user</code>). You can find the device for an IAM user by going to the AWS Management Console and viewing the user's security credentials. </p> <p>The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@:/-</p>\"\
        },\
        \"TokenCode\":{\
          \"shape\":\"tokenCodeType\",\
          \"documentation\":\"<p>The value provided by the MFA device, if MFA is required. If any policy requires the IAM user to submit an MFA code, specify this value. If MFA authentication is required, the user must provide a code when requesting a set of temporary security credentials. A user who fails to provide the code receives an \\\"access denied\\\" response when requesting resources that require MFA authentication.</p> <p>The format for this parameter, as described by its regex pattern, is a sequence of six numeric digits.</p>\"\
        }\
      }\
    },\
    \"GetSessionTokenResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Credentials\":{\
          \"shape\":\"Credentials\",\
          \"documentation\":\"<p>The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.</p> <note> <p>The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.</p> </note>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the response to a successful <a>GetSessionToken</a> request, including temporary AWS credentials that can be used to make AWS requests. </p>\"\
    },\
    \"IDPCommunicationErrorException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"idpCommunicationErrorMessage\"}\
      },\
      \"documentation\":\"<p>The request could not be fulfilled because the identity provider (IDP) that was asked to verify the incoming identity token could not be reached. This is often a transient error caused by network conditions. Retry the request a limited number of times so that you don't exceed the request rate. If the error persists, the identity provider might be down or not responding.</p>\",\
      \"error\":{\
        \"code\":\"IDPCommunicationError\",\
        \"httpStatusCode\":400,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"IDPRejectedClaimException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"idpRejectedClaimMessage\"}\
      },\
      \"documentation\":\"<p>The identity provider (IdP) reported that authentication failed. This might be because the claim is invalid.</p> <p>If this error is returned for the <code>AssumeRoleWithWebIdentity</code> operation, it can also mean that the claim has expired or has been explicitly revoked. </p>\",\
      \"error\":{\
        \"code\":\"IDPRejectedClaim\",\
        \"httpStatusCode\":403,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"InvalidAuthorizationMessageException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"invalidAuthorizationMessage\"}\
      },\
      \"documentation\":\"<p>The error returned if the message passed to <code>DecodeAuthorizationMessage</code> was invalid. This can happen if the token contains invalid characters, such as linebreaks. </p>\",\
      \"error\":{\
        \"code\":\"InvalidAuthorizationMessageException\",\
        \"httpStatusCode\":400,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"InvalidIdentityTokenException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"invalidIdentityTokenMessage\"}\
      },\
      \"documentation\":\"<p>The web identity token that was passed could not be validated by AWS. Get a new identity token from the identity provider and then retry the request.</p>\",\
      \"error\":{\
        \"code\":\"InvalidIdentityToken\",\
        \"httpStatusCode\":400,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"Issuer\":{\"type\":\"string\"},\
    \"MalformedPolicyDocumentException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"malformedPolicyDocumentMessage\"}\
      },\
      \"documentation\":\"<p>The request was rejected because the policy document was malformed. The error message describes the specific error.</p>\",\
      \"error\":{\
        \"code\":\"MalformedPolicyDocument\",\
        \"httpStatusCode\":400,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"NameQualifier\":{\"type\":\"string\"},\
    \"PackedPolicyTooLargeException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"packedPolicyTooLargeMessage\"}\
      },\
      \"documentation\":\"<p>The request was rejected because the total packed size of the session policies and session tags combined was too large. An AWS conversion compresses the session policy document, session policy ARNs, and session tags into a packed binary format that has a separate limit. The error message indicates by percentage how close the policies and tags are to the upper size limit. For more information, see <a href=\\\"https:
      \"error\":{\
        \"code\":\"PackedPolicyTooLarge\",\
        \"httpStatusCode\":400,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"PolicyDescriptorType\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"arn\":{\
          \"shape\":\"arnType\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the IAM managed policy to use as a session policy for the role. For more information about ARNs, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>A reference to the IAM managed policy that is passed as a session policy for a role session or a federated user session.</p>\"\
    },\
    \"RegionDisabledException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\"shape\":\"regionDisabledMessage\"}\
      },\
      \"documentation\":\"<p>STS is not activated in the requested region for the account that is being asked to generate credentials. The account administrator must use the IAM console to activate STS in that region. For more information, see <a href=\\\"https:
      \"error\":{\
        \"code\":\"RegionDisabledException\",\
        \"httpStatusCode\":403,\
        \"senderFault\":true\
      },\
      \"exception\":true\
    },\
    \"SAMLAssertionType\":{\
      \"type\":\"string\",\
      \"max\":100000,\
      \"min\":4\
    },\
    \"Subject\":{\"type\":\"string\"},\
    \"SubjectType\":{\"type\":\"string\"},\
    \"Tag\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Key\",\
        \"Value\"\
      ],\
      \"members\":{\
        \"Key\":{\
          \"shape\":\"tagKeyType\",\
          \"documentation\":\"<p>The key for a session tag.</p> <p>You can pass up to 50 session tags. The plain text session tag keys canât exceed 128 characters. For these and additional limits, see <a href=\\\"https:
        },\
        \"Value\":{\
          \"shape\":\"tagValueType\",\
          \"documentation\":\"<p>The value for a session tag.</p> <p>You can pass up to 50 session tags. The plain text session tag values canât exceed 256 characters. For these and additional limits, see <a href=\\\"https:
        }\
      },\
      \"documentation\":\"<p>You can pass custom key-value pair attributes when you assume a role or federate a user. These are called session tags. You can then use the session tags to control access to resources. For more information, see <a href=\\\"https:
    },\
    \"accessKeyIdType\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":16,\
      \"pattern\":\"[\\\\w]*\"\
    },\
    \"accessKeySecretType\":{\"type\":\"string\"},\
    \"accountType\":{\"type\":\"string\"},\
    \"arnType\":{\
      \"type\":\"string\",\
      \"max\":2048,\
      \"min\":20,\
      \"pattern\":\"[\\\\u0009\\\\u000A\\\\u000D\\\\u0020-\\\\u007E\\\\u0085\\\\u00A0-\\\\uD7FF\\\\uE000-\\\\uFFFD\\\\u10000-\\\\u10FFFF]+\"\
    },\
    \"assumedRoleIdType\":{\
      \"type\":\"string\",\
      \"max\":193,\
      \"min\":2,\
      \"pattern\":\"[\\\\w+=,.@:-]*\"\
    },\
    \"clientTokenType\":{\
      \"type\":\"string\",\
      \"max\":2048,\
      \"min\":4\
    },\
    \"dateType\":{\"type\":\"timestamp\"},\
    \"decodedMessageType\":{\"type\":\"string\"},\
    \"durationSecondsType\":{\
      \"type\":\"integer\",\
      \"max\":129600,\
      \"min\":900\
    },\
    \"encodedMessageType\":{\
      \"type\":\"string\",\
      \"max\":10240,\
      \"min\":1\
    },\
    \"expiredIdentityTokenMessage\":{\"type\":\"string\"},\
    \"externalIdType\":{\
      \"type\":\"string\",\
      \"max\":1224,\
      \"min\":2,\
      \"pattern\":\"[\\\\w+=,.@:\\\\/-]*\"\
    },\
    \"federatedIdType\":{\
      \"type\":\"string\",\
      \"max\":193,\
      \"min\":2,\
      \"pattern\":\"[\\\\w+=,.@\\\\:-]*\"\
    },\
    \"idpCommunicationErrorMessage\":{\"type\":\"string\"},\
    \"idpRejectedClaimMessage\":{\"type\":\"string\"},\
    \"invalidAuthorizationMessage\":{\"type\":\"string\"},\
    \"invalidIdentityTokenMessage\":{\"type\":\"string\"},\
    \"malformedPolicyDocumentMessage\":{\"type\":\"string\"},\
    \"nonNegativeIntegerType\":{\
      \"type\":\"integer\",\
      \"min\":0\
    },\
    \"packedPolicyTooLargeMessage\":{\"type\":\"string\"},\
    \"policyDescriptorListType\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"PolicyDescriptorType\"}\
    },\
    \"regionDisabledMessage\":{\"type\":\"string\"},\
    \"roleDurationSecondsType\":{\
      \"type\":\"integer\",\
      \"max\":43200,\
      \"min\":900\
    },\
    \"roleSessionNameType\":{\
      \"type\":\"string\",\
      \"max\":64,\
      \"min\":2,\
      \"pattern\":\"[\\\\w+=,.@-]*\"\
    },\
    \"serialNumberType\":{\
      \"type\":\"string\",\
      \"max\":256,\
      \"min\":9,\
      \"pattern\":\"[\\\\w+=/:,.@-]*\"\
    },\
    \"sessionPolicyDocumentType\":{\
      \"type\":\"string\",\
      \"max\":2048,\
      \"min\":1,\
      \"pattern\":\"[\\\\u0009\\\\u000A\\\\u000D\\\\u0020-\\\\u00FF]+\"\
    },\
    \"tagKeyListType\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"tagKeyType\"},\
      \"max\":50\
    },\
    \"tagKeyType\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"[\\\\p{L}\\\\p{Z}\\\\p{N}_.:/=+\\\\-@]+\"\
    },\
    \"tagListType\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Tag\"},\
      \"max\":50\
    },\
    \"tagValueType\":{\
      \"type\":\"string\",\
      \"max\":256,\
      \"min\":0,\
      \"pattern\":\"[\\\\p{L}\\\\p{Z}\\\\p{N}_.:/=+\\\\-@]*\"\
    },\
    \"tokenCodeType\":{\
      \"type\":\"string\",\
      \"max\":6,\
      \"min\":6,\
      \"pattern\":\"[\\\\d]*\"\
    },\
    \"tokenType\":{\"type\":\"string\"},\
    \"urlType\":{\
      \"type\":\"string\",\
      \"max\":2048,\
      \"min\":4\
    },\
    \"userIdType\":{\"type\":\"string\"},\
    \"userNameType\":{\
      \"type\":\"string\",\
      \"max\":32,\
      \"min\":2,\
      \"pattern\":\"[\\\\w+=,.@-]*\"\
    },\
    \"webIdentitySubjectType\":{\
      \"type\":\"string\",\
      \"max\":255,\
      \"min\":6\
    }\
  },\
  \"documentation\":\"<fullname>AWS Security Token Service</fullname> <p>AWS Security Token Service (STS) enables you to request temporary, limited-privilege credentials for AWS Identity and Access Management (IAM) users or for users that you authenticate (federated users). This guide provides descriptions of the STS API. For more information about using this service, see <a href=\\\"https:
}\
";
}
@end