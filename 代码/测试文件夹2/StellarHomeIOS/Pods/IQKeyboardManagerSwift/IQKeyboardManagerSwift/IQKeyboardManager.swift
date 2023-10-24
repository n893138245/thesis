import Foundation
import CoreGraphics
import UIKit
import QuartzCore
@objc public class IQKeyboardManager: NSObject, UIGestureRecognizerDelegate {
    private static let  kIQDoneButtonToolbarTag         =   -1002
    private static let  kIQPreviousNextButtonToolbarTag =   -1005
    private static let  kIQCGPointInvalid = CGPoint.init(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
    @objc public var enable = false {
        didSet {
            if enable == true &&
                oldValue == false {
                if let notification = _kbShowNotification {
                    keyboardWillShow(notification)
                }
                showLog("Enabled")
            } else if enable == false &&
                oldValue == true {   
                keyboardWillHide(nil)
                showLog("Disabled")
            }
        }
    }
    private func privateIsEnabled() -> Bool {
        var isEnabled = enable
        let enableMode = _textFieldView?.enableMode
        if enableMode == .enabled {
            isEnabled = true
        } else if enableMode == .disabled {
            isEnabled = false
        } else {
            if var textFieldViewController = _textFieldView?.viewContainingController() {
                if _textFieldView?.textFieldSearchBar() != nil, let navController = textFieldViewController as? UINavigationController, let topController = navController.topViewController {
                    textFieldViewController = topController
                }
                if isEnabled == false {
                    for enabledClass in enabledDistanceHandlingClasses {
                        if textFieldViewController.isKind(of: enabledClass) {
                            isEnabled = true
                            break
                        }
                    }
                }
                if isEnabled == true {
                    for disabledClass in disabledDistanceHandlingClasses {
                        if textFieldViewController.isKind(of: disabledClass) {
                            isEnabled = false
                            break
                        }
                    }
                    if isEnabled == true {
                        let classNameString = NSStringFromClass(type(of: textFieldViewController.self))
                        if classNameString.contains("UIAlertController") && classNameString.hasSuffix("TextFieldViewController") {
                            isEnabled = false
                        }
                    }
                }
            }
        }
        return isEnabled
    }
    @objc public var keyboardDistanceFromTextField: CGFloat {
        set {
            _privateKeyboardDistanceFromTextField =  max(0, newValue)
            showLog("keyboardDistanceFromTextField: \(_privateKeyboardDistanceFromTextField)")
        }
        get {
            return _privateKeyboardDistanceFromTextField
        }
    }
    @objc public var keyboardShowing: Bool {
        return _privateIsKeyboardShowing
    }
    @objc public var movedDistance: CGFloat {
        return _privateMovedDistance
    }
    @objc public var movedDistanceChanged: ((CGFloat) -> Void)?
    @objc public static let shared = IQKeyboardManager()
    @objc public var enableAutoToolbar = true {
        didSet {
            privateIsEnableAutoToolbar() ? addToolbarIfRequired() : removeToolbarIfRequired()
            let enableToolbar = enableAutoToolbar ? "Yes" : "NO"
            showLog("enableAutoToolbar: \(enableToolbar)")
        }
    }
    private func privateIsEnableAutoToolbar() -> Bool {
        var enableToolbar = enableAutoToolbar
        if var textFieldViewController = _textFieldView?.viewContainingController() {
            if _textFieldView?.textFieldSearchBar() != nil, let navController = textFieldViewController as? UINavigationController, let topController = navController.topViewController {
                textFieldViewController = topController
            }
            if enableToolbar == false {
                for enabledClass in enabledToolbarClasses {
                    if textFieldViewController.isKind(of: enabledClass) {
                        enableToolbar = true
                        break
                    }
                }
            }
            if enableToolbar == true {
                for disabledClass in disabledToolbarClasses {
                    if textFieldViewController.isKind(of: disabledClass) {
                        enableToolbar = false
                        break
                    }
                }
                if enableToolbar == true {
                    let classNameString = NSStringFromClass(type(of: textFieldViewController.self))
                    if classNameString.contains("UIAlertController") && classNameString.hasSuffix("TextFieldViewController") {
                        enableToolbar = false
                    }
                }
            }
        }
        return enableToolbar
    }
    AutoToolbar managing behaviour. Default is IQAutoToolbarBySubviews.
    */
    @objc public var toolbarManageBehaviour = IQAutoToolbarManageBehaviour.bySubviews
    @objc public var shouldToolbarUsesTextFieldTintColor = false
    @objc public var toolbarTintColor: UIColor?
    @objc public var toolbarBarTintColor: UIColor?
    @objc public var previousNextDisplayMode = IQPreviousNextDisplayMode.default
    @objc public var toolbarPreviousBarButtonItemImage: UIImage?
    @objc public var toolbarNextBarButtonItemImage: UIImage?
    @objc public var toolbarDoneBarButtonItemImage: UIImage?
    @objc public var toolbarPreviousBarButtonItemText: String?
    @objc public var toolbarPreviousBarButtonItemAccessibilityLabel: String?
    @objc public var toolbarNextBarButtonItemText: String?
    @objc public var toolbarNextBarButtonItemAccessibilityLabel: String?
    @objc public var toolbarDoneBarButtonItemText: String?
    @objc public var toolbarDoneBarButtonItemAccessibilityLabel: String?
    @objc public var shouldShowToolbarPlaceholder = true
    @objc public var placeholderFont: UIFont?
    @objc public var placeholderColor: UIColor?
    @objc public var placeholderButtonColor: UIColor?
    private var         startingTextViewContentInsets = UIEdgeInsets()
    private var         startingTextViewScrollIndicatorInsets = UIEdgeInsets()
    private var         isTextViewContentInsetChanged = false
    @objc public var overrideKeyboardAppearance = false
    @objc public var keyboardAppearance = UIKeyboardAppearance.default
    @objc public var shouldResignOnTouchOutside = false {
        didSet {
            resignFirstResponderGesture.isEnabled = privateShouldResignOnTouchOutside()
            let shouldResign = shouldResignOnTouchOutside ? "Yes" : "NO"
            showLog("shouldResignOnTouchOutside: \(shouldResign)")
        }
    }
    @objc lazy public var resignFirstResponderGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        return tapGesture
    }()
    private func privateShouldResignOnTouchOutside() -> Bool {
        var shouldResign = shouldResignOnTouchOutside
        let enableMode = _textFieldView?.shouldResignOnTouchOutsideMode
        if enableMode == .enabled {
            shouldResign = true
        } else if enableMode == .disabled {
            shouldResign = false
        } else {
            if var textFieldViewController = _textFieldView?.viewContainingController() {
                if _textFieldView?.textFieldSearchBar() != nil, let navController = textFieldViewController as? UINavigationController, let topController = navController.topViewController {
                    textFieldViewController = topController
                }
                if shouldResign == false {
                    for enabledClass in enabledTouchResignedClasses {
                        if textFieldViewController.isKind(of: enabledClass) {
                            shouldResign = true
                            break
                        }
                    }
                }
                if shouldResign == true {
                    for disabledClass in disabledTouchResignedClasses {
                        if textFieldViewController.isKind(of: disabledClass) {
                            shouldResign = false
                            break
                        }
                    }
                    if shouldResign == true {
                        let classNameString = NSStringFromClass(type(of: textFieldViewController.self))
                        if classNameString.contains("UIAlertController") && classNameString.hasSuffix("TextFieldViewController") {
                            shouldResign = false
                        }
                    }
                }
            }
        }
        return shouldResign
    }
    @objc @discardableResult public func resignFirstResponder() -> Bool {
        if let textFieldRetain = _textFieldView {
            let isResignFirstResponder = textFieldRetain.resignFirstResponder()
            if isResignFirstResponder == false {
                textFieldRetain.becomeFirstResponder()
                showLog("Refuses to resign first responder: \(textFieldRetain)")
            }
            return isResignFirstResponder
        }
        return false
    }
    @objc public var canGoPrevious: Bool {
        if let textFields = responderViews() {
            if let  textFieldRetain = _textFieldView {
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    if index > 0 {
                        return true
                    }
                }
            }
        }
        return false
    }
    @objc public var canGoNext: Bool {
        if let textFields = responderViews() {
            if let  textFieldRetain = _textFieldView {
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    if index < textFields.count-1 {
                        return true
                    }
                }
            }
        }
        return false
    }
    @objc @discardableResult public func goPrevious() -> Bool {
        if let  textFieldRetain = _textFieldView {
            if let textFields = responderViews() {
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    if index > 0 {
                        let nextTextField = textFields[index-1]
                        let isAcceptAsFirstResponder = nextTextField.becomeFirstResponder()
                        if isAcceptAsFirstResponder == false {
                            textFieldRetain.becomeFirstResponder()
                            showLog("Refuses to become first responder: \(nextTextField)")
                        }
                        return isAcceptAsFirstResponder
                    }
                }
            }
        }
        return false
    }
    @objc @discardableResult public func goNext() -> Bool {
        if let  textFieldRetain = _textFieldView {
            if let textFields = responderViews() {
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    if index < textFields.count-1 {
                        let nextTextField = textFields[index+1]
                        let isAcceptAsFirstResponder = nextTextField.becomeFirstResponder()
                        if isAcceptAsFirstResponder == false {
                            textFieldRetain.becomeFirstResponder()
                            showLog("Refuses to become first responder: \(nextTextField)")
                        }
                        return isAcceptAsFirstResponder
                    }
                }
            }
        }
        return false
    }
    @objc internal func previousAction (_ barButton: IQBarButtonItem) {
        if shouldPlayInputClicks == true {
            UIDevice.current.playInputClick()
        }
        if canGoPrevious == true {
            if let textFieldRetain = _textFieldView {
                let isAcceptAsFirstResponder = goPrevious()
                var invocation = barButton.invocation
                var sender = textFieldRetain
                do {
                    if let searchBar = textFieldRetain.textFieldSearchBar() {
                        invocation = searchBar.keyboardToolbar.previousBarButton.invocation
                        sender = searchBar
                    }
                }
                if isAcceptAsFirstResponder {
                    invocation?.invoke(from: sender)
                }
            }
        }
    }
    @objc internal func nextAction (_ barButton: IQBarButtonItem) {
        if shouldPlayInputClicks == true {
            UIDevice.current.playInputClick()
        }
        if canGoNext == true {
            if let textFieldRetain = _textFieldView {
                let isAcceptAsFirstResponder = goNext()
                var invocation = barButton.invocation
                var sender = textFieldRetain
                do {
                    if let searchBar = textFieldRetain.textFieldSearchBar() {
                        invocation = searchBar.keyboardToolbar.nextBarButton.invocation
                        sender = searchBar
                    }
                }
                if isAcceptAsFirstResponder {
                    invocation?.invoke(from: sender)
                }
            }
        }
    }
    @objc internal func doneAction (_ barButton: IQBarButtonItem) {
        if shouldPlayInputClicks == true {
            UIDevice.current.playInputClick()
        }
        if let textFieldRetain = _textFieldView {
            let isResignedFirstResponder = resignFirstResponder()
            var invocation = barButton.invocation
            var sender = textFieldRetain
            do {
                if let searchBar = textFieldRetain.textFieldSearchBar() {
                    invocation = searchBar.keyboardToolbar.doneBarButton.invocation
                    sender = searchBar
                }
            }
            if isResignedFirstResponder {
                invocation?.invoke(from: sender)
            }
        }
    }
    @objc internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            resignFirstResponder()
        }
    }
    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        for ignoreClass in touchResignedGestureIgnoreClasses {
            if touch.view?.isKind(of: ignoreClass) == true {
                return false
            }
        }
        return true
    }
    @objc public var shouldPlayInputClicks = true
    @objc public var layoutIfNeededOnUpdate = false
    @objc public var disabledDistanceHandlingClasses  = [UIViewController.Type]()
    @objc public var enabledDistanceHandlingClasses  = [UIViewController.Type]()
    @objc public var disabledToolbarClasses  = [UIViewController.Type]()
    @objc public var enabledToolbarClasses  = [UIViewController.Type]()
    @objc public var toolbarPreviousNextAllowedClasses  = [UIView.Type]()
    @objc public var disabledTouchResignedClasses  = [UIViewController.Type]()
    @objc public var enabledTouchResignedClasses  = [UIViewController.Type]()
    @objc public var touchResignedGestureIgnoreClasses  = [UIView.Type]()
    @objc public func registerTextFieldViewClass(_ aClass: UIView.Type, didBeginEditingNotificationName: String, didEndEditingNotificationName: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidBeginEditing(_:)), name: Notification.Name(rawValue: didBeginEditingNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidEndEditing(_:)), name: Notification.Name(rawValue: didEndEditingNotificationName), object: nil)
    }
    @objc public func unregisterTextFieldViewClass(_ aClass: UIView.Type, didBeginEditingNotificationName: String, didEndEditingNotificationName: String) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: didBeginEditingNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: didEndEditingNotificationName), object: nil)
    }
    private weak var    _textFieldView: UIView?
    private var         _topViewBeginOrigin = IQKeyboardManager.kIQCGPointInvalid
    private weak var    _rootViewControllerWhilePopGestureRecognizerActive: UIViewController?
    private var         _topViewBeginOriginWhilePopGestureRecognizerActive = IQKeyboardManager.kIQCGPointInvalid
    private weak var    _rootViewController: UIViewController?
    private weak var    _lastScrollView: UIScrollView?
    private var         _startingContentOffset = CGPoint.zero
    private var         _startingScrollIndicatorInsets = UIEdgeInsets()
    private var         _startingContentInsets = UIEdgeInsets()
    private var         _kbShowNotification: Notification?
    private var         _kbFrame = CGRect.zero
    private var         _animationDuration: TimeInterval = 0.25
    #if swift(>=4.2)
    private var         _animationCurve: UIView.AnimationOptions = .curveEaseOut
    #else
    private var         _animationCurve: UIViewAnimationOptions = .curveEaseOut
    #endif
    private var         _privateIsKeyboardShowing = false
    private var         _privateMovedDistance: CGFloat = 0.0 {
        didSet {
            movedDistanceChanged?(_privateMovedDistance)
        }
    }
    private var         _privateKeyboardDistanceFromTextField: CGFloat = 10.0
    private var         _privateHasPendingAdjustRequest = false
    override init() {
        super.init()
        self.registerAllNotifications()
        resignFirstResponderGesture.isEnabled = shouldResignOnTouchOutside
        let textField = UITextField()
        textField.addDoneOnKeyboardWithTarget(nil, action: #selector(self.doneAction(_:)))
        textField.addPreviousNextDoneOnKeyboardWithTarget(nil, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(self.nextAction(_:)), doneAction: #selector(self.doneAction(_:)))
        disabledDistanceHandlingClasses.append(UITableViewController.self)
        disabledDistanceHandlingClasses.append(UIAlertController.self)
        disabledToolbarClasses.append(UIAlertController.self)
        disabledTouchResignedClasses.append(UIAlertController.self)
        toolbarPreviousNextAllowedClasses.append(UITableView.self)
        toolbarPreviousNextAllowedClasses.append(UICollectionView.self)
        toolbarPreviousNextAllowedClasses.append(IQPreviousNextView.self)
        touchResignedGestureIgnoreClasses.append(UIControl.self)
        touchResignedGestureIgnoreClasses.append(UINavigationBar.self)
    }
    deinit {
        enable = false
        NotificationCenter.default.removeObserver(self)
    }
    private func keyWindow() -> UIWindow? {
        if let keyWindow = _textFieldView?.window {
            return keyWindow
        } else {
            struct Static {
                static weak var keyWindow: UIWindow?
            }
            var originalKeyWindow : UIWindow? = nil
            #if swift(>=5.1)
            if #available(iOS 13, *) {
                originalKeyWindow = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first(where: { $0.isKeyWindow })
            } else {
                originalKeyWindow = UIApplication.shared.keyWindow
            }
            #else
            originalKeyWindow = UIApplication.shared.keyWindow
            #endif
            if let originalKeyWindow = originalKeyWindow {
                Static.keyWindow = originalKeyWindow
            }
            return Static.keyWindow
        }
    }
    private func optimizedAdjustPosition() {
        if _privateHasPendingAdjustRequest == false {
            _privateHasPendingAdjustRequest = true
            OperationQueue.main.addOperation {
                self.adjustPosition()
                self._privateHasPendingAdjustRequest = false
            }
        }
    }
    private func adjustPosition() {
        if _privateHasPendingAdjustRequest == true,
            let textFieldView = _textFieldView,
            let rootController = textFieldView.parentContainerViewController(),
            let window = keyWindow(),
            let textFieldViewRectInWindow = textFieldView.superview?.convert(textFieldView.frame, to: window),
            let textFieldViewRectInRootSuperview = textFieldView.superview?.convert(textFieldView.frame, to: rootController.view?.superview) {
            let startTime = CACurrentMediaTime()
            showLog("****** \(#function) started ******", indentation: 1)
            var rootViewOrigin = rootController.view.frame.origin
            var specialKeyboardDistanceFromTextField = textFieldView.keyboardDistanceFromTextField
            if let searchBar = textFieldView.textFieldSearchBar() {
                specialKeyboardDistanceFromTextField = searchBar.keyboardDistanceFromTextField
            }
            let newKeyboardDistanceFromTextField = (specialKeyboardDistanceFromTextField == kIQUseDefaultKeyboardDistance) ? keyboardDistanceFromTextField : specialKeyboardDistanceFromTextField
            var kbSize = _kbFrame.size
            do {
                var kbFrame = _kbFrame
                kbFrame.origin.y -= newKeyboardDistanceFromTextField
                kbFrame.size.height += newKeyboardDistanceFromTextField
                let intersectRect = kbFrame.intersection(window.frame)
                if intersectRect.isNull {
                    kbSize = CGSize(width: kbFrame.size.width, height: 0)
                } else {
                    kbSize = intersectRect.size
                }
            }
            let statusBarHeight : CGFloat
            #if swift(>=5.1)
            if #available(iOS 13, *) {
                statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            #else
            statusBarHeight = UIApplication.shared.statusBarFrame.height
            #endif
            let navigationBarAreaHeight: CGFloat = statusBarHeight + ( rootController.navigationController?.navigationBar.frame.height ?? 0)
            let layoutAreaHeight: CGFloat = rootController.view.layoutMargins.bottom
            let topLayoutGuide: CGFloat = max(navigationBarAreaHeight, layoutAreaHeight) + 5
            let bottomLayoutGuide: CGFloat = (textFieldView is UIScrollView && textFieldView.responds(to: #selector(getter: UITextView.isEditable))) ? 0 : rootController.view.layoutMargins.bottom  
            var move: CGFloat = min(textFieldViewRectInRootSuperview.minY-(topLayoutGuide), textFieldViewRectInWindow.maxY-(window.frame.height-kbSize.height)+bottomLayoutGuide)
            showLog("Need to move: \(move)")
            var superScrollView: UIScrollView?
            var superView = textFieldView.superviewOfClassType(UIScrollView.self) as? UIScrollView
            while let view = superView {
                if view.isScrollEnabled && view.shouldIgnoreScrollingAdjustment == false {
                    superScrollView = view
                    break
                } else {
                    superView = view.superviewOfClassType(UIScrollView.self) as? UIScrollView
                }
            }
            if let lastScrollView = _lastScrollView {
                if superScrollView == nil {
                    if lastScrollView.contentInset != self._startingContentInsets {
                        showLog("Restoring contentInset to: \(_startingContentInsets)")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            lastScrollView.contentInset = self._startingContentInsets
                            lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                        })
                    }
                    if lastScrollView.shouldRestoreScrollViewContentOffset == true && lastScrollView.contentOffset.equalTo(_startingContentOffset) == false {
                        showLog("Restoring contentOffset to: \(_startingContentOffset)")
                        var animatedContentOffset = false   
                        if #available(iOS 9, *) {
                            animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil
                        }
                        if animatedContentOffset {
                            lastScrollView.setContentOffset(_startingContentOffset, animated: UIView.areAnimationsEnabled)
                        } else {
                            lastScrollView.contentOffset = _startingContentOffset
                        }
                    }
                    _startingContentInsets = UIEdgeInsets()
                    _startingScrollIndicatorInsets = UIEdgeInsets()
                    _startingContentOffset = CGPoint.zero
                    _lastScrollView = nil
                } else if superScrollView != lastScrollView {     
                    if lastScrollView.contentInset != self._startingContentInsets {
                        showLog("Restoring contentInset to: \(_startingContentInsets)")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            lastScrollView.contentInset = self._startingContentInsets
                            lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                        })
                    }
                    if lastScrollView.shouldRestoreScrollViewContentOffset == true && lastScrollView.contentOffset.equalTo(_startingContentOffset) == false {
                        showLog("Restoring contentOffset to: \(_startingContentOffset)")
                        var animatedContentOffset = false   
                        if #available(iOS 9, *) {
                            animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil
                        }
                        if animatedContentOffset {
                            lastScrollView.setContentOffset(_startingContentOffset, animated: UIView.areAnimationsEnabled)
                        } else {
                            lastScrollView.contentOffset = _startingContentOffset
                        }
                    }
                    _lastScrollView = superScrollView
                    if let scrollView = superScrollView {
                        _startingContentInsets = scrollView.contentInset
                        _startingContentOffset = scrollView.contentOffset
                        #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            _startingScrollIndicatorInsets = scrollView.verticalScrollIndicatorInsets
                        } else {
                            _startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
                        }
                        #else
                        _startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
                        #endif
                    }
                    showLog("Saving ScrollView New contentInset: \(_startingContentInsets) and contentOffset: \(_startingContentOffset)")
                }
            } else if let unwrappedSuperScrollView = superScrollView {    
                _lastScrollView = unwrappedSuperScrollView
                _startingContentInsets = unwrappedSuperScrollView.contentInset
                _startingContentOffset = unwrappedSuperScrollView.contentOffset
                #if swift(>=5.1)
                if #available(iOS 11.1, *) {
                    _startingScrollIndicatorInsets = unwrappedSuperScrollView.verticalScrollIndicatorInsets
                } else {
                    _startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
                }
                #else
                _startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
                #endif
                showLog("Saving ScrollView contentInset: \(_startingContentInsets) and contentOffset: \(_startingContentOffset)")
            }
            if let lastScrollView = _lastScrollView {
                var lastView = textFieldView
                var superScrollView = _lastScrollView
                while let scrollView = superScrollView {
                    var shouldContinue = false
                    if move > 0 {
                        shouldContinue =  move > (-scrollView.contentOffset.y - scrollView.contentInset.top)
                    } else if let tableView = scrollView.superviewOfClassType(UITableView.self) as? UITableView {
                        shouldContinue = scrollView.contentOffset.y > 0
                        if shouldContinue == true, let tableCell = textFieldView.superviewOfClassType(UITableViewCell.self) as? UITableViewCell, let indexPath = tableView.indexPath(for: tableCell), let previousIndexPath = tableView.previousIndexPath(of: indexPath) {
                            let previousCellRect = tableView.rectForRow(at: previousIndexPath)
                            if previousCellRect.isEmpty == false {
                                let previousCellRectInRootSuperview = tableView.convert(previousCellRect, to: rootController.view.superview)
                                move = min(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                            }
                        }
                    } else if let collectionView = scrollView.superviewOfClassType(UICollectionView.self) as? UICollectionView {
                        shouldContinue = scrollView.contentOffset.y > 0
                        if shouldContinue == true, let collectionCell = textFieldView.superviewOfClassType(UICollectionViewCell.self) as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: collectionCell), let previousIndexPath = collectionView.previousIndexPath(of: indexPath), let attributes = collectionView.layoutAttributesForItem(at: previousIndexPath) {
                            let previousCellRect = attributes.frame
                            if previousCellRect.isEmpty == false {
                                let previousCellRectInRootSuperview = collectionView.convert(previousCellRect, to: rootController.view.superview)
                                move = min(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                            }
                        }
                    } else {
                        shouldContinue = textFieldViewRectInRootSuperview.origin.y < topLayoutGuide
                        if shouldContinue {
                            move = min(0, textFieldViewRectInRootSuperview.origin.y - topLayoutGuide)
                        }
                    }
                    if shouldContinue {
                        var tempScrollView = scrollView.superviewOfClassType(UIScrollView.self) as? UIScrollView
                        var nextScrollView: UIScrollView?
                        while let view = tempScrollView {
                            if view.isScrollEnabled && view.shouldIgnoreScrollingAdjustment == false {
                                nextScrollView = view
                                break
                            } else {
                                tempScrollView = view.superviewOfClassType(UIScrollView.self) as? UIScrollView
                            }
                        }
                        if let lastViewRect = lastView.superview?.convert(lastView.frame, to: scrollView) {
                            var shouldOffsetY = scrollView.contentOffset.y - min(scrollView.contentOffset.y, -move)
                            shouldOffsetY = min(shouldOffsetY, lastViewRect.origin.y)
                            if (textFieldView is UIScrollView && textFieldView.responds(to: #selector(getter: UITextView.isEditable))) &&
                                nextScrollView == nil &&
                                shouldOffsetY >= 0 {
                                if let currentTextFieldViewRect = textFieldView.superview?.convert(textFieldView.frame, to: window) {
                                    let expectedFixDistance = currentTextFieldViewRect.minY - topLayoutGuide
                                    shouldOffsetY = min(shouldOffsetY, scrollView.contentOffset.y + expectedFixDistance)
                                    move = 0
                                } else {
                                    move -= (shouldOffsetY-scrollView.contentOffset.y)
                                }
                            } else {
                                move -= (shouldOffsetY-scrollView.contentOffset.y)
                            }
                            let newContentOffset = CGPoint(x: scrollView.contentOffset.x, y: shouldOffsetY)
                            if scrollView.contentOffset.equalTo(newContentOffset) == false {
                                showLog("old contentOffset: \(scrollView.contentOffset) new contentOffset: \(newContentOffset)")
                                self.showLog("Remaining Move: \(move)")
                                UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                                    var animatedContentOffset = false   
                                    if #available(iOS 9, *) {
                                        animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: scrollView) != nil
                                    }
                                    if animatedContentOffset {
                                        scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                                    } else {
                                        scrollView.contentOffset = newContentOffset
                                    }
                                }) { _ in
                                    if scrollView is UITableView || scrollView is UICollectionView {
                                        self.addToolbarIfRequired()
                                    }
                                }
                            }
                        }
                        lastView = scrollView
                        superScrollView = nextScrollView
                    } else {
                        move = 0
                        break
                    }
                }
                if let lastScrollViewRect = lastScrollView.superview?.convert(lastScrollView.frame, to: window),
                    lastScrollView.shouldIgnoreContentInsetAdjustment == false {
                    var bottomInset: CGFloat = (kbSize.height)-(window.frame.height-lastScrollViewRect.maxY)
                    var bottomScrollIndicatorInset = bottomInset - newKeyboardDistanceFromTextField
                    bottomInset = max(_startingContentInsets.bottom, bottomInset)
                    bottomScrollIndicatorInset = max(_startingScrollIndicatorInsets.bottom, bottomScrollIndicatorInset)
                    #if swift(>=4.0)
                    if #available(iOS 11, *) {
                        bottomInset -= lastScrollView.safeAreaInsets.bottom
                        bottomScrollIndicatorInset -= lastScrollView.safeAreaInsets.bottom
                    }
                    #endif
                    var movedInsets = lastScrollView.contentInset
                    movedInsets.bottom = bottomInset
                    if lastScrollView.contentInset != movedInsets {
                        showLog("old ContentInset: \(lastScrollView.contentInset) new ContentInset: \(movedInsets)")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            lastScrollView.contentInset = movedInsets
                            var newScrollIndicatorInset : UIEdgeInsets
                            #if swift(>=5.1)
                            if #available(iOS 11.1, *) {
                                newScrollIndicatorInset = lastScrollView.verticalScrollIndicatorInsets
                            } else {
                                newScrollIndicatorInset = lastScrollView.scrollIndicatorInsets
                            }
                            #else
                            newScrollIndicatorInset = lastScrollView.scrollIndicatorInsets
                            #endif
                            newScrollIndicatorInset.bottom = bottomScrollIndicatorInset
                            lastScrollView.scrollIndicatorInsets = newScrollIndicatorInset
                        })
                    }
                }
            }
            if let textView = textFieldView as? UIScrollView, textView.isScrollEnabled, textFieldView.responds(to: #selector(getter: UITextView.isEditable)) {
                let keyboardYPosition = window.frame.height - (kbSize.height-newKeyboardDistanceFromTextField)
                var rootSuperViewFrameInWindow = window.frame
                if let rootSuperview = rootController.view.superview {
                    rootSuperViewFrameInWindow = rootSuperview.convert(rootSuperview.bounds, to: window)
                }
                let keyboardOverlapping = rootSuperViewFrameInWindow.maxY - keyboardYPosition
                let textViewHeight = min(textView.frame.height, rootSuperViewFrameInWindow.height-topLayoutGuide-keyboardOverlapping)
                if textView.frame.size.height-textView.contentInset.bottom>textViewHeight {
                    if self.isTextViewContentInsetChanged == false {
                        self.startingTextViewContentInsets = textView.contentInset
                        #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            self.startingTextViewScrollIndicatorInsets = textView.verticalScrollIndicatorInsets
                        } else {
                            self.startingTextViewScrollIndicatorInsets = textView.scrollIndicatorInsets
                        }
                        #else
                        self.startingTextViewScrollIndicatorInsets = textView.scrollIndicatorInsets
                        #endif
                    }
                    self.isTextViewContentInsetChanged = true
                    var newContentInset = textView.contentInset
                    newContentInset.bottom = textView.frame.size.height-textViewHeight
                    #if swift(>=4.0)
                    if #available(iOS 11, *) {
                        newContentInset.bottom -= textView.safeAreaInsets.bottom
                    }
                    #endif
                    if textView.contentInset != newContentInset {
                        self.showLog("\(textFieldView) Old UITextView.contentInset: \(textView.contentInset) New UITextView.contentInset: \(newContentInset)")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            textView.contentInset = newContentInset
                            textView.scrollIndicatorInsets = newContentInset
                        }, completion: { (_) -> Void in })
                    }
                }
            }
            if move >= 0 {
                rootViewOrigin.y = max(rootViewOrigin.y - move, min(0, -(kbSize.height-newKeyboardDistanceFromTextField)))
                if rootController.view.frame.origin.equalTo(rootViewOrigin) == false {
                    showLog("Moving Upward")
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        var rect = rootController.view.frame
                        rect.origin = rootViewOrigin
                        rootController.view.frame = rect
                        if self.layoutIfNeededOnUpdate == true {
                            rootController.view.setNeedsLayout()
                            rootController.view.layoutIfNeeded()
                        }
                        self.showLog("Set \(rootController) origin to: \(rootViewOrigin)")
                    })
                }
                _privateMovedDistance = (_topViewBeginOrigin.y-rootViewOrigin.y)
            } else {  
                let disturbDistance: CGFloat = rootViewOrigin.y-_topViewBeginOrigin.y
                if disturbDistance <= 0 {
                    rootViewOrigin.y -= max(move, disturbDistance)
                    if rootController.view.frame.origin.equalTo(rootViewOrigin) == false {
                        showLog("Moving Downward")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            var rect = rootController.view.frame
                            rect.origin = rootViewOrigin
                            rootController.view.frame = rect
                            if self.layoutIfNeededOnUpdate == true {
                                rootController.view.setNeedsLayout()
                                rootController.view.layoutIfNeeded()
                            }
                            self.showLog("Set \(rootController) origin to: \(rootViewOrigin)")
                        })
                    }
                    _privateMovedDistance = (_topViewBeginOrigin.y-rootViewOrigin.y)
                }
            }
            let elapsedTime = CACurrentMediaTime() - startTime
            showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
        }
    }
    private func restorePosition() {
        _privateHasPendingAdjustRequest = false
        if _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == false {
            if let rootViewController = _rootViewController {
                if rootViewController.view.frame.origin.equalTo(self._topViewBeginOrigin) == false {
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        self.showLog("Restoring \(rootViewController) origin to: \(self._topViewBeginOrigin)")
                        var rect = rootViewController.view.frame
                        rect.origin = self._topViewBeginOrigin
                        rootViewController.view.frame = rect
                        if self.layoutIfNeededOnUpdate == true {
                            rootViewController.view.setNeedsLayout()
                            rootViewController.view.layoutIfNeeded()
                        }
                    })
                }
                self._privateMovedDistance = 0
                if rootViewController.navigationController?.interactivePopGestureRecognizer?.state == .began {
                    self._rootViewControllerWhilePopGestureRecognizerActive = rootViewController
                    self._topViewBeginOriginWhilePopGestureRecognizerActive = self._topViewBeginOrigin
                }
                _rootViewController = nil
            }
        }
    }
    @objc public func reloadLayoutIfNeeded() {
        if privateIsEnabled() == true {
            if _privateIsKeyboardShowing == true,
                _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == false,
                let textFieldView = _textFieldView,
                textFieldView.isAlertViewTextField() == false {
                optimizedAdjustPosition()
            }
        }
    }
    @objc internal func keyboardWillShow(_ notification: Notification?) {
        _kbShowNotification = notification
        _privateIsKeyboardShowing = true
        let oldKBFrame = _kbFrame
        if let info = notification?.userInfo {
            #if swift(>=4.2)
            let curveUserInfoKey    = UIResponder.keyboardAnimationCurveUserInfoKey
            let durationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            #else
            let curveUserInfoKey    = UIKeyboardAnimationCurveUserInfoKey
            let durationUserInfoKey = UIKeyboardAnimationDurationUserInfoKey
            let frameEndUserInfoKey = UIKeyboardFrameEndUserInfoKey
            #endif
            if let curve = info[curveUserInfoKey] as? UInt {
                _animationCurve = .init(rawValue: curve)
            } else {
                _animationCurve = .curveEaseOut
            }
            if let duration = info[durationUserInfoKey] as? TimeInterval {
                if duration != 0.0 {
                    _animationDuration = duration
                }
            } else {
                _animationDuration = 0.25
            }
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                _kbFrame = kbFrame
                showLog("UIKeyboard Frame: \(_kbFrame)")
            }
        }
        if privateIsEnabled() == false {
            restorePosition()
            _topViewBeginOrigin = IQKeyboardManager.kIQCGPointInvalid
            return
        }
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        if let textFieldView = _textFieldView, _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == true {
            _rootViewController = textFieldView.parentContainerViewController()
            if let controller = _rootViewController {
                if _rootViewControllerWhilePopGestureRecognizerActive == controller {
                    _topViewBeginOrigin = _topViewBeginOriginWhilePopGestureRecognizerActive
                } else {
                    _topViewBeginOrigin = controller.view.frame.origin
                }
                _rootViewControllerWhilePopGestureRecognizerActive = nil
                _topViewBeginOriginWhilePopGestureRecognizerActive = IQKeyboardManager.kIQCGPointInvalid
                self.showLog("Saving \(controller) beginning origin: \(self._topViewBeginOrigin)")
            }
        }
        if _kbFrame.equalTo(oldKBFrame) == false {
            if _privateIsKeyboardShowing == true,
                let textFieldView = _textFieldView,
                textFieldView.isAlertViewTextField() == false {
                optimizedAdjustPosition()
            }
        }
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc internal func keyboardDidShow(_ notification: Notification?) {
        if privateIsEnabled() == false {
            return
        }
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        if let textFieldView = _textFieldView,
            let parentController = textFieldView.parentContainerViewController(), (parentController.modalPresentationStyle == UIModalPresentationStyle.formSheet || parentController.modalPresentationStyle == UIModalPresentationStyle.pageSheet),
            textFieldView.isAlertViewTextField() == false {
            self.optimizedAdjustPosition()
        }
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc internal func keyboardWillHide(_ notification: Notification?) {
        if notification != nil {
            _kbShowNotification = nil
        }
        _privateIsKeyboardShowing = false
        if let info = notification?.userInfo {
            #if swift(>=4.2)
            let durationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
            #else
            let durationUserInfoKey = UIKeyboardAnimationDurationUserInfoKey
            #endif
            if let duration =  info[durationUserInfoKey] as? TimeInterval {
                if duration != 0 {
                    _animationDuration = duration
                }
            }
        }
        if privateIsEnabled() == false {
            return
        }
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        if let lastScrollView = _lastScrollView {
            UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                if lastScrollView.contentInset != self._startingContentInsets {
                    self.showLog("Restoring contentInset to: \(self._startingContentInsets)")
                    lastScrollView.contentInset = self._startingContentInsets
                    lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                }
                if lastScrollView.shouldRestoreScrollViewContentOffset == true && lastScrollView.contentOffset.equalTo(self._startingContentOffset) == false {
                    self.showLog("Restoring contentOffset to: \(self._startingContentOffset)")
                    var animatedContentOffset = false   
                    if #available(iOS 9, *) {
                        animatedContentOffset = self._textFieldView?.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil
                    }
                    if animatedContentOffset {
                        lastScrollView.setContentOffset(self._startingContentOffset, animated: UIView.areAnimationsEnabled)
                    } else {
                        lastScrollView.contentOffset = self._startingContentOffset
                    }
                }
                var superScrollView: UIScrollView? = lastScrollView
                while let scrollView = superScrollView {
                    let contentSize = CGSize(width: max(scrollView.contentSize.width, scrollView.frame.width), height: max(scrollView.contentSize.height, scrollView.frame.height))
                    let minimumY = contentSize.height - scrollView.frame.height
                    if minimumY < scrollView.contentOffset.y {
                        let newContentOffset = CGPoint(x: scrollView.contentOffset.x, y: minimumY)
                        if scrollView.contentOffset.equalTo(newContentOffset) == false {
                            var animatedContentOffset = false   
                            if #available(iOS 9, *) {
                                animatedContentOffset = self._textFieldView?.superviewOfClassType(UIStackView.self, belowView: scrollView) != nil
                            }
                            if animatedContentOffset {
                                scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                            } else {
                                scrollView.contentOffset = newContentOffset
                            }
                            self.showLog("Restoring contentOffset to: \(self._startingContentOffset)")
                        }
                    }
                    superScrollView = scrollView.superviewOfClassType(UIScrollView.self) as? UIScrollView
                }
            })
        }
        restorePosition()
        _lastScrollView = nil
        _kbFrame = CGRect.zero
        _startingContentInsets = UIEdgeInsets()
        _startingScrollIndicatorInsets = UIEdgeInsets()
        _startingContentOffset = CGPoint.zero
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc internal func keyboardDidHide(_ notification: Notification) {
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        _topViewBeginOrigin = IQKeyboardManager.kIQCGPointInvalid
        _kbFrame = CGRect.zero
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc internal func textFieldViewDidBeginEditing(_ notification: Notification) {
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        _textFieldView = notification.object as? UIView
        if overrideKeyboardAppearance == true {
            if let textInput = _textFieldView as? UITextInput {
                if textInput.keyboardAppearance != keyboardAppearance {
                    if let textFieldView = _textFieldView as? UITextField {
                        textFieldView.keyboardAppearance = keyboardAppearance
                    } else if  let textFieldView = _textFieldView as? UITextView {
                        textFieldView.keyboardAppearance = keyboardAppearance
                    }
                    _textFieldView?.reloadInputViews()
                }
            }
        }
        if privateIsEnableAutoToolbar() == true {
            if let textView = _textFieldView as? UIScrollView, textView.responds(to: #selector(getter: UITextView.isEditable)),
                textView.inputAccessoryView == nil {
                UIView.animate(withDuration: 0.00001, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                    self.addToolbarIfRequired()
                    }, completion: { (_) -> Void in
                        textView.reloadInputViews()
                })
            } else {
                addToolbarIfRequired()
            }
        } else {
            removeToolbarIfRequired()
        }
        resignFirstResponderGesture.isEnabled = privateShouldResignOnTouchOutside()
        _textFieldView?.window?.addGestureRecognizer(resignFirstResponderGesture)    
        if privateIsEnabled() == false {
            restorePosition()
            _topViewBeginOrigin = IQKeyboardManager.kIQCGPointInvalid
        } else {
            if _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == true {    
                _rootViewController = _textFieldView?.parentContainerViewController()
                if let controller = _rootViewController {
                    if _rootViewControllerWhilePopGestureRecognizerActive == controller {
                        _topViewBeginOrigin = _topViewBeginOriginWhilePopGestureRecognizerActive
                    } else {
                        _topViewBeginOrigin = controller.view.frame.origin
                    }
                    _rootViewControllerWhilePopGestureRecognizerActive = nil
                    _topViewBeginOriginWhilePopGestureRecognizerActive = IQKeyboardManager.kIQCGPointInvalid
                    self.showLog("Saving \(controller) beginning origin: \(self._topViewBeginOrigin)")
                }
            }
            if _privateIsKeyboardShowing == true,
                let textFieldView = _textFieldView,
                textFieldView.isAlertViewTextField() == false {
                optimizedAdjustPosition()
            }
        }
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc internal func textFieldViewDidEndEditing(_ notification: Notification) {
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        _textFieldView?.window?.removeGestureRecognizer(resignFirstResponderGesture)
        if let textView = _textFieldView as? UIScrollView, textView.responds(to: #selector(getter: UITextView.isEditable)) {
            if isTextViewContentInsetChanged == true {
                self.isTextViewContentInsetChanged = false
                if textView.contentInset != self.startingTextViewContentInsets {
                    self.showLog("Restoring textView.contentInset to: \(self.startingTextViewContentInsets)")
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        textView.contentInset = self.startingTextViewContentInsets
                        textView.scrollIndicatorInsets = self.startingTextViewScrollIndicatorInsets
                    }, completion: { (_) -> Void in })
                }
            }
        }
        _textFieldView = nil
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc internal func willChangeStatusBarOrientation(_ notification: Notification) {
        let currentStatusBarOrientation : UIInterfaceOrientation
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            currentStatusBarOrientation = keyWindow()?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.unknown
        } else {
            currentStatusBarOrientation = UIApplication.shared.statusBarOrientation
        }
        #else
        currentStatusBarOrientation = UIApplication.shared.statusBarOrientation
        #endif
        #if swift(>=4.2)
        let statusBarUserInfoKey    = UIApplication.statusBarOrientationUserInfoKey
        #else
        let statusBarUserInfoKey    = UIApplicationStatusBarOrientationUserInfoKey
        #endif
        guard let statusBarOrientation = notification.userInfo?[statusBarUserInfoKey] as? Int, currentStatusBarOrientation.rawValue != statusBarOrientation else {
            return
        }
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        if let textView = _textFieldView as? UITextView, textView.responds(to: #selector(getter: UITextView.isEditable)) {
            if isTextViewContentInsetChanged == true {
                self.isTextViewContentInsetChanged = false
                if textView.contentInset != self.startingTextViewContentInsets {
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        self.showLog("Restoring textView.contentInset to: \(self.startingTextViewContentInsets)")
                        textView.contentInset = self.startingTextViewContentInsets
                        textView.scrollIndicatorInsets = self.startingTextViewScrollIndicatorInsets
                    }, completion: { (_) -> Void in })
                }
            }
        }
        restorePosition()
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    private func responderViews() -> [UIView]? {
        var superConsideredView: UIView?
        for disabledClass in toolbarPreviousNextAllowedClasses {
            superConsideredView = _textFieldView?.superviewOfClassType(disabledClass)
            if superConsideredView != nil {
                break
            }
        }
        if let view = superConsideredView {
            return view.deepResponderViews()
        } else {  
            if let textFields = _textFieldView?.responderSiblings() {
                switch toolbarManageBehaviour {
                case IQAutoToolbarManageBehaviour.bySubviews:   return textFields
                case IQAutoToolbarManageBehaviour.byTag:    return textFields.sortedArrayByTag()
                case IQAutoToolbarManageBehaviour.byPosition:    return textFields.sortedArrayByPosition()
                }
            } else {
                return nil
            }
        }
    }
    private func addToolbarIfRequired() {
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        if let siblings = responderViews(), !siblings.isEmpty {
            showLog("Found \(siblings.count) responder sibling(s)")
            if let textField = _textFieldView {
                if textField.responds(to: #selector(setter: UITextField.inputAccessoryView)) {
                    if textField.inputAccessoryView == nil ||
                        textField.inputAccessoryView?.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag ||
                        textField.inputAccessoryView?.tag == IQKeyboardManager.kIQDoneButtonToolbarTag {
                        let rightConfiguration: IQBarButtonItemConfiguration
                        if let doneBarButtonItemImage = toolbarDoneBarButtonItemImage {
                            rightConfiguration = IQBarButtonItemConfiguration(image: doneBarButtonItemImage, action: #selector(self.doneAction(_:)))
                        } else if let doneBarButtonItemText = toolbarDoneBarButtonItemText {
                            rightConfiguration = IQBarButtonItemConfiguration(title: doneBarButtonItemText, action: #selector(self.doneAction(_:)))
                        } else {
                            rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: #selector(self.doneAction(_:)))
                        }
                        rightConfiguration.accessibilityLabel = toolbarDoneBarButtonItemAccessibilityLabel ?? "Done"
                        if (siblings.count <= 1 && previousNextDisplayMode == .default) || previousNextDisplayMode == .alwaysHide {
                            textField.addKeyboardToolbarWithTarget(target: self, titleText: (shouldShowToolbarPlaceholder ? textField.drawingToolbarPlaceholder: nil), rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: nil, nextBarButtonConfiguration: nil)
                            textField.inputAccessoryView?.tag = IQKeyboardManager.kIQDoneButtonToolbarTag 
                        } else if previousNextDisplayMode == .default || previousNextDisplayMode == .alwaysShow {
                            let prevConfiguration: IQBarButtonItemConfiguration
                            if let doneBarButtonItemImage = toolbarPreviousBarButtonItemImage {
                                prevConfiguration = IQBarButtonItemConfiguration(image: doneBarButtonItemImage, action: #selector(self.previousAction(_:)))
                            } else if let doneBarButtonItemText = toolbarPreviousBarButtonItemText {
                                prevConfiguration = IQBarButtonItemConfiguration(title: doneBarButtonItemText, action: #selector(self.previousAction(_:)))
                            } else {
                                prevConfiguration = IQBarButtonItemConfiguration(image: (UIImage.keyboardPreviousImage() ?? UIImage()), action: #selector(self.previousAction(_:)))
                            }
                            prevConfiguration.accessibilityLabel = toolbarPreviousBarButtonItemAccessibilityLabel ?? "Previous"
                            let nextConfiguration: IQBarButtonItemConfiguration
                            if let doneBarButtonItemImage = toolbarNextBarButtonItemImage {
                                nextConfiguration = IQBarButtonItemConfiguration(image: doneBarButtonItemImage, action: #selector(self.nextAction(_:)))
                            } else if let doneBarButtonItemText = toolbarNextBarButtonItemText {
                                nextConfiguration = IQBarButtonItemConfiguration(title: doneBarButtonItemText, action: #selector(self.nextAction(_:)))
                            } else {
                                nextConfiguration = IQBarButtonItemConfiguration(image: (UIImage.keyboardNextImage() ?? UIImage()), action: #selector(self.nextAction(_:)))
                            }
                            nextConfiguration.accessibilityLabel = toolbarNextBarButtonItemAccessibilityLabel ?? "Next"
                            textField.addKeyboardToolbarWithTarget(target: self, titleText: (shouldShowToolbarPlaceholder ? textField.drawingToolbarPlaceholder: nil), rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
                            textField.inputAccessoryView?.tag = IQKeyboardManager.kIQPreviousNextButtonToolbarTag 
                        }
                        let toolbar = textField.keyboardToolbar
                        if shouldToolbarUsesTextFieldTintColor {
                            toolbar.tintColor = textField.tintColor
                        } else if let tintColor = toolbarTintColor {
                            toolbar.tintColor = tintColor
                        } else {
                            toolbar.tintColor = nil
                        }
                        if let textFieldView = textField as? UITextInput {
                            switch textFieldView.keyboardAppearance {
                            case .dark?:
                                toolbar.barStyle = .black
                                toolbar.barTintColor = nil
                            default:
                                toolbar.barStyle = .default
                                toolbar.barTintColor = toolbarBarTintColor
                            }
                        }
                        if shouldShowToolbarPlaceholder == true &&
                            textField.shouldHideToolbarPlaceholder == false {
                            if toolbar.titleBarButton.title == nil ||
                                toolbar.titleBarButton.title != textField.drawingToolbarPlaceholder {
                                toolbar.titleBarButton.title = textField.drawingToolbarPlaceholder
                            }
                            if let font = placeholderFont {
                                toolbar.titleBarButton.titleFont = font
                            }
                            if let color = placeholderColor {
                                toolbar.titleBarButton.titleColor = color
                            }
                            if let color = placeholderButtonColor {
                                toolbar.titleBarButton.selectableTitleColor = color
                            }
                        } else {
                            toolbar.titleBarButton.title = nil
                        }
                        if siblings.first == textField {
                            if siblings.count == 1 {
                                textField.keyboardToolbar.previousBarButton.isEnabled = false
                                textField.keyboardToolbar.nextBarButton.isEnabled = false
                            } else {
                                textField.keyboardToolbar.previousBarButton.isEnabled = false
                                textField.keyboardToolbar.nextBarButton.isEnabled = true
                            }
                        } else if siblings.last  == textField {   
                            textField.keyboardToolbar.previousBarButton.isEnabled = true
                            textField.keyboardToolbar.nextBarButton.isEnabled = false
                        } else {
                            textField.keyboardToolbar.previousBarButton.isEnabled = true
                            textField.keyboardToolbar.nextBarButton.isEnabled = true
                        }
                    }
                }
            }
        }
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    private func removeToolbarIfRequired() {    
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        if let siblings = responderViews() {
            showLog("Found \(siblings.count) responder sibling(s)")
            for view in siblings {
                if let toolbar = view.inputAccessoryView as? IQToolbar {
                    if view.responds(to: #selector(setter: UITextField.inputAccessoryView)) &&
                        (toolbar.tag == IQKeyboardManager.kIQDoneButtonToolbarTag || toolbar.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag) {
                        if let textField = view as? UITextField {
                            textField.inputAccessoryView = nil
                        } else if let textView = view as? UITextView {
                            textView.inputAccessoryView = nil
                        }
                        view.reloadInputViews()
                    }
                }
            }
        }
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    @objc public func reloadInputViews() {
        if privateIsEnableAutoToolbar() == true {
            self.addToolbarIfRequired()
        } else {
            self.removeToolbarIfRequired()
        }
    }
    @objc public var enableDebugging = false
    @objc public func registerAllNotifications() {
        #if swift(>=4.2)
        let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
        let UIKeyboardDidShow   = UIResponder.keyboardDidShowNotification
        let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
        let UIKeyboardDidHide   = UIResponder.keyboardDidHideNotification
        let UITextFieldTextDidBeginEditing  = UITextField.textDidBeginEditingNotification
        let UITextFieldTextDidEndEditing    = UITextField.textDidEndEditingNotification
        let UITextViewTextDidBeginEditing   = UITextView.textDidBeginEditingNotification
        let UITextViewTextDidEndEditing     = UITextView.textDidEndEditingNotification
        let UIApplicationWillChangeStatusBarOrientation = UIApplication.willChangeStatusBarOrientationNotification
        #else
        let UIKeyboardWillShow  = Notification.Name.UIKeyboardWillShow
        let UIKeyboardDidShow   = Notification.Name.UIKeyboardDidShow
        let UIKeyboardWillHide  = Notification.Name.UIKeyboardWillHide
        let UIKeyboardDidHide   = Notification.Name.UIKeyboardDidHide
        let UITextFieldTextDidBeginEditing  = Notification.Name.UITextFieldTextDidBeginEditing
        let UITextFieldTextDidEndEditing    = Notification.Name.UITextFieldTextDidEndEditing
        let UITextViewTextDidBeginEditing   = Notification.Name.UITextViewTextDidBeginEditing
        let UITextViewTextDidEndEditing     = Notification.Name.UITextViewTextDidEndEditing
        let UIApplicationWillChangeStatusBarOrientation = Notification.Name.UIApplicationWillChangeStatusBarOrientation
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIKeyboardDidHide, object: nil)
        registerTextFieldViewClass(UITextField.self, didBeginEditingNotificationName: UITextFieldTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextFieldTextDidEndEditing.rawValue)
        registerTextFieldViewClass(UITextView.self, didBeginEditingNotificationName: UITextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextViewTextDidEndEditing.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willChangeStatusBarOrientation(_:)), name: UIApplicationWillChangeStatusBarOrientation, object: UIApplication.shared)
    }
    @objc public func unregisterAllNotifications() {
        #if swift(>=4.2)
        let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
        let UIKeyboardDidShow   = UIResponder.keyboardDidShowNotification
        let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
        let UIKeyboardDidHide   = UIResponder.keyboardDidHideNotification
        let UITextFieldTextDidBeginEditing  = UITextField.textDidBeginEditingNotification
        let UITextFieldTextDidEndEditing    = UITextField.textDidEndEditingNotification
        let UITextViewTextDidBeginEditing   = UITextView.textDidBeginEditingNotification
        let UITextViewTextDidEndEditing     = UITextView.textDidEndEditingNotification
        let UIApplicationWillChangeStatusBarOrientation = UIApplication.willChangeStatusBarOrientationNotification
        #else
        let UIKeyboardWillShow  = Notification.Name.UIKeyboardWillShow
        let UIKeyboardDidShow   = Notification.Name.UIKeyboardDidShow
        let UIKeyboardWillHide  = Notification.Name.UIKeyboardWillHide
        let UIKeyboardDidHide   = Notification.Name.UIKeyboardDidHide
        let UITextFieldTextDidBeginEditing  = Notification.Name.UITextFieldTextDidBeginEditing
        let UITextFieldTextDidEndEditing    = Notification.Name.UITextFieldTextDidEndEditing
        let UITextViewTextDidBeginEditing   = Notification.Name.UITextViewTextDidBeginEditing
        let UITextViewTextDidEndEditing     = Notification.Name.UITextViewTextDidEndEditing
        let UIApplicationWillChangeStatusBarOrientation = Notification.Name.UIApplicationWillChangeStatusBarOrientation
        #endif
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardDidHide, object: nil)
        unregisterTextFieldViewClass(UITextField.self, didBeginEditingNotificationName: UITextFieldTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextFieldTextDidEndEditing.rawValue)
        unregisterTextFieldViewClass(UITextView.self, didBeginEditingNotificationName: UITextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextViewTextDidEndEditing.rawValue)
        NotificationCenter.default.removeObserver(self, name: UIApplicationWillChangeStatusBarOrientation, object: UIApplication.shared)
    }
    private func showLog(_ logString: String, indentation: Int = 0) {
        struct Static {
            static var indentation = 0
        }
        if indentation < 0 {
            Static.indentation = max(0, Static.indentation + indentation)
        }
        if enableDebugging {
            var preLog = "IQKeyboardManager"
            for _ in 0 ... Static.indentation {
                preLog += "|\t"
            }
            print(preLog + logString)
        }
        if indentation > 0 {
            Static.indentation += indentation
        }
    }
}