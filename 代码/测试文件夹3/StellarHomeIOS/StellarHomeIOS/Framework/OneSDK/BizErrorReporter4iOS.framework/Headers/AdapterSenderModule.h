#ifndef AdapterSenderModule_h
#define AdapterSenderModule_h
#import <Foundation/Foundation.h>
@interface AdapterSenderModule : NSObject
@property(nonatomic,readwrite) NSDictionary* sendContent;
@property(nonatomic,readwrite) NSString* businessType;
@property(nonatomic,readwrite) NSString* aggregationType;
@property(nonatomic,readwrite) int eventId;
@property(nonatomic,readwrite) NSString* sendFlag;
@property(nonatomic,readwrite) NSString* currentStack;
@end
#endif 