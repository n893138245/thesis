import UIKit
import RxSwift
class StreamerViewController: BaseViewController {
    var selectedButton: UIButton?
    var isSmart: Bool = false {
        didSet {
            recView.isSmart = isSmart
            myCreatView.isSamrt = isSmart
        }
    }
    var tabbrIsHidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        setupViewsActions()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(bgScrollView)
        view.addSubview(recButton)
        view.addSubview(myCreatButton)
        bgScrollView.addSubview(recView)
        bgScrollView.addSubview(myCreatView)
        recButton.isSelected = true
        selectedButton = recButton
        if !isSmart {
            let plusButton = UIButton.init(type: .custom)
            plusButton.setBackgroundImage(UIImage(named: "icon_add_device.png"), for: .normal)
            view.addSubview(plusButton)
            plusButton.snp.makeConstraints {
                $0.centerY.equalTo(self.recButton.snp.centerY)
                $0.right.equalTo(self.view).offset(-20.fit)
                $0.height.equalTo(40.fit)
                $0.width.equalTo(40.fit)
            }
            plusButton.rx.tap.subscribe(onNext:{ [weak self] in
                let vc = CreatStreamerViewController.init()
                vc.resState = .creatStreamer
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        }
        if tabbrIsHidden {
            var frame = bgScrollView.frame
            frame.size.height += 126.fit
            bgScrollView.frame = frame
            recView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: bgScrollView.frame.height)
            myCreatView.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: bgScrollView.frame.height)
        }
    }
    private func setupRx() {
        recButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            [weak self]  in
            if (self?.selectedButton!.isEqual(self?.recButton))! {
                return
            }
            self?.selectedButton?.isSelected = false
            self?.recButton.isSelected = true
            self?.selectedButton = self?.recButton
            self?.setBgContenOffset(xWith: 0)
        }).disposed(by: disposeBag)
        myCreatButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            [weak self]  in
            if (self?.selectedButton!.isEqual(self?.myCreatButton))! {
                return
            }
            self?.selectedButton?.isSelected = false
            self?.myCreatButton.isSelected = true
            self?.selectedButton = self?.myCreatButton
            self?.setBgContenOffset(xWith: kScreenWidth)
        }).disposed(by: disposeBag)
    }
    private func setupViewsActions() {
        recView.clickMoreForRowBlock = { [weak self] (row) in
            let vc = StreamerDetailViewController()
            vc.playBlock = { (isPlay) in
                self?.changeRecViewWithPlayState(isPlay: isPlay, row: row)
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        recView.chageStatusBlock = { [weak self] in
            self?.myCreatView.clearSelected()
        }
        myCreatView.clickMoreForRowBlock = { [weak self] (row) in
            let vc = CreatStreamerViewController.init()
            vc.streamerNmae = "Amazing"
            vc.resState = .stremerDetail
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        myCreatView.chageStatusBlock = { [weak self] in
            self?.recView.clearSelected()
        }
    }
    private func setBgContenOffset(xWith: CGFloat) {
        var offset = bgScrollView.contentOffset
        offset.x = xWith
        self.bgScrollView.setContentOffset(offset, animated: true)
    }
    private func changeRecViewWithPlayState(isPlay: Bool, row :Int) {
        recView.changeCurrentStatus(row: row)
    }
    lazy var bgScrollView: UIScrollView = {
        let tempView = UIScrollView.init()
        var frame = CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight - 126.fit - 26.fit - 40.fit - 1.fit - kNavigationH - getAllVersionSafeAreaBottomHeight())
        if isSmart {
            frame.size.height -= 54.fit
        }
        tempView.frame = frame
        tempView.contentSize = CGSize(width: kScreenWidth*2, height: 0)
        tempView.isPagingEnabled = true
        tempView.showsHorizontalScrollIndicator = false
        tempView.isScrollEnabled = false
        return tempView
    }()
    lazy var recButton: UIButton = {
        var frame = CGRect(x: 20.fit, y: kScreenHeight - 126.fit - 38.fit - 27.fit - getAllVersionSafeAreaBottomHeight(), width: 94.fit, height: 38.fit)
        let tempView = UIButton.init(type: .custom)
        if isSmart {
            frame.origin.y -= 54.fit
        }
        if self.tabbrIsHidden {
            frame.origin.y += 126.fit
        }
        tempView.frame = frame
        tempView.setTitle(StellarLocalizedString("TIME_RECOMMEND"), for: .normal)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#F3F4F9")), for: .normal)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#1E55B7")), for: .selected)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        tempView.setTitleColor(STELLAR_COLOR_C5, for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .selected)
        tempView.layer.cornerRadius = tempView.frame.size.height/2
        tempView.clipsToBounds = true
        return tempView
    }()
    lazy var myCreatButton: UIButton = {
        var frame = CGRect(x: 20.fit+16.fit+94.fit, y: kScreenHeight - 126.fit - 38.fit - 27.fit - getAllVersionSafeAreaBottomHeight(), width: 94.fit, height: 38.fit)
        let tempView = UIButton.init(type: .custom)
        if isSmart {
            frame.origin.y -= 54.fit
        }
        if self.tabbrIsHidden {
            frame.origin.y += 126.fit
        }
        tempView.frame = frame
        tempView.setTitle(StellarLocalizedString("SCENE_CUSTOM"), for: .normal)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#F3F4F9")), for: .normal)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#1E55B7")), for: .selected)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        tempView.setTitleColor(STELLAR_COLOR_C5, for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .selected)
        tempView.layer.cornerRadius = tempView.frame.size.height/2
        tempView.clipsToBounds = true
        return tempView
    }()
    lazy var myCreatView: MyCreatView = {
        let tempView = MyCreatView.init(frame: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: bgScrollView.frame.size.height))
        return tempView
    }()
    lazy var recView: RecommendView = {
        let tempView = RecommendView.init(frame: bgScrollView.bounds)
        return tempView
    }()
}