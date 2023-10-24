#import <UIKit/UIKit.h>
#import "TZAssetModel.h"
#import "NSBundle+TZImagePicker.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZPhotoPreviewController.h"
#import "TZPhotoPreviewCell.h"
@class TZAlbumCell, TZAssetCell;
@protocol TZImagePickerControllerDelegate;
@interface TZImagePickerController : UINavigationController
#pragma mark -
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate;
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<TZImagePickerControllerDelegate>)delegate;
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<TZImagePickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc;
- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets selectedPhotos:(NSMutableArray *)selectedPhotos index:(NSInteger)index;
- (instancetype)initCropTypeWithAsset:(PHAsset *)asset photo:(UIImage *)photo completion:(void (^)(UIImage *cropImage,PHAsset *asset))completion;
#pragma mark -
@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, assign) NSInteger minImagesCount;
@property (nonatomic, assign) BOOL autoSelectCurrentWhenDone;
@property (nonatomic, assign) BOOL alwaysEnableDoneBtn;
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;
@property (nonatomic, assign) CGFloat photoWidth;
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
@property (nonatomic, assign) BOOL allowPickingVideo;
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;
@property (nonatomic, assign) BOOL allowPickingGif;
@property (nonatomic, assign) BOOL allowPickingImage;
@property (nonatomic, assign) BOOL allowTakePicture;
@property (nonatomic, assign) BOOL allowCameraLocation;
@property(nonatomic, assign) BOOL allowTakeVideo;
@property (assign, nonatomic) NSTimeInterval videoMaximumDuration;
@property (nonatomic, copy) void(^uiImagePickerControllerSettingBlock)(UIImagePickerController *imagePickerController);
@property (copy, nonatomic) NSString *preferredLanguage;
@property (strong, nonatomic) NSBundle *languageBundle;
@property (nonatomic, assign) BOOL allowPreview;
@property(nonatomic, assign) BOOL autoDismiss;
@property (assign, nonatomic) BOOL onlyReturnAsset;
@property (assign, nonatomic) BOOL showSelectedIndex;
@property (assign, nonatomic) BOOL showPhotoCannotSelectLayer;
@property (strong, nonatomic) UIColor *cannotSelectLayerColor;
@property (assign, nonatomic) BOOL notScaleImage;
@property (assign, nonatomic) BOOL needFixComposition;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *selectedModels;
@property (nonatomic, strong) NSMutableArray *selectedAssetIds;
- (void)addSelectedModel:(TZAssetModel *)model;
- (void)removeSelectedModel:(TZAssetModel *)model;
@property (nonatomic, assign) NSInteger minPhotoWidthSelectable;
@property (nonatomic, assign) NSInteger minPhotoHeightSelectable;
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;
@property (nonatomic, assign) BOOL isStatusBarDefault __attribute__((deprecated("Use -statusBarStyle.")));
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
#pragma mark -
@property (nonatomic, assign) BOOL showSelectBtn;        
@property (nonatomic, assign) BOOL allowCrop;            
@property (nonatomic, assign) BOOL scaleAspectFillCrop;  
@property (nonatomic, assign) CGRect cropRect;           
@property (nonatomic, assign) CGRect cropRectPortrait;   
@property (nonatomic, assign) CGRect cropRectLandscape;  
@property (nonatomic, assign) BOOL needCircleCrop;       
@property (nonatomic, assign) NSInteger circleCropRadius;  
@property (nonatomic, copy) void (^cropViewSettingBlock)(UIView *cropView);     
@property (nonatomic, copy) void (^navLeftBarButtonSettingBlock)(UIButton *leftButton);     
@property (nonatomic, copy) void (^photoPickerPageUIConfigBlock)(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine);
@property (nonatomic, copy) void (^photoPreviewPageUIConfigBlock)(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel);
@property (nonatomic, copy) void (^videoPreviewPageUIConfigBlock)(UIButton *playButton, UIView *toolBar, UIButton *doneButton);
@property (nonatomic, copy) void (^gifPreviewPageUIConfigBlock)(UIView *toolBar, UIButton *doneButton);
@property (nonatomic, copy) void (^albumPickerPageUIConfigBlock)(UITableView *tableView);
@property (nonatomic, copy) void (^assetCellDidSetModelBlock)(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView);
@property (nonatomic, copy) void (^albumCellDidSetModelBlock)(TZAlbumCell *cell, UIImageView *posterImageView, UILabel *titleLabel);
@property (nonatomic, copy) void (^photoPickerPageDidLayoutSubviewsBlock)(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine);
@property (nonatomic, copy) void (^photoPreviewPageDidLayoutSubviewsBlock)(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel);
@property (nonatomic, copy) void (^videoPreviewPageDidLayoutSubviewsBlock)(UIButton *playButton, UIView *toolBar, UIButton *doneButton);
@property (nonatomic, copy) void (^gifPreviewPageDidLayoutSubviewsBlock)(UIView *toolBar, UIButton *doneButton);
@property (nonatomic, copy) void (^albumPickerPageDidLayoutSubviewsBlock)(UITableView *tableView);
@property (nonatomic, copy) void (^assetCellDidLayoutSubviewsBlock)(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView);
@property (nonatomic, copy) void (^albumCellDidLayoutSubviewsBlock)(TZAlbumCell *cell, UIImageView *posterImageView, UILabel *titleLabel);
@property (nonatomic, copy) void (^photoPickerPageDidRefreshStateBlock)(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine);
@property (nonatomic, copy) void (^photoPreviewPageDidRefreshStateBlock)(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel);
#pragma mark -
- (UIAlertController *)showAlertWithTitle:(NSString *)title;
- (void)showProgressHUD;
- (void)hideProgressHUD;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (assign, nonatomic) BOOL needShowStatusBar;
#pragma mark -
@property (nonatomic, copy) NSString *takePictureImageName __attribute__((deprecated("Use -takePictureImage.")));
@property (nonatomic, copy) NSString *photoSelImageName __attribute__((deprecated("Use -photoSelImage.")));
@property (nonatomic, copy) NSString *photoDefImageName __attribute__((deprecated("Use -photoDefImage.")));
@property (nonatomic, copy) NSString *photoOriginSelImageName __attribute__((deprecated("Use -photoOriginSelImage.")));
@property (nonatomic, copy) NSString *photoOriginDefImageName __attribute__((deprecated("Use -photoOriginDefImage.")));
@property (nonatomic, copy) NSString *photoPreviewOriginDefImageName __attribute__((deprecated("Use -photoPreviewOriginDefImage.")));
@property (nonatomic, copy) NSString *photoNumberIconImageName __attribute__((deprecated("Use -photoNumberIconImage.")));
@property (nonatomic, strong) UIImage *takePictureImage;
@property (nonatomic, strong) UIImage *photoSelImage;
@property (nonatomic, strong) UIImage *photoDefImage;
@property (nonatomic, strong) UIImage *photoOriginSelImage;
@property (nonatomic, strong) UIImage *photoOriginDefImage;
@property (nonatomic, strong) UIImage *photoPreviewOriginDefImage;
@property (nonatomic, strong) UIImage *photoNumberIconImage;
#pragma mark -
@property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
@property (nonatomic, strong) UIColor *oKButtonTitleColorDisabled;
@property (nonatomic, strong) UIColor *naviBgColor;
@property (nonatomic, strong) UIColor *naviTitleColor;
@property (nonatomic, strong) UIFont *naviTitleFont;
@property (nonatomic, strong) UIColor *barItemTextColor;
@property (nonatomic, strong) UIFont *barItemTextFont;
@property (nonatomic, copy) NSString *doneBtnTitleStr;
@property (nonatomic, copy) NSString *cancelBtnTitleStr;
@property (nonatomic, copy) NSString *previewBtnTitleStr;
@property (nonatomic, copy) NSString *fullImageBtnTitleStr;
@property (nonatomic, copy) NSString *settingBtnTitleStr;
@property (nonatomic, copy) NSString *processHintStr;
@property (strong, nonatomic) UIColor *iconThemeColor;
#pragma mark -
- (void)cancelButtonClick;
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^didFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto,NSArray<NSDictionary *> *infos);
@property (nonatomic, copy) void (^imagePickerControllerDidCancelHandle)(void);
@property (nonatomic, copy) void (^didFinishPickingVideoHandle)(UIImage *coverImage,PHAsset *asset);
@property (nonatomic, copy) void (^didFinishPickingGifImageHandle)(UIImage *animatedImage,id sourceAssets);
@property (nonatomic, weak) id<TZImagePickerControllerDelegate> pickerDelegate;
@end
@protocol TZImagePickerControllerDelegate <NSObject>
@optional
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos;
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker;
- (void)imagePickerController:(TZImagePickerController *)picker didSelectAsset:(PHAsset *)asset photo:(UIImage *)photo isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
- (void)imagePickerController:(TZImagePickerController *)picker didDeselectAsset:(PHAsset *)asset photo:(UIImage *)photo isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset;
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset;
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result;
- (BOOL)isAssetCanSelect:(PHAsset *)asset __attribute__((deprecated("Use -isAssetCanBeDisplayed:.")));
- (BOOL)isAssetCanBeDisplayed:(PHAsset *)asset;
- (BOOL)isAssetCanBeSelected:(PHAsset *)asset;
@end
@interface TZAlbumPickerController : UIViewController
@property (nonatomic, assign) NSInteger columnNumber;
@property (assign, nonatomic) BOOL isFirstAppear;
- (void)configTableView;
@end
@interface UIImage (MyBundle)
+ (UIImage *)tz_imageNamedFromMyBundle:(NSString *)name;
@end
@interface TZCommonTools : NSObject
+ (UIEdgeInsets)tz_safeAreaInsets;
+ (BOOL)tz_isIPhoneX;
+ (CGFloat)tz_statusBarHeight;
+ (NSDictionary *)tz_getInfoDictionary;
+ (BOOL)tz_isRightToLeftLayout;
+ (void)configBarButtonItem:(UIBarButtonItem *)item tzImagePickerVc:(TZImagePickerController *)tzImagePickerVc;
+ (BOOL)isICloudSyncError:(NSError *)error;
@end
@interface TZImagePickerConfig : NSObject
+ (instancetype)sharedInstance;
@property (copy, nonatomic) NSString *preferredLanguage;
@property(nonatomic, assign) BOOL allowPickingImage;
@property (nonatomic, assign) BOOL allowPickingVideo;
@property (strong, nonatomic) NSBundle *languageBundle;
@property (assign, nonatomic) BOOL showSelectedIndex;
@property (assign, nonatomic) BOOL showPhotoCannotSelectLayer;
@property (assign, nonatomic) BOOL notScaleImage;
@property (assign, nonatomic) BOOL needFixComposition;
@property (assign, nonatomic) NSInteger gifPreviewMaxImagesCount;
@property (nonatomic, copy) void (^gifImagePlayBlock)(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info);
@end