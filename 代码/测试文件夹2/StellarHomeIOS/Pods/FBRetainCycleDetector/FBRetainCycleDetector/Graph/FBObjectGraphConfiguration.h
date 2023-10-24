#import <Foundation/Foundation.h>
#import "FBObjectiveCGraphElement.h"
typedef NS_ENUM(NSUInteger, FBGraphEdgeType) {
  FBGraphEdgeValid,
  FBGraphEdgeInvalid,
};
@protocol FBObjectReference;
typedef FBGraphEdgeType (^FBGraphEdgeFilterBlock)(FBObjectiveCGraphElement *_Nullable fromObject,
                                                  NSString *_Nullable byIvar,
                                                  Class _Nullable toObjectOfClass);
typedef FBObjectiveCGraphElement *_Nullable(^FBObjectiveCGraphElementTransformerBlock)(FBObjectiveCGraphElement *_Nonnull fromObject);
@interface FBObjectGraphConfiguration : NSObject
@property (nonatomic, readonly, copy, nullable) NSArray<FBGraphEdgeFilterBlock> *filterBlocks;
@property (nonatomic, readonly, copy, nullable) FBObjectiveCGraphElementTransformerBlock transformerBlock;
@property (nonatomic, readonly) BOOL shouldInspectTimers;
@property (nonatomic, readonly) BOOL shouldIncludeBlockAddress;
@property (nonatomic, readonly, nullable) NSMutableDictionary<Class, NSArray<id<FBObjectReference>> *> *layoutCache;
@property (nonatomic, readonly) BOOL shouldCacheLayouts;
- (nonnull instancetype)initWithFilterBlocks:(nonnull NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                         shouldInspectTimers:(BOOL)shouldInspectTimers
                         transformerBlock:(nullable FBObjectiveCGraphElementTransformerBlock)transformerBlock
                         shouldIncludeBlockAddress:(BOOL)shouldIncludeBlockAddress NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithFilterBlocks:(nonnull NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                         shouldInspectTimers:(BOOL)shouldInspectTimers
                         transformerBlock:(nullable FBObjectiveCGraphElementTransformerBlock)transformerBlock;
- (nonnull instancetype)initWithFilterBlocks:(nonnull NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                         shouldInspectTimers:(BOOL)shouldInspectTimers;
@end