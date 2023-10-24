#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextAttribute.h>
#import <YYKit/YYTextInput.h>
#else
#import "YYTextAttribute.h"
#import "YYTextInput.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface YYSelectionGrabberDot : UIView
@property (nonatomic, strong) UIView *mirror;
@end
@interface YYSelectionGrabber : UIView
@property (nonatomic, readonly) YYSelectionGrabberDot *dot; 
@property (nonatomic) YYTextDirection dotDirection;         
@property (nullable, nonatomic, strong) UIColor *color;     
@end
@interface YYTextSelectionView : UIView
@property (nullable, nonatomic, weak) UIView *hostView; 
@property (nullable, nonatomic, strong) UIColor *color; 
@property (nonatomic, getter = isCaretBlinks) BOOL caretBlinks; 
@property (nonatomic, getter = isCaretVisible) BOOL caretVisible; 
@property (nonatomic, getter = isVerticalForm) BOOL verticalForm; 
@property (nonatomic) CGRect caretRect; 
@property (nullable, nonatomic, copy) NSArray<YYTextSelectionRect *> *selectionRects; 
@property (nonatomic, readonly) UIView *caretView;
@property (nonatomic, readonly) YYSelectionGrabber *startGrabber;
@property (nonatomic, readonly) YYSelectionGrabber *endGrabber;
- (BOOL)isGrabberContainsPoint:(CGPoint)point;
- (BOOL)isStartGrabberContainsPoint:(CGPoint)point;
- (BOOL)isEndGrabberContainsPoint:(CGPoint)point;
- (BOOL)isCaretContainsPoint:(CGPoint)point;
- (BOOL)isSelectionRectsContainsPoint:(CGPoint)point;
@end
NS_ASSUME_NONNULL_END