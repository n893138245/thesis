import Foundation
public struct OrderedDictionary<K: Hashable, V> {
	var keys = [K]()
	var dict = [K:V]()
	public var count: Int {
		return self.keys.count
	}
	public subscript(key: K) -> V? {
		get {
			return self.dict[key]
		}
		set(newValue) {
			if newValue == nil {
				self.dict.removeValue(forKey:key)
				self.keys = self.keys.filter {$0 != key}
			} else {
				let oldValue = self.dict.updateValue(newValue!, forKey: key)
				if oldValue == nil {
					self.keys.append(key)
				}
			}
		}
	}
	public mutating func remove(key: K) -> V? {
		guard let idx = self.keys.firstIndex(of: key) else { return nil }
		self.keys.remove(at: idx)
		return self.dict.removeValue(forKey: key)
	}
}
extension OrderedDictionary: Sequence {
	public func makeIterator() -> AnyIterator<V> {
		var counter = 0
		return AnyIterator {
			guard counter<self.keys.count else {
				return nil
			}
			let next = self.dict[self.keys[counter]]
			counter += 1
			return next
		}
	}
}
extension OrderedDictionary: CustomStringConvertible {
	public var description: String {
		let isString = type(of: self.keys[0]) == String.self
		var result = "["
		for key in keys {
			result += isString ? "\"\(key)\"" : "\(key)"
			result += ": \(self[key]!), "
		}
		result = String(result.dropLast(2))
		result += "]"
		return result
	}
}
extension OrderedDictionary: ExpressibleByDictionaryLiteral {
	public init(dictionaryLiteral elements: (K, V)...) {
		self.init()
		for (key, value) in elements {
			self[key] = value
		}
	}
}