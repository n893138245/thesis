import UIKit
class SSBottomPopView: UIView {
    @IBOutlet weak var contentViewBottpmConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var leftBtnWdith: NSLayoutConstraint!
    private let disposeBag = DisposeBag()
    private var selectionBaseFactory:HBottomSelectionBaseFactory?
    private var tableViewDataModel = TableViewDataModel()
    private var leftButtonClick:(()->Void)?
    var animDuration:TimeInterval = 0.3
    class func SSBottomPopView() ->SSBottomPopView {
        let view = Bundle.main.loadNibNamed("SSBottomPopView", owner: nil, options: nil)?.last as! SSBottomPopView
        view.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        view.tableViewDataModel.targetTableView(myTableview: view.tableview)
        let maskPath = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight], cornerRadii:CGSize(width:20, height:20))
        let masklayer = CAShapeLayer()
        masklayer.frame = view.bounds
        masklayer.path = maskPath.cgPath
        view.contentView.layer.mask = masklayer
        view.contentViewBottpmConstraint.constant = -view.contentViewHeightConstraint.constant
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        leftButton.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer()
        self.bgView.addGestureRecognizer(tap)
        tap.rx.event
            .subscribe(onNext: { [weak self] recognizer in
                self?.hidden(complete: nil)
            })
            .disposed(by: disposeBag)
        tableview.isScrollEnabled = false
        var leftWidth: CGFloat = 88
        if !isChinese() {
            leftWidth = 120
        }
        leftBtnWdith.constant = leftWidth
        leftButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 20 )
        leftButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: leftWidth-16, bottom: 0, right:0)
    }
    func setDisplayFactory(factory:HBottomSelectionBaseFactory){
        selectionBaseFactory = factory
        tableViewDataModel.tableViewDataArr.removeAll()
        tableViewDataModel.tableViewDataArr = factory.getSectionModelData()
        tableview.reloadData()
        factory.reloadBlock = { [weak self] in
            self?.tableViewDataModel.tableViewDataArr.removeAll()
            self?.tableViewDataModel.tableViewDataArr = factory.getSectionModelData()
            self?.tableview.reloadData()
        }
    }
    func setContentHeight(height:CGFloat,animated: Bool = false){
        if animated {
            UIView.animate(withDuration: animDuration, delay: 0.02, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.4, options: .allowAnimatedContent, animations: {
                self.contentViewHeightConstraint.constant = height
                self.layoutIfNeeded()
            }){ (finished) in
            }
        }else {
            contentViewHeightConstraint.constant = height
        }
    }
    func testHeright() {
        let height = contentViewHeightConstraint.constant
        contentViewHeightConstraint.constant = height + 100
        layoutIfNeeded()
    }
    func setupViews(title:String,leftClick:(()->Void)? = nil){
        titleLabel.text = title
        if leftClick == nil {
            leftButton.isHidden = true
        }else{
            leftButton.isHidden = false
        }
        self.leftButtonClick = {
            leftClick?()
        }
    }
    func show(){
        bgView.alpha = 0
        CURRENT_TOP_VC().view.addSubview(self)
        CURRENT_TOP_VC().fd_interactivePopDisabled = true
        layoutIfNeeded()
        UIView.animate(withDuration: animDuration, delay: 0.02, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .allowAnimatedContent, animations: {
            self.bgView.alpha = 0.5
            self.contentViewBottpmConstraint.constant = 0
            self.layoutIfNeeded()
        }){ (finished) in
        }
    }
    func hidden(complete: (() ->Void)?) {
        self.contentViewBottpmConstraint.constant = -contentViewHeightConstraint.constant
        UIView.animate(withDuration: 0.3, delay: 0.02, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .allowAnimatedContent, animations: {
            self.bgView.alpha = 0
            self.layoutIfNeeded()
        }){ (finished) in
            self.subviews.forEach({ (subView) in
                subView.removeFromSuperview()
            })
            self.removeFromSuperview()
            CURRENT_TOP_VC().fd_interactivePopDisabled = false
            complete?()
        }
    }
    @IBAction func leftClick(_ sender: Any) {
        leftButtonClick?()
    }
    @IBAction func closeClick(_ sender: Any) {
        hidden(complete: nil)
    }
    deinit {
        print("deinit-------------\(classForCoder)")
    }
}