import UIKit
class EquipmentLoadingBottomView: UIView {
    @IBOutlet weak var tabbarTopView1: UIView!
    @IBOutlet weak var tabbarBottomView1: UIView!
    @IBOutlet weak var tabbarTopView2: UIView!
    @IBOutlet weak var tabbarBottomView2: UIView!
    @IBOutlet weak var tabbarTopView3: UIView!
    @IBOutlet weak var tabbarBottomView3: UIView!
    @IBOutlet weak var tabbarTopView4: UIView!
    @IBOutlet weak var tabbarBottomView4: UIView!
    class func equipmentLoadingBottomView() ->EquipmentLoadingBottomView {
        let view = Bundle.main.loadNibNamed("EquipmentLoadingBottomView", owner: nil, options: nil)?.last as! EquipmentLoadingBottomView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ss.addGradientLayer(maskPreView: tabbarTopView1)
        self.ss.addGradientLayer(maskPreView: tabbarTopView2)
        self.ss.addGradientLayer(maskPreView: tabbarTopView3)
        self.ss.addGradientLayer(maskPreView: tabbarTopView4)
        self.ss.addGradientLayer(maskPreView: tabbarBottomView1)
        self.ss.addGradientLayer(maskPreView: tabbarBottomView2)
        self.ss.addGradientLayer(maskPreView: tabbarBottomView3)
        self.ss.addGradientLayer(maskPreView: tabbarBottomView4)
    }
}