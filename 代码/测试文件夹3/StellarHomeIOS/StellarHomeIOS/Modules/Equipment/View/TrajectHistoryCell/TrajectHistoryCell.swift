import UIKit
class TrajectHistoryCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }
    private func setupUI() {
        contentView.addSubview(bgImage)
        bgImage.snp.makeConstraints {
            $0.top.equalTo(self).offset(36)
            $0.left.equalTo(9.fit)
            $0.width.equalTo(kScreenWidth - 18.fit)
        }
        contentView.addSubview(radisView)
    }
    static func initWithXIb() -> UITableViewCell {
        let arrayOfViews = Bundle.main.loadNibNamed("TrajectHistoryCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
    func setupData(locations: [RadarLocationInfo]) {
        radisView.addPointViews(locations: locations)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    lazy var bgImage: UIImageView = {
        let tempView = UIImageView(image: UIImage(named: "ydgj_bg_round"))
        tempView.contentMode = .scaleAspectFit
        return tempView
    }()
    private lazy var radisView: PositionView = {
        let tempView = PositionView.init(frame: CGRect(x: (kScreenWidth - 172) * 0.5, y: 61, width: 172, height: 172))
        return tempView
    }()
}