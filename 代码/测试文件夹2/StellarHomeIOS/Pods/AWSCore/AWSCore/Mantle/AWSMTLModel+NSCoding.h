#import "AWSMTLModel.h"
void awsmtl_loadMTLNSCoding(void);
typedef enum : NSUInteger {
    AWSMTLModelEncodingBehaviorExcluded = 0,
    AWSMTLModelEncodingBehaviorUnconditional,
    AWSMTLModelEncodingBehaviorConditional,
} AWSMTLModelEncodingBehavior;
@interface AWSMTLModel (NSCoding) <NSCoding>
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
+ (NSDictionary *)encodingBehaviorsByPropertyKey;
+ (NSDictionary *)allowedSecureCodingClassesByPropertyKey;
- (id)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion;
+ (NSUInteger)modelVersion;
@end
@interface AWSMTLModel (OldArchiveSupport)
+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation version:(NSUInteger)fromVersion;
@end