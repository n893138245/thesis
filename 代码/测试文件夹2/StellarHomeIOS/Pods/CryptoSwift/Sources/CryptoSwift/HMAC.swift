public final class HMAC: Authenticator {
  public enum Error: Swift.Error {
    case authenticateError
    case invalidInput
  }
  public enum Variant {
    case sha1, sha256, sha384, sha512, md5
    var digestLength: Int {
      switch self {
        case .sha1:
          return SHA1.digestLength
        case .sha256:
          return SHA2.Variant.sha256.digestLength
        case .sha384:
          return SHA2.Variant.sha384.digestLength
        case .sha512:
          return SHA2.Variant.sha512.digestLength
        case .md5:
          return MD5.digestLength
      }
    }
    func calculateHash(_ bytes: Array<UInt8>) -> Array<UInt8> {
      switch self {
        case .sha1:
          return Digest.sha1(bytes)
        case .sha256:
          return Digest.sha256(bytes)
        case .sha384:
          return Digest.sha384(bytes)
        case .sha512:
          return Digest.sha512(bytes)
        case .md5:
          return Digest.md5(bytes)
      }
    }
    func blockSize() -> Int {
      switch self {
        case .md5:
          return MD5.blockSize
        case .sha1, .sha256:
          return 64
        case .sha384, .sha512:
          return 128
      }
    }
  }
  var key: Array<UInt8>
  let variant: Variant
  public init(key: Array<UInt8>, variant: HMAC.Variant = .md5) {
    self.variant = variant
    self.key = key
    if key.count > variant.blockSize() {
      let hash = variant.calculateHash(key)
      self.key = hash
    }
    if key.count < variant.blockSize() {
      self.key = ZeroPadding().add(to: key, blockSize: variant.blockSize())
    }
  }
  public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    var opad = Array<UInt8>(repeating: 0x5c, count: variant.blockSize())
    for idx in self.key.indices {
      opad[idx] = self.key[idx] ^ opad[idx]
    }
    var ipad = Array<UInt8>(repeating: 0x36, count: variant.blockSize())
    for idx in self.key.indices {
      ipad[idx] = self.key[idx] ^ ipad[idx]
    }
    let ipadAndMessageHash = self.variant.calculateHash(ipad + bytes)
    let result = self.variant.calculateHash(opad + ipadAndMessageHash)
    return result
  }
}