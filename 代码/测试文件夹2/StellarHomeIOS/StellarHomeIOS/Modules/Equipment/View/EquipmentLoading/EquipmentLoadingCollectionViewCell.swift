import UIKit
class EquipmentLoadingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var top1View: UIView!
    @IBOutlet weak var top2View: UIView!
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ss.addGradientLayer(maskPreView: top1View)
        self.ss.addGradientLayer(maskPreView: top2View)
        self.ss.addGradientLayer(maskPreView: bottomView)
    }
}