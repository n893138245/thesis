#import <Foundation/Foundation.h>
@class MOBFXmlNode;
@interface MOBFXml : NSObject
@property (nonatomic, strong, readonly) MOBFXmlNode *rootNode;
- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithString:(NSString *)string;
- (NSDictionary *)dictionaryValue;
@end