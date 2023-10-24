#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef struct {
    BOOL fromVisible; 
    BOOL toVisible;   
    CGRect fromFrame; 
    CGRect toFrame;   
    NSTimeInterval animationDuration;       
    UIViewAnimationCurve animationCurve;    
    UIViewAnimationOptions animationOption; 
} YYTextKeyboardTransition;
@protocol YYTextKeyboardObserver <NSObject>
@optional
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition;
@end
@interface YYTextKeyboardManager : NSObject
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)defaultManager;
@property (nullable, nonatomic, readonly) UIWindow *keyboardWindow;
@property (nullable, nonatomic, readonly) UIView *keyboardView;
@property (nonatomic, readonly, getter=isKeyboardVisible) BOOL keyboardVisible;
@property (nonatomic, readonly) CGRect keyboardFrame;
- (void)addObserver:(id<YYTextKeyboardObserver>)observer;
- (void)removeObserver:(id<YYTextKeyboardObserver>)observer;
- (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
@end
NS_ASSUME_NONNULL_END