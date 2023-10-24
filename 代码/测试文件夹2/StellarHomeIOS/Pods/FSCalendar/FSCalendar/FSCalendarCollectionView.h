#import <UIKit/UIKit.h>
@class FSCalendarCollectionView;
@protocol FSCalendarCollectionViewInternalDelegate <UICollectionViewDelegate>
@optional
- (void)collectionViewDidFinishLayoutSubviews:(FSCalendarCollectionView *)collectionView;
@end
@interface FSCalendarCollectionView : UICollectionView
@property (weak, nonatomic) id<FSCalendarCollectionViewInternalDelegate> internalDelegate;
@end