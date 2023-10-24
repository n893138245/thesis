#import <UIKit/UIKit.h>
@class FSCalendar,FSCalendarAppearance;
@interface FSCalendarStickyHeader : UICollectionReusableView
@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSDate *month;
- (void)configureAppearance;
@end