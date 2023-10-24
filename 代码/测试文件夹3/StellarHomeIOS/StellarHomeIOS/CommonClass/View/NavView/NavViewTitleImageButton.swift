import UIKit
class NavViewTitleImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if let title = self.titleLabel?.text, let _ = imageView?.image {
            let buttonRect = String.ss.getTextRectSize(text: title,font: STELLAR_FONT_BOLD_T18,size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 22))
            let MAX_TEXT_WIDTH = kScreenWidth - 110
            if buttonRect.size.width > MAX_TEXT_WIDTH {
                titleLabel?.frame = CGRect(x:0, y: 0, width: MAX_TEXT_WIDTH, height: 22)
                imageView?.center = CGPoint(x: MAX_TEXT_WIDTH + (imageView?.frame.width ?? 0) / 2.0, y: titleLabel?.centerY ?? 0)
            }else {
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -40, bottom: 0, right: 0 )
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: buttonRect.size.width + 8, bottom: 0, right:0)
            }
        }
    }
}