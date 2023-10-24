import UIKit
class StellarSeleCardCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardNameLabel.font = STELLAR_FONT_T14
        backgroundColor = STELLAR_COLOR_C8
    }
    func setData(name:String,isSelect:Bool){
        cardNameLabel.text = name
        if isSelect {
            cardNameLabel.textColor = STELLAR_COLOR_C1
            backgroundColor = STELLAR_COLOR_C3
            cardNameLabel.font = STELLAR_FONT_BOLD_T14
        }else{
            cardNameLabel.font = STELLAR_FONT_T14
            cardNameLabel.textColor = STELLAR_COLOR_C4
            backgroundColor = STELLAR_COLOR_C8
        }
    }
}