import Foundation
public extension NSRange {
	func `in`(_ str: String) -> Range<String.Index>? {
		return Range(self, in: str)
	}
}
public extension String {
	func rangeFrom(nsRange : NSRange) -> Range<String.Index>? {
		return Range(nsRange, in: self)
	}
	func substring(from: Int?, length: Int) -> String? {
		guard length > 0 else { return nil }
		let start = from ?? 0
		let end = min(count, max(0, start) + length)
		guard start < end else { return nil }
		return self[start..<end]?.string
	}
	subscript(index: Int) -> Character? {
		guard !self.isEmpty, let stringIndex = self.index(startIndex, offsetBy: index, limitedBy: self.index(before: endIndex)) else { return nil }
		return self[stringIndex]
	}
	subscript(range: Range<Int>) -> Substring? {
		guard let left = offset(by: range.lowerBound) else { return nil }
		guard let right = index(left, offsetBy: range.upperBound - range.lowerBound,
								limitedBy: endIndex) else { return nil }
		return self[left..<right]
	}
	subscript(value: PartialRangeUpTo<Int>) -> Substring? {
		if value.upperBound < 0 {
			guard abs(value.upperBound) <= count else { return nil }
			return self[..<(count - abs(value.upperBound))]
		}
		guard let right = offset(by: value.upperBound) else { return nil }
		return self[..<right]
	}
	subscript(range: ClosedRange<Int>) -> Substring? {
		if range.upperBound < 0 {
			guard abs(range.lowerBound) <= count else { return nil }
			return self[(count - abs(range.lowerBound))...]
		}
		guard let left = offset(by: range.lowerBound) else { return nil }
		guard let right = index(left, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
		return self[left...right]
	}
	subscript(value: PartialRangeFrom<Int>) -> Substring? {
		guard let left = self.offset(by: value.lowerBound) else { return nil }
		return self[left...]
	}
	subscript(value: PartialRangeThrough<Int>) -> Substring? {
		guard let right = self.offset(by: value.upperBound) else { return nil }
		return self[...right]
	}
	internal func offset(by distance: Int) -> String.Index? {
		return index(startIndex, offsetBy: distance, limitedBy: endIndex)
	}
	func removing(prefix: String) -> String {
		if hasPrefix(prefix) {
			let start = index(startIndex, offsetBy: prefix.count)
			return self[start...].string
		}
		return self
	}
	func removing(suffix: String) -> String {
		if hasSuffix(suffix) {
			let end = index(startIndex, offsetBy: self.count-suffix.count)
			return self[..<end].string
		}
		return self
	}
}
public extension Substring {
	var string: String {
		return String(self)
	}
}