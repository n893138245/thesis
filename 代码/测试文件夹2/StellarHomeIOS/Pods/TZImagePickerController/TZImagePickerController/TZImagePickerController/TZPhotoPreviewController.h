#import <UIKit/UIKit.h>
@interface TZPhotoPreviewController : UIViewController
@property (nonatomic, strong) NSMutableArray *models;                  
@property (nonatomic, strong) NSMutableArray *photos;                  
@property (nonatomic, assign) NSInteger currentIndex;           
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;       
@property (nonatomic, assign) BOOL isCropImage;
@property (nonatomic, copy) void (^backButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage,id asset);
@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
@end