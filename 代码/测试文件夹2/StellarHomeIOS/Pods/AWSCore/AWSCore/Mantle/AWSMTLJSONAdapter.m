#import "AWSMTLJSONAdapter.h"
#import "AWSMTLModel.h"
#import "AWSMTLReflection.h"
NSString * const AWSMTLJSONAdapterErrorDomain = @"AWSMTLJSONAdapterErrorDomain";
const NSInteger AWSMTLJSONAdapterErrorNoClassFound = 2;
const NSInteger AWSMTLJSONAdapterErrorInvalidJSONDictionary = 3;
const NSInteger AWSMTLJSONAdapterErrorInvalidJSONMapping = 4;
const NSInteger AWSMTLJSONAdapterErrorExceptionThrown = 1;
static NSString * const AWSMTLJSONAdapterThrownExceptionErrorKey = @"AWSMTLJSONAdapterThrownException";
@interface AWSMTLJSONAdapter ()
@property (nonatomic, strong, readonly) Class modelClass;
@property (nonatomic, copy, readonly) NSDictionary *JSONKeyPathsByPropertyKey;
- (NSValueTransformer *)JSONTransformerForKey:(NSString *)key;
@end
@implementation AWSMTLJSONAdapter
#pragma mark Convenience methods
+ (id)modelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)JSONDictionary error:(NSError **)error {
	AWSMTLJSONAdapter *adapter = [[self alloc] initWithJSONDictionary:JSONDictionary modelClass:modelClass error:error];
	return adapter.model;
}
+ (NSArray *)modelsOfClass:(Class)modelClass fromJSONArray:(NSArray *)JSONArray error:(NSError **)error {
	if (JSONArray == nil || ![JSONArray isKindOfClass:NSArray.class]) {
		if (error != NULL) {
			NSDictionary *userInfo = @{
				NSLocalizedDescriptionKey: NSLocalizedString(@"Missing JSON array", @""),
				NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"%@ could not be created because an invalid JSON array was provided: %@", @""), NSStringFromClass(modelClass), JSONArray.class],
			};
			*error = [NSError errorWithDomain:AWSMTLJSONAdapterErrorDomain code:AWSMTLJSONAdapterErrorInvalidJSONDictionary userInfo:userInfo];
		}
		return nil;
	}
	NSMutableArray *models = [NSMutableArray arrayWithCapacity:JSONArray.count];
	for (NSDictionary *JSONDictionary in JSONArray){
		AWSMTLModel *model = [self modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:error];
		if (model == nil) return nil;
		[models addObject:model];
	}
	return models;
}
+ (NSDictionary *)JSONDictionaryFromModel:(AWSMTLModel<AWSMTLJSONSerializing> *)model {
	AWSMTLJSONAdapter *adapter = [[self alloc] initWithModel:model];
	return adapter.JSONDictionary;
}
+ (NSArray *)JSONArrayFromModels:(NSArray *)models {
	NSParameterAssert(models != nil);
	NSParameterAssert([models isKindOfClass:NSArray.class]);
	NSMutableArray *JSONArray = [NSMutableArray arrayWithCapacity:models.count];
	for (AWSMTLModel<AWSMTLJSONSerializing> *model in models) {
		NSDictionary *JSONDictionary = [self JSONDictionaryFromModel:model];
		if (JSONDictionary == nil) return nil;
		[JSONArray addObject:JSONDictionary];
	}
	return JSONArray;
}
#pragma mark Lifecycle
- (id)init {
	NSAssert(NO, @"%@ must be initialized with a JSON dictionary or model object", self.class);
	return nil;
}
- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary modelClass:(Class)modelClass error:(NSError **)error {
	NSParameterAssert(modelClass != nil);
	NSParameterAssert([modelClass isSubclassOfClass:AWSMTLModel.class]);
	NSParameterAssert([modelClass conformsToProtocol:@protocol(AWSMTLJSONSerializing)]);
	if (JSONDictionary == nil || ![JSONDictionary isKindOfClass:NSDictionary.class]) {
		if (error != NULL) {
			NSDictionary *userInfo = @{
				NSLocalizedDescriptionKey: NSLocalizedString(@"Missing JSON dictionary", @""),
				NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"%@ could not be created because an invalid JSON dictionary was provided: %@", @""), NSStringFromClass(modelClass), JSONDictionary.class],
			};
			*error = [NSError errorWithDomain:AWSMTLJSONAdapterErrorDomain code:AWSMTLJSONAdapterErrorInvalidJSONDictionary userInfo:userInfo];
		}
		return nil;
	}
	if ([modelClass respondsToSelector:@selector(classForParsingJSONDictionary:)]) {
		modelClass = [modelClass classForParsingJSONDictionary:JSONDictionary];
		if (modelClass == nil) {
			if (error != NULL) {
				NSDictionary *userInfo = @{
					NSLocalizedDescriptionKey: NSLocalizedString(@"Could not parse JSON", @""),
					NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"No model class could be found to parse the JSON dictionary.", @"")
				};
				*error = [NSError errorWithDomain:AWSMTLJSONAdapterErrorDomain code:AWSMTLJSONAdapterErrorNoClassFound userInfo:userInfo];
			}
			return nil;
		}
		NSAssert([modelClass isSubclassOfClass:AWSMTLModel.class], @"Class %@ returned from +classForParsingJSONDictionary: is not a subclass of MTLModel", modelClass);
		NSAssert([modelClass conformsToProtocol:@protocol(AWSMTLJSONSerializing)], @"Class %@ returned from +classForParsingJSONDictionary: does not conform to <MTLJSONSerializing>", modelClass);
	}
	self = [super init];
	if (self == nil) return nil;
	_modelClass = modelClass;
	_JSONKeyPathsByPropertyKey = [[modelClass JSONKeyPathsByPropertyKey] copy];
	NSMutableDictionary *dictionaryValue = [[NSMutableDictionary alloc] initWithCapacity:JSONDictionary.count];
	NSSet *propertyKeys = [self.modelClass propertyKeys];
	for (NSString *mappedPropertyKey in self.JSONKeyPathsByPropertyKey) {
		if (![propertyKeys containsObject:mappedPropertyKey]) {
			NSAssert(NO, @"%@ is not a property of %@.", mappedPropertyKey, modelClass);
			return nil;
		}
		id value = self.JSONKeyPathsByPropertyKey[mappedPropertyKey];
		if (![value isKindOfClass:NSString.class] && value != NSNull.null) {
			NSAssert(NO, @"%@ must either map to a JSON key path or NSNull, got: %@.",mappedPropertyKey, value);
			return nil;
		}
	}
	for (NSString *propertyKey in propertyKeys) {
		NSString *JSONKeyPath = [self JSONKeyPathForPropertyKey:propertyKey];
		if (JSONKeyPath == nil) continue;
		id value;
		@try {
			value = [JSONDictionary valueForKeyPath:JSONKeyPath];
		} @catch (NSException *ex) {
			if (error != NULL) {
				NSDictionary *userInfo = @{
					NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid JSON dictionary", nil),
					NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"%1$@ could not be parsed because an invalid JSON dictionary was provided for key path \"%2$@\"", nil), modelClass, JSONKeyPath],
					AWSMTLJSONAdapterThrownExceptionErrorKey: ex
				};
				*error = [NSError errorWithDomain:AWSMTLJSONAdapterErrorDomain code:AWSMTLJSONAdapterErrorInvalidJSONDictionary userInfo:userInfo];
			}
			return nil;
		}
		if (value == nil) continue;
		@try {
			NSValueTransformer *transformer = [self JSONTransformerForKey:propertyKey];
			if (transformer != nil) {
				if ([value isEqual:NSNull.null]) value = nil;
				value = [transformer transformedValue:value] ?: NSNull.null;
			}
			dictionaryValue[propertyKey] = value;
		} @catch (NSException *ex) {
			NSLog(@"*** Caught exception %@ parsing JSON key path \"%@\" from: %@", ex, JSONKeyPath, JSONDictionary);
			#if DEBUG
			@throw ex;
			#else
			if (error != NULL) {
				NSDictionary *userInfo = @{
					NSLocalizedDescriptionKey: ex.description,
					NSLocalizedFailureReasonErrorKey: ex.reason,
					AWSMTLJSONAdapterThrownExceptionErrorKey: ex
				};
				*error = [NSError errorWithDomain:AWSMTLJSONAdapterErrorDomain code:AWSMTLJSONAdapterErrorExceptionThrown userInfo:userInfo];
			}
			return nil;
			#endif
		}
	}
	_model = [self.modelClass modelWithDictionary:dictionaryValue error:error];
	if (_model == nil) return nil;
	return self;
}
- (id)initWithModel:(AWSMTLModel<AWSMTLJSONSerializing> *)model {
	NSParameterAssert(model != nil);
	self = [super init];
	if (self == nil) return nil;
	_model = model;
	_modelClass = model.class;
	_JSONKeyPathsByPropertyKey = [[model.class JSONKeyPathsByPropertyKey] copy];
	return self;
}
#pragma mark Serialization
- (NSDictionary *)JSONDictionary {
	NSDictionary *dictionaryValue = self.model.dictionaryValue;
	NSMutableDictionary *JSONDictionary = [[NSMutableDictionary alloc] initWithCapacity:dictionaryValue.count];
	[dictionaryValue enumerateKeysAndObjectsUsingBlock:^(NSString *propertyKey, id value, BOOL *stop) {
		NSString *JSONKeyPath = [self JSONKeyPathForPropertyKey:propertyKey];
		if (JSONKeyPath == nil) return;
		NSValueTransformer *transformer = [self JSONTransformerForKey:propertyKey];
		if ([transformer.class allowsReverseTransformation]) {
			if ([value isEqual:NSNull.null]) value = nil;
			value = [transformer reverseTransformedValue:value] ?: NSNull.null;
		}
		NSArray *keyPathComponents = [JSONKeyPath componentsSeparatedByString:@"."];
		id obj = JSONDictionary;
		for (NSString *component in keyPathComponents) {
			if ([obj valueForKey:component] == nil) {
				[obj setValue:[NSMutableDictionary dictionary] forKey:component];
			}
			obj = [obj valueForKey:component];
		}
		[JSONDictionary setValue:value forKeyPath:JSONKeyPath];
	}];
	return JSONDictionary;
}
- (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
	NSParameterAssert(key != nil);
	SEL selector = AWSMTLSelectorWithKeyPattern(key, "JSONTransformer");
	if ([self.modelClass respondsToSelector:selector]) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.modelClass methodSignatureForSelector:selector]];
		invocation.target = self.modelClass;
		invocation.selector = selector;
		[invocation invoke];
		__unsafe_unretained id result = nil;
		[invocation getReturnValue:&result];
		return result;
	}
	if ([self.modelClass respondsToSelector:@selector(JSONTransformerForKey:)]) {
		return [self.modelClass JSONTransformerForKey:key];
	}
	return nil;
}
- (NSString *)JSONKeyPathForPropertyKey:(NSString *)key {
	NSParameterAssert(key != nil);
	id JSONKeyPath = self.JSONKeyPathsByPropertyKey[key];
	if ([JSONKeyPath isEqual:NSNull.null]) return nil;
	if (JSONKeyPath == nil) {
		return key;
	} else {
		return JSONKeyPath;
	}
}
@end
@implementation AWSMTLJSONAdapter (Deprecated)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
+ (id)modelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)JSONDictionary {
	return [self modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:NULL];
}
- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary modelClass:(Class)modelClass {
	return [self initWithJSONDictionary:JSONDictionary modelClass:modelClass error:NULL];
}
#pragma clang diagnostic pop
@end