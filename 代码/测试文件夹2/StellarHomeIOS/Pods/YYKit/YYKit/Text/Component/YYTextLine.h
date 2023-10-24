#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextAttribute.h>
#else
#import "YYTextAttribute.h"
#endif
@class YYTextRunGlyphRange;
NS_ASSUME_NONNULL_BEGIN
@interface YYTextLine : NSObject
+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position vertical:(BOOL)isVertical;
@property (nonatomic) NSUInteger index;     
@property (nonatomic) NSUInteger row;       
@property (nullable, nonatomic, strong) NSArray<NSArray<YYTextRunGlyphRange *> *> *verticalRotateRange; 
@property (nonatomic, readonly) CTLineRef CTLine;   
@property (nonatomic, readonly) NSRange range;      
@property (nonatomic, readonly) BOOL vertical;      
@property (nonatomic, readonly) CGRect bounds;      
@property (nonatomic, readonly) CGSize size;        
@property (nonatomic, readonly) CGFloat width;      
@property (nonatomic, readonly) CGFloat height;     
@property (nonatomic, readonly) CGFloat top;        
@property (nonatomic, readonly) CGFloat bottom;     
@property (nonatomic, readonly) CGFloat left;       
@property (nonatomic, readonly) CGFloat right;      
@property (nonatomic)   CGPoint position;   
@property (nonatomic, readonly) CGFloat ascent;     
@property (nonatomic, readonly) CGFloat descent;    
@property (nonatomic, readonly) CGFloat leading;    
@property (nonatomic, readonly) CGFloat lineWidth;  
@property (nonatomic, readonly) CGFloat trailingWhitespaceWidth;
@property (nullable, nonatomic, readonly) NSArray<YYTextAttachment *> *attachments; 
@property (nullable, nonatomic, readonly) NSArray<NSValue *> *attachmentRanges;     
@property (nullable, nonatomic, readonly) NSArray<NSValue *> *attachmentRects;      
@end
typedef NS_ENUM(NSUInteger, YYTextRunGlyphDrawMode) {
    YYTextRunGlyphDrawModeHorizontal = 0,
    YYTextRunGlyphDrawModeVerticalRotate = 1,
    YYTextRunGlyphDrawModeVerticalRotateMove = 2,
};
@interface YYTextRunGlyphRange : NSObject
@property (nonatomic) NSRange glyphRangeInRun;
@property (nonatomic) YYTextRunGlyphDrawMode drawMode;
+ (instancetype)rangeWithRange:(NSRange)range drawMode:(YYTextRunGlyphDrawMode)mode;
@end
NS_ASSUME_NONNULL_END