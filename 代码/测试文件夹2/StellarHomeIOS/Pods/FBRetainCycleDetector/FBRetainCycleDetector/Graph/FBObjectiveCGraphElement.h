#import <Foundation/Foundation.h>
@class FBObjectGraphConfiguration;
@interface FBObjectiveCGraphElement : NSObject
- (nonnull instancetype)initWithObject:(nullable id)object
                         configuration:(nonnull FBObjectGraphConfiguration *)configuration
                              namePath:(nullable NSArray<NSString *> *)namePath;
- (nonnull instancetype)initWithObject:(nullable id)object
                         configuration:(nonnull FBObjectGraphConfiguration *)configuration;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *namePath;
@property (nonatomic, weak, nullable) id object;
@property (nonatomic, readonly, nonnull) FBObjectGraphConfiguration *configuration;
- (nullable NSSet *)allRetainedObjects;
- (size_t)objectAddress;
- (nullable Class)objectClass;
- (nonnull NSString *)classNameOrNull;
@end