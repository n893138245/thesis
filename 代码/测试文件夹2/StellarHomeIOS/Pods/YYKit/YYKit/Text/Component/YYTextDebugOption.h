#import <UIKit/UIKit.h>
@class YYTextDebugOption;
NS_ASSUME_NONNULL_BEGIN
@protocol YYTextDebugTarget <NSObject>
@required
- (void)setDebugOption:(nullable YYTextDebugOption *)option;
@end
@interface YYTextDebugOption : NSObject <NSCopying>
@property (nullable, nonatomic, strong) UIColor *baselineColor;      
@property (nullable, nonatomic, strong) UIColor *CTFrameBorderColor; 
@property (nullable, nonatomic, strong) UIColor *CTFrameFillColor;   
@property (nullable, nonatomic, strong) UIColor *CTLineBorderColor;  
@property (nullable, nonatomic, strong) UIColor *CTLineFillColor;    
@property (nullable, nonatomic, strong) UIColor *CTLineNumberColor;  
@property (nullable, nonatomic, strong) UIColor *CTRunBorderColor;   
@property (nullable, nonatomic, strong) UIColor *CTRunFillColor;     
@property (nullable, nonatomic, strong) UIColor *CTRunNumberColor;   
@property (nullable, nonatomic, strong) UIColor *CGGlyphBorderColor; 
@property (nullable, nonatomic, strong) UIColor *CGGlyphFillColor;   
- (BOOL)needDrawDebug; 
- (void)clear; 
+ (void)addDebugTarget:(id<YYTextDebugTarget>)target;
+ (void)removeDebugTarget:(id<YYTextDebugTarget>)target;
+ (nullable YYTextDebugOption *)sharedDebugOption;
+ (void)setSharedDebugOption:(nullable YYTextDebugOption *)option;
@end
NS_ASSUME_NONNULL_END