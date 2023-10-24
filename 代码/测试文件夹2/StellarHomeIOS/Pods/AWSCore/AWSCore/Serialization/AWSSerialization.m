#import "AWSSerialization.h"
#import "AWSTimestampSerialization.h"
#import "AWSXMLWriter.h"
#import "AWSCategory.h"
#import "AWSCocoaLumberjack.h"
#import "AWSXMLDictionary.h"
NSString *const AWSXMLBuilderErrorDomain = @"com.amazonaws.AWSXMLBuilderErrorDomain";
NSString *const AWSXMLParserErrorDomain = @"com.amazonaws.AWSXMLParserErrorDomain";
NSString *const AWSQueryParamBuilderErrorDomain = @"com.amazonaws.AWSQueryParamBuilderErrorDomain";
NSString *const AWSEC2ParamBuilderErrorDomain = @"com.amazonaws.AWSEC2ParamBuilderErrorDomain";
NSString *const AWSJSONBuilderErrorDomain = @"com.amazonaws.AWSJSONBuilderErrorDomain";
NSString *const AWSJSONParserErrorDomain = @"com.amazonaws.AWSJSONParserErrorDomain";
@interface AWSJSONDictionary()
@property (nonatomic, strong) NSDictionary *embeddedDictionary;
@property (nonatomic, strong) NSDictionary *JSONDefinitionRule;
@end
@implementation AWSJSONDictionary
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary JSONDefinitionRule:(NSDictionary *)rule {
    self = [super init];
    if (self) {
        _embeddedDictionary = [[NSDictionary alloc] initWithDictionary:otherDictionary];
        _JSONDefinitionRule = [rule copy];
    }
    return self;
}
- (id)parseResult:(id)result {
    if ([result isKindOfClass:[NSDictionary class]]) {
        return [[AWSJSONDictionary alloc] initWithDictionary:result JSONDefinitionRule:self.JSONDefinitionRule];
    } else {
        return result;
    }
}
- (NSUInteger)count {
    return [self.embeddedDictionary count];
}
- (id)objectForKey:(id)aKey {
    id value = [self.embeddedDictionary objectForKey:aKey];
    if (value) {
        return [self parseResult:value];
    }
    id result = [[self.embeddedDictionary objectForKey:@"metadata"] objectForKey:aKey];
    if (result) {
        return [self parseResult:result];
    }
    NSString *shapeName = [self.embeddedDictionary objectForKey:@"shape"];
    if (shapeName.length != 0) {
        NSDictionary *definitionResult = [self.JSONDefinitionRule objectForKey:shapeName];
        id result = [definitionResult objectForKey:aKey];
        if (result) {
            return [self parseResult:result];
        }
        id metaDataResult = [[definitionResult objectForKey:@"metadata"] objectForKey:aKey];
        if (metaDataResult) {
            return [self parseResult:metaDataResult];
        }
    }
    return nil;
}
- (NSEnumerator *)keyEnumerator {
    return [self.embeddedDictionary keyEnumerator];
}
@end
@implementation AWSXMLBuilder
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSXMLBuilderErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (NSString *)xmlStringForDictionary:(NSDictionary *)params actionName:(NSString *)actionName serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule error:(NSError *__autoreleasing *)error {
    return [[self xmlBuildForDictionary:params actionName:actionName serviceDefinitionRule:serviceDefinitionRule error:error] toString];
}
+ (NSData *)xmlDataForDictionary:(NSDictionary *)params actionName:(NSString *)actionName serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule error:(NSError *__autoreleasing *)error {
    if ([params count] == 0) {
        return nil;
    }
    NSData *resultData = [[self xmlBuildForDictionary:params actionName:actionName serviceDefinitionRule:serviceDefinitionRule  error:error] toData];
    return resultData;
}
+ (AWSXMLWriter *)xmlBuildForDictionary:(NSDictionary *)params actionName:(NSString *)actionName serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule error:(NSError *__autoreleasing *)error {
    NSDictionary *actionRule = [[[serviceDefinitionRule objectForKey:@"operations"] objectForKey:actionName] objectForKey:@"input"];
    NSDictionary *definitionRules = [serviceDefinitionRule objectForKey:@"shapes"];
    if (definitionRules == (id)[NSNull null] ||  [definitionRules count] == 0) {
        [self failWithCode:AWSXMLBuilderDefinitionFileIsEmpty description:@"JSON definition File is empty or can not be found" error:error];
        return nil;
    }
    if ([actionRule count] == 0) {
        [self failWithCode:AWSXMLBuilderUndefinedActionRule description:@"Invalid argument: actionRule is Empty" error:error];
        return nil;
    }
    AWSXMLWriter* xmlWriter = [[AWSXMLWriter alloc]init];
    AWSJSONDictionary *rules = [[AWSJSONDictionary alloc] initWithDictionary:actionRule JSONDefinitionRule:definitionRules];
    NSString *xmlElementName = rules[@"locationName"];
    if (xmlElementName) {
        [xmlWriter writeStartElement:xmlElementName];
        [self applyNamespacesAndAttributesByRules:rules params:params xmlWriter:xmlWriter];
    }
    [self serializeStructure:params rules:rules xmlWriter:xmlWriter error:error isRootRule:YES];
    if (xmlElementName) {
        [xmlWriter writeEndElement:xmlElementName];
    }
    return xmlWriter;
}
+ (BOOL)serializeStructure:(NSDictionary *)params rules:(AWSJSONDictionary *)rules xmlWriter:(AWSXMLWriter *)xmlWriter error:(NSError *__autoreleasing *)error isRootRule:(BOOL)isRootRule {
    AWSJSONDictionary *structureMembersRule = rules[@"members"]?rules[@"members"]:@{};
    if (isRootRule) {
        NSString *payloadMemberName = rules[@"payload"];
        if (payloadMemberName) {
            id value = params[payloadMemberName];
            if (value) {
                AWSJSONDictionary *payloadMemberRules = structureMembersRule[payloadMemberName];
                return [self serializeMember:value name:payloadMemberName rules:payloadMemberRules isPayloadType:YES xmlWriter:xmlWriter error:error];
            } else {
                return YES;
            }
        }
    }
    __block BOOL isValid = YES;
    __block NSError *blockErr = nil;
    [structureMembersRule enumerateKeysAndObjectsUsingBlock:^(NSString *memberName, id memberRules, BOOL *stop) {
        id value = params[memberName];
        if (value) {
            if (memberRules[@"xmlAttribute"]) {
                return;
            }
            if (memberRules[@"location"]) {
                return;
            }
            if (![self serializeMember:value name:memberName rules:memberRules isPayloadType:NO xmlWriter:xmlWriter error:&blockErr]) {
                *stop = YES;
                isValid = NO;
                return;
            }
        }
    }];
    if (error) *error = blockErr;
    return isValid;
}
+ (BOOL)serializeList:(NSArray *)list name:(NSString *)name rules:(AWSJSONDictionary *)rules xmlWriter:(AWSXMLWriter *)xmlWriter error:(NSError *__autoreleasing *)error {
    AWSJSONDictionary *memberRules = rules[@"member"]?rules[@"member"]:@{};
    NSString *xmlListName = rules[@"locationName"]?rules[@"locationName"]:name;
    __block BOOL isValid = YES;
    __block NSError *blockErr = nil;
    if ([rules[@"flattened"] boolValue]) {
        [list enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
            if (![self serializeMember:value name:xmlListName rules:memberRules isPayloadType:NO xmlWriter:xmlWriter error:&blockErr]) {
                *stop = YES;
                isValid = NO;
                return ;
            }
        }];
    } else {
        [xmlWriter writeStartElement:xmlListName];
        [list enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
            if (![self serializeMember:value name:@"member" rules:memberRules isPayloadType:NO xmlWriter:xmlWriter error:&blockErr]) {
                *stop = YES;
                isValid = NO;
                return ;
            }
        }];
        [xmlWriter writeEndElement:xmlListName];
    }
    if (error) *error = blockErr;
    return isValid;
}
+ (BOOL)serializeMember:(id)params name:(NSString *)memberName rules:(AWSJSONDictionary *)rules isPayloadType:(Boolean)isPayloadType xmlWriter:(AWSXMLWriter *)xmlWriter error:(NSError *__autoreleasing *)error {
    NSString *xmlElementName = rules[@"locationName"]?rules[@"locationName"]:memberName;
    NSString *rulesType = rules[@"type"];
    if ([rulesType isEqualToString:@"structure"]) {
        [xmlWriter writeStartElement:xmlElementName];
        [self applyNamespacesAndAttributesByRules:rules params:params xmlWriter:xmlWriter];
        [self serializeStructure:params rules:rules xmlWriter:xmlWriter error:error isRootRule:NO];
        [xmlWriter writeEndElement:xmlElementName];
    } else if ([rulesType isEqualToString:@"list"]) {
        [self serializeList:params name:memberName rules:rules xmlWriter:xmlWriter error:error];
    } else if ([rulesType isEqualToString:@"map"]) {
    } else if ([rulesType isEqualToString:@"timestamp"]) {
        NSString *timestampStr = [AWSXMLTimestampSerialization serializeTimestamp:rules value:params error:error];
        if (isPayloadType == NO) [xmlWriter writeStartElement:xmlElementName];
        [xmlWriter writeCharacters:timestampStr];
        if (isPayloadType == NO) [xmlWriter writeEndElement:xmlElementName];
    } else if ([rulesType isEqualToString:@"integer"] || [rulesType isEqualToString:@"long"] || [rulesType isEqualToString:@"float"] || [rulesType isEqualToString:@"double"]) {
        NSNumber *numberValue = params;
        if (isPayloadType == NO) [xmlWriter writeStartElement:xmlElementName];
        [xmlWriter writeCharacters:[numberValue stringValue]];
        if (isPayloadType == NO) [xmlWriter writeEndElement:xmlElementName];
    } else if ([rulesType isEqualToString:@"blob"]) {
        if ([rules[@"streaming"] boolValue] == NO) {
            if ([params isKindOfClass:[NSString class]]) {
                params = [params dataUsingEncoding:NSUTF8StringEncoding];
            }
            if ([params isKindOfClass:[NSData class]]) {
                if (isPayloadType == NO) {
                    NSString *base64encodedStr = [params base64EncodedStringWithOptions:0];
                    [xmlWriter writeStartElement:xmlElementName];
                    [xmlWriter writeCharacters:base64encodedStr];
                    [xmlWriter writeEndElement:xmlElementName];
                } else {
                    NSString* utf8String = [[NSString alloc] initWithData:params encoding:NSUTF8StringEncoding];
                    [xmlWriter writeCharacters:utf8String?utf8String:@""];
                }
            } else {
                [self failWithCode:AWSXMLBuilderInvalidXMLValue description:@"'blob' value should be a NSData type." error:error];
                return NO;
            }
        }
    } else if ([rulesType isEqualToString:@"boolean"]) {
        if (isPayloadType == NO) [xmlWriter writeStartElement:xmlElementName];
        [xmlWriter writeCharacters:[params boolValue]?@"true":@"false"];
        if (isPayloadType == NO) [xmlWriter writeEndElement:xmlElementName];
    } else if ([rulesType isEqualToString:@"string"]) {
        if (isPayloadType == NO) [xmlWriter writeStartElement:xmlElementName];
        [xmlWriter writeCharacters:params];
        if (isPayloadType == NO) [xmlWriter writeEndElement:xmlElementName];
    } else {
        [self failWithCode:AWSXMLBuilderUnCatchedRuleTypeInDifinitionFile description:[NSString stringWithFormat:@"uncatched ruletype:%@ for value:%@",rulesType,[params description]] error:error];
        return NO;
    }
    return YES;
}
+ (void)applyNamespacesAndAttributesByRules:(NSDictionary *)rules params:(id)params xmlWriter:(AWSXMLWriter *)xmlWriter {
    id xmlNamespaceValue = rules[@"xmlNamespace"];
    if (xmlNamespaceValue) {
        if ([xmlNamespaceValue isKindOfClass:[NSDictionary class]]) {
            NSString *xmlnsName = @"xmlns";
            if (xmlNamespaceValue[@"prefix"]) {
                xmlnsName = [xmlnsName stringByAppendingString:[NSString stringWithFormat:@":%@",xmlNamespaceValue[@"prefix"]]];
            }
            [xmlWriter writeAttribute:xmlnsName value:xmlNamespaceValue[@"uri"]];
        } else if ([xmlNamespaceValue isKindOfClass:[NSString class]]) {
            NSString *xmlnsName = @"xmlns";
            [xmlWriter writeAttribute:xmlnsName value:xmlNamespaceValue];
        }
    }
    if ([rules[@"members"][@"Type"][@"xmlAttribute"] boolValue]) {
        NSString *xmlName = rules[@"members"][@"Type"][@"locationName"];
        if (params[@"Type"]) {
            [xmlWriter writeAttribute:xmlName value:params[@"Type"]];
        }
    }
}
@end
@interface AWSXMLParser ()
@property (nonatomic, strong) AWSXMLDictionaryParser *xmlDictionaryParser;
@end
@implementation AWSXMLParser
+ (AWSXMLParser *)sharedInstance {
    static dispatch_once_t once;
    static AWSXMLParser *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [AWSXMLParser new];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (self = [super init]) {
        _xmlDictionaryParser = [AWSXMLDictionaryParser new];
        _xmlDictionaryParser.trimWhiteSpace = NO;
        _xmlDictionaryParser.attributesMode = AWSXMLDictionaryAttributesModeDiscard; 
        _xmlDictionaryParser.stripEmptyNodes = NO;
        _xmlDictionaryParser.wrapRootNode = YES; 
        _xmlDictionaryParser.nodeNameMode = AWSXMLDictionaryNodeNameModeNever; 
    }
    return self;
}
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSXMLParserErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (NSMutableDictionary *)preprocessDictionary:(NSMutableDictionary *)fromDictionary operationName:(NSString *)operationName actionRule:(NSDictionary *)actionRule serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule {
    NSString *serviceTypeStr = serviceDefinitionRule[@"metadata"][@"type"]?serviceDefinitionRule[@"metadata"][@"type"]:serviceDefinitionRule[@"metadata"][@"protocol"];
    if ([serviceTypeStr isEqualToString:@"query"]) {
        NSNumber *isResultWrapped = serviceDefinitionRule[@"metadata"][@"resultWrapped"];
        if (isResultWrapped && ![isResultWrapped boolValue]) {
            return fromDictionary;
        } else {
            if (actionRule[@"resultWrapper"] && fromDictionary[actionRule[@"resultWrapper"]]) {
                return fromDictionary[actionRule[@"resultWrapper"]];
            } else if ([operationName stringByAppendingString:@"Result"] && fromDictionary[[operationName stringByAppendingString:@"Result"]]){
                return fromDictionary[[operationName stringByAppendingString:@"Result"]];
            } else {
                return fromDictionary;
            }
        }
    } else if ([serviceTypeStr isEqualToString:@"rest-xml"]) {
        return fromDictionary;
    } else if ([serviceTypeStr isEqualToString:@"json"]) {
        return fromDictionary;
    } else if ([serviceTypeStr isEqualToString:@"rest-json"]) {
        return fromDictionary;
    } else {
        return fromDictionary;
    }
}
- (NSMutableDictionary *)dictionaryForXMLData:(NSData *)data
                                   actionName:(NSString *)actionName
                        serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                        error:(NSError *__autoreleasing *)error {
    if (!data) {
        return [NSMutableDictionary new];
    }
    NSDictionary *actionRule = [[[serviceDefinitionRule objectForKey:@"operations"] objectForKey:actionName] objectForKey:@"output"];
    if (actionRule == (id)[NSNull null]) {
        actionRule = @{};
    }
    NSDictionary *definitionRules = [serviceDefinitionRule objectForKey:@"shapes"];
    if (definitionRules == (id)[NSNull null]) {
        definitionRules = @{};
    }
    if ([definitionRules count] == 0) {
        if (error) {
            *error = [NSError errorWithDomain:AWSXMLParserErrorDomain
                                         code:AWSXMLParserDefinitionFileIsEmpty
                                     userInfo:@{
                                                NSLocalizedDescriptionKey : @"JSON definition File is empty or can not be found"
                                                }];
        }
        return nil;
    }
    NSMutableDictionary *rootXmlDictionary = nil;
    if ([data isKindOfClass:[NSData class]]) {
        @synchronized (self) {
            rootXmlDictionary = [[self.xmlDictionaryParser dictionaryWithData:data] mutableCopy]; 
        }
    }
    NSString *rootNodeName = [[rootXmlDictionary allKeys] firstObject];
    NSMutableDictionary *xmlDictionary = ([rootXmlDictionary[rootNodeName] isKindOfClass:[NSDictionary class]] && [rootXmlDictionary[rootNodeName] count] > 0)?rootXmlDictionary[rootNodeName]:rootXmlDictionary;
    if (*error) {
        return nil;
    } else if ([rootNodeName isEqualToString:@"Error"]) {
        return [@{rootNodeName:xmlDictionary} mutableCopy];
    } else if ([xmlDictionary objectForKey:@"Errors"]) {
        if ([[xmlDictionary objectForKey:@"Errors"] isKindOfClass:[NSDictionary class]]) {
            return [xmlDictionary objectForKey:@"Errors"];
        } else if  ([[xmlDictionary objectForKey:@"Errors"] isKindOfClass:[NSArray class]]) {
            return [[xmlDictionary objectForKey:@"Errors"] firstObject];
        }
        return nil;
    }else if ([xmlDictionary objectForKey:@"Error"]) {
        return [xmlDictionary mutableCopy];
    }else {
        AWSJSONDictionary *rules = [[AWSJSONDictionary alloc] initWithDictionary:actionRule JSONDefinitionRule:definitionRules];
        xmlDictionary = [AWSXMLParser preprocessDictionary:xmlDictionary operationName:actionName actionRule:rules serviceDefinitionRule:serviceDefinitionRule];
        NSString *isPayloadData = rules[@"payload"];
        rules = rules[@"members"]?rules[@"members"]:@{};
        NSMutableDictionary *parsedData = [NSMutableDictionary new];
        if (isPayloadData) {
            if (rules[isPayloadData][@"streaming"]) {
                parsedData[isPayloadData] = data;
                return parsedData;
            }
            rules = rules[isPayloadData][@"members"];
            parsedData[isPayloadData] = [AWSXMLParser parseStructure:xmlDictionary rules:rules error:error];
        } else {
            parsedData = [AWSXMLParser parseStructure:xmlDictionary rules:rules error:error];
        }
        if ([parsedData count] == 0) {
            NSString *serviceTypeStr = serviceDefinitionRule[@"metadata"][@"type"]?serviceDefinitionRule[@"metadata"][@"type"]:serviceDefinitionRule[@"metadata"][@"protocol"];
            if ([serviceTypeStr isEqualToString:@"rest-xml"]) {
                xmlDictionary = [AWSXMLParser preprocessDictionary:xmlDictionary operationName:actionName actionRule:actionRule serviceDefinitionRule:serviceDefinitionRule];
                parsedData = [AWSXMLParser parseStructure:xmlDictionary rules:rules error:error];
            }
        }
        return parsedData;
    };
}
+ (NSString *)findKeyNameByXMLName:(NSString *)xmlName rules:(NSDictionary *)rules {
    __block NSString *result;
    [rules enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([key isEqualToString:xmlName]) {
            result = key;
            *stop = YES;
            return;
        }
        if ([obj isKindOfClass:[NSDictionary class]] && ([obj[@"type"] isEqualToString:@"list"] || [obj[@"type"] isEqualToString:@"map"])) {
            if ([obj[@"flattened"] boolValue]) {
                NSString *objXMLName = obj[@"member"][@"locationName"]?obj[@"member"][@"locationName"]:obj[@"locationName"];
                objXMLName = objXMLName?objXMLName:@"member";
                if ([xmlName isEqualToString:objXMLName]) {
                    result = key;
                    *stop = YES;
                    return;
                }
            } else {
                if ([xmlName isEqualToString:obj[@"locationName"]]) {
                    result = key;
                    *stop = YES;
                    return;
                }
            }
        }
        if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"locationName"]) {
            if ([xmlName isEqualToString:[obj objectForKey:@"locationName"]]) {
                result = key;
                *stop = YES;
                return;
            }
        }
    }];
    return result;
}
+ (BOOL)validateConstraint:(id)value rules:(NSDictionary *)rules error:(NSError *__autoreleasing *)error {
    return YES;
}
+ (NSMutableDictionary *)parseStructure:(NSDictionary *)structure rules:(AWSJSONDictionary *)rules error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (![self validateConstraint:structure rules:rules error:error]) {
        return data;
    }
    __block NSError *blockErr = nil;
    [structure enumerateKeysAndObjectsUsingBlock:^(NSString *xmlName, id value, BOOL *stop) {
        if ([xmlName isEqualToString:@"$"]) {
        } else {
            NSString *keyName = [self findKeyNameByXMLName:xmlName rules:rules];
            if (!keyName) {
                if (![xmlName isEqualToString:@"_xmlns"] &&
                    ![xmlName isEqualToString:@"requestId"] &&
                    ![xmlName isEqualToString:@"ResponseMetadata"] &&
                    ![xmlName isEqualToString:@"__text"]) {
                    AWSDDLogWarn(@"Response element ignored: no rule for %@ - %@", xmlName, [value description]);
                }
                return;
            }
            AWSJSONDictionary *rule = rules[keyName];
            if ([rules count] == 0) {
                [self failWithCode:AWSXMLParserUnexpectedXMLElement description:[NSString stringWithFormat:@"Unexpected XML Element found:%@",xmlName] error:&blockErr];
                *stop = YES;
            } else {
                NSString *dicName = rule[@"name"]?rule[@"name"]:keyName;
                data[dicName] = [self parseMember:value rules:rule error:&blockErr];
                if (blockErr) *stop = YES;
            }
        }
    }];
    if (error) *error = blockErr;
    return data;
}
+ (NSMutableDictionary *)parseMap:(id)map rules:(AWSJSONDictionary *)rules error:(NSError *__autoreleasing *)error {
    AWSJSONDictionary *keyRules = rules[@"key"]?rules[@"key"]:@{};
    AWSJSONDictionary *valueRules = rules[@"value"]?rules[@"value"]:@{};
    NSString *keyName = keyRules[@"locationName"]?keyRules[@"locationName"]:@"key";
    NSString *valueName = valueRules[@"locationName"]?valueRules[@"locationName"]:@"value";
    __block NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (![self validateConstraint:map rules:rules error:error]) return data;
    NSArray *mapList = nil;
    if ([rules[@"flattened"] boolValue] == NO) {
        if ([map isKindOfClass:[NSDictionary class]] && [map objectForKey:@"entry"]) {
            mapList = [map objectForKey:@"entry"];
        } else {
            mapList = map;
        }
    } else {
        mapList = map;
    }
    if (!mapList) {
        return data;
    }
    if ([mapList isKindOfClass:[NSDictionary class]]) {
        mapList = @[mapList];
    }
    if (![mapList isKindOfClass:[NSArray class]]) {
        [self failWithCode:AWSXMLParserUnExpectedType description:[NSString stringWithFormat:@"xml(mapList type) should be an array but got:%@",NSStringFromClass([mapList class])] error:error];
        return [NSMutableDictionary new];
    } else {
        __block NSError *blockErr = nil;
        [mapList enumerateObjectsUsingBlock:^(id entry, NSUInteger idx, BOOL *stop) {
            NSString *dataKeyName = entry[keyName];
            if (dataKeyName) {
                data[dataKeyName] = [self parseMember:entry[valueName] rules:valueRules error:&blockErr];
                if (blockErr) *stop = YES;
            }
        }];
        if (error) *error = blockErr;
        return data;
    }
}
+ (NSArray *)parseList:(id)list rules:(AWSJSONDictionary *)rules error:(NSError *__autoreleasing *)error {
    AWSJSONDictionary *memberRules = rules[@"member"]?rules[@"member"]:@{};
    __block NSMutableArray *data = [NSMutableArray array];
    if (![self validateConstraint:list rules:rules error:error]) return data;
    __block NSError *blockErr = nil;
    if (![rules[@"flattened"] boolValue]) {
        NSString *memberName = memberRules[@"locationName"]?memberRules[@"locationName"]:@"member";
        if (![list isKindOfClass:[NSDictionary class]]) {
            [self failWithCode:AWSXMLParserUnExpectedType description:[NSString stringWithFormat:@"unflattened xml(list type) should be dictionary but got:%@",NSStringFromClass([list class])] error:error];
            return @[];
        }
        if ([list count] == 0) {
            return @[];
        }
        list = list[memberName];
        if (!list) {
            [self failWithCode:AWSXMLParserUnExpectedType description:[NSString stringWithFormat:@"Can not find the '%@' key-pair in un-falttened xml list type",memberName] error:error];
            return @[@"XMLPARSER:ERROR"];
        }
    }
    if ([list isKindOfClass:[NSDictionary class]]) {
        list = @[list];
    }
    if (![list isKindOfClass:[NSArray class]]) {
        return @[list];
    }
    [list enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
        [data addObject:[self parseMember:value rules:memberRules error:&blockErr]];
        if (blockErr) *stop = YES;
    }];
    if (error) *error = blockErr;
    return data;
}
+ (id)parseMember:(id)values rules:(AWSJSONDictionary *)rules error:(NSError *__autoreleasing *)error {
    NSString *rulesType = rules[@"type"];
    if (!values) {
        if ([rulesType isEqualToString:@"structure"]) return @{};
        if ([rulesType isEqualToString:@"list"]) return @[];
        if ([rulesType isEqualToString:@"map"]) return @{};
        return @"XMLPARSER:ERROR";
    }
    if (!rulesType) {
        [self failWithCode:AWSXMLParserNoTypeDefinitionInRule description:[NSString stringWithFormat:@"can not find the 'type' keywords in definition file:%@ for value:%@",[rules description],[values description]] error:error];
        return @"XMLPARSER:ERROR";
    }
    if (![self validateConstraint:values rules:rules error:error]) return @"XMLPARSER:ERROR";
    if ([rulesType isEqualToString:@"string"] || [rulesType isEqualToString:@"character"]) {
        if ([values isKindOfClass:[NSString class]]) {
            return values;
        } else if ([values isKindOfClass:[NSDictionary class]] && [values count] == 0) {
            return @"";
        } else {
            return [values description];
        }
    } else if ([rulesType isEqualToString:@"structure"]) {
        return [self parseStructure:values rules:rules[@"members"]?rules[@"members"]:@{} error:error];
    } else if ([rulesType isEqualToString:@"list"]) {
        return [self parseList:values rules:rules error:error];
    } else if ([rulesType isEqualToString:@"map"]) {
        return [self parseMap:values rules:rules error:error];
    } else if ([rulesType isEqualToString:@"integer"] || [rulesType isEqualToString:@"long"]) {
        if ([values isKindOfClass:[NSNumber class]]) {
            return values;
        } else if ([values isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithInteger:[values integerValue]];
        }
    } else if ([rulesType isEqualToString:@"float"] || [rulesType isEqualToString:@"double"]) {
        if ([values isKindOfClass:[NSNumber class]]) {
            return values;
        } else if ([values isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithDouble:[values doubleValue]];
        }
    } else if ([rulesType isEqualToString:@"boolean"]) {
        if ([values isKindOfClass:[NSNumber class]]) {
            return values;
        } else if ([values isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithBool:[values boolValue]];
        }
    } else if ([rulesType isEqualToString:@"timestamp"]) {
        NSString *timestampStr = [AWSQueryTimestampSerialization serializeTimestamp:rules value:values error:error];
        return timestampStr;
    } else if ([rulesType isEqualToString:@"blob"]) {
        if ([values isKindOfClass:[NSString class]]) {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:values options:0];
            return decodedData?decodedData:values;
        } else {
            [self failWithCode:AWSXMLParserInvalidXMLValue description:@"blob value should be NSString type" error:error];
            return [NSData new];
        }
    }
    [self failWithCode:AWSXMLParserUnHandledType description:[NSString stringWithFormat:@"unhandled type for value:%@",[values description]] error:error];
    return @"XMLPARSER:ERROR";
}
@end
@implementation AWSQueryParamBuilder
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSQueryParamBuilderErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (NSDictionary *)buildFormattedParams:(NSDictionary *)params
                            actionName:(NSString *)actionName
                 serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                 error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *formattedParams = [NSMutableDictionary new];
    NSString *urlEncodedActionName = [actionName aws_stringWithURLEncoding];
    if (!urlEncodedActionName) {
        AWSDDLogError(@"actionName is nil!");
        [self failWithCode:AWSQueryParamBuilderUndefinedActionRule description:@"actionName is nil" error:error];
        return nil;
    }
    [formattedParams setObject:urlEncodedActionName forKey:@"Action"];
    if (serviceDefinitionRule[@"metadata"] && serviceDefinitionRule[@"metadata"][@"apiVersion"] && [serviceDefinitionRule[@"metadata"][@"apiVersion"] isKindOfClass:[NSString class]]) {
        NSString *urlEncodedAPIVersion = [serviceDefinitionRule[@"metadata"][@"apiVersion"] aws_stringWithURLEncoding];
        if (urlEncodedAPIVersion) {
            [formattedParams setObject:urlEncodedAPIVersion forKey:@"Version"];
        } else {
            AWSDDLogError(@"can not encode APIVersion String:%@",urlEncodedAPIVersion);
        }
    } else {
        AWSDDLogError(@"can not find apiVersion keyword in definition file!");
    }
    if ([params count] == 0) {
        return formattedParams;
    }
    NSDictionary *actionRule = [[[serviceDefinitionRule objectForKey:@"operations"] objectForKey:actionName] objectForKey:@"input"];
    NSDictionary *definitionRules = [serviceDefinitionRule objectForKey:@"shapes"];
    if (definitionRules == (id)[NSNull null] ||  [definitionRules count] == 0) {
        [self failWithCode:AWSQueryParamBuilderDefinitionFileIsEmpty description:@"JSON definition File is empty or can not be found" error:error];
        return nil;
    }
    if ([actionRule count] == 0) {
        [self failWithCode:AWSQueryParamBuilderUndefinedActionRule description:@"Invalid argument: actionRule is Empty" error:error];
        return nil;
    }
    AWSJSONDictionary *rules = [[AWSJSONDictionary alloc] initWithDictionary:actionRule JSONDefinitionRule:definitionRules];
    [AWSQueryParamBuilder serializeStructure:params rules:rules prefix:@"" formattedParams:formattedParams  error:error];
    return formattedParams;
}
+ (BOOL)serializeStructure:(NSDictionary *)values rules:(AWSJSONDictionary *)structureRules prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    for (NSString *name in values) {
        id value = values[name];
        AWSJSONDictionary *memberShape = structureRules[@"members"][name];
        if (memberShape && value) {
            [self serializeMember:value rules:memberShape prefix:[NSString stringWithFormat:@"%@%@",prefix,[self queryName:memberShape withDefaultName:name]] formattedParams:formattedParams error:error];
            if (error && *error != nil) {
                return NO;
            }
        }
    }
    return YES;
}
+ (BOOL)serializeList:(NSArray *)values rules:(AWSJSONDictionary *)listRules prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    if (values == nil) {
        if (prefix) {
            [formattedParams setObject:prefix forKey:@""];
        }
        return YES;
    }
    if ([listRules[@"flattened"] boolValue]) {
        NSString *memberName = [self queryName:listRules[@"member"] withDefaultName:nil];
        if (memberName) {
            NSMutableArray *parts = [[prefix componentsSeparatedByString:@"."] mutableCopy];
            if (parts) {
                [parts removeLastObject];
                [parts addObject:memberName];
                prefix = [[parts componentsJoinedByString:@"."] mutableCopy];
            }
        }
    } else {
        prefix = [prefix stringByAppendingString:@".member"];
    }
    for (int i = 0; i < [values count]; i++) {
        id value = values[i];
        [self serializeMember:value rules:listRules[@"member"] prefix:[NSString stringWithFormat:@"%@.%d",prefix,i+1] formattedParams:formattedParams error:error];
        if (error && *error != nil) {
            return NO;
        }
    }
    return YES;
}
+ (BOOL)serializeMap:(NSDictionary *)values rules:(AWSJSONDictionary *)mapRules prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    if ([mapRules[@"flattened"] boolValue] == NO) {
        prefix = [prefix stringByAppendingString:@".entry"];
    }
    NSArray *allKeysArray = [[values allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    int index = 0;
    for (NSString *key in allKeysArray) {
        id value = values[key];
        [self serializeMember:key rules:mapRules[@"key"] prefix:[NSString stringWithFormat:@"%@.%d.%@",prefix,index+1,[self queryName:mapRules[@"key"] withDefaultName:@"key"]] formattedParams:formattedParams error:error];
        if (error && *error != nil) return NO;
        [self serializeMember:value rules:mapRules[@"value"] prefix:[NSString stringWithFormat:@"%@.%d.%@",prefix,index+1,[self queryName:mapRules[@"value"] withDefaultName:@"value"]] formattedParams:formattedParams error:error];
        if (error && *error != nil) return NO;
        index++;
    }
    return YES;
}
+ (BOOL)serializeMember:(id)value rules:(AWSJSONDictionary *)shape prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    if (prefix == nil) {
        prefix = @"";
    }
    NSString *rulesType = shape[@"type"];
    if ([rulesType isEqualToString:@"structure"]) {
        [self serializeStructure:value rules:shape prefix:[NSString stringWithFormat:@"%@.",prefix] formattedParams:formattedParams error:error];
    } else if ([rulesType isEqualToString:@"list"]) {
        [self serializeList:value rules:shape prefix:prefix formattedParams:formattedParams error:error];
    } else if ([rulesType isEqualToString:@"map"]) {
        [self serializeMap:value rules:shape prefix:prefix formattedParams:formattedParams error:error];
    } else if ([rulesType isEqualToString:@"timestamp"]) {
        NSString *timestampStr = [AWSQueryTimestampSerialization serializeTimestamp:shape value:value error:error];
        formattedParams[prefix] = timestampStr;
    } else if ([rulesType isEqualToString:@"blob"]) {
        if ([value isKindOfClass:[NSString class]]) {
            value = [value dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([value isKindOfClass:[NSData class]]) {
            NSString *base64encodedStr = [value base64EncodedStringWithOptions:0];
            formattedParams[prefix] = base64encodedStr?base64encodedStr:@"";
        } else {
            [self failWithCode:AWSQueryParamBuilderInvalidParameter description:@"'blob' value should be a NSData type." error:error];
            return NO;
        }
    } else if ([rulesType isEqualToString:@"boolean"]) {
        formattedParams[prefix] = [value boolValue]?@"true":@"false";
    } else {
        formattedParams[prefix] = value;
    }
    return YES;
}
+ (NSString *)queryName:(NSDictionary *)shape withDefaultName:(NSString *)defaultName {
    return shape[@"locationName"]?shape[@"locationName"]:defaultName;
}
@end
@implementation AWSEC2ParamBuilder
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSEC2ParamBuilderErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (NSDictionary *)buildFormattedParams:(NSDictionary *)params
                            actionName:(NSString *)actionName
                 serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                 error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *formattedParams = [NSMutableDictionary new];
    NSString *urlEncodedActionName = [actionName aws_stringWithURLEncoding];
    if (!urlEncodedActionName) {
        AWSDDLogError(@"actionName is nil!");
        [self failWithCode:AWSEC2ParamBuilderUndefinedActionRule description:@"actionName is nil" error:error];
        return nil;
    }
    [formattedParams setObject:urlEncodedActionName forKey:@"Action"];
    if (serviceDefinitionRule[@"metadata"] && serviceDefinitionRule[@"metadata"][@"apiVersion"] && [serviceDefinitionRule[@"metadata"][@"apiVersion"] isKindOfClass:[NSString class]]) {
        NSString *urlEncodedAPIVersion = [serviceDefinitionRule[@"metadata"][@"apiVersion"] aws_stringWithURLEncoding];
        if (urlEncodedAPIVersion) {
            [formattedParams setObject:urlEncodedAPIVersion forKey:@"Version"];
        } else {
            AWSDDLogError(@"can not encode APIVersion String:%@",urlEncodedAPIVersion);
        }
    } else {
        AWSDDLogError(@"can not find apiVersion keyword in definition file!");
    }
    if ([params count] == 0) {
        return formattedParams;
    }
    NSDictionary *actionRule = [[[serviceDefinitionRule objectForKey:@"operations"] objectForKey:actionName] objectForKey:@"input"];
    NSDictionary *definitionRules = [serviceDefinitionRule objectForKey:@"shapes"];
    if (definitionRules == (id)[NSNull null] ||  [definitionRules count] == 0) {
        [self failWithCode:AWSEC2ParamBuilderDefinitionFileIsEmpty description:@"JSON definition File is empty or can not be found" error:error];
        return nil;
    }
    if ([actionRule count] == 0) {
        [self failWithCode:AWSEC2ParamBuilderUndefinedActionRule description:@"Invalid argument: actionRule is Empty" error:error];
        return nil;
    }
    AWSJSONDictionary *rules = [[AWSJSONDictionary alloc] initWithDictionary:actionRule JSONDefinitionRule:definitionRules];
    [AWSEC2ParamBuilder serializeStructure:params rules:rules prefix:@"" formattedParams:formattedParams  error:error];
    return formattedParams;
}
+ (BOOL)serializeStructure:(NSDictionary *)values rules:(AWSJSONDictionary *)structureRules prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    for (NSString *name in values) {
        id value = values[name];
        AWSJSONDictionary *memberShape = structureRules[@"members"][name];
        if (memberShape && value) {
            [self serializeMember:value rules:memberShape prefix:[NSString stringWithFormat:@"%@%@",prefix,[self queryName:memberShape withDefaultName:name]] formattedParams:formattedParams error:error];
            if (error && *error != nil) {
                return NO;
            }
        }
    }
    return YES;
}
+ (BOOL)serializeList:(NSArray *)values rules:(AWSJSONDictionary *)listRules prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    if (values == nil) {
        if (prefix) {
            [formattedParams setObject:prefix forKey:@""];
        }
        return YES;
    }
    for (int i = 0; i < [values count]; i++) {
        id value = values[i];
        [self serializeMember:value rules:listRules[@"member"] prefix:[NSString stringWithFormat:@"%@.%d",prefix,i+1] formattedParams:formattedParams error:error];
        if (error && *error != nil) {
            return NO;
        }
    }
    return YES;
}
+ (BOOL)serializeMember:(id)value rules:(AWSJSONDictionary *)shape prefix:(NSString *)prefix formattedParams:(NSMutableDictionary *)formattedParams error:(NSError *__autoreleasing *)error {
    if (prefix == nil) {
        prefix = @"";
    }
    NSString *rulesType = shape[@"type"];
    if ([rulesType isEqualToString:@"structure"]) {
        [self serializeStructure:value rules:shape prefix:[NSString stringWithFormat:@"%@.",prefix] formattedParams:formattedParams error:error];
    } else if ([rulesType isEqualToString:@"list"]) {
        [self serializeList:value rules:shape prefix:prefix formattedParams:formattedParams error:error];
    } else if ([rulesType isEqualToString:@"map"]) {
        [self failWithCode:AWSEC2ParamBuilderInternalError description:@"serialize map type value has not been implemented yet" error:error];
        return NO;
    } else if ([rulesType isEqualToString:@"timestamp"]) {
        NSString *timestampStr = [AWSEC2TimestampSerialization serializeTimestamp:shape value:value  error:error];
        formattedParams[prefix] = timestampStr;
    } else if ([rulesType isEqualToString:@"blob"]) {
        if ([value isKindOfClass:[NSString class]]) {
            value = [value dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([value isKindOfClass:[NSData class]]) {
            NSString *base64encodedStr = [value base64EncodedStringWithOptions:0];
            formattedParams[prefix] = base64encodedStr?base64encodedStr:@"";
        } else {
            [self failWithCode:AWSEC2ParamBuilderInvalidParameter description:@"'blob' value should be a NSData type." error:error];
            return NO;
        }
    } else if ([rulesType isEqualToString:@"boolean"]) {
        formattedParams[prefix] = [value boolValue]?@"true":@"false";
    } else {
        formattedParams[prefix] = value;
    }
    return YES;
}
+ (NSString *)queryName:(NSDictionary *)shape withDefaultName:(NSString *)defaultName {
    NSString *resultStr = shape[@"queryName"]?shape[@"queryName"]:[self upperCaseFirstChar:shape[@"locationName"]];
    return resultStr?resultStr:defaultName;
}
+ (NSString *)upperCaseFirstChar:(NSString *) inputString {
    if ([inputString length] < 1) {
        return nil;
    }
    return [[[inputString substringToIndex:1] uppercaseString] stringByAppendingString: [inputString length]>1 ? [inputString substringFromIndex:1] : @"" ];
}
@end
@implementation AWSJSONBuilder
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSJSONBuilderErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (NSData *)jsonDataForDictionary:(NSDictionary *)params
                       actionName:(NSString *)actionName
            serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                            error:(NSError *__autoreleasing *)error {
    id serializedJsonObject = [self buildJSONDictionary:params actionName:actionName serviceDefinitionRule:serviceDefinitionRule error:error];
    if (!serializedJsonObject) {
        serializedJsonObject = @{};
    }
    if ([NSJSONSerialization isValidJSONObject:serializedJsonObject] == NO) {
        if ([serializedJsonObject isKindOfClass:[NSData class]]) {
            return serializedJsonObject;
        } else {
            [self failWithCode:AWSJSONBuilderInvalidParameter description:[NSString stringWithFormat:@"serialized object is neither a valid json Object nor NSData object: %@",serializedJsonObject] error:error];
            return nil;
        }
    } else {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:serializedJsonObject
                                                           options:0
                                                             error:error];
        return bodyData;
    }
}
+ (NSDictionary *)buildJSONDictionary:(NSDictionary *)params
                           actionName:(NSString *)actionName
                serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                error:(NSError *__autoreleasing *)error {
    if ([params count] == 0) {
        return nil;
    }
    NSDictionary *actionRule = [[[serviceDefinitionRule objectForKey:@"operations"] objectForKey:actionName] objectForKey:@"input"];
    NSDictionary *definitionRules = [serviceDefinitionRule objectForKey:@"shapes"];
    if (definitionRules == (id)[NSNull null] ||  [definitionRules count] == 0) {
        AWSDDLogError(@"JSON definition File is empty or can not be found, will return un-serialized dictionary");
        return params;
    }
    if ([actionRule count] == 0) {
        [self failWithCode:AWSJSONBuilderUndefinedActionRule description:@"Invalid argument: actionRule is Empty" error:error];
        return nil;
    }
    AWSJSONDictionary *rules = [[AWSJSONDictionary alloc] initWithDictionary:actionRule JSONDefinitionRule:definitionRules];
    id resultParams = [self serializeMember:rules value:params isPayloadType:NO error:error];
    return resultParams;
}
+ (NSDictionary *)serializeStructure:(NSDictionary *)structureRules values:(NSDictionary *)values error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *data = [NSMutableDictionary new];
    for (NSString *key in values) {
        id value = values[key];
        AWSJSONDictionary *memberShape = structureRules[@"members"][key];
        if (memberShape[@"location"]) {
            continue;
        }
        if (memberShape && value) {
            NSString *name = memberShape[@"locationName"]?memberShape[@"locationName"]:key;
            data[name] = [self serializeMember:memberShape value:value isPayloadType:NO error:error];
        }
    }
    return data;
}
+ (NSArray *)serializeList:(NSDictionary *)listRules values:(NSArray *)values error:(NSError *__autoreleasing *)error {
    NSMutableArray *dataArray = [NSMutableArray new];
    for (id value in values) {
        [dataArray addObject:[self serializeMember:listRules[@"member"] value:value isPayloadType:NO error:error]];
    }
    return dataArray;
}
+ (NSDictionary *)serializeMap:(NSDictionary *)mapRules values:(NSDictionary *)values error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *data = [NSMutableDictionary new];
    for (NSString *key in values) {
        id value = values[key];
        data[key] = [self serializeMember:mapRules[@"value"] value:value isPayloadType:NO error:error];
    }
    return data;
}
+ (id)serializeMember:(NSDictionary *)shape value:(id)value isPayloadType:(BOOL)isPayloadType error:(NSError *__autoreleasing *)error {
    NSString *payloadMemberName = shape[@"payload"];
    if (payloadMemberName) {
        id payload = value[payloadMemberName];
        if (payload) {
            AWSJSONDictionary *structureMembersRule = shape[@"members"]?shape[@"members"]:@{};
            AWSJSONDictionary *payloadMemberRules = structureMembersRule[payloadMemberName];
            return [self serializeMember:payloadMemberRules value:payload isPayloadType:YES error:error];
        }
    }
    NSString *rulesType = shape[@"type"];
    if ([rulesType isEqualToString:@"structure"]) {
        if (![value isKindOfClass:[NSDictionary class]]) {
            if (![value isKindOfClass:[NSNull class]]) {
                [self failWithCode:AWSJSONBuilderInvalidParameter description:[NSString stringWithFormat:@"a structure input should be a dictionary but got:%@",value] error:error];
            }
            return @{};
        } else {
            return [self serializeStructure:shape values:value error:error];
        }
    } else if ([rulesType isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            if (![value isKindOfClass:[NSNull class]]) {
                [self failWithCode:AWSJSONBuilderInvalidParameter description:[NSString stringWithFormat:@"a list input should be an array but got:%@",value] error:error];
            }
            return @[];
        } else {
            return [self serializeList:shape values:value error:error];
        }
    } else if ([rulesType isEqualToString:@"map"]) {
        if (![value isKindOfClass:[NSDictionary class]]) {
            if (![value isKindOfClass:[NSNull class]]) {
                [self failWithCode:AWSJSONBuilderInvalidParameter description:[NSString stringWithFormat:@"a map input should be a dictionary but got:%@",value] error:error];
            }
            return @{};
        } else {
            return [self serializeMap:shape values:value error:error];
        }
    } else if ([rulesType isEqualToString:@"timestamp"]) {
        NSString *timestampStr = [AWSJSONTimestampSerialization serializeTimestamp:shape value:value error:error];
        if ([shape[@"timestampFormat"] isEqualToString:@"iso8601"] || [shape[@"timestampFormat"] isEqualToString:@"rfc822"]) {
            return timestampStr;
        } else {
            return [NSNumber numberWithDouble:[timestampStr doubleValue]];
        }
    } else if ([rulesType isEqualToString:@"blob"]) {
        if ([value isKindOfClass:[NSString class]]) {
            value = [value dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([value isKindOfClass:[NSData class]]) {
            if (isPayloadType) {
                return value;
            } else {
                NSString *base64encodedStr = [value base64EncodedStringWithOptions:0];
                return base64encodedStr?base64encodedStr:@"";
            }
        } else {
            [self failWithCode:AWSJSONBuilderInvalidParameter description:@"'blob' value should be a NSData type." error:error];
            return @"";
        }
    } else {
        return value;
    }
}
@end
@implementation AWSJSONParser
+ (BOOL)failWithCode:(NSInteger)code description:(NSString *)description error:(NSError *__autoreleasing *)error {
    if (error) {
        *error = [NSError errorWithDomain:AWSJSONParserErrorDomain
                                     code:code
                                 userInfo:@{NSLocalizedDescriptionKey : description}];
    }
    return NO;
}
+ (NSDictionary *)dictionaryForJsonData:(NSData *)data
                               response:(NSHTTPURLResponse *)response
                             actionName:(NSString *)actionName
                  serviceDefinitionRule:(NSDictionary *)serviceDefinitionRule
                                  error:(NSError *__autoreleasing *)error {
    if (!data) {
        return [NSMutableDictionary new];
    }
    id result =  [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:error];
    NSDictionary *actionRule = [[[serviceDefinitionRule objectForKey:@"operations"] objectForKey:actionName] objectForKey:@"output"];
    if (actionRule == (id)[NSNull null]) {
        actionRule = @{};
    }
    NSDictionary *definitionRules = [serviceDefinitionRule objectForKey:@"shapes"];
    if (definitionRules == (id)[NSNull null]) {
        definitionRules = @{};
    }
    if ([definitionRules count] == 0) {
        AWSDDLogError(@"JSON definition File is empty or can not be found, will return un-serialized dictionary");
        return result;
    }
    if (response.statusCode/100 != 2) {
        return result;
    }
    AWSJSONDictionary *rules = [[AWSJSONDictionary alloc] initWithDictionary:actionRule JSONDefinitionRule:definitionRules];
    NSString *isPayloadData = rules[@"payload"];
    NSMutableDictionary *parsedData = [NSMutableDictionary new];
    if (isPayloadData) {
        NSString *shapeName = [rules[@"members"][isPayloadData] objectForKey:@"shape"];
        if ((rules[@"members"][isPayloadData][@"streaming"]) ||
                ([shapeName isEqual:@"JsonDocument"]) ||
                ([shapeName isEqual:@"BlobStream"]) ||
                ([shapeName isEqual:@"BodyBlob"])) {
            parsedData[isPayloadData] = data;
            if (error) *error = nil;
            return parsedData;
        }
        rules = rules[isPayloadData][@"members"];
        parsedData[isPayloadData] = [self serializeMember:rules value:result target:nil error:error];
    } else {
        parsedData = [self serializeMember:rules value:result target:nil error:error];
    }
    return parsedData;
}
+ (NSString *)findMemberName:(NSString*)locationName structureRules:(NSDictionary *)structureRules {
    for (NSString *aMember in structureRules[@"members"]) {
        NSDictionary *memberShape = structureRules[@"members"][aMember];
        if ([memberShape[@"locationName"] isEqualToString:locationName]) {
            return aMember;
        }
    }
    return locationName;
}
+ (id)serializeStructure:(NSDictionary *)structureRules values:(NSDictionary *)values target:(id)target error:(NSError *__autoreleasing *)error{
    if (!target) {
        target = [NSMutableDictionary new];
    }
    for (NSString *serialized_name in values) {
        id value = values[serialized_name];
        NSString *memberName = [self findMemberName:serialized_name structureRules:structureRules];
        AWSJSONDictionary *memberShape = structureRules[@"members"][memberName];
        if (memberShape && value) {
            target[memberName] = [self serializeMember:memberShape value:value target:nil error:(NSError *__autoreleasing *)error];
        }
    }
    return target;
}
+ (NSMutableArray *)serializeList:(NSDictionary *)listRules values:(NSDictionary *)values target:(id)target error:(NSError *__autoreleasing *)error{
    if (!target) {
        target = [NSMutableArray new];
    }
    for (NSString *value in values) {
        [target addObject:[self serializeMember:listRules[@"member"] value:value target:nil error:(NSError *__autoreleasing *)error]];
    }
    return target;
}
+ (NSMutableDictionary *) serializeMap:(NSDictionary *)mapRules values:(NSDictionary *)values target:(id)target error:(NSError *__autoreleasing *)error{
    if (!target) {
        target = [NSMutableDictionary new];
    }
    for (NSString *key in values) {
        id value = values[key];
        target[key] = [self serializeMember:mapRules[@"value"] value:value target:nil error:(NSError *__autoreleasing *)error];
    }
    return target;
}
+ (id)serializeMember:(NSDictionary *)shape value:(id)value target:(id)target error:(NSError *__autoreleasing *)error{
    if (!value) {
        return nil;
    }
    NSString *rulesType = shape[@"type"];
    if ([rulesType isEqualToString:@"structure"]) {
        if (![value isKindOfClass:[NSDictionary class]]) {
            if (![value isKindOfClass:[NSNull class]]) {
                [self failWithCode:AWSJSONParserInvalidParameter description:[NSString stringWithFormat:@"a structure input should be a dictionary but got:%@",value] error:error];
            }
            return @{};
        } else {
            return [self serializeStructure:shape values:value target:target error:error];
        }
    } else if ([rulesType isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            if (![value isKindOfClass:[NSNull class]]) {
                [self failWithCode:AWSJSONParserInvalidParameter description:[NSString stringWithFormat:@"a list input should be an array but got:%@",value] error:error];
            }
            return @[];
        } else {
            return [self serializeList:shape values:value target:target error:error];
        }
    } else if ([rulesType isEqualToString:@"map"]) {
        if (![value isKindOfClass:[NSDictionary class]]) {
            if (![value isKindOfClass:[NSNull class]]) {
                [self failWithCode:AWSJSONParserInvalidParameter description:[NSString stringWithFormat:@"a map input should be a dictionary but got:%@",value] error:error];
            }
            return @{};
        } else {
            return [self serializeMap:shape values:value target:target error:error];
        }
    } else if ([rulesType isEqualToString:@"timestamp"]) {
        NSString *timestampStr = [AWSJSONTimestampSerialization serializeTimestamp:shape value:value error:error];
        if ([shape[@"timestampFormat"] isEqualToString:@"iso8601"] || [shape[@"timestampFormat"] isEqualToString:@"rfc822"]) {
            NSDate *timeStampDate = [NSDate aws_dateFromString:timestampStr];
            return [NSNumber numberWithDouble:[timeStampDate timeIntervalSince1970]];
        } else {
            return [NSNumber numberWithDouble:[timestampStr doubleValue]];
        }
    } else if ([rulesType isEqualToString:@"blob"]) {
        if ([value isKindOfClass:[NSString class]]) {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:value options:0];
            return decodedData?decodedData:value;
        } else {
            [self failWithCode:AWSJSONParserInvalidParameter description:@"blob value should be NSString type." error:error];
            return [NSData new];
        }
    } else {
        return value;
    }
}
@end