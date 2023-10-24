#import "NSDictionary+AWSMTLManipulationAdditions.h"
@implementation NSDictionary (AWSMTLManipulationAdditions)
- (NSDictionary *)awsmtl_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary {
	NSMutableDictionary *result = [self mutableCopy];
	[result addEntriesFromDictionary:dictionary];
	return result;
}
- (NSDictionary *)awsmtl_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys {
	NSMutableDictionary *result = [self mutableCopy];
	[result removeObjectsForKeys:keys.allObjects];
	return result;
}
@end