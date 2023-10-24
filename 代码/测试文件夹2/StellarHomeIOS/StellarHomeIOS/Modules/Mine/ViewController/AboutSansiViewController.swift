import UIKit
import MessageUI
class AboutSansiViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    private func setupUI() {
        view.addSubview(navBar)
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tableView)
        let header = Bundle.main.loadNibNamed("AboutSansiHeaderView", owner: nil, options: nil)?.first as! AboutSansiHeaderView
        header.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 122)
        tableView.tableHeaderView = header
        let bottomSpace = 20.fit + getAllVersionSafeAreaBottomHeight()
        view.addSubview(copyrightLabel)
        copyrightLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).offset(-bottomSpace)
        }
        view.addSubview(userAgreementButton)
        userAgreementButton.snp.makeConstraints {
            $0.centerX.equalTo(view).offset(-20)
            $0.bottom.equalTo(copyrightLabel.snp.top).offset(-9.fit)
        }
        view.addSubview(privacyAgreementButton)
        privacyAgreementButton.snp.makeConstraints {
            $0.left.equalTo(userAgreementButton.snp.right)
            $0.bottom.equalTo(copyrightLabel.snp.top).offset(-9.fit)
        }
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        userAgreementButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = UserAgreementViewController()
            vc.titleText  = StellarLocalizedString("MINE_USER_ABOUT_USER_AGREEMENT")
            vc.urlStr = StellarHomeResourceUrl.agreement_link
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        privacyAgreementButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = UserAgreementViewController()
            vc.titleText  = StellarLocalizedString("MINE_USER_ABOUT_USER_PRIVACY")
            vc.urlStr = StellarHomeResourceUrl.privacy_link
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "AboutSansiWebCell", bundle: nil), forCellReuseIdentifier: "AboutSansiWebCell")
        tempView.register(UINib(nibName: "AboutSansiSocialCell", bundle: nil), forCellReuseIdentifier: "AboutSansiSocialCell")
        tempView.separatorStyle = .none
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tempView.moreButton.isHidden = true
        tempView.titleLabel.text = StellarLocalizedString("MINE_ABOUT_US")
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var copyrightLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C7
        tempView.text = "Copyright©2020 SANSI. All Rights Reserved."
        return tempView
    }()
    lazy var userAgreementButton: UIButton = {
        let tempView = UIButton(type: .custom)
        let str = StellarLocalizedString("MINE_USER_ABOUT_USER_AGREEMENT")
        var attributedString = NSMutableAttributedString(string:str)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C5,
                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                        NSAttributedString.Key.font: STELLAR_FONT_T13], range: NSRange.init(location: 0, length: str.count))
        tempView.setAttributedTitle(attributedString, for: .normal)
        var attributedEndString = NSMutableAttributedString(string:StellarLocalizedString("MINE_USER_AND"))
        attributedEndString.addAttributes([NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C5,
                                           NSAttributedString.Key.font: STELLAR_FONT_T13], range: NSRange.init(location: 0, length: 1))
        attributedString.append(attributedEndString)
        tempView.setAttributedTitle(attributedString, for: .normal)
        tempView.sizeToFit()
        return tempView
    }()
    lazy var privacyAgreementButton: UIButton = {
        let tempView = UIButton(type: .custom)
        let str = StellarLocalizedString("MINE_USER_ABOUT_USER_PRIVACY")
        var attributedString = NSMutableAttributedString(string:str)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C5,
                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                        NSAttributedString.Key.font: STELLAR_FONT_T13], range: NSRange.init(location: 0, length: str.count))
        tempView.setAttributedTitle(attributedString, for: .normal)
        tempView.sizeToFit()
        return tempView
    }()
}
extension AboutSansiViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutSansiSocialCell", for: indexPath) as! AboutSansiSocialCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutSansiWebCell", for: indexPath) as! AboutSansiWebCell
        if indexPath.row != 3 {
            cell.aboutStyle = .web
            if indexPath.row == 0 {
                cell.mTitleLabel.text = StellarLocalizedString("MINE_ABUOT_WEB")
                cell.webLabel.text = "www.sansitech.com"
            }else {
                cell.mTitleLabel.text = "联系电话"
                cell.webLabel.text = "400-118-3434"
            }
        }else {
            cell.aboutStyle = .version
            cell.mTitleLabel.text = StellarLocalizedString("MINE_ABUOT_VERSION")
            cell.versionLabel.text = "V\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0beat")"+"(\((Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""))"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 145
        }
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            jumpTo(url: "http:
        case 1:
            jumpTo(url: "telprompt:
        default:
            break
        }
    }
}