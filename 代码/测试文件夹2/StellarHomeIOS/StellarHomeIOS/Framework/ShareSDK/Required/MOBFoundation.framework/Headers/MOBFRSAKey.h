#import <Foundation/Foundation.h>
@class MOBFBigInteger;
@interface MOBFRSAKey : NSObject
@property (nonatomic) int bits;
@property (nonatomic, strong) MOBFBigInteger *n;
@property (nonatomic, strong) MOBFBigInteger *e;
@property (nonatomic, strong) MOBFBigInteger *d;
@end