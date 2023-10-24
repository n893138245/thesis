#import "NSError+AWSMTLModelException.h"
#import "AWSMTLModel.h"
#import "AWSEXTRuntimeExtensions.h"
#import "AWSEXTScope.h"
#import "AWSMTLReflection.h"
#import <objc/runtime.h>
#import "AWSMTLJSONAdapter.h"
#import "AWSMTLModel+NSCoding.h"
static void *MTLModelCachedPropertyKeysKey = &MTLModelCachedPropertyKeysKey;
static BOOL MTLValidateAndSetValue(id obj, NSString *key, id value, BOOL forceUpdate, NSError **error) {
	__autoreleasing id validatedValue = value;
	@try {
		if (![obj validateValue:&validatedValue forKey:key error:error]) return NO;
		if (forceUpdate || value != validatedValue) {
			[obj setValue:validatedValue forKey:key];
		}
		return YES;
	} @catch (NSException *ex) {
		NSLog(@"*** Caught exception setting key \"%@\" : %@", key, ex);
		#if DEBUG
		@throw ex;
		#else
		if (error != NULL) {
			*error = [NSError awsmtl_modelErrorWithException:ex];
		}
		return NO;
		#endif
	}
}
@interface AWSMTLModel ()
+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block;
@end
@implementation AWSMTLModel
#pragma mark Lifecycle
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
	return [[self alloc] initWithDictionary:dictionary error:error];
}
- (instancetype)init {
	return [super init];
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
	self = [self init];
	if (self == nil) return nil;
	for (NSString *key in dictionary) {
		__autoreleasing id value = [dictionary objectForKey:key];
		if ([value isEqual:NSNull.null]) value = nil;
		BOOL success = MTLValidateAndSetValue(self, key, value, YES, error);
		if (!success) return nil;
	}
	return self;
}
#pragma mark Reflection
+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block {
	Class cls = self;
	BOOL stop = NO;
	while (!stop && ![cls isEqual:AWSMTLModel.class]) {
		unsigned count = 0;
		objc_property_t *properties = class_copyPropertyList(cls, &count);
		cls = cls.superclass;
		if (properties == NULL) continue;
		@onExit {
			free(properties);
		};
		for (unsigned i = 0; i < count; i++) {
			block(properties[i], &stop);
			if (stop) break;
		}
	}
}
+ (NSSet *)propertyKeys {
	NSSet *cachedKeys = objc_getAssociatedObject(self, MTLModelCachedPropertyKeysKey);
	if (cachedKeys != nil) return cachedKeys;
	NSMutableSet *keys = [NSMutableSet set];
	[self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
		awsmtl_propertyAttributes *attributes = awsmtl_copyPropertyAttributes(property);
		@onExit {
			free(attributes);
		};
		if (attributes->readonly && attributes->ivar == NULL) return;
		NSString *key = @(property_getName(property));
		[keys addObject:key];
	}];
	objc_setAssociatedObject(self, MTLModelCachedPropertyKeysKey, keys, OBJC_ASSOCIATION_COPY);
	return keys;
}
- (NSDictionary *)dictionaryValue {
	return [self dictionaryWithValuesForKeys:self.class.propertyKeys.allObjects];
}
#pragma mark Merging
- (void)mergeValueForKey:(NSString *)key fromModel:(AWSMTLModel *)model {
	NSParameterAssert(key != nil);
	SEL selector = AWSMTLSelectorWithCapitalizedKeyPattern("merge", key, "FromModel:");
	if (![self respondsToSelector:selector]) {
		if (model != nil) {
			[self setValue:[model valueForKey:key] forKey:key];
		}
		return;
	}
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
	invocation.target = self;
	invocation.selector = selector;
	[invocation setArgument:&model atIndex:2];
	[invocation invoke];
}
- (void)mergeValuesForKeysFromModel:(AWSMTLModel *)model {
	NSSet *propertyKeys = model.class.propertyKeys;
	for (NSString *key in self.class.propertyKeys) {
		if (![propertyKeys containsObject:key]) continue;
		[self mergeValueForKey:key fromModel:model];
	}
}
#pragma mark Validation
- (BOOL)validate:(NSError **)error {
	for (NSString *key in self.class.propertyKeys) {
		id value = [self valueForKey:key];
		BOOL success = MTLValidateAndSetValue(self, key, value, NO, error);
		if (!success) return NO;
	}
	return YES;
}
#pragma mark NSCopying
- (instancetype)copyWithZone:(NSZone *)zone {
	return [[self.class allocWithZone:zone] initWithDictionary:self.dictionaryValue error:NULL];
}
#pragma mark NSObject
- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.dictionaryValue];
}
- (NSUInteger)hash {
	NSUInteger value = 0;
	for (NSString *key in self.class.propertyKeys) {
		value ^= [[self valueForKey:key] hash];
	}
	return value;
}
- (BOOL)isEqual:(AWSMTLModel *)model {
	if (self == model) return YES;
	if (![model isMemberOfClass:self.class]) return NO;
	for (NSString *key in self.class.propertyKeys) {
		id selfValue = [self valueForKey:key];
		id modelValue = [model valueForKey:key];
		BOOL valuesEqual = ((selfValue == nil && modelValue == nil) || [selfValue isEqual:modelValue]);
		if (!valuesEqual) return NO;
	}
	return YES;
}
@end