#import "AWSMTLModel+NSCoding.h"
#import "AWSEXTRuntimeExtensions.h"
#import "AWSEXTScope.h"
#import "AWSMTLReflection.h"
#import <objc/runtime.h>
void awsmtl_loadMTLNSCoding(){
}
static NSString * const AWSMTLModelVersionKey = @"AWSMTLModelVersion";
static void *AWSMTLModelCachedAllowedClassesKey = &AWSMTLModelCachedAllowedClassesKey;
static BOOL coderRequiresSecureCoding(NSCoder *coder) {
	SEL requiresSecureCodingSelector = @selector(requiresSecureCoding);
	if (![coder respondsToSelector:requiresSecureCodingSelector]) return NO;
	BOOL (*requiresSecureCodingIMP)(NSCoder *, SEL) = (__typeof__(requiresSecureCodingIMP))[coder methodForSelector:requiresSecureCodingSelector];
	if (requiresSecureCodingIMP == NULL) return NO;
	return requiresSecureCodingIMP(coder, requiresSecureCodingSelector);
}
static NSSet *encodablePropertyKeysForClass(Class modelClass) {
	return [[modelClass encodingBehaviorsByPropertyKey] keysOfEntriesPassingTest:^ BOOL (NSString *propertyKey, NSNumber *behavior, BOOL *stop) {
		return behavior.unsignedIntegerValue != AWSMTLModelEncodingBehaviorExcluded;
	}];
}
static void verifyAllowedClassesByPropertyKey(Class modelClass) {
	NSDictionary *allowedClasses = [modelClass allowedSecureCodingClassesByPropertyKey];
	NSMutableSet *specifiedPropertyKeys = [[NSMutableSet alloc] initWithArray:allowedClasses.allKeys];
	[specifiedPropertyKeys minusSet:encodablePropertyKeysForClass(modelClass)];
	if (specifiedPropertyKeys.count > 0) {
		[NSException raise:NSInvalidArgumentException format:@"Cannot encode %@ securely, because keys are missing from +allowedSecureCodingClassesByPropertyKey: %@", modelClass, specifiedPropertyKeys];
	}
}
@implementation AWSMTLModel (NSCoding)
#pragma mark Versioning
+ (NSUInteger)modelVersion {
	return 0;
}
#pragma mark Encoding Behaviors
+ (NSDictionary *)encodingBehaviorsByPropertyKey {
	NSSet *propertyKeys = self.propertyKeys;
	NSMutableDictionary *behaviors = [[NSMutableDictionary alloc] initWithCapacity:propertyKeys.count];
	for (NSString *key in propertyKeys) {
		objc_property_t property = class_getProperty(self, key.UTF8String);
		NSAssert(property != NULL, @"Could not find property \"%@\" on %@", key, self);
		awsmtl_propertyAttributes *attributes = awsmtl_copyPropertyAttributes(property);
		@onExit {
			free(attributes);
		};
		AWSMTLModelEncodingBehavior behavior = (attributes->weak ? AWSMTLModelEncodingBehaviorConditional : AWSMTLModelEncodingBehaviorUnconditional);
		behaviors[key] = @(behavior);
	}
	return behaviors;
}
+ (NSDictionary *)allowedSecureCodingClassesByPropertyKey {
	NSDictionary *cachedClasses = objc_getAssociatedObject(self, AWSMTLModelCachedAllowedClassesKey);
	if (cachedClasses != nil) return cachedClasses;
	NSSet *propertyKeys = [self.encodingBehaviorsByPropertyKey keysOfEntriesPassingTest:^ BOOL (NSString *propertyKey, NSNumber *behavior, BOOL *stop) {
		return behavior.unsignedIntegerValue != AWSMTLModelEncodingBehaviorExcluded;
	}];
	NSMutableDictionary *allowedClasses = [[NSMutableDictionary alloc] initWithCapacity:propertyKeys.count];
	for (NSString *key in propertyKeys) {
		objc_property_t property = class_getProperty(self, key.UTF8String);
		NSAssert(property != NULL, @"Could not find property \"%@\" on %@", key, self);
		awsmtl_propertyAttributes *attributes = awsmtl_copyPropertyAttributes(property);
		@onExit {
			free(attributes);
		};
		if (attributes->type[0] != '@' && attributes->type[0] != '#') {
			allowedClasses[key] = @[ NSValue.class ];
			continue;
		}
		if (attributes->objectClass != nil) {
			allowedClasses[key] = @[ attributes->objectClass ];
		}
	}
	objc_setAssociatedObject(self, AWSMTLModelCachedAllowedClassesKey, allowedClasses, OBJC_ASSOCIATION_COPY);
	return allowedClasses;
}
- (id)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
	NSParameterAssert(key != nil);
	NSParameterAssert(coder != nil);
	SEL selector = AWSMTLSelectorWithCapitalizedKeyPattern("decode", key, "WithCoder:modelVersion:");
	if ([self respondsToSelector:selector]) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
		invocation.target = self;
		invocation.selector = selector;
		[invocation setArgument:&coder atIndex:2];
		[invocation setArgument:&modelVersion atIndex:3];
		[invocation invoke];
		__unsafe_unretained id result = nil;
		[invocation getReturnValue:&result];
		return result;
	}
	@try {
		if (coderRequiresSecureCoding(coder)) {
			NSArray *allowedClasses = self.class.allowedSecureCodingClassesByPropertyKey[key];
			NSAssert(allowedClasses != nil, @"No allowed classes specified for securely decoding key \"%@\" on %@", key, self.class);
			return [coder decodeObjectOfClasses:[NSSet setWithArray:allowedClasses] forKey:key];
		} else {
			return [coder decodeObjectForKey:key];
		}
	} @catch (NSException *ex) {
		NSLog(@"*** Caught exception decoding value for key \"%@\" on class %@: %@", key, self.class, ex);
		@throw ex;
	}
}
#pragma mark NSCoding
- (instancetype)initWithCoder:(NSCoder *)coder {
	BOOL requiresSecureCoding = coderRequiresSecureCoding(coder);
	NSNumber *version = nil;
	if (requiresSecureCoding) {
		version = [coder decodeObjectOfClass:NSNumber.class forKey:AWSMTLModelVersionKey];
	} else {
		version = [coder decodeObjectForKey:AWSMTLModelVersionKey];
	}
	if (version == nil) {
		NSLog(@"Warning: decoding an archive of %@ without a version, assuming 0", self.class);
	} else if (version.unsignedIntegerValue > self.class.modelVersion) {
		return nil;
	}
	if (requiresSecureCoding) {
		verifyAllowedClassesByPropertyKey(self.class);
	} else {
		NSDictionary *externalRepresentation = [coder decodeObjectForKey:@"externalRepresentation"];
		if (externalRepresentation != nil) {
			NSAssert([self.class methodForSelector:@selector(dictionaryValueFromArchivedExternalRepresentation:version:)] != [AWSMTLModel methodForSelector:@selector(dictionaryValueFromArchivedExternalRepresentation:version:)], @"Decoded an old archive of %@ that contains an externalRepresentation, but +dictionaryValueFromArchivedExternalRepresentation:version: is not overridden to handle it", self.class);
			NSDictionary *dictionaryValue = [self.class dictionaryValueFromArchivedExternalRepresentation:externalRepresentation version:version.unsignedIntegerValue];
			if (dictionaryValue == nil) return nil;
			NSError *error = nil;
			self = [self initWithDictionary:dictionaryValue error:&error];
			if (self == nil) NSLog(@"*** Could not decode old %@ archive: %@", self.class, error);
			return self;
		}
	}
	NSSet *propertyKeys = self.class.propertyKeys;
	NSMutableDictionary *dictionaryValue = [[NSMutableDictionary alloc] initWithCapacity:propertyKeys.count];
	for (NSString *key in propertyKeys) {
		id value = [self decodeValueForKey:key withCoder:coder modelVersion:version.unsignedIntegerValue];
		if (value == nil) continue;
		dictionaryValue[key] = value;
	}
	NSError *error = nil;
	self = [self initWithDictionary:dictionaryValue error:&error];
	if (self == nil) NSLog(@"*** Could not unarchive %@: %@", self.class, error);
	return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
	if (coderRequiresSecureCoding(coder)) verifyAllowedClassesByPropertyKey(self.class);
	[coder encodeObject:@(self.class.modelVersion) forKey:AWSMTLModelVersionKey];
	NSDictionary *encodingBehaviors = self.class.encodingBehaviorsByPropertyKey;
	[self.dictionaryValue enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
		@try {
			if ([value isEqual:NSNull.null]) return;
			switch ([encodingBehaviors[key] unsignedIntegerValue]) {
				case AWSMTLModelEncodingBehaviorExcluded:
					break;
				case AWSMTLModelEncodingBehaviorUnconditional:
					[coder encodeObject:value forKey:key];
					break;
				case AWSMTLModelEncodingBehaviorConditional:
					[coder encodeConditionalObject:value forKey:key];
					break;
				default:
					NSAssert(NO, @"Unrecognized encoding behavior %@ on class %@ for key \"%@\"", self.class, encodingBehaviors[key], key);
			}
		} @catch (NSException *ex) {
			NSLog(@"*** Caught exception encoding value for key \"%@\" on class %@: %@", key, self.class, ex);
			@throw ex;
		}
	}];
}
#pragma mark NSSecureCoding
+ (BOOL)supportsSecureCoding {
	return NO;
}
@end
@implementation AWSMTLModel (OldArchiveSupport)
+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation version:(NSUInteger)fromVersion {
	return nil;
}
@end