#import <CoreData/CoreData.h>
@class AWSMTLModel;
@protocol AWSMTLManagedObjectSerializing
@required
+ (NSString *)managedObjectEntityName;
+ (NSDictionary *)managedObjectKeysByPropertyKey;
@optional
+ (NSSet *)propertyKeysForManagedObjectUniquing;
+ (NSValueTransformer *)entityAttributeTransformerForKey:(NSString *)key;
+ (NSDictionary *)relationshipModelClassesByPropertyKey;
+ (Class)classForDeserializingManagedObject:(NSManagedObject *)managedObject;
- (void)mergeValueForKey:(NSString *)key fromManagedObject:(NSManagedObject *)managedObject;
- (void)mergeValuesForKeysFromManagedObject:(NSManagedObject *)managedObject;
@end
extern NSString * const AWSMTLManagedObjectAdapterErrorDomain;
extern const NSInteger AWSMTLManagedObjectAdapterErrorNoClassFound;
extern const NSInteger AWSMTLManagedObjectAdapterErrorInitializationFailed;
extern const NSInteger AWSMTLManagedObjectAdapterErrorInvalidManagedObjectKey;
extern const NSInteger AWSMTLManagedObjectAdapterErrorUnsupportedManagedObjectPropertyType;
extern const NSInteger AWSMTLManagedObjectAdapterErrorUniqueFetchRequestFailed;
extern const NSInteger AWSMTLManagedObjectAdapterErrorUnsupportedRelationshipClass;
extern const NSInteger AWSMTLManagedObjectAdapterErrorInvalidManagedObjectMapping;
@interface AWSMTLManagedObjectAdapter : NSObject
+ (id)modelOfClass:(Class)modelClass fromManagedObject:(NSManagedObject *)managedObject error:(NSError **)error;
+ (id)managedObjectFromModel:(AWSMTLModel<AWSMTLManagedObjectSerializing> *)model insertingIntoContext:(NSManagedObjectContext *)context error:(NSError **)error;
@end