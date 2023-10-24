#ifndef EMASRestSendService_h
#define EMASRestSendService_h
#import <Foundation/Foundation.h>
#import "EMASRestConfiguration.h"
@interface EMASRestSendService : NSObject
@property (nonatomic, copy) NSString* utabtest;
@property (nonatomic, copy) NSString* utabtestpage;
@property (nonatomic, weak) id<EMASRestReservesProviderProtocol> reserveProvider;
+ (EMASRestSendService*)shareInstance;
- (BOOL)configBasicParamWithTBConfiguration:(EMASRestConfiguration*)config;
- (EMASRestConfiguration*)obtainConfiguration;
-(BOOL)sendLogSync:(NSObject*)aPageName eventId:(int) aEventId arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;
-(void)sendLogAsync:(NSObject*)aPageName eventId:(int) aEventId arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;
- (NSData *) sendLogWithUrl:(NSString*)url PageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString *) aArg1 arg2:(NSString *) aArg2 arg3:(NSString *) aArg3 args:(NSDictionary *) aArgs;
@end
#endif 