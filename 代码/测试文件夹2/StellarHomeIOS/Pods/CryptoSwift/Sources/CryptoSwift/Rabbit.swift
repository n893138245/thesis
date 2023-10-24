public final class Rabbit: BlockCipher {
  public enum Error: Swift.Error {
    case invalidKeyOrInitializationVector
  }
  public static let ivSize = 64 / 8
  public static let keySize = 128 / 8
  public static let blockSize = 128 / 8
  public var keySize: Int {
    self.key.count
  }
  private let key: Key
  private let iv: Array<UInt8>?
  private var x = Array<UInt32>(repeating: 0, count: 8)
  private var c = Array<UInt32>(repeating: 0, count: 8)
  private var p7: UInt32 = 0
  private var a: Array<UInt32> = [
    0x4d34d34d,
    0xd34d34d3,
    0x34d34d34,
    0x4d34d34d,
    0xd34d34d3,
    0x34d34d34,
    0x4d34d34d,
    0xd34d34d3
  ]
  public convenience init(key: Array<UInt8>) throws {
    try self.init(key: key, iv: nil)
  }
  public init(key: Array<UInt8>, iv: Array<UInt8>?) throws {
    self.key = Key(bytes: key)
    self.iv = iv
    guard key.count == Rabbit.keySize && (iv == nil || iv!.count == Rabbit.ivSize) else {
      throw Error.invalidKeyOrInitializationVector
    }
  }
  fileprivate func setup() {
    self.p7 = 0
    let k = Array<UInt32>(unsafeUninitializedCapacity: 8) { buf, count in
      for j in 0..<8 {
        buf[j] = UInt32(self.key[Rabbit.blockSize - (2 * j + 1)]) | (UInt32(self.key[Rabbit.blockSize - (2 * j + 2)]) << 8)
      }
      count = 8
    }
    for j in 0..<8 {
      if j % 2 == 0 {
        self.x[j] = (k[(j + 1) % 8] << 16) | k[j]
        self.c[j] = (k[(j + 4) % 8] << 16) | k[(j + 5) % 8]
      } else {
        self.x[j] = (k[(j + 5) % 8] << 16) | k[(j + 4) % 8]
        self.c[j] = (k[j] << 16) | k[(j + 1) % 8]
      }
    }
    self.nextState()
    self.nextState()
    self.nextState()
    self.nextState()
    for j in 0..<8 {
      self.c[j] = self.c[j] ^ self.x[(j + 4) % 8]
    }
    if let iv = iv {
      self.setupIV(iv)
    }
  }
  private func setupIV(_ iv: Array<UInt8>) {
    let iv0 = UInt32(bytes: [iv[4], iv[5], iv[6], iv[7]])
    let iv1 = UInt32(bytes: [iv[0], iv[1], iv[4], iv[5]])
    let iv2 = UInt32(bytes: [iv[0], iv[1], iv[2], iv[3]])
    let iv3 = UInt32(bytes: [iv[2], iv[3], iv[6], iv[7]])
    c[0] = self.c[0] ^ iv0
    self.c[1] = self.c[1] ^ iv1
    self.c[2] = self.c[2] ^ iv2
    self.c[3] = self.c[3] ^ iv3
    self.c[4] = self.c[4] ^ iv0
    self.c[5] = self.c[5] ^ iv1
    self.c[6] = self.c[6] ^ iv2
    self.c[7] = self.c[7] ^ iv3
    self.nextState()
    self.nextState()
    self.nextState()
    self.nextState()
  }
  private func nextState() {
    var carry = self.p7
    for j in 0..<8 {
      let prev = self.c[j]
      self.c[j] = prev &+ self.a[j] &+ carry
      carry = prev > self.c[j] ? 1 : 0 
    }
    self.p7 = carry 
    self.x = Array<UInt32>(unsafeUninitializedCapacity: 8) { newX, count in
      newX[0] = self.g(0) &+ rotateLeft(self.g(7), by: 16) &+ rotateLeft(self.g(6), by: 16)
      newX[1] = self.g(1) &+ rotateLeft(self.g(0), by: 8) &+ self.g(7)
      newX[2] = self.g(2) &+ rotateLeft(self.g(1), by: 16) &+ rotateLeft(self.g(0), by: 16)
      newX[3] = self.g(3) &+ rotateLeft(self.g(2), by: 8) &+ self.g(1)
      newX[4] = self.g(4) &+ rotateLeft(self.g(3), by: 16) &+ rotateLeft(self.g(2), by: 16)
      newX[5] = self.g(5) &+ rotateLeft(self.g(4), by: 8) &+ self.g(3)
      newX[6] = self.g(6) &+ rotateLeft(self.g(5), by: 16) &+ rotateLeft(self.g(4), by: 16)
      newX[7] = self.g(7) &+ rotateLeft(self.g(6), by: 8) &+ self.g(5)
      count = 8
    }
  }
  private func g(_ j: Int) -> UInt32 {
    let sum = self.x[j] &+ self.c[j]
    let square = UInt64(sum) * UInt64(sum)
    return UInt32(truncatingIfNeeded: square ^ (square >> 32))
  }
  fileprivate func nextOutput() -> Array<UInt8> {
    self.nextState()
    var output16 = Array<UInt16>(repeating: 0, count: Rabbit.blockSize / 2)
    output16[7] = UInt16(truncatingIfNeeded: self.x[0]) ^ UInt16(truncatingIfNeeded: self.x[5] >> 16)
    output16[6] = UInt16(truncatingIfNeeded: self.x[0] >> 16) ^ UInt16(truncatingIfNeeded: self.x[3])
    output16[5] = UInt16(truncatingIfNeeded: self.x[2]) ^ UInt16(truncatingIfNeeded: self.x[7] >> 16)
    output16[4] = UInt16(truncatingIfNeeded: self.x[2] >> 16) ^ UInt16(truncatingIfNeeded: self.x[5])
    output16[3] = UInt16(truncatingIfNeeded: self.x[4]) ^ UInt16(truncatingIfNeeded: self.x[1] >> 16)
    output16[2] = UInt16(truncatingIfNeeded: self.x[4] >> 16) ^ UInt16(truncatingIfNeeded: self.x[7])
    output16[1] = UInt16(truncatingIfNeeded: self.x[6]) ^ UInt16(truncatingIfNeeded: self.x[3] >> 16)
    output16[0] = UInt16(truncatingIfNeeded: self.x[6] >> 16) ^ UInt16(truncatingIfNeeded: self.x[1])
    var output8 = Array<UInt8>(repeating: 0, count: Rabbit.blockSize)
    for j in 0..<output16.count {
      output8[j * 2] = UInt8(truncatingIfNeeded: output16[j] >> 8)
      output8[j * 2 + 1] = UInt8(truncatingIfNeeded: output16[j])
    }
    return output8
  }
}
extension Rabbit: Cipher {
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    self.setup()
    return Array<UInt8>(unsafeUninitializedCapacity: bytes.count) { result, count in
      var output = self.nextOutput()
      var byteIdx = 0
      var outputIdx = 0
      while byteIdx < bytes.count {
        if outputIdx == Rabbit.blockSize {
          output = self.nextOutput()
          outputIdx = 0
        }
        result[byteIdx] = bytes[byteIdx] ^ output[outputIdx]
        byteIdx += 1
        outputIdx += 1
      }
      count = bytes.count
    }
  }
  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    try self.encrypt(bytes)
  }
}