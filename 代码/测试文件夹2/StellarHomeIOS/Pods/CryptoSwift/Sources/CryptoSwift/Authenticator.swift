public protocol Authenticator {
  func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8>
}