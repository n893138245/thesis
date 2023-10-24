#import "FindDevicesTableViewCell.h"
#import "FindDeviceCollectionViewCell.h"
@interface FindDevicesTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@end
@implementation FindDevicesTableViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FindDevicesTableViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[FindDevicesTableViewCell class]])
        {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.frame=frame;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsMake(0,15,0,0)];
        }
        [self setupView];
        [self layoutIfNeeded];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
-(void)setupView
{
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    [self.collectView registerClass:[FindDeviceCollectionViewCell class] forCellWithReuseIdentifier:@"findDeviceCollectionViewCell"];
}
#pragma mark - deleDate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"findDeviceCollectionViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FindDeviceCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((self.frame.size.width - 40)/3,(self.frame.size.width - 40)/3);
}
@end