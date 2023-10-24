#import <Foundation/Foundation.h>
FOUNDATION_EXPORT double FBRetainCycleDetectorVersionNumber;
FOUNDATION_EXPORT const unsigned char FBRetainCycleDetectorVersionString[];
#import <FBRetainCycleDetector/FBAssociationManager.h>
#import <FBRetainCycleDetector/FBObjectiveCBlock.h>
#import <FBRetainCycleDetector/FBObjectiveCGraphElement.h>
#import <FBRetainCycleDetector/FBObjectiveCNSCFTimer.h>
#import <FBRetainCycleDetector/FBObjectiveCObject.h>
#import <FBRetainCycleDetector/FBObjectGraphConfiguration.h>
#import <FBRetainCycleDetector/FBStandardGraphEdgeFilters.h>
@interface FBRetainCycleDetector : NSObject
- (nonnull instancetype)initWithConfiguration:(nonnull FBObjectGraphConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
- (void)addCandidate:(nonnull id)candidate;
- (nonnull NSSet<NSArray<FBObjectiveCGraphElement *> *> *)findRetainCycles;
- (nonnull NSSet<NSArray<FBObjectiveCGraphElement *> *> *)findRetainCyclesWithMaxCycleLength:(NSUInteger)length;
#ifdef RETAIN_CYCLE_DETECTOR_ENABLED
#define _INTERNAL_RCD_ENABLED RETAIN_CYCLE_DETECTOR_ENABLED
#else
#define _INTERNAL_RCD_ENABLED DEBUG
#endif
@end