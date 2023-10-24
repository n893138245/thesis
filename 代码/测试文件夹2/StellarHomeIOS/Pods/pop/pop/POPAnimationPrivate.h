#import <pop/POPAnimation.h>
#define POP_ANIMATION_FRICTION_FOR_QC_FRICTION(qcFriction) (25.0 + (((qcFriction - 8.0) / 2.0) * (25.0 - 19.0)))
#define POP_ANIMATION_TENSION_FOR_QC_TENSION(qcTension) (194.0 + (((qcTension - 30.0) / 50.0) * (375.0 - 194.0)))
#define QC_FRICTION_FOR_POP_ANIMATION_FRICTION(fbFriction) (8.0 + 2.0 * ((fbFriction - 25.0)/(25.0 - 19.0)))
#define QC_TENSION_FOR_POP_ANIMATION_TENSION(fbTension) (30.0 + 50.0 * ((fbTension - 194.0)/(375.0 - 194.0)))