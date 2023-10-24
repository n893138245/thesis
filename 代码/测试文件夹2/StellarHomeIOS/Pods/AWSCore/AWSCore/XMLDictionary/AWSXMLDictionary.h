#import <Foundation/Foundation.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
typedef NS_ENUM(NSInteger, AWSXMLDictionaryAttributesMode)
{
    AWSXMLDictionaryAttributesModePrefixed = 0, 
    AWSXMLDictionaryAttributesModeDictionary,
    AWSXMLDictionaryAttributesModeUnprefixed,
    AWSXMLDictionaryAttributesModeDiscard
};
typedef NS_ENUM(NSInteger, AWSXMLDictionaryNodeNameMode)
{
    AWSXMLDictionaryNodeNameModeRootOnly = 0, 
    AWSXMLDictionaryNodeNameModeAlways,
    AWSXMLDictionaryNodeNameModeNever
};
static NSString *const AWSXMLDictionaryAttributesKey   = @"__attributes";
static NSString *const AWSXMLDictionaryCommentsKey     = @"__comments";
static NSString *const AWSXMLDictionaryTextKey         = @"__text";
static NSString *const AWSXMLDictionaryNodeNameKey     = @"__name";
static NSString *const AWSXMLDictionaryAttributePrefix = @"_";
@interface AWSXMLDictionaryParser : NSObject <NSCopying>
+ (AWSXMLDictionaryParser *)sharedInstance;
@property (nonatomic, assign) BOOL collapseTextNodes; 
@property (nonatomic, assign) BOOL stripEmptyNodes;   
@property (nonatomic, assign) BOOL trimWhiteSpace;    
@property (nonatomic, assign) BOOL alwaysUseArrays;   
@property (nonatomic, assign) BOOL preserveComments;  
@property (nonatomic, assign) BOOL wrapRootNode;      
@property (nonatomic, assign) AWSXMLDictionaryAttributesMode attributesMode;
@property (nonatomic, assign) AWSXMLDictionaryNodeNameMode nodeNameMode;
- (NSDictionary *)dictionaryWithParser:(NSXMLParser *)parser;
- (NSDictionary *)dictionaryWithData:(NSData *)data;
- (NSDictionary *)dictionaryWithString:(NSString *)string;
- (NSDictionary *)dictionaryWithFile:(NSString *)path;
@end
@interface NSDictionary (AWSXMLDictionary)
+ (NSDictionary *)awsxml_dictionaryWithXMLParser:(NSXMLParser *)parser;
+ (NSDictionary *)awsxml_dictionaryWithXMLData:(NSData *)data;
+ (NSDictionary *)awsxml_dictionaryWithXMLString:(NSString *)string;
+ (NSDictionary *)awsxml_dictionaryWithXMLFile:(NSString *)path;
- (NSDictionary *)awsxml_attributes;
- (NSDictionary *)awsxml_childNodes;
- (NSArray *)awsxml_comments;
- (NSString *)awsxml_nodeName;
- (NSString *)awsxml_innerText;
- (NSString *)awsxml_innerXML;
- (NSString *)awsxml_XMLString;
- (NSArray *)awsxml_arrayValueForKeyPath:(NSString *)keyPath;
- (NSString *)awsxml_stringValueForKeyPath:(NSString *)keyPath;
- (NSDictionary *)awsxml_dictionaryValueForKeyPath:(NSString *)keyPath;
@end
@interface NSString (AWSXMLDictionary)
- (NSString *)awsxml_XMLEncodedString;
@end
#pragma GCC diagnostic pop