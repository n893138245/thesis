@protocol AWSUIConfiguration <NSObject>
@property (nonatomic, nullable) UIImage *logoImage;
@property (nonatomic, nullable) UIColor *backgroundColor;
@property (nonatomic, nullable) UIColor *secondaryBackgroundColor;
@property (nonatomic, nullable) UIColor *primaryColor;
@property (nonatomic) BOOL isBackgroundColorFullScreen;
@property (nonatomic, nullable) UIFont *font;
@end