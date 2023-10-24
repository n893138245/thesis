#if os(iOS) || os(tvOS)
    import Foundation
    import UIKit
    public struct AnimationConfiguration {
        public let insertAnimation: UITableView.RowAnimation
        public let reloadAnimation: UITableView.RowAnimation
        public let deleteAnimation: UITableView.RowAnimation
        public init(insertAnimation: UITableView.RowAnimation = .automatic,
                    reloadAnimation: UITableView.RowAnimation = .automatic,
                    deleteAnimation: UITableView.RowAnimation = .automatic) {
            self.insertAnimation = insertAnimation
            self.reloadAnimation = reloadAnimation
            self.deleteAnimation = deleteAnimation
        }
    }
#endif