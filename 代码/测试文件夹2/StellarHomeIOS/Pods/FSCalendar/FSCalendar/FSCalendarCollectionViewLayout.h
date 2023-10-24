#import <UIKit/UIKit.h>
@class FSCalendar;
@interface FSCalendarCollectionViewLayout : UICollectionViewLayout
@property (weak, nonatomic) FSCalendar *calendar;
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@end