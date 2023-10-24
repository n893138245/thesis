#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/NSObject.h>
#import <pop/POPDefines.h>
#import <pop/POPAnimatablePropertyTypes.h>
@class POPMutableAnimatableProperty;
@interface POPAnimatableProperty : NSObject <NSCopying, NSMutableCopying>
+ (id)propertyWithName:(NSString *)name;
+ (id)propertyWithName:(NSString *)name initializer:(void (^)(POPMutableAnimatableProperty *prop))block;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) POPAnimatablePropertyReadBlock readBlock;
@property (readonly, nonatomic, copy) POPAnimatablePropertyWriteBlock writeBlock;
@property (readonly, nonatomic, assign) CGFloat threshold;
@end
@interface POPMutableAnimatableProperty : POPAnimatableProperty
@property (readwrite, nonatomic, copy) NSString *name;
@property (readwrite, nonatomic, copy) POPAnimatablePropertyReadBlock readBlock;
@property (readwrite, nonatomic, copy) POPAnimatablePropertyWriteBlock writeBlock;
@property (readwrite, nonatomic, assign) CGFloat threshold;
@end
POP_EXTERN_C_BEGIN
extern NSString * const kPOPLayerBackgroundColor;
extern NSString * const kPOPLayerBounds;
extern NSString * const kPOPLayerCornerRadius;
extern NSString * const kPOPLayerBorderWidth;
extern NSString * const kPOPLayerBorderColor;
extern NSString * const kPOPLayerOpacity;
extern NSString * const kPOPLayerPosition;
extern NSString * const kPOPLayerPositionX;
extern NSString * const kPOPLayerPositionY;
extern NSString * const kPOPLayerRotation;
extern NSString * const kPOPLayerRotationX;
extern NSString * const kPOPLayerRotationY;
extern NSString * const kPOPLayerScaleX;
extern NSString * const kPOPLayerScaleXY;
extern NSString * const kPOPLayerScaleY;
extern NSString * const kPOPLayerSize;
extern NSString * const kPOPLayerSubscaleXY;
extern NSString * const kPOPLayerSubtranslationX;
extern NSString * const kPOPLayerSubtranslationXY;
extern NSString * const kPOPLayerSubtranslationY;
extern NSString * const kPOPLayerSubtranslationZ;
extern NSString * const kPOPLayerTranslationX;
extern NSString * const kPOPLayerTranslationXY;
extern NSString * const kPOPLayerTranslationY;
extern NSString * const kPOPLayerTranslationZ;
extern NSString * const kPOPLayerZPosition;
extern NSString * const kPOPLayerShadowColor;
extern NSString * const kPOPLayerShadowOffset;
extern NSString * const kPOPLayerShadowOpacity;
extern NSString * const kPOPLayerShadowRadius;
extern NSString * const kPOPShapeLayerStrokeStart;
extern NSString * const kPOPShapeLayerStrokeEnd;
extern NSString * const kPOPShapeLayerStrokeColor;
extern NSString * const kPOPShapeLayerFillColor;
extern NSString * const kPOPShapeLayerLineWidth;
extern NSString * const kPOPShapeLayerLineDashPhase;
extern NSString * const kPOPLayoutConstraintConstant;
#if TARGET_OS_IPHONE
extern NSString * const kPOPViewAlpha;
extern NSString * const kPOPViewBackgroundColor;
extern NSString * const kPOPViewBounds;
extern NSString * const kPOPViewCenter;
extern NSString * const kPOPViewFrame;
extern NSString * const kPOPViewScaleX;
extern NSString * const kPOPViewScaleXY;
extern NSString * const kPOPViewScaleY;
extern NSString * const kPOPViewSize;
extern NSString * const kPOPViewTintColor;
extern NSString * const kPOPScrollViewContentOffset;
extern NSString * const kPOPScrollViewContentSize;
extern NSString * const kPOPScrollViewZoomScale;
extern NSString * const kPOPScrollViewContentInset;
extern NSString * const kPOPScrollViewScrollIndicatorInsets;
extern NSString * const kPOPTableViewContentOffset;
extern NSString * const kPOPTableViewContentSize;
extern NSString * const kPOPCollectionViewContentOffset;
extern NSString * const kPOPCollectionViewContentSize;
extern NSString * const kPOPNavigationBarBarTintColor;
extern NSString * const kPOPToolbarBarTintColor;
extern NSString * const kPOPTabBarBarTintColor;
extern NSString * const kPOPLabelTextColor;
#else
extern NSString * const kPOPViewFrame;
extern NSString * const kPOPViewBounds;
extern NSString * const kPOPViewAlphaValue;
extern NSString * const kPOPViewFrameRotation;
extern NSString * const kPOPViewFrameCenterRotation;
extern NSString * const kPOPViewBoundsRotation;
extern NSString * const kPOPWindowFrame;
extern NSString * const kPOPWindowAlphaValue;
extern NSString * const kPOPWindowBackgroundColor;
#endif
#if SCENEKIT_SDK_AVAILABLE
extern NSString * const kPOPSCNNodePosition;
extern NSString * const kPOPSCNNodePositionX;
extern NSString * const kPOPSCNNodePositionY;
extern NSString * const kPOPSCNNodePositionZ;
extern NSString * const kPOPSCNNodeTranslation;
extern NSString * const kPOPSCNNodeTranslationX;
extern NSString * const kPOPSCNNodeTranslationY;
extern NSString * const kPOPSCNNodeTranslationZ;
extern NSString * const kPOPSCNNodeRotation;
extern NSString * const kPOPSCNNodeRotationX;
extern NSString * const kPOPSCNNodeRotationY;
extern NSString * const kPOPSCNNodeRotationZ;
extern NSString * const kPOPSCNNodeRotationW;
extern NSString * const kPOPSCNNodeEulerAngles;
extern NSString * const kPOPSCNNodeEulerAnglesX;
extern NSString * const kPOPSCNNodeEulerAnglesY;
extern NSString * const kPOPSCNNodeEulerAnglesZ;
extern NSString * const kPOPSCNNodeOrientation;
extern NSString * const kPOPSCNNodeOrientationX;
extern NSString * const kPOPSCNNodeOrientationY;
extern NSString * const kPOPSCNNodeOrientationZ;
extern NSString * const kPOPSCNNodeOrientationW;
extern NSString * const kPOPSCNNodeScale;
extern NSString * const kPOPSCNNodeScaleX;
extern NSString * const kPOPSCNNodeScaleY;
extern NSString * const kPOPSCNNodeScaleZ;
extern NSString * const kPOPSCNNodeScaleXY;
#endif
POP_EXTERN_C_END