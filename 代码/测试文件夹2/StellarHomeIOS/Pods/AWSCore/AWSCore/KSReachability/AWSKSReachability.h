#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#define kAWSDefaultNetworkReachabilityChangedNotification @"kAWSNetworkReachabilityChangedNotification"
@class AWSKSReachability;
typedef void(^AWSKSReachabilityCallback)(AWSKSReachability* reachability);
@interface AWSKSReachability : NSObject
#pragma mark Constructors
+ (AWSKSReachability*) reachabilityToHost:(NSString*) hostname;
+ (AWSKSReachability*) reachabilityToLocalNetwork;
+ (AWSKSReachability*) reachabilityToInternet;
#pragma mark General Information
@property(nonatomic,readonly,retain) NSString* hostname;
#pragma mark Notifications and Callbacks
@property(atomic,readwrite,copy) AWSKSReachabilityCallback onInitializationComplete;
@property(atomic,readwrite,copy) AWSKSReachabilityCallback onReachabilityChanged;
@property(nonatomic,readwrite,retain) NSString* notificationName;
#pragma mark KVO Compliant Status Properties
@property(nonatomic,readonly,assign) SCNetworkReachabilityFlags flags;
@property(nonatomic,readonly,assign) BOOL reachable;
@property(nonatomic,readonly,assign) BOOL WWANOnly;
@property(atomic,readonly,assign) BOOL initialized;
@end
@interface AWSKSReachableOperation: NSObject
+ (AWSKSReachableOperation*) operationWithHost:(NSString*) hostname
                                  allowWWAN:(BOOL) allowWWAN
                     onReachabilityAchieved:(dispatch_block_t) onReachabilityAchieved;
+ (AWSKSReachableOperation*) operationWithReachability:(AWSKSReachability*) reachability
                                          allowWWAN:(BOOL) allowWWAN
                             onReachabilityAchieved:(dispatch_block_t) onReachabilityAchieved;
- (id) initWithHost:(NSString*) hostname
          allowWWAN:(BOOL) allowWWAN
onReachabilityAchieved:(dispatch_block_t) onReachabilityAchieved;
- (id) initWithReachability:(AWSKSReachability*) reachability
                  allowWWAN:(BOOL) allowWWAN
     onReachabilityAchieved:(dispatch_block_t) onReachabilityAchieved;
@property(nonatomic,readonly,retain) AWSKSReachability* reachability;
@end