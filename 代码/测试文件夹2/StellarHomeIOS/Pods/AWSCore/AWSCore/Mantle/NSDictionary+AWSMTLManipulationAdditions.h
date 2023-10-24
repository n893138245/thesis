#import <Foundation/Foundation.h>
@interface NSDictionary (AWSMTLManipulationAdditions)
- (NSDictionary *)awsmtl_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)awsmtl_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys;
@end