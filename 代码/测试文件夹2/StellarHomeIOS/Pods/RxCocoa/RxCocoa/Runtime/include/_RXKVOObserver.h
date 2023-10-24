#import <Foundation/Foundation.h>
@interface _RXKVOObserver : NSObject
-(instancetype)initWithTarget:(id)target
                 retainTarget:(BOOL)retainTarget
                      keyPath:(NSString*)keyPath
                      options:(NSKeyValueObservingOptions)options
                     callback:(void (^)(id))callback;
-(void)dispose;
@end