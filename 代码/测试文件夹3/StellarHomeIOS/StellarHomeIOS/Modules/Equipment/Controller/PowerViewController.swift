import UIKit
class PowerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStars()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.setupStars()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self?.setupStars()
            })
        }
    }
    func setupUI() {
        let  bgImage = UIImageView.init()
        bgImage.backgroundColor = .red
        bgImage.image = UIImage(named: "light_close_bg")
        view.addSubview(bgImage)
        bgImage.frame = CGRect(x: 0, y: -1, width: kScreenWidth, height: kScreenHeight - 126.fit - getAllVersionSafeAreaBottomHeight())
    }
    private func setupStars() {
        for _ in 0...3 {
            let width = randomCustom(min: 4, max: 22)
            let star = OfflineStarView.init(frame: CGRect(x: randomCustom(min: 20, max: kScreenWidth-40), y: randomCustom(min: kNavigationH, max: kScreenHeight-150.fit), width: width, height: width))
            view.addSubview(star)
        }
    }
}