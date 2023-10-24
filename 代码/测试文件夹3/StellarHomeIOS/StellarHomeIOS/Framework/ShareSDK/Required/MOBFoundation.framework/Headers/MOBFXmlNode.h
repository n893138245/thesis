#import <Foundation/Foundation.h>
@interface MOBFXmlNode : NSObject
@property (nonatomic, weak) MOBFXmlNode *parentNode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong, readonly) NSMutableDictionary *attributes;
@property (nonatomic, strong, readonly) NSMutableArray *children;
@property (nonatomic, copy) NSString *text;
- (NSDictionary *)dictionaryValue;
@end