#import <QuartzCore/QuartzCore.h>
#import <pop/POPDefines.h>
POP_EXTERN_C_BEGIN
#pragma mark - Scale
extern CGFloat POPLayerGetScaleX(CALayer *l);
extern void POPLayerSetScaleX(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetScaleY(CALayer *l);
extern void POPLayerSetScaleY(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetScaleZ(CALayer *l);
extern void POPLayerSetScaleZ(CALayer *l, CGFloat f);
extern CGPoint POPLayerGetScaleXY(CALayer *l);
extern void POPLayerSetScaleXY(CALayer *l, CGPoint p);
#pragma mark - Translation
extern CGFloat POPLayerGetTranslationX(CALayer *l);
extern void POPLayerSetTranslationX(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetTranslationY(CALayer *l);
extern void POPLayerSetTranslationY(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetTranslationZ(CALayer *l);
extern void POPLayerSetTranslationZ(CALayer *l, CGFloat f);
extern CGPoint POPLayerGetTranslationXY(CALayer *l);
extern void POPLayerSetTranslationXY(CALayer *l, CGPoint p);
#pragma mark - Rotation
extern CGFloat POPLayerGetRotationX(CALayer *l);
extern void POPLayerSetRotationX(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetRotationY(CALayer *l);
extern void POPLayerSetRotationY(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetRotationZ(CALayer *l);
extern void POPLayerSetRotationZ(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetRotation(CALayer *l);
extern void POPLayerSetRotation(CALayer *l, CGFloat f);
#pragma mark - Sublayer Scale
extern CGPoint POPLayerGetSubScaleXY(CALayer *l);
extern void POPLayerSetSubScaleXY(CALayer *l, CGPoint p);
#pragma mark - Sublayer Translation
extern CGFloat POPLayerGetSubTranslationX(CALayer *l);
extern void POPLayerSetSubTranslationX(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetSubTranslationY(CALayer *l);
extern void POPLayerSetSubTranslationY(CALayer *l, CGFloat f);
extern CGFloat POPLayerGetSubTranslationZ(CALayer *l);
extern void POPLayerSetSubTranslationZ(CALayer *l, CGFloat f);
extern CGPoint POPLayerGetSubTranslationXY(CALayer *l);
extern void POPLayerSetSubTranslationXY(CALayer *l, CGPoint p);
POP_EXTERN_C_END