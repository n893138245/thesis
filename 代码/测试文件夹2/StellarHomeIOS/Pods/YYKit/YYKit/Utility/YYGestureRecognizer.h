#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YYGestureRecognizerState) {
    YYGestureRecognizerStateBegan, 
    YYGestureRecognizerStateMoved, 
    YYGestureRecognizerStateEnded, 
    YYGestureRecognizerStateCancelled, 
};
@interface YYGestureRecognizer : UIGestureRecognizer
@property (nonatomic, readonly) CGPoint startPoint; 
@property (nonatomic, readonly) CGPoint lastPoint; 
@property (nonatomic, readonly) CGPoint currentPoint; 
@property (nullable, nonatomic, copy) void (^action)(YYGestureRecognizer *gesture, YYGestureRecognizerState state);
- (void)cancel;
@end
NS_ASSUME_NONNULL_END