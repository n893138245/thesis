import UIKit
private var kIQShouldHideToolbarPlaceholder = "kIQShouldHideToolbarPlaceholder"
private var kIQToolbarPlaceholder           = "kIQToolbarPlaceholder"
private var kIQKeyboardToolbar              = "kIQKeyboardToolbar"
@objc public class IQBarButtonItemConfiguration: NSObject {
    #if swift(>=4.2)
    @objc public init(barButtonSystemItem: UIBarButtonItem.SystemItem, action: Selector) {
        self.barButtonSystemItem = barButtonSystemItem
        self.image = nil
        self.title = nil
        self.action = action
        super.init()
    }
    #else
    @objc public init(barButtonSystemItem: UIBarButtonSystemItem, action: Selector) {
        self.barButtonSystemItem = barButtonSystemItem
        self.image = nil
        self.title = nil
        self.action = action
    super.init()
    }
    #endif
    @objc public init(image: UIImage, action: Selector) {
        self.barButtonSystemItem = nil
        self.image = image
        self.title = nil
        self.action = action
        super.init()
    }
    @objc public init(title: String, action: Selector) {
        self.barButtonSystemItem = nil
        self.image = nil
        self.title = title
        self.action = action
        super.init()
    }
    #if swift(>=4.2)
    public let barButtonSystemItem: UIBarButtonItem.SystemItem?    
    #else
    public let barButtonSystemItem: UIBarButtonSystemItem?    
    #endif
    @objc public let image: UIImage?    
    @objc public let title: String?     
    @objc public let action: Selector?  
}
@objc public extension UIImage {
    @objc static func keyboardLeftImage() -> UIImage? {
        struct Static {
            static var keyboardLeftImage: UIImage?
        }
        if Static.keyboardLeftImage == nil {
            let base64Data = "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"
            if let data = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters) {
                Static.keyboardLeftImage = UIImage(data: data, scale: 3)
            }
            if #available(iOS 9, *) {
                Static.keyboardLeftImage = Static.keyboardLeftImage?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        return Static.keyboardLeftImage
    }
    @objc static func keyboardRightImage() -> UIImage? {
        struct Static {
            static var keyboardRightImage: UIImage?
        }
        if Static.keyboardRightImage == nil {
            let base64Data = "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"
            if let data = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters) {
                Static.keyboardRightImage = UIImage(data: data, scale: 3)
            }
            if #available(iOS 9, *) {
                Static.keyboardRightImage = Static.keyboardRightImage?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        return Static.keyboardRightImage
    }
    @objc static func keyboardUpImage() -> UIImage? {
        struct Static {
            static var keyboardUpImage: UIImage?
        }
        if Static.keyboardUpImage == nil {
            let base64Data = "iVBORw0KGgoAAAANSUhEUgAAAD8AAAAkCAYAAAA+TuKHAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAAGmklEQVRoBd1ZWWwbRRie2bVz27s2adPGxzqxqAQCIRA3CDVJGxpKaEtRoSAVISQQggdeQIIHeIAHkOCBFyQeKlARhaYHvUJa0ksVoIgKUKFqKWqdeG2nR1Lsdeo0h73D54iku7NO6ySOk3alyPN
            if let data = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters) {
                Static.keyboardUpImage = UIImage(data: data, scale: 3)
            }
            if #available(iOS 9, *) {
                Static.keyboardUpImage = Static.keyboardUpImage?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        return Static.keyboardUpImage
    }
    @objc static func keyboardDownImage() -> UIImage? {
        struct Static {
            static var keyboardDownImage: UIImage?
        }
        if Static.keyboardDownImage == nil {
            let base64Data = "iVBORw0KGgoAAAANSUhEUgAAAD8AAAAkCAYAAAA+TuKHAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAAGp0lEQVRoBd1ZCWhcRRiemff25WrydmOtuXbfZlMo4lEpKkppm6TpZUovC4UqKlQoUhURqQcUBcWDIkhVUCuI9SpJa+2h0VZjUawUEUUUirLNXqmxSnc32WaT7O4bv0nd5R1bc+2maR8s7z9m5v+/+f/5Z94sIf89jW73Yp/bfUuWvwLfDp/H8zhwObLYmCCaPJ6FjLJPCWNHNU1bkFVeQW/Zp2l7KWUvNmlaB3DJAhvz1ntvI5R1EUpnUUKdEifHGuvr519BwKUmj/cDYNtwARNd5/NoH4GWKIhzlFKXCSzn/xCut/jD4V9N8suPYYj4ewC+2e46f55Rwp/geExKSmdzJn2l1WrXmuSXF8MQ8XfyAeeEn9KTyV3MHwq9RTh50IqLEjJHUkh3Y13dPKvuMuApIr6bUHKP1VeE+Y8MIa09Z8/+JQlltD/+Q7VaFcW6X2VsjFmbRRnbUFFZeai/v/+cUTeDaYqIv4GlfL/NR879I3qmORwOnxG6UfCCiMbjJ51VagKdlgs+91BaKVO6oVJVD8bj8WhOPkMJn1t7jTL6gNU9pHpgKJ1q7u3tjWR1OfBCEOuPf+9Sq4YwAW3ZBqNvSqsYpeuc5WUHYolE3KSbQYzP430FwB+yuoSCFtKHaXP4z3DIqDOBFwpkwHfVThXLgrYaG6IGOAmT1pZVVHw8MDDQb9TNBLrJre0E8EdtvnAeSRPeHOwN9lh1NvCiASbgG5fqRLDJEmMHsSU6GFuDGrAfNWDAqLuUNE5uL6A2bbf5wPkZrmdaAuGw36aDIC940TAajx1HBijIgEWmjpRWS4ytrnKq+1EDEibdJWAa3dqzjLGnrKaxxvt4OtXS09v7u1WX5S8KXjRABnQ7VbUCEV+Y7SDeWAJX4dfuLCnZFzt
            if let data = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters) {
                Static.keyboardDownImage = UIImage(data: data, scale: 3)
            }
            if #available(iOS 9, *) {
                Static.keyboardDownImage = Static.keyboardDownImage?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        return Static.keyboardDownImage
    }
    @objc static func keyboardPreviousImage() -> UIImage? {
        if #available(iOS 10, *) {
            return keyboardUpImage()
        } else {
            return keyboardLeftImage()
        }
    }
    @objc static func keyboardNextImage() -> UIImage? {
        if #available(iOS 10, *) {
            return keyboardDownImage()
        } else {
            return keyboardRightImage()
        }
    }
}
@objc public extension UIView {
    @objc var keyboardToolbar: IQToolbar {
        var toolbar = inputAccessoryView as? IQToolbar
        if toolbar == nil {
            toolbar = objc_getAssociatedObject(self, &kIQKeyboardToolbar) as? IQToolbar
        }
        if let unwrappedToolbar = toolbar {
            return unwrappedToolbar
        } else {
            let frame = CGRect(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 44))
            let newToolbar = IQToolbar(frame: frame)
            objc_setAssociatedObject(self, &kIQKeyboardToolbar, newToolbar, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newToolbar
        }
    }
    @objc var shouldHideToolbarPlaceholder: Bool {
        get {
            let aValue = objc_getAssociatedObject(self, &kIQShouldHideToolbarPlaceholder) as Any?
            if let unwrapedValue = aValue as? Bool {
                return unwrapedValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldHideToolbarPlaceholder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.keyboardToolbar.titleBarButton.title = self.drawingToolbarPlaceholder
        }
    }
    @objc var toolbarPlaceholder: String? {
        get {
            let aValue = objc_getAssociatedObject(self, &kIQToolbarPlaceholder) as? String
            return aValue
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQToolbarPlaceholder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.keyboardToolbar.titleBarButton.title = self.drawingToolbarPlaceholder
        }
    }
    @objc var drawingToolbarPlaceholder: String? {
        if self.shouldHideToolbarPlaceholder {
            return nil
        } else if self.toolbarPlaceholder?.isEmpty == false {
            return self.toolbarPlaceholder
        } else if self.responds(to: #selector(getter: UITextField.placeholder)) {
            if let textField = self as? UITextField {
                return textField.placeholder
            } else if let textView = self as? IQTextView {
                return textView.placeholder
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    private static func flexibleBarButtonItem () -> IQBarButtonItem {
        struct Static {
            static let nilButton = IQBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        Static.nilButton.isSystemItem = true
        return Static.nilButton
    }
    @objc func addKeyboardToolbarWithTarget(target: AnyObject?, titleText: String?, rightBarButtonConfiguration: IQBarButtonItemConfiguration?, previousBarButtonConfiguration: IQBarButtonItemConfiguration? = nil, nextBarButtonConfiguration: IQBarButtonItemConfiguration? = nil) {
        if self.responds(to: #selector(setter: UITextField.inputAccessoryView)) {
            let toolbar = self.keyboardToolbar
            var items: [IQBarButtonItem] = []
            if let prevConfig = previousBarButtonConfiguration {
                var prev = toolbar.previousBarButton
                if prevConfig.barButtonSystemItem == nil && prev.isSystemItem == false {
                    prev.title = prevConfig.title
                    prev.accessibilityLabel = prevConfig.accessibilityLabel
                    prev.image = prevConfig.image
                    prev.target = target
                    prev.action = prevConfig.action
                } else {
                    if let systemItem = prevConfig.barButtonSystemItem {
                        prev = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: prevConfig.action)
                        prev.isSystemItem = true
                    } else if let image = prevConfig.image {
                        prev = IQBarButtonItem(image: image, style: .plain, target: target, action: prevConfig.action)
                    } else {
                        prev = IQBarButtonItem(title: prevConfig.title, style: .plain, target: target, action: prevConfig.action)
                    }
                    prev.invocation = toolbar.previousBarButton.invocation
                    prev.accessibilityLabel = prevConfig.accessibilityLabel
                    prev.isEnabled = toolbar.previousBarButton.isEnabled
                    prev.tag = toolbar.previousBarButton.tag
                    toolbar.previousBarButton = prev
                }
                items.append(prev)
            }
            if previousBarButtonConfiguration != nil && nextBarButtonConfiguration != nil {
                items.append(toolbar.fixedSpaceBarButton)
            }
            if let nextConfig = nextBarButtonConfiguration {
                var next = toolbar.nextBarButton
                if nextConfig.barButtonSystemItem == nil && next.isSystemItem == false {
                    next.title = nextConfig.title
                    next.accessibilityLabel = nextConfig.accessibilityLabel
                    next.image = nextConfig.image
                    next.target = target
                    next.action = nextConfig.action
                } else {
                    if let systemItem = nextConfig.barButtonSystemItem {
                        next = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: nextConfig.action)
                        next.isSystemItem = true
                    } else if let image = nextConfig.image {
                        next = IQBarButtonItem(image: image, style: .plain, target: target, action: nextConfig.action)
                    } else {
                        next = IQBarButtonItem(title: nextConfig.title, style: .plain, target: target, action: nextConfig.action)
                    }
                    next.invocation = toolbar.nextBarButton.invocation
                    next.accessibilityLabel = nextConfig.accessibilityLabel
                    next.isEnabled = toolbar.nextBarButton.isEnabled
                    next.tag = toolbar.nextBarButton.tag
                    toolbar.nextBarButton = next
                }
                items.append(next)
            }
            do {
                items.append(UIView.flexibleBarButtonItem())
                toolbar.titleBarButton.title = titleText
                if #available(iOS 11, *) {} else {
                    toolbar.titleBarButton.customView?.frame = CGRect.zero
                }
                items.append(toolbar.titleBarButton)
                items.append(UIView.flexibleBarButtonItem())
            }
            if let rightConfig = rightBarButtonConfiguration {
                var done = toolbar.doneBarButton
                if rightConfig.barButtonSystemItem == nil && done.isSystemItem == false {
                    done.title = rightConfig.title
                    done.accessibilityLabel = rightConfig.accessibilityLabel
                    done.image = rightConfig.image
                    done.target = target
                    done.action = rightConfig.action
                } else {
                    if let systemItem = rightConfig.barButtonSystemItem {
                        done = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: rightConfig.action)
                        done.isSystemItem = true
                    } else if let image = rightConfig.image {
                        done = IQBarButtonItem(image: image, style: .plain, target: target, action: rightConfig.action)
                    } else {
                        done = IQBarButtonItem(title: rightConfig.title, style: .plain, target: target, action: rightConfig.action)
                    }
                    done.invocation = toolbar.doneBarButton.invocation
                    done.accessibilityLabel = rightConfig.accessibilityLabel
                    done.isEnabled = toolbar.doneBarButton.isEnabled
                    done.tag = toolbar.doneBarButton.tag
                    toolbar.doneBarButton = done
                }
                items.append(done)
            }
            toolbar.items = items
            if let textInput = self as? UITextInput {
                switch textInput.keyboardAppearance {
                case .dark?:
                    toolbar.barStyle = .black
                default:
                    toolbar.barStyle = .default
                }
            }
            if let textField = self as? UITextField {
                textField.inputAccessoryView = toolbar
            } else if let textView = self as? UITextView {
                textView.inputAccessoryView = toolbar
            }
        }
    }
    @objc func addDoneOnKeyboardWithTarget(_ target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false) {
        addDoneOnKeyboardWithTarget(target, action: action, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addDoneOnKeyboardWithTarget(_ target: AnyObject?, action: Selector, titleText: String?) {
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: action)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }
    @objc func addRightButtonOnKeyboardWithImage(_ image: UIImage, target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false) {
        addRightButtonOnKeyboardWithImage(image, target: target, action: action, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addRightButtonOnKeyboardWithImage(_ image: UIImage, target: AnyObject?, action: Selector, titleText: String?) {
        let rightConfiguration = IQBarButtonItemConfiguration(image: image, action: action)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }
    @objc func addRightButtonOnKeyboardWithText(_ text: String, target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false) {
        addRightButtonOnKeyboardWithText(text, target: target, action: action, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addRightButtonOnKeyboardWithText(_ text: String, target: AnyObject?, action: Selector, titleText: String?) {
        let rightConfiguration = IQBarButtonItemConfiguration(title: text, action: action)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }
    @objc func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?, cancelAction: Selector, doneAction: Selector, shouldShowPlaceholder: Bool = false) {
        addCancelDoneOnKeyboardWithTarget(target, cancelAction: cancelAction, doneAction: doneAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        addRightLeftOnKeyboardWithTarget(target, leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonImage: UIImage, rightButtonImage: UIImage, leftButtonAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        addRightLeftOnKeyboardWithTarget(target, leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?, cancelAction: Selector, doneAction: Selector, titleText: String?) {
        let leftConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .cancel, action: cancelAction)
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: doneAction)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: Selector, rightButtonAction: Selector, titleText: String?) {
        let leftConfiguration = IQBarButtonItemConfiguration(title: leftButtonTitle, action: leftButtonAction)
        let rightConfiguration = IQBarButtonItemConfiguration(title: rightButtonTitle, action: rightButtonAction)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonImage: UIImage, rightButtonImage: UIImage, leftButtonAction: Selector, rightButtonAction: Selector, titleText: String?) {
        let leftConfiguration = IQBarButtonItemConfiguration(image: leftButtonImage, action: leftButtonAction)
        let rightConfiguration = IQBarButtonItemConfiguration(image: rightButtonImage, action: rightButtonAction)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }
    @objc func addPreviousNextDoneOnKeyboardWithTarget (_ target: AnyObject?, previousAction: Selector, nextAction: Selector, doneAction: Selector, shouldShowPlaceholder: Bool = false) {
        addPreviousNextDoneOnKeyboardWithTarget(target, previousAction: previousAction, nextAction: nextAction, doneAction: doneAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonImage: UIImage, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        addPreviousNextRightOnKeyboardWithTarget(target, rightButtonImage: rightButtonImage, previousAction: previousAction, nextAction: nextAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonTitle: String, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        addPreviousNextRightOnKeyboardWithTarget(target, rightButtonTitle: rightButtonTitle, previousAction: previousAction, nextAction: nextAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    @objc func addPreviousNextDoneOnKeyboardWithTarget (_ target: AnyObject?, previousAction: Selector, nextAction: Selector, doneAction: Selector, titleText: String?) {
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: doneAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonImage: UIImage, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, titleText: String?) {
        let rightConfiguration = IQBarButtonItemConfiguration(image: rightButtonImage, action: rightButtonAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonTitle: String, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, titleText: String?) {
        let rightConfiguration = IQBarButtonItemConfiguration(title: rightButtonTitle, action: rightButtonAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
}