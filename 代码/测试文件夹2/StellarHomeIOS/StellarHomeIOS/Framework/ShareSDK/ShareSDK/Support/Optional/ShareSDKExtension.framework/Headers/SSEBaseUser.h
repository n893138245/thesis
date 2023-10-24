#import <Foundation/Foundation.h>
#import <MOBFoundation/MOBFDataModel.h>
@interface SSEBaseUser : MOBFDataModel
@property (nonatomic, copy) NSString *linkId;
@property (nonatomic, strong) NSMutableDictionary *socialUsers;
- (void)updateInfo:(id)data;
@end