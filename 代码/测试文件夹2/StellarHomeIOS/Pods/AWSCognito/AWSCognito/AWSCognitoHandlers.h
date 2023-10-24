#import <Foundation/Foundation.h>
@class AWSCognitoResolvedConflict;
@class AWSCognitoConflict;
typedef BOOL (^AWSCognitoDatasetDeletedHandler)(NSString *datasetName);
typedef void (^AWSCognitoDatasetMergedHandler)(NSString *datasetName, NSArray *datasets);
typedef AWSCognitoResolvedConflict* (^AWSCognitoRecordConflictHandler)(NSString *datasetName, AWSCognitoConflict *conflict);