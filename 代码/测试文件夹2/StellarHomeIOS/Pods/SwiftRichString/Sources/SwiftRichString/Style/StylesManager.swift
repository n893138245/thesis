import Foundation
public let Styles: StylesManager = StylesManager.shared
public class StylesManager {
	public static let shared: StylesManager = StylesManager()
	public var onDeferStyle: ((String) -> (StyleProtocol?, Bool))? = nil
	public private(set) var styles: [String: StyleProtocol] = [:]
	public func register(_ name: String, style: StyleProtocol) {
		self.styles[name] = style
	}
	public subscript(name: String?) -> StyleProtocol? {
		guard let name = name else { return nil }
		if let cachedStyle = self.styles[name] { 
			return cachedStyle
		} else {
			if let (deferredStyle,canCache) = self.onDeferStyle?(name) {
				if canCache, let dStyle = deferredStyle { self.styles[name] = dStyle }
				return deferredStyle
			}
			return nil 
		}
	}
	public subscript(names: [String]?) -> [StyleProtocol]? {
		guard let names = names else { return nil }
		return names.compactMap { self.styles[$0] }
	}
}