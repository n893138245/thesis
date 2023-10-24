#import "FBObjectGraphConfiguration.h"
@implementation FBObjectGraphConfiguration
- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
                    transformerBlock:(nullable FBObjectiveCGraphElementTransformerBlock)transformerBlock
           shouldIncludeBlockAddress:(BOOL)shouldIncludeBlockAddress
{
  if (self = [super init]) {
    _filterBlocks = [filterBlocks copy];
    _shouldInspectTimers = shouldInspectTimers;
    _shouldIncludeBlockAddress = shouldIncludeBlockAddress;
    _transformerBlock = [transformerBlock copy];
    _layoutCache = [NSMutableDictionary new];
  }
  return self;
}
- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
                    transformerBlock:(nullable FBObjectiveCGraphElementTransformerBlock)transformerBlock
{
  return [self initWithFilterBlocks:filterBlocks
                shouldInspectTimers:shouldInspectTimers
                   transformerBlock:transformerBlock
          shouldIncludeBlockAddress:NO];
}
- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
{
  return [self initWithFilterBlocks:filterBlocks
                shouldInspectTimers:shouldInspectTimers
                   transformerBlock:nil];
}
- (instancetype)init
{
  return [self initWithFilterBlocks:@[]
                shouldInspectTimers:YES];
}
@end