#if os(iOS) || os(tvOS)
import UIKit
public typealias ItemMovedEvent = (sourceIndex: IndexPath, destinationIndex: IndexPath)
public typealias WillDisplayCellEvent = (cell: UITableViewCell, indexPath: IndexPath)
public typealias DidEndDisplayingCellEvent = (cell: UITableViewCell, indexPath: IndexPath)
#endif