#import <Foundation/Foundation.h>
#import "AWSCognitoHandlers.h"
@class AWSCognitoRecord;
@class AWSTask;
@interface AWSCognitoDatasetMetadata : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSNumber *lastSyncCount;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSNumber *dataStorage;
@property (nonatomic, readonly) NSString *lastModifiedBy;
@property (nonatomic, readonly) NSDate *lastModifiedDate;
@property (nonatomic, readonly) NSNumber *numRecords;
- (BOOL)isDeleted;
@end
@interface AWSCognitoDataset : AWSCognitoDatasetMetadata
@property (nonatomic, copy) AWSCognitoRecordConflictHandler conflictHandler;
@property (nonatomic, copy) AWSCognitoDatasetDeletedHandler datasetDeletedHandler;
@property (nonatomic, copy) AWSCognitoDatasetMergedHandler datasetMergedHandler;
@property (nonatomic, assign) uint32_t synchronizeRetries;
@property (nonatomic, assign) BOOL synchronizeOnWiFiOnly;
- (void)setString:(NSString *) aString forKey:(NSString *) aKey;
- (NSString *)stringForKey:(NSString *) aKey;
- (AWSTask *)synchronize;
- (AWSTask *)synchronizeOnConnectivity;
- (AWSTask *)subscribe;
- (AWSTask *)unsubscribe;
- (NSArray<AWSCognitoRecord *> *)getAllRecords;
- (NSDictionary<NSString *, NSString *> *)getAll;
- (void)removeObjectForKey:(NSString *) aKey;
- (AWSCognitoRecord *)recordForKey:(NSString *) aKey;
- (void) clear;
- (long) size;
- (long) sizeForKey:(NSString *) aKey;
@end