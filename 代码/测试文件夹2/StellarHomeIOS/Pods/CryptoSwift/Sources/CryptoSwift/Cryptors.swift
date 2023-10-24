#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(ucrt)
import ucrt
#endif
public protocol Cryptors: AnyObject {
  func makeEncryptor() throws -> Cryptor & Updatable
  func makeDecryptor() throws -> Cryptor & Updatable
  static func randomIV(_ blockSize: Int) -> Array<UInt8>
}
extension Cryptors {
  public static func randomIV(_ count: Int) -> Array<UInt8> {
    (0..<count).map({ _ in UInt8.random(in: 0...UInt8.max) })
  }
}