import UIKit
class CommonReSetViewController: AddDeviceBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C1
        navBar.titleLabel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_HELP_TITLE")
        navBar.exitButton.isHidden = true
        lineImage.isHidden = true
        tableView.register(UINib(nibName: "ReSetHubCell", bundle: nil), forCellReuseIdentifier: "ReSetHubCell")
        cardView.addSubview(tableView)
        cardView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(9.fit)
            make.right.equalToSuperview().offset(-9.fit)
            make.top.equalTo(navBar.snp.bottom).offset(10.fit)
            make.bottom.equalToSuperview().offset(-kBottomArcH - 32.fit)
        }
        tableView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        cardView.layer.cornerRadius = 12.fit
        cardView.clipsToBounds = true
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.cardView.frame.width, height: self.cardView.frame.height))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.separatorStyle = .none
        return tempView
    }()
}
extension CommonReSetViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReSetHubCell", for: indexPath) as! ReSetHubCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}