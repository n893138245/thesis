import UIKit
class EquipmentLoadingHeadView: UIView {
    @IBOutlet weak var leftView1: UIView!
    @IBOutlet weak var leftView2: UIView!
    @IBOutlet weak var rightView: UIView!
    class func equipmentLoadingHeadView() ->EquipmentLoadingHeadView {
        let view = Bundle.main.loadNibNamed("EquipmentLoadingHeadView", owner: nil, options: nil)?.last as! EquipmentLoadingHeadView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ss.addGradientLayer(maskPreView: leftView1)
        self.ss.addGradientLayer(maskPreView: leftView2)
        self.ss.addGradientLayer(maskPreView: rightView)
    }
}