import UIKit
class StellarNumTextField: UITextField {
    var deleteBlock:(()->Void)? = nil
    override func deleteBackward() {
        super.deleteBackward()
        if deleteBlock != nil{
            deleteBlock!()
        }
    }
}