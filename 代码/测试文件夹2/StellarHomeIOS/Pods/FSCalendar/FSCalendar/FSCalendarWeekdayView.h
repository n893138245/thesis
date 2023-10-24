#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class FSCalendar;
@interface FSCalendarWeekdayView : UIView
@property (readonly, nonatomic) NSArray<UILabel *> *weekdayLabels;
- (void)configureAppearance;
@end
NS_ASSUME_NONNULL_END