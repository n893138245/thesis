struct PKCS7Padding: PaddingProtocol {
  enum Error: Swift.Error {
    case invalidPaddingValue
  }
  init() {
  }
  @inlinable
  func add(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
    let padding = UInt8(blockSize - (bytes.count % blockSize))
    var withPadding = bytes
    if padding == 0 {
      withPadding += Array<UInt8>(repeating: UInt8(blockSize), count: Int(blockSize))
    } else {
      withPadding += Array<UInt8>(repeating: padding, count: Int(padding))
    }
    return withPadding
  }
  @inlinable
  func remove(from bytes: Array<UInt8>, blockSize _: Int?) -> Array<UInt8> {
    guard !bytes.isEmpty, let lastByte = bytes.last else {
      return bytes
    }
    assert(!bytes.isEmpty, "Need bytes to remove padding")
    let padding = Int(lastByte) 
    let finalLength = bytes.count - padding
    if finalLength < 0 {
      return bytes
    }
    if padding >= 1 {
      return Array(bytes[0..<finalLength])
    }
    return bytes
  }
}