#import <Foundation/Foundation.h>
#import <mach/mach.h>
@interface JDYThreadScene : NSObject
@property (nonatomic, strong) NSArray *threadScene;
@property (nonatomic, strong) NSString *sceneTitle;
+ (JDYThreadScene *)captureSceneForThread:(thread_t)thread;
+ (JDYThreadScene *)captureSceneForThreadIndex:(int)index;
@end