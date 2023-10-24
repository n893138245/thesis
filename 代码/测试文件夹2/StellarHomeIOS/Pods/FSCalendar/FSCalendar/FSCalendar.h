#import <UIKit/UIKit.h>
#import "FSCalendarAppearance.h"
#import "FSCalendarConstants.h"
#import "FSCalendarCell.h"
#import "FSCalendarWeekdayView.h"
#import "FSCalendarHeaderView.h"
FOUNDATION_EXPORT double FSCalendarVersionNumber;
FOUNDATION_EXPORT const unsigned char FSCalendarVersionString[];
typedef NS_ENUM(NSUInteger, FSCalendarScope) {
    FSCalendarScopeMonth,
    FSCalendarScopeWeek
};
typedef NS_ENUM(NSUInteger, FSCalendarScrollDirection) {
    FSCalendarScrollDirectionVertical,
    FSCalendarScrollDirectionHorizontal
};
typedef NS_ENUM(NSUInteger, FSCalendarPlaceholderType) {
    FSCalendarPlaceholderTypeNone          = 0,
    FSCalendarPlaceholderTypeFillHeadTail  = 1,
    FSCalendarPlaceholderTypeFillSixRows   = 2
};
typedef NS_ENUM(NSUInteger, FSCalendarMonthPosition) {
    FSCalendarMonthPositionPrevious,
    FSCalendarMonthPositionCurrent,
    FSCalendarMonthPositionNext,
    FSCalendarMonthPositionNotFound = NSNotFound
};
NS_ASSUME_NONNULL_BEGIN
@class FSCalendar;
@protocol FSCalendarDataSource <NSObject>
@optional
- (nullable NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date;
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date;
- (nullable UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date;
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar;
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar;
- (__kindof FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date;
@end
@protocol FSCalendarDelegate <NSObject>
@optional
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated;
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar;
@end
@protocol FSCalendarDelegateAppearance <FSCalendarDelegate>
@optional
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date;
- (nullable NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date;
- (nullable NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date;
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date;
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date;
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleOffsetForDate:(NSDate *)date;
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance imageOffsetForDate:(NSDate *)date;
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date;
- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(NSDate *)date;
@end
#pragma mark - Primary
IB_DESIGNABLE
@interface FSCalendar : UIView
@property (weak, nonatomic) IBOutlet id<FSCalendarDelegate> delegate;
@property (weak, nonatomic) IBOutlet id<FSCalendarDataSource> dataSource;
@property (nullable, strong, nonatomic) NSDate *today;
@property (strong, nonatomic) NSDate *currentPage;
@property (copy, nonatomic) NSLocale *locale;
@property (assign, nonatomic) FSCalendarScrollDirection scrollDirection;
@property (assign, nonatomic) FSCalendarScope scope;
@property (readonly, nonatomic) UIPanGestureRecognizer *scopeGesture FSCalendarDeprecated(handleScopeGesture:);
@property (readonly, nonatomic) UILongPressGestureRecognizer *swipeToChooseGesture;
@property (assign, nonatomic) FSCalendarPlaceholderType placeholderType;
@property (assign, nonatomic) IBInspectable NSUInteger firstWeekday;
@property (assign, nonatomic) IBInspectable CGFloat headerHeight;
@property (assign, nonatomic) IBInspectable CGFloat weekdayHeight;
@property (strong, nonatomic) FSCalendarWeekdayView *calendarWeekdayView;
@property (strong, nonatomic) FSCalendarHeaderView *calendarHeaderView;
@property (assign, nonatomic) IBInspectable BOOL allowsSelection;
@property (assign, nonatomic) IBInspectable BOOL allowsMultipleSelection;
@property (assign, nonatomic) IBInspectable BOOL adjustsBoundingRectWhenChangingMonths;
@property (assign, nonatomic) IBInspectable BOOL pagingEnabled;
@property (assign, nonatomic) IBInspectable BOOL scrollEnabled;
@property (assign, nonatomic) IBInspectable CGFloat rowHeight;
@property (readonly, nonatomic) FSCalendarAppearance *appearance;
@property (readonly, nonatomic) NSDate *minimumDate;
@property (readonly, nonatomic) NSDate *maximumDate;
@property (nullable, readonly, nonatomic) NSDate *selectedDate;
@property (readonly, nonatomic) NSArray<NSDate *> *selectedDates;
- (void)reloadData;
- (void)setScope:(FSCalendarScope)scope animated:(BOOL)animated;
- (void)selectDate:(nullable NSDate *)date;
- (void)selectDate:(nullable NSDate *)date scrollToDate:(BOOL)scrollToDate;
- (void)deselectDate:(NSDate *)date;
- (void)setCurrentPage:(NSDate *)currentPage animated:(BOOL)animated;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (__kindof FSCalendarCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;
- (nullable FSCalendarCell *)cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;
- (nullable NSDate *)dateForCell:(FSCalendarCell *)cell;
- (FSCalendarMonthPosition)monthPositionForCell:(FSCalendarCell *)cell;
- (NSArray<__kindof FSCalendarCell *> *)visibleCells;
- (CGRect)frameForDate:(NSDate *)date;
- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender;
@end
IB_DESIGNABLE
@interface FSCalendar (IBExtension)
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable CGFloat  titleTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  subtitleTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  weekdayTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  headerTitleTextSize;
@property (strong, nonatomic) IBInspectable UIColor  *eventDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *eventSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *weekdayTextColor;
@property (strong, nonatomic) IBInspectable UIColor  *headerTitleColor;
@property (strong, nonatomic) IBInspectable NSString *headerDateFormat;
@property (assign, nonatomic) IBInspectable CGFloat  headerMinimumDissolvedAlpha;
@property (strong, nonatomic) IBInspectable UIColor  *titleDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleTodayColor;
@property (strong, nonatomic) IBInspectable UIColor  *titlePlaceholderColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleWeekendColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleTodayColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitlePlaceholderColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleWeekendColor;
@property (strong, nonatomic) IBInspectable UIColor  *selectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *todayColor;
@property (strong, nonatomic) IBInspectable UIColor  *todaySelectionColor;
@property (strong, nonatomic) IBInspectable UIColor *borderDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor *borderSelectionColor;
@property (assign, nonatomic) IBInspectable CGFloat borderRadius;
@property (assign, nonatomic) IBInspectable BOOL    useVeryShortWeekdaySymbols;
@property (assign, nonatomic) IBInspectable BOOL      fakeSubtitles;
@property (assign, nonatomic) IBInspectable BOOL      fakeEventDots;
@property (assign, nonatomic) IBInspectable NSInteger fakedSelectedDay;
#endif
@end
NS_ASSUME_NONNULL_END