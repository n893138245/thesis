import Foundation
extension Blowfish {
  public convenience init(key: String, iv: String, padding: Padding = .pkcs7) throws {
    try self.init(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: padding)
  }
}