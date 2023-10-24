public enum NoError: Swift.Error, Equatable {
	public static func ==(lhs: NoError, rhs: NoError) -> Bool {
		return true
	}
}