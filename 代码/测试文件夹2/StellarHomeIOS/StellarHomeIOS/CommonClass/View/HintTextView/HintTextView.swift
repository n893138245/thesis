import UIKit
class HintTextView: UIView {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textLabelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var isShowing: Bool = false
    class func HintTextView(_ title:String = "") ->HintTextView {
        let view = Bundle.main.loadNibNamed("HintTextView", owner: nil, options: nil)?.last as! HintTextView
        view.textLabel.text = title
        view.sizeToFit()
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.textColor = STELLAR_COLOR_C3
        textLabel.font = STELLAR_FONT_T14
        contentView.backgroundColor = STELLAR_COLOR_C2
        isHidden = true
        textLabelViewTopConstraint.constant = -contentView.bounds.size.height
    }
    func showAnimationAndHideenAfterDuration(_ duration: TimeInterval){
        layoutIfNeeded()
        if isShowing == false{
            isShowing = true
            self.isHidden = false
            textLabelViewTopConstraint.constant = 40
            UIView.animate(withDuration: 0.75, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now()+duration, execute: {
                    self.closeView()
                })
            }
        }
    }
    func showAnimationWithTitle(_ title:String , duration: TimeInterval){
        textLabel.text = title
        showAnimationAndHideenAfterDuration(duration)
    }
    func closeView(){
        if isShowing == true{
            self.isShowing = false
            textLabelViewTopConstraint.constant = -contentView.bounds.size.height
            UIView.animate(withDuration: 0.75, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.isHidden = true
            }
        }
    }
}