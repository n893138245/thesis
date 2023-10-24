#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface TZLocationManager : NSObject
+ (instancetype)manager NS_SWIFT_NAME(default());
- (void)startLocation;
- (void)startLocationWithSuccessBlock:(void (^)(NSArray<CLLocation *> *))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
- (void)startLocationWithGeocoderBlock:(void (^)(NSArray *geocoderArray))geocoderBlock;
- (void)startLocationWithSuccessBlock:(void (^)(NSArray<CLLocation *> *))successBlock failureBlock:(void (^)(NSError *error))failureBlock geocoderBlock:(void (^)(NSArray *geocoderArray))geocoderBlock;
- (void)stopUpdatingLocation;
@end