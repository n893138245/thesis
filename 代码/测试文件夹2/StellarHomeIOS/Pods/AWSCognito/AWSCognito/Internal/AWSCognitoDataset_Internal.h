#import "AWSCognitoDataset.h"
@class AWSCognitoSync;
@interface AWSCognitoDatasetMetadata()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *lastSyncCount;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSNumber *dataStorage;
@property (nonatomic, strong) NSString *lastModifiedBy;
@property (nonatomic, strong) NSDate *lastModifiedDate;
@property (nonatomic, strong) NSNumber *numRecords;
@end
@interface AWSCognitoDataset()
- (instancetype)initWithDatasetName:(NSString *)datasetName
                      sqliteManager:(AWSCognitoSQLiteManager *)sqliteManager
                     cognitoService:(AWSCognitoSync *)cognitoService;
@end