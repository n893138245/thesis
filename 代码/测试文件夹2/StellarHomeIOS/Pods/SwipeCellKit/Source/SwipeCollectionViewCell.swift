import UIKit
open class SwipeCollectionViewCell: UICollectionViewCell {
    public weak var delegate: SwipeCollectionViewCellDelegate?
    var state = SwipeState.center
    var actionsView: SwipeActionsView?
    var scrollView: UIScrollView? {
        return collectionView
    }
    var indexPath: IndexPath? {
        return collectionView?.indexPath(for: self)
    }
    var panGestureRecognizer: UIGestureRecognizer
    {
        return swipeController.panGestureRecognizer;
    }
    var swipeController: SwipeController!
    var isPreviouslySelected = false
    weak var collectionView: UICollectionView?
    open override var frame: CGRect {
        set { super.frame = state.isActive ? CGRect(origin: CGPoint(x: frame.minX, y: newValue.minY), size: newValue.size) : newValue }
        get { return super.frame }
    }
    open override var isHighlighted: Bool {
        set {
            guard state == .center else { return }
            super.isHighlighted = newValue
        }
        get { return super.isHighlighted }
    }
    open override var layoutMargins: UIEdgeInsets {
        get {
            return frame.origin.x != 0 ? swipeController.originalLayoutMargins : super.layoutMargins
        }
        set {
            super.layoutMargins = newValue
        }
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    deinit {
        collectionView?.panGestureRecognizer.removeTarget(self, action: nil)
    }
    func configure() {
        contentView.clipsToBounds = false
        if contentView.translatesAutoresizingMaskIntoConstraints == true {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
        swipeController = SwipeController(swipeable: self, actionsContainerView: contentView)
        swipeController.delegate = self
    }
    override open func prepareForReuse() {
        super.prepareForReuse()
        reset()
        resetSelectedState()
    }
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        var view: UIView = self
        while let superview = view.superview {
            view = superview
            if let collectionView = view as? UICollectionView {
                self.collectionView = collectionView
                swipeController.scrollView = scrollView
                collectionView.panGestureRecognizer.removeTarget(self, action: nil)
                collectionView.panGestureRecognizer.addTarget(self, action: #selector(handleCollectionPan(gesture:)))
                return
            }
        }
    }
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            reset()
        }
    }
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = superview else { return false }
        let point = convert(point, to: superview)
        if !UIAccessibility.isVoiceOverRunning {
            for cell in collectionView?.swipeCells ?? [] {
                if (cell.state == .left || cell.state == .right) && !cell.contains(point: point) {
                    collectionView?.hideSwipeCell()
                    return false
                }
            }
        }
        return contains(point: point)
    }
    func contains(point: CGPoint) -> Bool {
        return frame.contains(point)
    }
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard
          let actionsView = actionsView,
          isHidden == false
        else { return super.hitTest(point, with: event) }
        let modifiedPoint = actionsView.convert(point, from: self)
        return actionsView.hitTest(modifiedPoint, with: event) ?? super.hitTest(point, with: event)
    }
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return swipeController.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        swipeController.traitCollectionDidChange(from: previousTraitCollection, to: self.traitCollection)
    }
    @objc func handleCollectionPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            hideSwipe(animated: true)
        }
    }
    func reset() {
        contentView.clipsToBounds = false
        swipeController.reset()
        collectionView?.setGestureEnabled(true)
    }
    func resetSelectedState() {
        if isPreviouslySelected {
            if let collectionView = collectionView, let indexPath = collectionView.indexPath(for: self) {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
        isPreviouslySelected = false
    }
}
extension SwipeCollectionViewCell: SwipeControllerDelegate {
    func swipeController(_ controller: SwipeController, canBeginEditingSwipeableFor orientation: SwipeActionsOrientation) -> Bool {
        return true
    }
    func swipeController(_ controller: SwipeController, editActionsForSwipeableFor orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard let collectionView = collectionView, let indexPath = collectionView.indexPath(for: self) else { return nil }
        return delegate?.collectionView(collectionView, editActionsForItemAt: indexPath, for: orientation)
    }
    func swipeController(_ controller: SwipeController, editActionsOptionsForSwipeableFor orientation: SwipeActionsOrientation) -> SwipeOptions {
        guard let collectionView = collectionView, let indexPath = collectionView.indexPath(for: self) else { return SwipeOptions() }
        return delegate?.collectionView(collectionView, editActionsOptionsForItemAt: indexPath, for: orientation) ?? SwipeOptions()
    }
    func swipeController(_ controller: SwipeController, visibleRectFor scrollView: UIScrollView) -> CGRect? {
        guard let collectionView = collectionView else { return nil }
        return delegate?.visibleRect(for: collectionView)
    }
    func swipeController(_ controller: SwipeController, willBeginEditingSwipeableFor orientation: SwipeActionsOrientation) {
        guard let collectionView = collectionView, let indexPath = collectionView.indexPath(for: self) else { return }
        super.isHighlighted = false
        isPreviouslySelected = isSelected
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.collectionView(collectionView, willBeginEditingItemAt: indexPath, for: orientation)
    }
    func swipeController(_ controller: SwipeController, didEndEditingSwipeableFor orientation: SwipeActionsOrientation) {
        guard let collectionView = collectionView, let indexPath = collectionView.indexPath(for: self), let actionsView = self.actionsView else { return }
        resetSelectedState()
        delegate?.collectionView(collectionView, didEndEditingItemAt: indexPath, for: actionsView.orientation)
    }
    func swipeController(_ controller: SwipeController, didDeleteSwipeableAt indexPath: IndexPath) {
        collectionView?.deleteItems(at: [indexPath])
    }
}