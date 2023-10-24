import UIKit
class UploadPicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    var deleteBlock:(()->Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUploadImageView(image:UIImage){
        uploadImageView.isHidden = false
        deleteBtn.isHidden = false
        uploadImageView.image = image
    }
    func setAddState(){
        uploadImageView.isHidden = true
        deleteBtn.isHidden = true
    }
    @IBAction func clickAction(_ sender: UIButton) {
        if deleteBlock != nil {
            deleteBlock!()
        }
    }
}