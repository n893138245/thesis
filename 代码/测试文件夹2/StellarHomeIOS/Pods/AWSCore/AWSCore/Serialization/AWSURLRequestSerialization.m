#import "AWSURLRequestSerialization.h"
#import "AWSGZIP.h"
#import "AWSBolts.h"
#import "AWSNetworking.h"
#import "AWSValidation.h"
#import "AWSSerialization.h"
#import "AWSCategory.h"
#import "AWSCocoaLumberjack.h"
#import "AWSClientContext.h"
@interface NSMutableURLRequest (AWSRequestSerializer)
- (void)aws_validateHTTPMethodAndBody;
@end
@implementation NSMutableURLRequest (AWSRequestSerializer)
- (void)aws_validateHTTPMethodAndBody {
    if ([self.HTTPMethod isEqualToString:@"GET"]
        || [self.HTTPMethod isEqualToString:@"DELETE"]) {
        if (self.HTTPBody) {
            self.HTTPBody = nil;
        }
        if (self.HTTPBodyStream) {
            self.HTTPBodyStream = nil;
        }
    }
}
@end
@interface AWSJSONRequestSerializer()
@property (nonatomic, strong) NSDictionary *serviceDefinitionJSON;
@property (nonatomic, strong) NSString *actionName;
@end
@implementation AWSJSONRequestSerializer
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName {
    if (self = [super init]) {
        _serviceDefinitionJSON = JSONDefinition;
        if (_serviceDefinitionJSON == nil) {
            AWSDDLogError(@"serviceDefinitionJSON is nil.");
            return nil;
        }
        _actionName = actionName;
    }
    return self;
}
- (AWSTask *)serializeRequest:(NSMutableURLRequest *)request
                      headers:(NSDictionary *)headers
                   parameters:(NSDictionary *)parameters {
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    if ([parameters objectForKey:@"clientContext"]) {
        [request setValue:[[[parameters objectForKey:@"clientContext"] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:kNilOptions]
       forHTTPHeaderField:AWSClientContextHeader];
        [request setValue:@"base64"
       forHTTPHeaderField:AWSClientContextHeaderEncoding];
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        [mutableParameters removeObjectForKey:@"clientContext"];
        parameters = mutableParameters;
    }
    NSDictionary *actionRules = [[self.serviceDefinitionJSON objectForKey:@"operations"] objectForKey:self.actionName];
    NSDictionary *shapeRules = [self.serviceDefinitionJSON objectForKey:@"shapes"];
    AWSJSONDictionary *inputRules = [[AWSJSONDictionary alloc] initWithDictionary:[actionRules objectForKey:@"input"] JSONDefinitionRule:shapeRules];
    NSDictionary *actionHTTPRule = [actionRules objectForKey:@"http"];
    NSString *ruleURIStr = [actionHTTPRule objectForKey:@"requestUri"];
    NSDictionary *actionEndpoint = [actionRules objectForKey:@"endpoint"];
    NSString *endpointHostPrefix = [actionEndpoint objectForKey:@"hostPrefix"];
    NSError *error = nil;
    [AWSXMLRequestSerializer constructURIandHeadersAndBody:request
                                                     rules:inputRules
                                                parameters:parameters
                                                 uriSchema:ruleURIStr
                                                hostPrefix:endpointHostPrefix
                                                     error:&error];
    if (error) {
        return [AWSTask taskWithError:error];
    }
    if (!request.HTTPBodyStream) {
        NSData *bodyData = [AWSJSONBuilder jsonDataForDictionary:parameters actionName:self.actionName serviceDefinitionRule:self.serviceDefinitionJSON error:&error];
        if (!error) {
            if (headers[@"Content-Encoding"] && [headers[@"Content-Encoding"] rangeOfString:@"gzip"].location != NSNotFound) {
                request.HTTPBody = [bodyData awsgzip_gzippedData];
            } else {
                request.HTTPBody = bodyData;
            }
        }
    }
    [request aws_validateHTTPMethodAndBody];
    NSDictionary<NSString *, NSString *> *allHeaders = [request allHTTPHeaderFields];
    if (!error) {
        for (NSString *key in headers) {
            if(![allHeaders objectForKey:key])
                [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
        return [AWSTask taskWithResult:nil];
    }
    return [AWSTask taskWithError:error];
}
- (AWSTask *)validateRequest:(NSURLRequest *)request {
    return [AWSTask taskWithResult:nil];
}
@end
@interface AWSXMLRequestSerializer()
@property (nonatomic, strong) NSDictionary *serviceDefinitionJSON;
@property (nonatomic, strong) NSString *actionName;
@end
@implementation AWSXMLRequestSerializer
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName {
    if (self = [super init]) {
        _serviceDefinitionJSON = JSONDefinition;
        if (_serviceDefinitionJSON == nil) {
            AWSDDLogError(@"serviceDefinitionJSON is nil.");
            return nil;
        }
        _actionName = actionName;
    }
    return self;
}
- (AWSTask *)serializeRequest:(NSMutableURLRequest *)request
                      headers:(NSDictionary *)headers
                   parameters:(NSDictionary *)parameters {
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSDictionary *anActionRules = [[self.serviceDefinitionJSON objectForKey:@"operations"] objectForKey:self.actionName];
    NSDictionary *actionHTTPRule = [anActionRules objectForKey:@"http"];
    NSString *ruleHTTPMethod = [actionHTTPRule objectForKey:@"method"];
    if ([ruleHTTPMethod length] > 0) {
        request.HTTPMethod = ruleHTTPMethod;
    }
    NSString *ruleURIStr = [actionHTTPRule objectForKey:@"requestUri"];
    NSDictionary *shapeRules = [self.serviceDefinitionJSON objectForKey:@"shapes"];
    AWSJSONDictionary *inputRules = [[AWSJSONDictionary alloc] initWithDictionary:[anActionRules objectForKey:@"input"] JSONDefinitionRule:shapeRules];
    NSDictionary *actionEndpoint = [anActionRules objectForKey:@"endpoint"];
    NSString *endpointHostPrefix = [actionEndpoint objectForKey:@"hostPrefix"];
    NSError *error = nil;
    [AWSXMLRequestSerializer constructURIandHeadersAndBody:request
                                                     rules:inputRules
                                                parameters:parameters
                                                 uriSchema:ruleURIStr
                                                hostPrefix:endpointHostPrefix
                                                     error:&error];
    if (!error) {
        if (!request.HTTPBodyStream) {
            request.HTTPBody = [AWSXMLBuilder xmlDataForDictionary:parameters
                                                        actionName:self.actionName
                                             serviceDefinitionRule:self.serviceDefinitionJSON
                                                             error:&error];
        }
        if (!error) {
            if (headers) {
                for (NSString *key in headers.allKeys) {
                    [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
                }
            }
        }
    }
    [request aws_validateHTTPMethodAndBody];
    if (error) {
        return [AWSTask taskWithError:error];
    } else {
        return [AWSTask taskWithResult:nil];
    }
}
- (AWSTask *)validateRequest:(NSURLRequest *)request {
    return [AWSTask taskWithResult:nil];
}
+ (BOOL)constructURIandHeadersAndBody:(NSMutableURLRequest *)request
                                rules:(AWSJSONDictionary *)rules
                           parameters:(NSDictionary *)params
                            uriSchema:(NSString *)uriSchema
                           hostPrefix:(NSString *)hostPrefix
                                error:(NSError *__autoreleasing *)error {
    if (rules == (id)[NSNull null] ||  [rules count] == 0) {
        return YES;
    }
    NSMutableDictionary *queryStringDictionary = [NSMutableDictionary new];
    rules = rules[@"members"] ? rules[@"members"] : @{};
    __block NSString *rawURI = uriSchema?uriSchema:@"";
    __block BOOL isValid = YES;
    __block NSError *blockErr = nil;
    [rules enumerateKeysAndObjectsUsingBlock:^(NSString *memberName, id memberRules, BOOL *stop) {
        NSString *xmlElementName = memberRules[@"locationName"]?memberRules[@"locationName"]:memberName;
        id value = nil;
        if (memberRules[@"locationName"]) {
            value = params[memberRules[@"locationName"]];
        }
        if (!value) {
            value = params[memberName];
        }
        if (value && value != [NSNull null] && [memberRules isKindOfClass:[NSDictionary class]]) {
            NSString *rulesType = memberRules[@"type"];
            NSString *valueStr = @"";
            if ([rulesType isEqualToString:@"integer"] || [rulesType isEqualToString:@"long"] || [rulesType isEqualToString:@"float"] || [rulesType isEqualToString:@"double"]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    valueStr = [value stringValue];
                }
            } else if ([rulesType isEqualToString:@"boolean"]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    valueStr = [value boolValue]?@"true":@"false";
                }
            } else if ([rulesType isEqualToString:@"string"]) {
                if ([value isKindOfClass:[NSString class]]) {
                    valueStr = value;
                }
            } else if ([rulesType isEqualToString:@"timestamp"]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    if ([memberRules[@"location"] isEqualToString:@"header"]) {
                        NSDate *timeStampDate = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                        valueStr = [timeStampDate aws_stringValue:AWSDateRFC822DateFormat1];
                    } else {
                        valueStr = [value stringValue];
                    }
                } else if ([value isKindOfClass:[NSString class]]) {
                    valueStr = value; 
                }
            } else {
                valueStr = @"";
            }
            if ([memberRules[@"location"] isEqualToString:@"header"]) {
                [request addValue:valueStr forHTTPHeaderField:memberRules[@"locationName"]];
            }
            if ([value isKindOfClass:[NSDictionary class]] && [rulesType isEqualToString:@"map"] && [memberRules[@"location"] isEqualToString:@"headers"]) {
                for (NSString *key in value) {
                    NSString *keyName = [memberRules[@"locationName"] stringByAppendingString:key];
                    [request addValue:value[key] forHTTPHeaderField:keyName];
                }
            }
            if ([memberRules[@"location"] isEqualToString:@"uri"]) {
                NSString *keyToFind = [NSString stringWithFormat:@"{%@}", xmlElementName];
                NSString *greedyKeyToFind = [NSString stringWithFormat:@"{%@+}", xmlElementName];
                if ([rawURI rangeOfString:keyToFind].location != NSNotFound) {
                    rawURI = [rawURI stringByReplacingOccurrencesOfString:keyToFind
                                                               withString:[valueStr aws_stringWithURLEncoding]];
                } else if ([rawURI rangeOfString:greedyKeyToFind].location != NSNotFound) {
                    rawURI = [rawURI stringByReplacingOccurrencesOfString:greedyKeyToFind
                                                               withString:[valueStr aws_stringWithURLEncodingPathWithoutPriorDecoding]];
                }
            }
            if ([memberRules[@"location"] isEqualToString:@"querystring"] &&
                [rulesType isEqualToString:@"list"]) {
                [queryStringDictionary setObject:value forKey:memberRules[@"locationName"]];
            } else if ([memberRules[@"location"] isEqualToString:@"querystring"]) {
                [queryStringDictionary setObject:valueStr forKey:memberRules[@"locationName"]];
            }
            if (([xmlElementName isEqualToString:@"Body"] || [xmlElementName isEqualToString:@"body"]) && [memberRules[@"streaming"] boolValue]) {
                if ([value isKindOfClass:[NSURL class]]) {
                    if ([value checkResourceIsReachableAndReturnError:&blockErr]) {
                        request.HTTPBodyStream = [NSInputStream inputStreamWithURL:value];
                    } else {
                        isValid = NO;
                        *stop = YES;
                    }
                } else {
                    if ([value isKindOfClass:[NSString class]]) {
                        value = [value dataUsingEncoding:NSUTF8StringEncoding];
                    }
                    if ([value isKindOfClass:[NSData class]]) {
                        request.HTTPBodyStream = [NSInputStream inputStreamWithData:value];
                    }
                }
            }
            if([memberRules[@"shape"] isEqualToString:@"BlobStream"]){
                AWSDDLogVerbose(@"value type = %@", [value class]);
                if([value isKindOfClass:[NSInputStream class]]){
                    request.HTTPBodyStream = value;
                }else{
                    if ([value isKindOfClass:[NSString class]]) {
                        value = [value dataUsingEncoding:NSUTF8StringEncoding];
                    }
                    if ([value isKindOfClass:[NSData class]]) {
                        request.HTTPBodyStream = [NSInputStream inputStreamWithData:value];
                    }
                }
            }
        }
    }];
    if (!isValid) {
        if (error) {
            *error = blockErr;
            if (*error == nil) {
                *error = [NSError errorWithDomain:AWSValidationErrorDomain code:AWSValidationUnknownError userInfo:[NSDictionary dictionaryWithObject:@"Unknown error happened while enumerating rules" forKey:NSLocalizedDescriptionKey]];
            }
        }
        return NO;
    }
    BOOL uriSchemaContainsQuestionMark = NO;
    NSRange hasQuestionMark = [uriSchema rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
    if (hasQuestionMark.location != NSNotFound) {
        uriSchemaContainsQuestionMark = YES;
    }
    if ([queryStringDictionary count]) {
        NSArray *myKeys = [queryStringDictionary allKeys];
        NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSString *queryString = @"";
        NSMutableArray *keyValuesToAppend = [@[] mutableCopy];
        for (NSString *key in sortedKeys) {
            if ([queryStringDictionary[key] isKindOfClass:[NSArray class]]) {
                NSArray *listOfValues = (NSArray*)queryStringDictionary[key];
                for (NSString *singleValue in listOfValues) {
                    NSString *keyVal = [NSString stringWithFormat:@"%@=%@", [key aws_stringWithURLEncoding], [singleValue aws_stringWithURLEncoding]];
                    [keyValuesToAppend addObject:keyVal];
                }
            } else {
                NSString *keyVal = [NSString stringWithFormat:@"%@=%@", [key aws_stringWithURLEncoding], [queryStringDictionary[key] aws_stringWithURLEncoding]];
                [keyValuesToAppend addObject:keyVal];
            }
        }
        for (NSString *keyValue in keyValuesToAppend) {
            if ([queryString length] == 0 && uriSchemaContainsQuestionMark == NO) {
                queryString = [NSString stringWithFormat:@"?%@", keyValue];
            } else {
                NSString *appendString = [NSString stringWithFormat:@"&%@", keyValue];
                queryString = [queryString stringByAppendingString:appendString];
            }
        }
        rawURI = [rawURI stringByAppendingString:queryString];
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{.*?\\}" options:NSRegularExpressionCaseInsensitive error:nil];
    rawURI = [regex stringByReplacingMatchesInString:rawURI options:0 range:NSMakeRange(0, [rawURI length]) withTemplate:@""];
    if (hostPrefix.length) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSString* finalHost = [hostPrefix stringByAppendingString:request.URL.host];
        [urlComponents setHost:finalHost];
        request.URL = urlComponents.URL;
    }
    NSRange r = [rawURI rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    if (r.location != NSNotFound) {
        if (error) {
            *error = [NSError errorWithDomain:AWSValidationErrorDomain code:AWSValidationURIIsInvalid userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"the constructed request queryString is invalid:%@",rawURI] forKey:NSLocalizedDescriptionKey]];
        }
        request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/", request.URL]];
        return NO;
    } else {
        NSRange hasQuestionMark = [rawURI rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
        NSRange hasEqualMark = [rawURI rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        if ((hasQuestionMark.location != NSNotFound) && (hasEqualMark.location == NSNotFound)) {
            rawURI = [rawURI stringByAppendingString:@"="];
        }
        NSString *finalURL = [NSString stringWithFormat:@"%@%@", request.URL,rawURI];
        request.URL = [NSURL URLWithString:finalURL];
        if (!request.URL) {
            if (error) {
                *error = [NSError errorWithDomain:AWSValidationErrorDomain code:AWSValidationURIIsInvalid userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"unable the assigned URL to request, URL may be invalid:%@",finalURL] forKey:NSLocalizedDescriptionKey]];
            }
            return NO;
        }
        return YES;
    }
}
@end
@interface AWSQueryStringRequestSerializer()
@property (nonatomic, strong) NSDictionary *serviceDefinitionJSON;
@property (nonatomic, strong) NSString *actionName;
@end
@implementation AWSQueryStringRequestSerializer
- (instancetype)initWithJSONDefinition:(NSDictionary *)JSONDefinition
                            actionName:(NSString *)actionName {
    if (self = [super init]) {
        _serviceDefinitionJSON = JSONDefinition;
        if (_serviceDefinitionJSON == nil) {
            AWSDDLogError(@"serviceDefinitionJSON of is nil.");
            return nil;
        }
        _actionName = actionName;
    }
    return self;
}
- (void)processParameters:(NSDictionary *)parameters queryString:(NSMutableString *)queryString {
    for (NSString *key in parameters) {
        id obj = parameters[key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [self processParameters:obj queryString:queryString];
        } else {
            if ([queryString length] > 0) {
                [queryString appendString:@"&"];
            }
            if ([obj isKindOfClass:[NSString class]]) {
                [queryString appendString:[key aws_stringWithURLEncoding]];
                [queryString appendString:@"="];
                NSString *urlEncodedString = [obj aws_stringWithURLEncoding];
                [queryString appendString:urlEncodedString];
            } else if ([obj isKindOfClass:[NSNumber class]]) {
                [queryString appendString:[key aws_stringWithURLEncoding]];
                [queryString appendString:@"="];
                [queryString appendString:[[obj stringValue] aws_stringWithURLEncoding]];
            } else {
                AWSDDLogError(@"key[%@] is invalid.", key);
                [queryString appendString:[key aws_stringWithURLEncoding]];
                [queryString appendString:@"="];
                [queryString appendString:[[obj description]aws_stringWithURLEncoding]];
            }
        }
    }
}
- (AWSTask *)serializeRequest:(NSMutableURLRequest *)request
                      headers:(NSDictionary *)headers
                   parameters:(NSDictionary *)parameters {
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    parameters = [parameters mutableCopy];
    [self.additionalParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [parameters setValue:obj forKey:key];
    }];
    NSError *error = nil;
    NSDictionary *formattedParams = [AWSQueryParamBuilder buildFormattedParams:parameters
                                                                    actionName:self.actionName
                                                         serviceDefinitionRule:self.serviceDefinitionJSON error:&error];
    if (error) {
        return [AWSTask taskWithError:error];
    }
    NSMutableString *queryString = [NSMutableString new];
    [self processParameters:formattedParams queryString:queryString];
    if ([queryString length] > 0) {
        request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (headers) {
        for (NSString *key in headers.allKeys) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    if (!request.allHTTPHeaderFields[@"Content-Type"]) {
        [request addValue:@"application/x-www-form-urlencoded; charset=utf-8"
       forHTTPHeaderField:@"Content-Type"];
    }
    [request aws_validateHTTPMethodAndBody];
    return [AWSTask taskWithResult:nil];
}
- (AWSTask *)validateRequest:(NSURLRequest *)request {
    return [AWSTask taskWithResult:nil];
}
@end