import UIKit
open class IQToolbar: UIToolbar, UIInputViewAudioFeedback {
    private static var _classInitialize: Void = classInitialize()
    private class func classInitialize() {
        let  appearanceProxy = self.appearance()
        appearanceProxy.barTintColor = nil
        let positions: [UIBarPosition] = [.any, .bottom, .top, .topAttached]
        for position in positions {
            appearanceProxy.setBackgroundImage(nil, forToolbarPosition: position, barMetrics: .default)
            appearanceProxy.setShadowImage(nil, forToolbarPosition: .any)
        }
        appearanceProxy.backgroundColor = nil
    }
    private var privatePreviousBarButton: IQBarButtonItem?
    @objc open var previousBarButton: IQBarButtonItem {
        get {
            if privatePreviousBarButton == nil {
                privatePreviousBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
            }
            return privatePreviousBarButton!
        }
        set (newValue) {
            privatePreviousBarButton = newValue
        }
    }
    private var privateNextBarButton: IQBarButtonItem?
    @objc open var nextBarButton: IQBarButtonItem {
        get {
            if privateNextBarButton == nil {
                privateNextBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
            }
            return privateNextBarButton!
        }
        set (newValue) {
            privateNextBarButton = newValue
        }
    }
    private var privateTitleBarButton: IQTitleBarButtonItem?
    @objc open var titleBarButton: IQTitleBarButtonItem {
        get {
            if privateTitleBarButton == nil {
                privateTitleBarButton = IQTitleBarButtonItem(title: nil)
                privateTitleBarButton?.accessibilityLabel = "Title"
            }
            return privateTitleBarButton!
        }
        set (newValue) {
            privateTitleBarButton = newValue
        }
    }
    private var privateDoneBarButton: IQBarButtonItem?
    @objc open var doneBarButton: IQBarButtonItem {
        get {
            if privateDoneBarButton == nil {
                privateDoneBarButton = IQBarButtonItem(title: nil, style: .done, target: nil, action: nil)
            }
            return privateDoneBarButton!
        }
        set (newValue) {
            privateDoneBarButton = newValue
        }
    }
    private var privateFixedSpaceBarButton: IQBarButtonItem?
    @objc open var fixedSpaceBarButton: IQBarButtonItem {
        get {
            if privateFixedSpaceBarButton == nil {
                privateFixedSpaceBarButton = IQBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            }
            privateFixedSpaceBarButton!.isSystemItem = true
            if #available(iOS 10, *) {
                privateFixedSpaceBarButton!.width = 6
            } else {
                privateFixedSpaceBarButton!.width = 20
            }
            return privateFixedSpaceBarButton!
        }
        set (newValue) {
            privateFixedSpaceBarButton = newValue
        }
    }
    override init(frame: CGRect) {
        _ = IQToolbar._classInitialize
        super.init(frame: frame)
        sizeToFit()
        autoresizingMask = .flexibleWidth
        self.isTranslucent = true
    }
    @objc required public init?(coder aDecoder: NSCoder) {
        _ = IQToolbar._classInitialize
        super.init(coder: aDecoder)
        sizeToFit()
        autoresizingMask = .flexibleWidth
        self.isTranslucent = true
    }
    @objc override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFit = super.sizeThatFits(size)
        sizeThatFit.height = 44
        return sizeThatFit
    }
    @objc override open var tintColor: UIColor! {
        didSet {
            if let unwrappedItems = items {
                for item in unwrappedItems {
                    item.tintColor = tintColor
                }
            }
        }
    }
    @objc override open func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11, *) {
            return
        } else if let customTitleView = titleBarButton.customView {
            var leftRect = CGRect.null
            var rightRect = CGRect.null
            var isTitleBarButtonFound = false
            let sortedSubviews = self.subviews.sorted(by: { (view1: UIView, view2: UIView) -> Bool in
                if view1.frame.minX != view2.frame.minX {
                    return view1.frame.minX < view2.frame.minX
                } else {
                    return view1.frame.minY < view2.frame.minY
                }
            })
            for barButtonItemView in sortedSubviews {
                if isTitleBarButtonFound == true {
                    rightRect = barButtonItemView.frame
                    break
                } else if barButtonItemView === customTitleView {
                    isTitleBarButtonFound = true
                } else if barButtonItemView.isKind(of: UIControl.self) == true {
                    leftRect = barButtonItemView.frame
                }
            }
            let titleMargin: CGFloat = 16
            let maxWidth: CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
            let maxHeight = self.frame.height
            let sizeThatFits = customTitleView.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            var titleRect: CGRect
            if sizeThatFits.width > 0 && sizeThatFits.height > 0 {
                let width = min(sizeThatFits.width, maxWidth)
                let height = min(sizeThatFits.height, maxHeight)
                var xPosition: CGFloat
                if leftRect.isNull == false {
                    xPosition = titleMargin + leftRect.maxX + ((maxWidth - width)/2)
                } else {
                    xPosition = titleMargin
                }
                let yPosition = (maxHeight - height)/2
                titleRect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            } else {
                var xPosition: CGFloat
                if leftRect.isNull == false {
                    xPosition = titleMargin + leftRect.maxX
                } else {
                    xPosition = titleMargin
                }
                let width: CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
                titleRect = CGRect(x: xPosition, y: 0, width: width, height: maxHeight)
            }
            customTitleView.frame = titleRect
        }
    }
    @objc open var enableInputClicksWhenVisible: Bool {
        return true
    }
    deinit {
        items = nil
        privatePreviousBarButton = nil
        privateNextBarButton = nil
        privateTitleBarButton = nil
        privateDoneBarButton = nil
        privateFixedSpaceBarButton = nil
    }
}