#import <Foundation/Foundation.h>
#import "IMOBFDataModel.h"
@protocol IMOBBaseUser <IMOBFDataModel>
- (NSString *)uid;
- (NSString *)avatar;
- (NSString *)nickname;
@end