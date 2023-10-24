#import "AWSCognitoDataset.h"
#import "AWSCognitoUtil.h"
#import "AWSCognitoConstants.h"
#import "AWSCognitoService.h"
#import "AWSCognitoRecord_Internal.h"
#import "AWSCognitoSQLiteManager.h"
#import "AWSCognitoConflict_Internal.h"
#import <AWSCore/AWSCocoaLumberjack.h>
#import "AWSCognitoRecord.h"
#import "AWSKSReachability.h"
@interface AWSCognitoDatasetMetadata()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *lastSyncCount;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSNumber *dataStorage;
@property (nonatomic, strong) NSString *lastModifiedBy;
@property (nonatomic, strong) NSDate *lastModifiedDate;
@property (nonatomic, strong) NSNumber *numRecords;
@end
@implementation AWSCognitoDatasetMetadata
-(id)initWithDatasetName:(NSString *) datasetName dataSource:(AWSCognitoSQLiteManager *)manager {
    [manager initializeDatasetTables:datasetName];
    if (self = [super init]) {
        _name = datasetName;
        [manager loadDatasetMetadata:self error:nil];
    }
    return self;
}
- (BOOL)isDeleted {
    return [self.lastSyncCount intValue] == -1;
}
@end
@interface AWSCognitoDataset()
@property (nonatomic, strong) NSString *syncSessionToken;
@property (nonatomic, strong) AWSCognitoSQLiteManager *sqliteManager;
@property (nonatomic, strong) AWSCognitoSync *cognitoService;
@property (nonatomic, strong) AWSKSReachability *reachability;
@property (nonatomic, strong) NSNumber *currentSyncCount;
@property (nonatomic, strong) NSDictionary *records;
@property (nonatomic, strong) dispatch_semaphore_t synchronizeQueue;
@property (nonatomic, strong) dispatch_semaphore_t serializer;
@end
@implementation AWSCognitoDataset
-(id)initWithDatasetName:(NSString *) datasetName
           sqliteManager:(AWSCognitoSQLiteManager *)sqliteManager
          cognitoService:(AWSCognitoSync *)cognitoService {
    if(self = [super initWithDatasetName:datasetName dataSource:sqliteManager]) {
        _sqliteManager = sqliteManager;
        _cognitoService = cognitoService;
        _reachability = [AWSKSReachability reachabilityToHost:[cognitoService.configuration.endpoint.URL host]];
        _synchronizeQueue = dispatch_semaphore_create(2l);
        _serializer = dispatch_semaphore_create(1l);
    }
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - CRUD operations
- (NSString *)stringForKey:(NSString *)aKey
{
    NSString *string = nil;
    NSError *error = nil;
    AWSCognitoRecord *record = [self getRecordById:aKey error:&error];
    if(error || (!record.data.string))
    {
        AWSDDLogDebug(@"Error: %@", error);
    }
    if (record != nil && ![record isDeleted]) {
        string = record.data.string;
    }
    return string;
}
- (void)setString:(NSString *)aString forKey:(NSString *)aKey
{
    AWSCognitoRecordValue *data = [[AWSCognitoRecordValue alloc] initWithString:aString];
    AWSCognitoRecord *record = [self recordForKey:aKey];
    if (record == nil) {
        record = [[AWSCognitoRecord alloc] initWithId:aKey data:data];
    }
    else {
        record.data = data;
    }
    if([self sizeForRecord:record] > AWSCognitoMaxDatasetSize){
        AWSDDLogDebug(@"Error: Record would exceed max dataset size");
        return;
    }
    if([self sizeForString:aKey] > AWSCognitoMaxKeySize){
        AWSDDLogDebug(@"Error: Key size too large, max is %d bytes", AWSCognitoMaxKeySize);
        return;
    }
    if([self sizeForString:aKey] < AWSCognitoMinKeySize){
        AWSDDLogDebug(@"Error: Key size too small, min is %d byte", AWSCognitoMinKeySize);
        return;
    }
    if([self sizeForString:aString] > AWSCognitoMaxDatasetSize){
        AWSDDLogDebug(@"Error: Value size too large, max is %d bytes", AWSCognitoMaxRecordValueSize);
        return;
    }
    int numRecords = [[self.sqliteManager numRecords:self.name] intValue];
    if(numRecords == AWSCognitoMaxNumRecords && !([self recordForKey:aKey] == nil)){
        AWSDDLogDebug(@"Error: Too many records, max is %d", AWSCognitoMaxNumRecords);
        return;
    }
    NSError *error = nil;
    if(![self putRecord:record error:&error])
    {
        AWSDDLogDebug(@"Error: %@", error);
    }
}
- (BOOL)putRecord:(AWSCognitoRecord *)record error:(NSError **)error
{
    if(record == nil || record.data == nil || record.recordId == nil)
    {
        if(error != nil)
        {
            *error = [AWSCognitoUtil errorIllegalArgument:@""];
        }
        return NO;
    }
    BOOL result = [self.sqliteManager putRecord:record datasetName:self.name error:error];
    if(result){
        self.lastModifiedDate = record.lastModified;
    }
    return result;
}
- (AWSCognitoRecord *)recordForKey: (NSString *)aKey
{
    NSError *error = nil;
    AWSCognitoRecord * result = [self getRecordById:aKey error:&error];
    if(!result)
    {
        AWSDDLogDebug(@"Error: %@", error);
    }
    return result;
}
- (AWSCognitoRecord *)getRecordById:(NSString *)recordId error:(NSError **)error
{
    if(recordId == nil)
    {
        if(error != nil)
        {
            *error = [AWSCognitoUtil errorIllegalArgument:@""];
        }
        return nil;
    }
    AWSCognitoRecord *fetchedRecord = [self.sqliteManager getRecordById:recordId
                                                     datasetName:(NSString *)self.name
                                                           error:error];
    return fetchedRecord;
}
- (BOOL)removeRecordById:(NSString *)recordId error:(NSError **)error
{
    if(recordId == nil)
    {
        if(error != nil)
        {
            *error = [AWSCognitoUtil errorIllegalArgument:@""];
        }
        return NO;
    }
    BOOL result = [self.sqliteManager flagRecordAsDeletedById:recordId
                                                  datasetName:(NSString *)self.name
                                                        error:error];
    if(result){
        self.lastModifiedDate = [NSDate date];
    }
    return result;
}
- (NSArray<AWSCognitoRecord *> *)getAllRecords
{
    NSArray *allRecords = nil;
    allRecords = [self.sqliteManager allRecords:self.name];
    return allRecords;
}
- (NSDictionary<NSString *, NSString *> *)getAll
{
    NSArray *allRecords = nil;
    NSMutableDictionary *recordsAsDictionary = [NSMutableDictionary dictionary];
    allRecords = [self.sqliteManager allRecords:self.name];
    for (AWSCognitoRecord *record in allRecords) {
        if ([record isDeleted]) {
            continue;
        }
        [recordsAsDictionary setObject:record.data.string forKey:record.recordId];
    }
    return recordsAsDictionary;
}
- (void)removeObjectForKey:(NSString *)aKey
{
    NSError *error = nil;
    if(![self removeRecordById:aKey error:&error])
    {
        AWSDDLogDebug(@"Error: %@", error);
    }
}
- (void)clear
{
    NSError *error = nil;
    if(![self.sqliteManager deleteDataset:self.name error:&error])
    {
        AWSDDLogDebug(@"Error: %@", error);
    }
    else {
        self.lastSyncCount = [NSNumber numberWithInt:-1];
        self.lastModifiedDate = [NSDate date];
    }
}
#pragma mark - Size operations
- (long) size {
    NSArray * allRecords = [self getAllRecords];
    long size = 0;
    if(allRecords != nil){
        for (AWSCognitoRecord *record in allRecords) {
            size += [self sizeForRecord:record];
        }
    }
    return size;
}
- (long) sizeForKey: (NSString *) aKey {
    return [self sizeForRecord:[self recordForKey:aKey]];
}
- (long) sizeForRecord:(AWSCognitoRecord *) aRecord {
    if(aRecord == nil){
        return 0;
    }
    long sizeOfKey = [self sizeForString:aRecord.recordId];
    if ([aRecord isDeleted]) {
        return sizeOfKey;
    }
    return sizeOfKey + [self sizeForString:aRecord.data.string];
}
- (long) sizeForString:(NSString *) aString{
    if(aString == nil){
        return 0;
    }
    return [aString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - Synchronize
- (AWSTask *)syncPull:(uint32_t)remainingAttempts {
    AWSCognitoSyncListRecordsRequest *request = [AWSCognitoSyncListRecordsRequest new];
    request.identityPoolId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityPoolId;
    request.identityId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityId;
    request.datasetName = self.name;
    request.lastSyncCount = self.currentSyncCount;
    request.syncSessionToken = self.syncSessionToken;
    self.lastSyncCount = self.currentSyncCount;
    return [[self.cognitoService listRecords:request] continueWithBlock:^id(AWSTask *task) {
        if (task.isCancelled) {
            NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTaskCanceled userInfo:nil];
            [self postDidFailToSynchronizeNotification:error];
            return [AWSTask taskWithError:error];
        }else if(task.error){
            AWSDDLogError(@"Unable to list records: %@", task.error);
            if(task.error.code == AWSCognitoSyncErrorInvalidParameter && self.currentSyncCount.longLongValue > 0
               && task.error.userInfo[@"NSLocalizedDescription"] && [task.error.userInfo[@"NSLocalizedDescription"] hasPrefix:@"No such SyncCount:"]){
                self.currentSyncCount = [NSNumber numberWithLongLong:self.currentSyncCount.longLongValue - 1];
                return [self syncPull:remainingAttempts-1];
            } else {
                return task;
            }
        }else {
            NSError *error = nil;
            NSMutableArray *conflicts = [NSMutableArray new];
            NSMutableArray *nonConflictRecords = [NSMutableArray new];
            NSMutableArray *existingRecords = [NSMutableArray new];
            NSMutableArray *changedRecordNames = [NSMutableArray new];
            AWSCognitoSyncListRecordsResponse *response = task.result;
            self.syncSessionToken = response.syncSessionToken;
            if ((self.lastSyncCount != 0 && ![response.datasetExists boolValue]) ||
                ([response.datasetDeletedAfterRequestedSyncCount boolValue])) {
                if (self.datasetDeletedHandler && !self.datasetDeletedHandler(self.name)) {
                    [self.sqliteManager deleteDataset:self.name error:nil];
                    if (![response.datasetExists boolValue]) {
                        [self.sqliteManager deleteMetadata:self.name error:nil];
                        return nil;
                    }
                }
                [self.sqliteManager resetSyncCount:self.name error:nil];
                self.lastSyncCount = 0;
                self.currentSyncCount = 0;
            }
            if (response.mergedDatasetNames && response.mergedDatasetNames.count > 0 && self.datasetMergedHandler) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.datasetMergedHandler(self.name, response.mergedDatasetNames);
                });
            }
            if(response.records){
                self.lastSyncCount = response.datasetSyncCount;
                for(AWSCognitoSyncRecord *record in response.records){
                    [existingRecords addObject:record.key];
                    [changedRecordNames addObject:record.key];
                    AWSCognitoRecord * existing = [self.sqliteManager getRecordById:record.key datasetName:self.name error:&error];
                    AWSCognitoRecordValueType recordType = AWSCognitoRecordValueTypeString;
                    if (record.value == nil) {
                        recordType = AWSCognitoRecordValueTypeDeleted;
                    }
                    AWSCognitoRecord * newRecord = [[AWSCognitoRecord alloc] initWithId:record.key data:[[AWSCognitoRecordValue alloc]initWithString:record.value type:recordType]];
                    newRecord.syncCount = [record.syncCount longLongValue];
                    newRecord.lastModifiedBy = record.lastModifiedBy;
                    newRecord.lastModified = record.lastModifiedDate;
                    if(newRecord.lastModifiedBy == nil){
                        newRecord.lastModifiedBy = @"Unknown";
                    }
                    if(!existing || existing.isDirty==NO || [existing.data.string isEqualToString:record.value]){
                        [nonConflictRecords addObject: [[AWSCognitoRecordTuple alloc] initWithLocalRecord:existing remoteRecord:newRecord]];
                    }
                    else{
                        AWSDDLogInfo(@"Record %@ is dirty with value: %@ and can't be overwritten, flagging for conflict resolution",existing.recordId,existing.data.string);
                        [conflicts addObject: [[AWSCognitoConflict alloc] initWithLocalRecord:existing remoteRecord:newRecord]];
                    }
                }
                NSMutableArray *resolvedConflicts = [NSMutableArray arrayWithCapacity:[conflicts count]];
                if([conflicts count] > 0){
                    if(self.conflictHandler == nil) {
                        self.conflictHandler = [AWSCognito defaultConflictHandler];
                    }
                    for (AWSCognitoConflict *conflict in conflicts) {
                        AWSCognitoResolvedConflict *resolved = self.conflictHandler(self.name,conflict);
                        if (resolved == nil) {
                            NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTaskCanceled userInfo:nil];
                            [self postDidFailToSynchronizeNotification:error];
                            return [AWSTask taskWithError:error];
                        }
                        [resolvedConflicts addObject:resolved];
                    }
                }
                if (nonConflictRecords.count > 0 || resolvedConflicts.count > 0) {
                    if([self.sqliteManager updateWithRemoteChanges:self.name nonConflicts:nonConflictRecords resolvedConflicts:resolvedConflicts error:&error]) {
                        [self postDidChangeLocalValueFromRemoteNotification:changedRecordNames];
                    }
                    else {
                        [self postDidFailToSynchronizeNotification:error];
                        return [AWSTask taskWithError:error];
                    }
                }
                if(self.currentSyncCount < self.lastSyncCount){
                    [self.sqliteManager updateLastSyncCount:self.name syncCount:self.lastSyncCount lastModifiedBy:response.lastModifiedBy];
                }
            }
        }
        return nil;
    }];
}
- (AWSTask *)syncPush:(uint32_t)remainingAttempts {
    NSMutableArray *patches = [NSMutableArray new];
    NSError *error = nil;
    self.records = [self.sqliteManager recordsUpdatedAfterLastSync:self.name error:&error];
    NSNumber* maxPatchSyncCount = [NSNumber numberWithLongLong:0L];
    for(AWSCognitoRecord *record in self.records.allValues){
        AWSCognitoSyncRecordPatch *patch = [AWSCognitoSyncRecordPatch new];
        patch.key = record.recordId;
        patch.syncCount = [NSNumber numberWithLongLong: record.syncCount];
        patch.value = record.data.string;
        patch.op = [record isDeleted]?AWSCognitoSyncOperationRemove : AWSCognitoSyncOperationReplace;
        [patches addObject:patch];
        if([patch.syncCount longLongValue] > [maxPatchSyncCount longLongValue]){
            maxPatchSyncCount = patch.syncCount;
        }
    }
    if([patches count] > 0){
        if([self size] > AWSCognitoMaxDatasetSize){
            NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorUserDataSizeLimitExceeded userInfo:nil];
            [self postDidFailToSynchronizeNotification:error];
            return [AWSTask taskWithError:error];
        }
        AWSCognitoSyncUpdateRecordsRequest *request = [AWSCognitoSyncUpdateRecordsRequest new];
        request.identityId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityId;
        request.identityPoolId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityPoolId;
        request.datasetName = self.name;
        request.recordPatches = patches;
        request.syncSessionToken = self.syncSessionToken;
        request.deviceId = [AWSCognito cognitoDeviceId];
        return [[self.cognitoService updateRecords:request] continueWithBlock:^id(AWSTask *task) {
            NSNumber * currentSyncCount = self.lastSyncCount;
            BOOL okToUpdateSyncCount = YES;
            if(task.isCancelled){
                NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTaskCanceled userInfo:nil];
                [self postDidFailToSynchronizeNotification:error];
                return [AWSTask taskWithError:error];
            }else if(task.error){
                if(task.error.code == AWSCognitoSyncErrorResourceConflict){
                    AWSDDLogInfo(@"Conflicts existed on update, restarting synchronize.");
                    if(currentSyncCount > maxPatchSyncCount) {
                        [self.sqliteManager updateLastSyncCount:self.name syncCount:maxPatchSyncCount lastModifiedBy:nil];
                    }
                    return [self synchronizeInternal:remainingAttempts-1];
                }
                else {
                    AWSDDLogError(@"An error occured attempting to update records: %@",task.error);
                }
                return task;
            }else{
                AWSCognitoSyncUpdateRecordsResponse * response = task.result;
                if(response.records) {
                    NSMutableArray *changedRecords = [NSMutableArray new];
                    NSMutableArray *changedRecordsNames = [NSMutableArray new];
                    NSNumber *maxSyncCount = [NSNumber numberWithLong:0];
                    for (AWSCognitoSyncRecord * record in response.records) {
                        [changedRecordsNames addObject:record.key];
                        AWSCognitoRecordValueType recordType = AWSCognitoRecordValueTypeString;
                        if (record.value == nil) {
                            recordType = AWSCognitoRecordValueTypeDeleted;
                        }
                        AWSCognitoRecord * newRecord = [[AWSCognitoRecord alloc] initWithId:record.key data:[[AWSCognitoRecordValue alloc]initWithString:record.value type:recordType]];
                        if(record.syncCount.longLongValue > currentSyncCount.longLongValue + 1){
                            okToUpdateSyncCount = NO;
                        }
                        if(record.syncCount.longLongValue > maxSyncCount.longLongValue) {
                            maxSyncCount = record.syncCount;
                        }
                        newRecord.syncCount = [record.syncCount longLongValue];
                        newRecord.dirtyCount = 0;
                        newRecord.lastModifiedBy = record.lastModifiedBy;
                        if(newRecord.lastModifiedBy == nil){
                            newRecord.lastModifiedBy = @"Unknown";
                        }
                        newRecord.lastModified = record.lastModifiedDate;
                        AWSCognitoRecord * existingRecord = [self.records objectForKey:record.key];
                        if(existingRecord == nil){
                            NSError *error = nil;
                            existingRecord = [self.sqliteManager getRecordById:record.key datasetName:self.name error:&error];
                        }
                        [changedRecords addObject:[[AWSCognitoRecordTuple alloc] initWithLocalRecord:existingRecord remoteRecord:newRecord]];
                    }
                    NSError *error = nil;
                    if([self.sqliteManager updateLocalRecordMetadata:self.name records:changedRecords error:&error]) {
                        [self postDidChangeRemoteValueNotification:changedRecordsNames];
                        if(okToUpdateSyncCount){
                            [self.sqliteManager updateLastSyncCount:self.name syncCount:maxSyncCount lastModifiedBy:nil];
                        }
                    } else {
                        [self postDidFailToSynchronizeNotification:error];
                        return [AWSTask taskWithError:error];
                    }
                }
            }
            return nil;
        }];
    }
    return nil;
}
- (AWSTask *)synchronize {
    if(self.synchronizeOnWiFiOnly && self.reachability.WWANOnly){
        NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorWiFiNotAvailable userInfo:nil];
        [self postDidFailToSynchronizeNotification:error];
        return [AWSTask taskWithError:error];
    }
    [self postDidStartSynchronizeNotification];
    [self checkForLocalMergedDatasets];
    AWSCognitoCredentialsProvider *cognitoCredentials = self.cognitoService.configuration.credentialsProvider;
    return [[[cognitoCredentials credentials] continueWithBlock:^id(AWSTask *task) {
        NSError * error = nil;
        if (task.error) {
            error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoAuthenticationFailed userInfo:nil];
        }
        else if(!dispatch_semaphore_wait(self.synchronizeQueue, DISPATCH_TIME_NOW)){
            AWSTaskCompletionSource<AWSTask *> *completion = [AWSTaskCompletionSource new];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                if(!dispatch_semaphore_wait(self.serializer, dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_SEC))){
                    self.syncSessionToken = nil;
                    [[self synchronizeInternal:self.synchronizeRetries] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
                        dispatch_semaphore_signal(self.serializer);
                        dispatch_semaphore_signal(self.synchronizeQueue);
                        if(task.error){
                            completion.error = task.error;
                        }else {
                            completion.result = task.result;
                        }
                        return task;
                    }];
                }else {
                    dispatch_semaphore_signal(self.synchronizeQueue);
                    completion.error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTimedOutWaitingForInFlightSync userInfo:nil];
                }
            });
            return completion.task;
        }else {
            error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorSyncAlreadyPending userInfo:nil];
        }
        [self postDidFailToSynchronizeNotification:error];
        return [AWSTask taskWithError:error];
    }] continueWithBlock:^id(AWSTask *task) {
        [self postDidEndSynchronizeNotification];
        return task;
    }];
}
- (AWSTask *)synchronizeInternal:(uint32_t)remainingAttempts {
    if(remainingAttempts == 0){
        AWSDDLogError(@"Conflict retries exhausted");
        NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorConflictRetriesExhausted userInfo:nil];
        [self postDidFailToSynchronizeNotification:error];
        return [AWSTask taskWithError:error];
    }
    self.currentSyncCount = [self.sqliteManager lastSyncCount:self.name];
    if([self.currentSyncCount intValue] == -1){
        AWSCognitoSyncDeleteDatasetRequest *request = [AWSCognitoSyncDeleteDatasetRequest new];
        request.identityPoolId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityPoolId;
        request.identityId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityId;
        request.datasetName = self.name;
        return [[self.cognitoService deleteDataset:request]continueWithBlock:^id(AWSTask *task) {
            if(task.isCancelled) {
                NSError *error = [NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTaskCanceled userInfo:nil];
                [self postDidFailToSynchronizeNotification:error];
                return [AWSTask taskWithError:error];
            } else if(task.error && task.error.code != AWSCognitoSyncErrorResourceNotFound){
                AWSDDLogError(@"Unable to delete dataset: %@", task.error);
                return task;
            } else {
                [self.sqliteManager deleteMetadata:self.name error:nil];
                return nil;
            }
        }];
    }
    return [[self syncPull:remainingAttempts] continueWithSuccessBlock:^id(AWSTask *task) {
        return [self syncPush:remainingAttempts];
    }];
}
- (AWSTask *)synchronizeOnConnectivity {
    if(!self.reachability.reachable || (self.reachability.WWANOnly && self.synchronizeOnWiFiOnly)){
        AWSTaskCompletionSource<AWSTask *>* completionSource = [AWSTaskCompletionSource<AWSTask *> taskCompletionSource];
        [AWSKSReachableOperation operationWithReachability:self.reachability allowWWAN:!self.synchronizeOnWiFiOnly onReachabilityAchieved:^{
            __weak AWSCognitoDataset* weakSelf = self;
            [[weakSelf synchronize] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
                completionSource.result = task;
                return task;
            }];
        }];
        return completionSource.task;
    }
    else{
        return [self synchronize];
    }
}
-(AWSTask *)subscribe {
    NSString *currentDeviceId = [AWSCognito cognitoDeviceId];
    if(!currentDeviceId){
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorDeviceNotRegistered userInfo:nil]];
    }
    AWSCognitoSyncSubscribeToDatasetRequest* request = [AWSCognitoSyncSubscribeToDatasetRequest new];
    request.identityPoolId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityPoolId;
    request.identityId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityId;
    request.datasetName = self.name;
    request.deviceId = currentDeviceId;
    return [[self.cognitoService subscribeToDataset:request] continueWithBlock:^id(AWSTask *task) {
        if(task.isCancelled){
            return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTaskCanceled userInfo:nil]];
        }else if(task.error){
            AWSDDLogError(@"Unable to subscribe dataset: %@", task.error);
            return task;
        }else {
            return [AWSTask taskWithResult:task.result];
        }
    }];
}
-(AWSTask *)unsubscribe {
    NSString *currentDeviceId = [AWSCognito cognitoDeviceId];
    if(!currentDeviceId){
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorDeviceNotRegistered userInfo:nil]];
    }
    AWSCognitoSyncUnsubscribeFromDatasetRequest* request = [AWSCognitoSyncUnsubscribeFromDatasetRequest new];
    request.identityPoolId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityPoolId;
    request.identityId = ((AWSCognitoCredentialsProvider *)self.cognitoService.configuration.credentialsProvider).identityId;
    request.datasetName = self.name;
    request.deviceId = currentDeviceId;
    return [[self.cognitoService unsubscribeFromDataset:request] continueWithBlock:^id(AWSTask *task) {
        if(task.isCancelled){
            return [AWSTask taskWithError:[NSError errorWithDomain:AWSCognitoErrorDomain code:AWSCognitoErrorTaskCanceled userInfo:nil]];
        }else if(task.error){
            AWSDDLogError(@"Unable to unsubscribe dataset: %@", task.error);
            return task;
        }else {
            return [AWSTask taskWithResult:task.result];
        }
    }];
}
#pragma mark IdentityMerge
- (void)identityChanged:(NSNotification *)notification {
    AWSDDLogDebug(@"IdentityChanged");
    [self checkForLocalMergedDatasets];
}
- (void) checkForLocalMergedDatasets {
    if (self.datasetMergedHandler) {
        NSArray *localMergeDatasets =  [self.sqliteManager getMergeDatasets:self.name error:nil];
        if (localMergeDatasets) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.datasetMergedHandler(self.name, localMergeDatasets);
            });
        }
    }
}
#pragma mark Notifications
- (void)postDidStartSynchronizeNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AWSCognitoDidStartSynchronizeNotification
                                                            object:self
                                                          userInfo:@{@"dataset": self.name}];
    });
}
- (void)postDidEndSynchronizeNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AWSCognitoDidEndSynchronizeNotification
                                                            object:self
                                                          userInfo:@{@"dataset": self.name}];
    });
}
- (void)postDidChangeLocalValueFromRemoteNotification:(NSArray *)changedValues
{
    self.lastModifiedDate = [NSDate date];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AWSCognitoDidChangeLocalValueFromRemoteNotification
                                                            object:self
                                                          userInfo:@{@"dataset": self.name,
                                                                     @"keys": changedValues}];
    });
}
- (void)postDidChangeRemoteValueNotification:(NSArray *)changedValues
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AWSCognitoDidChangeRemoteValueNotification
                                                            object:self
                                                          userInfo:@{@"dataset": self.name,
                                                                     @"keys": changedValues}];
    });
}
- (void)postDidFailToSynchronizeNotification:(NSError *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AWSCognitoDidFailToSynchronizeNotification
                                                            object:self
                                                          userInfo:@{@"dataset": self.name,
                                                                     @"error": error}];
    });
}
@end