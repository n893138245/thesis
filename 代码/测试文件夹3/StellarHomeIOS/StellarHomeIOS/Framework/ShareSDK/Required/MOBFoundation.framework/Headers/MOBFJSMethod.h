#import <Foundation/Foundation.h>
#import "MOBFJSTypeDefine.h"
@interface MOBFJSMethod : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) MOBFJSMethodIMP imp;
- (id)initWithName:(NSString *)name imp:(MOBFJSMethodIMP)imp;
@end