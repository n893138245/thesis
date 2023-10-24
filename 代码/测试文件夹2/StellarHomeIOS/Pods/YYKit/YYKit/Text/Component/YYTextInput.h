#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YYTextAffinity) {
    YYTextAffinityForward  = 0, 
    YYTextAffinityBackward = 1, 
};
@interface YYTextPosition : UITextPosition <NSCopying>
@property (nonatomic, readonly) NSInteger offset;
@property (nonatomic, readonly) YYTextAffinity affinity;
+ (instancetype)positionWithOffset:(NSInteger)offset;
+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(YYTextAffinity) affinity;
- (NSComparisonResult)compare:(id)otherPosition;
@end
@interface YYTextRange : UITextRange <NSCopying>
@property (nonatomic, readonly) YYTextPosition *start;
@property (nonatomic, readonly) YYTextPosition *end;
@property (nonatomic, readonly, getter=isEmpty) BOOL empty;
+ (instancetype)rangeWithRange:(NSRange)range;
+ (instancetype)rangeWithRange:(NSRange)range affinity:(YYTextAffinity) affinity;
+ (instancetype)rangeWithStart:(YYTextPosition *)start end:(YYTextPosition *)end;
+ (instancetype)defaultRange; 
- (NSRange)asRange;
@end
@interface YYTextSelectionRect : UITextSelectionRect <NSCopying>
@property (nonatomic, readwrite) CGRect rect;
@property (nonatomic, readwrite) UITextWritingDirection writingDirection;
@property (nonatomic, readwrite) BOOL containsStart;
@property (nonatomic, readwrite) BOOL containsEnd;
@property (nonatomic, readwrite) BOOL isVertical;
@end
NS_ASSUME_NONNULL_END