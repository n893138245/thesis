import UIKit
open class SwipeTableViewCell: UITableViewCell {
    public weak var delegate: SwipeTableViewCellDelegate?
    var state = SwipeState.center
    var actionsView: SwipeActionsView?
    var scrollView: UIScrollView? {
        return tableView
    }
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
    var panGestureRecognizer: UIGestureRecognizer
    {
        return swipeController.panGestureRecognizer;
    }
    var swipeController: SwipeController!
    var isPreviouslySelected = false
    weak var tableView: UITableView?
    open override var frame: CGRect {
        set { super.frame = state.isActive ? CGRect(origin: CGPoint(x: frame.minX, y: newValue.minY), size: newValue.size) : newValue }
        get { return super.frame }
    }
    open override var layoutMargins: UIEdgeInsets {
        get {
            return frame.origin.x != 0 ? swipeController.originalLayoutMargins : super.layoutMargins
        }
        set {
            super.layoutMargins = newValue
        }
    }
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    deinit {
        tableView?.panGestureRecognizer.removeTarget(self, action: nil)
    }
    func configure() {
        clipsToBounds = false
        swipeController = SwipeController(swipeable: self, actionsContainerView: self)
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
            if let tableView = view as? UITableView {
                self.tableView = tableView
                swipeController.scrollView = tableView;
                tableView.panGestureRecognizer.removeTarget(self, action: nil)
                tableView.panGestureRecognizer.addTarget(self, action: #selector(handleTablePan(gesture:)))
                return
            }
        }
    }
    override open func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            hideSwipe(animated: false)
        }
    }
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = superview else { return false }
        let point = convert(point, to: superview)
        if !UIAccessibility.isVoiceOverRunning {
            for cell in tableView?.swipeCells ?? [] {
                if (cell.state == .left || cell.state == .right) && !cell.contains(point: point) {
                    tableView?.hideSwipeCell()
                    return false
                }
            }
        }
        return contains(point: point)
    }
    func contains(point: CGPoint) -> Bool {
        return point.y > frame.minY && point.y < frame.maxY
    }
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if state == .center {
            super.setHighlighted(highlighted, animated: animated)
        }
    }
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return swipeController.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        swipeController.traitCollectionDidChange(from: previousTraitCollection, to: self.traitCollection)
    }
    @objc func handleTablePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            hideSwipe(animated: true)
        }
    }
    func reset() {
        swipeController.reset()
        clipsToBounds = false
    }
    func resetSelectedState() {
        if isPreviouslySelected {
            if let tableView = tableView, let indexPath = tableView.indexPath(for: self) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        isPreviouslySelected = false
    }
}
extension SwipeTableViewCell: SwipeControllerDelegate {
    func swipeController(_ controller: SwipeController, canBeginEditingSwipeableFor orientation: SwipeActionsOrientation) -> Bool {
        return self.isEditing == false
    }
    func swipeController(_ controller: SwipeController, editActionsForSwipeableFor orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard let tableView = tableView, let indexPath = tableView.indexPath(for: self) else { return nil }
        return delegate?.tableView(tableView, editActionsForRowAt: indexPath, for: orientation)
    }
    func swipeController(_ controller: SwipeController, editActionsOptionsForSwipeableFor orientation: SwipeActionsOrientation) -> SwipeOptions {
        guard let tableView = tableView, let indexPath = tableView.indexPath(for: self) else { return SwipeOptions() }
        return delegate?.tableView(tableView, editActionsOptionsForRowAt: indexPath, for: orientation) ?? SwipeOptions()
    }
    func swipeController(_ controller: SwipeController, visibleRectFor scrollView: UIScrollView) -> CGRect? {
        guard let tableView = tableView else { return nil }
        return delegate?.visibleRect(for: tableView)
    }
    func swipeController(_ controller: SwipeController, willBeginEditingSwipeableFor orientation: SwipeActionsOrientation) {
        guard let tableView = tableView, let indexPath = tableView.indexPath(for: self) else { return }
        super.setHighlighted(false, animated: false)
        isPreviouslySelected = isSelected
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.tableView(tableView, willBeginEditingRowAt: indexPath, for: orientation)
    }
    func swipeController(_ controller: SwipeController, didEndEditingSwipeableFor orientation: SwipeActionsOrientation) {
        guard let tableView = tableView, let indexPath = tableView.indexPath(for: self), let actionsView = self.actionsView else { return }
        resetSelectedState()
        delegate?.tableView(tableView, didEndEditingRowAt: indexPath, for: actionsView.orientation)
    }
    func swipeController(_ controller: SwipeController, didDeleteSwipeableAt indexPath: IndexPath) {
        tableView?.deleteRows(at: [indexPath], with: .none)
    }
}