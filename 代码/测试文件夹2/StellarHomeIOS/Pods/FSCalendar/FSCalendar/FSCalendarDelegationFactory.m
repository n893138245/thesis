#import "FSCalendarDelegationFactory.h"
@implementation FSCalendarDelegationFactory
+ (FSCalendarDelegationProxy *)dataSourceProxy
{
    FSCalendarDelegationProxy *delegation = [[FSCalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(FSCalendarDataSource);
    return delegation;
}
+ (FSCalendarDelegationProxy *)delegateProxy
{
    FSCalendarDelegationProxy *delegation = [[FSCalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(FSCalendarDelegateAppearance);
    return delegation;
}
@end
#undef FSCalendarSelectorEntry