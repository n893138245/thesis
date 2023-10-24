public struct Bag<Element> {
	public struct Token {
		fileprivate let value: UInt64
	}
	fileprivate var elements: ContiguousArray<Element>
	fileprivate var tokens: ContiguousArray<UInt64>
	private var nextToken: Token
	public init() {
		elements = ContiguousArray()
		tokens = ContiguousArray()
		nextToken = Token(value: 0)
	}
	public init<S: Sequence>(_ elements: S) where S.Iterator.Element == Element {
		self.elements = ContiguousArray(elements)
		self.nextToken = Token(value: UInt64(self.elements.count))
		self.tokens = ContiguousArray(0..<nextToken.value)
	}
	@discardableResult
	public mutating func insert(_ value: Element) -> Token {
		let token = nextToken
		nextToken = Token(value: token.value &+ 1)
		elements.append(value)
		tokens.append(token.value)
		return token
	}
	@discardableResult
	public mutating func remove(using token: Token) -> Element? {
		guard let index = indices.first(where: { tokens[$0] == token.value }) else {
			return nil
		}
		tokens.remove(at: index)
		return elements.remove(at: index)
	}
}
extension Bag: RandomAccessCollection {
	public var startIndex: Int {
		return elements.startIndex
	}
	public var endIndex: Int {
		return elements.endIndex
	}
	public subscript(index: Int) -> Element {
		return elements[index]
	}
	public func makeIterator() -> Iterator {
		return Iterator(elements.makeIterator())
	}
	public struct Iterator: IteratorProtocol {
		private var base: ContiguousArray<Element>.Iterator
		fileprivate init(_ base: ContiguousArray<Element>.Iterator) {
			self.base = base
		}
		public mutating func next() -> Element? {
			return base.next()
		}
	}
}