#import "Fabric.h"
@protocol FABKit;
@interface Fabric (FABKits)
+ (fab_nonnull NSDictionary *)configurationDictionaryForKitClass:(fab_nonnull Class)kitClass;
@end