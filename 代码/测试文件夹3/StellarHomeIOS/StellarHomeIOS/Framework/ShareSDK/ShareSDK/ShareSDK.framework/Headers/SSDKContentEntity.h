#import <Foundation/Foundation.h>
@interface SSDKContentEntity : SSDKDataModel
@property (nonatomic, strong) id cid;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *urls;
@property (nonatomic, retain) NSDictionary *rawData;
@end