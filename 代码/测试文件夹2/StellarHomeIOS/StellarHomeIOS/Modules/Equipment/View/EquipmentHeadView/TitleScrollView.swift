import UIKit
enum TextColorStyle{
    case upStyle
    case downStyle
}
class TitleScrollView: UIView {
    let buttonSpaceWidth:CGFloat = 15
    var selectTitleNumBlock:((Int)->Void)? = nil
    var needJumpBegain:NSInteger = 0
    var needJumpEnd:NSInteger = 0
    var selectBeforeBtn:UIButton?
    var style: TextColorStyle = .upStyle{
        didSet{
            if oldValue != style{
                setupTextColorStyle()
            }
        }
    }
    var titles:[String] = [""]{
        didSet{
            for view in scrollview.subviews {
                view.removeFromSuperview()
            }
            initViewsWith(titles: titles)
        }
    }
    func setRooms(rooms:[String],selectRoomBlock:((String)->Void)?){
        titles = rooms
        selectTitleNumBlock = { index in
            if self.titles.count > 0{
                selectRoomBlock?(self.titles[index])
            }
        }
    }
    func setRoomsAndSelectedIndex(rooms:[String],selectRoomIndexBlock:((Int)->Void)?){
        titles = rooms
        selectTitleNumBlock = { index in
            if self.titles.count > 0{
                self.setupViews()
                selectRoomIndexBlock?(index)
            }
        }
    }
    var selectIndex:NSInteger = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadSubViews(){
        addSubview(scrollview)
        scrollview.backgroundColor = UIColor.clear
        scrollview.snp.makeConstraints {
            $0.left.right.equalTo(self)
            $0.bottom.equalTo(0)
            $0.top.equalTo(0)
        }
    }
    @objc func selectAction(btn:UIButton){
        if selectBeforeBtn == nil {
            return
        }
        selectIndex = btn.tag - 100
        selectTitleNumBlock?(selectIndex)
    }
    func tapActionWith(index:Int,animated:Bool = true){
        selectIndex = index
        setupViews(animated)
    }
    private func setupTextColorStyle(){
        switch style {
        case .downStyle:
            for i in 0..<titles.count {
                guard let button = scrollview.viewWithTag(100+i) as? UIButton else{
                    break
                }
                guard let lineview = scrollview.viewWithTag(200)else {
                    return
                }
                lineview.backgroundColor = STELLAR_COLOR_C3
                button.setTitleColor(STELLAR_COLOR_C4.withAlphaComponent(0.3), for: .normal)
                button.setTitleColor(STELLAR_COLOR_C3, for:.selected)
            }
            break
        case .upStyle:
            for i in 0..<titles.count {
                guard let button = scrollview.viewWithTag(100+i) as? UIButton else{
                    break
                }
                guard let lineview = scrollview.viewWithTag(200)else {
                    return
                }
                lineview.backgroundColor = STELLAR_COLOR_C1
                button.setTitleColor(STELLAR_COLOR_C6, for: .normal)
                button.setTitleColor(STELLAR_COLOR_C1, for: .selected)
            }
            break
        }
    }
    private func initViewsWith(titles:[String]){
        var contentWidth:CGFloat = 0;
        needJumpBegain = 0
        needJumpEnd = 0
        for i in 0..<titles.count {
            let text = titles[i]
            let button = UIButton.init(type: .custom)
            var buttonFont = STELLAR_FONT_BOLD_T16
            if i == 0 {
                buttonFont = STELLAR_FONT_BOLD_T18
            }
            let buttonRect = String.ss.getTextRectSize(text: text,font: buttonFont,size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 22.fit))
            let width = buttonRect.size.width + buttonSpaceWidth
            button.frame = CGRect.init(x: contentWidth + 14, y: 0, width: width, height: 22.fit)
            button.setTitle(text, for: .normal)
            button.tag = i+100
            button.titleLabel?.font = STELLAR_FONT_BOLD_T16
            button.setTitleColor(STELLAR_COLOR_C4.withAlphaComponent(0.3), for: .normal)
            button.setTitleColor(STELLAR_COLOR_C3, for: .selected)
            button.addTarget(self, action: #selector(selectAction(btn:)), for: .touchUpInside)
            scrollview.addSubview(button)
            if i==0{
                let line = UIView.init(frame: CGRect.init(x: button.frame.origin.x + buttonSpaceWidth/2.0, y: button.frame.maxY + 4, width: buttonRect.size.width, height: 4))
                line.backgroundColor = UIColor.white
                line.tag = 200
                button.titleLabel?.font = STELLAR_FONT_BOLD_T18
                button.isSelected = true
                selectBeforeBtn = button
                scrollview.addSubview(line)
            }
            contentWidth = width + contentWidth
            if (button.frame.maxX >= kScreenWidth/2.0) && needJumpBegain == 0
            {
                needJumpBegain = i
                needJumpBegain = needJumpBegain>0 ? needJumpBegain+1 : needJumpBegain
            }
        }
        style = .downStyle
        scrollview.contentSize = CGSize.init(width: contentWidth + 20, height: 0)
        for i in 0..<titles.count {
            guard let button = scrollview.viewWithTag(100+i) else{
                break
            }
            if ((scrollview.contentSize.width - button.frame.maxX) <= kScreenWidth/2.0) && needJumpEnd==0 {
                needJumpEnd = i
                needJumpEnd = needJumpEnd>0 ? needJumpEnd-1 : needJumpEnd
            }
        }
    }
    private func setupViews(_ animated:Bool = true){
        guard let lineview = scrollview.viewWithTag(200)else {
            return
        }
        guard let button = scrollview.viewWithTag(selectIndex+100) as? UIButton else{
            return
        }
        guard let beforeBtn = self.selectBeforeBtn else{
            return
        }
        if scrollview.contentSize.width > kScreenWidth{
            if selectIndex >= needJumpBegain && selectIndex <= needJumpEnd{
                scrollview.setContentOffset(CGPoint.init(x: button.frame.minX + button.bounds.size.width/2.0 - kScreenWidth / 2.0, y: 0), animated: true)
            }
            else if selectIndex < needJumpBegain{
                scrollview.setContentOffset(CGPoint.zero, animated: true)
            }else if selectIndex > needJumpEnd{
                scrollview.setContentOffset(CGPoint.init(x: scrollview.contentSize.width - scrollview.frame.size.width, y: 0), animated: true)
            }
        }
        beforeBtn.titleLabel?.font = STELLAR_FONT_BOLD_T16
        button.titleLabel?.font = STELLAR_FONT_BOLD_T18
        beforeBtn.titleLabel?.sizeToFit()
        if animated {
            UIView.animate(withDuration: 0.3) {
                button.titleLabel?.sizeToFit()
                lineview.frame = CGRect.init(x: button.frame.origin.x + self.buttonSpaceWidth/2.0, y: button.frame.maxY + 4, width: button.bounds.size.width - self.buttonSpaceWidth, height: 4)
            }
        }else{
            button.titleLabel?.sizeToFit()
            lineview.frame = CGRect.init(x: button.frame.origin.x + self.buttonSpaceWidth/2.0, y: button.frame.maxY + 4, width: button.bounds.size.width - self.buttonSpaceWidth, height: 4)
        }
        self.selectBeforeBtn?.isSelected = false
        button.isSelected = true
        self.selectBeforeBtn = button
    }
    lazy var scrollview:UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
}