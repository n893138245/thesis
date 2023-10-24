#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIPasteboard (YYText)
@property (nullable, nonatomic, copy) NSData *PNGData;    
@property (nullable, nonatomic, copy) NSData *JPEGData;   
@property (nullable, nonatomic, copy) NSData *GIFData;    
@property (nullable, nonatomic, copy) NSData *WEBPData;   
@property (nullable, nonatomic, copy) NSData *imageData;  
@property (nullable, nonatomic, copy) NSAttributedString *attributedString;
@end
UIKIT_EXTERN NSString *const YYPasteboardTypeAttributedString;
UIKIT_EXTERN NSString *const YYUTTypeWEBP;
NS_ASSUME_NONNULL_END