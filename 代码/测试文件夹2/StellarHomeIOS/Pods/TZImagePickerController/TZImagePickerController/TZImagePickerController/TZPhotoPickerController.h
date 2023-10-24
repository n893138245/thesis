#import <UIKit/UIKit.h>
@class TZAlbumModel;
@interface TZPhotoPickerController : UIViewController
@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) TZAlbumModel *model;
@end
@interface TZCollectionView : UICollectionView
@end