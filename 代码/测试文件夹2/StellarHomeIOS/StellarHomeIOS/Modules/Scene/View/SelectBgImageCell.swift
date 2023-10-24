import UIKit
class SelectBgImageCell: UICollectionViewCell {
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        selectBtn.isHidden = true
    }
    func setupData(bgModel: (model: ScenesBGImageModel, isSelected: Bool)) {
        let url = URL(string: getScenesBgImage(path: bgModel.model.path))
        bgImage.kf.setImage(with: url)
        selectBtn.isHidden = !bgModel.isSelected
    }
}