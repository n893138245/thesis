#ifndef POPACTION_H
#define POPACTION_H
#import <QuartzCore/CATransaction.h>
#import <pop/POPDefines.h>
#ifdef __cplusplus
namespace POP {
  class ActionDisabler
  {
    BOOL state;
  public:
    ActionDisabler() POP_NOTHROW
    {
      state = [CATransaction disableActions];
      [CATransaction setDisableActions:YES];
    }
    ~ActionDisabler()
    {
      [CATransaction setDisableActions:state];
    }
  };
  class ActionEnabler
  {
    BOOL state;
  public:
    ActionEnabler() POP_NOTHROW
    {
      state = [CATransaction disableActions];
      [CATransaction setDisableActions:NO];
    }
    ~ActionEnabler()
    {
      [CATransaction setDisableActions:state];
    }
  };
}
#endif 
#endif 