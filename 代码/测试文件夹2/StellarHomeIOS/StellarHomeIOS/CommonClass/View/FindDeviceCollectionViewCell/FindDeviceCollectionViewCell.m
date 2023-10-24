#import "FindDeviceCollectionViewCell.h"
@interface FindDeviceCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end
@implementation FindDeviceCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FindDeviceCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[FindDeviceCollectionViewCell class]])
        {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.frame=frame;
        [self layoutIfNeeded];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
@end