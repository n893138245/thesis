#import "AWSEXTScope.h"
void awsmtl_executeCleanupBlock (__strong awsmtl_cleanupBlock_t *block) {
    (*block)();
}