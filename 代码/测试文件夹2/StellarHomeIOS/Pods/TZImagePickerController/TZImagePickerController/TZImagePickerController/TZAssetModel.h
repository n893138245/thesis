#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
typedef enum : NSUInteger {
    TZAssetModelMediaTypePhoto = 0,
    TZAssetModelMediaTypeLivePhoto,
    TZAssetModelMediaTypePhotoGif,
    TZAssetModelMediaTypeVideo,
    TZAssetModelMediaTypeAudio
} TZAssetModelMediaType;
@class PHAsset;
@interface TZAssetModel : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL isSelected;      
@property (nonatomic, assign) TZAssetModelMediaType type;
@property (nonatomic, copy) NSString *timeLength;
@property (nonatomic, assign) BOOL iCloudFailed;
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(TZAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(TZAssetModelMediaType)type timeLength:(NSString *)timeLength;
@end
@class PHFetchResult;
@interface TZAlbumModel : NSObject
@property (nonatomic, strong) NSString *name;        
@property (nonatomic, assign) NSInteger count;       
@property (nonatomic, strong) PHFetchResult *result;
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) PHFetchOptions *options;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;
@property (nonatomic, assign) BOOL isCameraRoll;
- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets;
- (void)refreshFetchResult;
@end