#import <Foundation/Foundation.h>
#import <MOBFoundation/MOBFDataModel.h>
@interface SSEFriendsPaging : MOBFDataModel
@property (nonatomic) NSInteger prevCursor;
@property (nonatomic) NSInteger nextCursor;
@property (nonatomic) NSUInteger total;
@property (nonatomic) BOOL hasNext;
@property (nonatomic, strong) NSArray *users;
@end