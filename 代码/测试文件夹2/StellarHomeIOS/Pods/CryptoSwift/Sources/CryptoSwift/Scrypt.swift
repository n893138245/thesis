public final class Scrypt {
  enum Error: Swift.Error {
    case nIsTooLarge
    case rIsTooLarge
    case nMustBeAPowerOf2GreaterThan1
    case invalidInput
  }
  private let salt: SecureBytes
  private let password: SecureBytes
  private let blocksize: Int 
  private let salsaBlock = UnsafeMutableRawPointer.allocate(byteCount: 64, alignment: 64)
  private let dkLen: Int
  private let N: Int
  private let r: Int
  private let p: Int
  public init(password: Array<UInt8>, salt: Array<UInt8>, dkLen: Int, N: Int, r: Int, p: Int) throws {
    precondition(dkLen > 0)
    precondition(N > 0)
    precondition(r > 0)
    precondition(p > 0)
    guard !(N < 2 || (N & (N - 1)) != 0) else { throw Error.nMustBeAPowerOf2GreaterThan1 }
    guard N <= .max / 128 / r else { throw Error.nIsTooLarge }
    guard r <= .max / 128 / p else { throw Error.rIsTooLarge }
    guard !salt.isEmpty else {
      throw Error.invalidInput
    }
    self.blocksize = 128 * r
    self.N = N
    self.r = r
    self.p = p
    self.password = SecureBytes(bytes: password)
    self.salt = SecureBytes(bytes: salt)
    self.dkLen = dkLen
  }
  public func calculate() throws -> [UInt8] {
    let B = UnsafeMutableRawPointer.allocate(byteCount: 128 * self.r * self.p, alignment: 64)
    let XY = UnsafeMutableRawPointer.allocate(byteCount: 256 * self.r + 64, alignment: 64)
    let V = UnsafeMutableRawPointer.allocate(byteCount: 128 * self.r * self.N, alignment: 64)
    defer {
      B.deallocate()
      XY.deallocate()
      V.deallocate()
    }
    let barray = try PKCS5.PBKDF2(password: Array(self.password), salt: Array(self.salt), iterations: 1, keyLength: self.p * 128 * self.r, variant: .sha256).calculate()
    barray.withUnsafeBytes { p in
      B.copyMemory(from: p.baseAddress!, byteCount: barray.count)
    }
    for i in 0 ..< self.p {
      smix(B + i * 128 * self.r, V.assumingMemoryBound(to: UInt32.self), XY.assumingMemoryBound(to: UInt32.self))
    }
    let pointer = B.assumingMemoryBound(to: UInt8.self)
    let bufferPointer = UnsafeBufferPointer(start: pointer, count: p * 128 * self.r)
    let block = [UInt8](bufferPointer)
    return try PKCS5.PBKDF2(password: Array(self.password), salt: block, iterations: 1, keyLength: self.dkLen, variant: .sha256).calculate()
  }
}
private extension Scrypt {
  @inline(__always) func smix(_ block: UnsafeMutableRawPointer, _ v: UnsafeMutablePointer<UInt32>, _ xy: UnsafeMutablePointer<UInt32>) {
    let X = xy
    let Y = xy + 32 * self.r
    let Z = xy + 64 * self.r
    let typedBlock = block.assumingMemoryBound(to: UInt32.self)
    X.assign(from: typedBlock, count: 32 * self.r)
    for i in stride(from: 0, to: self.N, by: 2) {
      UnsafeMutableRawPointer(v + i * (32 * self.r)).copyMemory(from: X, byteCount: 128 * self.r)
      self.blockMixSalsa8(X, Y, Z)
      UnsafeMutableRawPointer(v + (i + 1) * (32 * self.r)).copyMemory(from: Y, byteCount: 128 * self.r)
      self.blockMixSalsa8(Y, X, Z)
    }
    for _ in stride(from: 0, to: self.N, by: 2) {
      var j = Int(integerify(X) & UInt64(self.N - 1))
      self.blockXor(X, v + j * 32 * self.r, 128 * self.r)
      self.blockMixSalsa8(X, Y, Z)
      j = Int(self.integerify(Y) & UInt64(self.N - 1))
      self.blockXor(Y, v + j * 32 * self.r, 128 * self.r)
      self.blockMixSalsa8(Y, X, Z)
    }
    for k in 0 ..< 32 * self.r {
      UnsafeMutableRawPointer(block + 4 * k).storeBytes(of: X[k], as: UInt32.self)
    }
  }
  @inline(__always) func integerify(_ block: UnsafeRawPointer) -> UInt64 {
    let bi = block + (2 * self.r - 1) * 64
    return bi.load(as: UInt64.self).littleEndian
  }
  @inline(__always) func blockMixSalsa8(_ bin: UnsafePointer<UInt32>, _ bout: UnsafeMutablePointer<UInt32>, _ x: UnsafeMutablePointer<UInt32>) {
    UnsafeMutableRawPointer(x).copyMemory(from: bin + (2 * self.r - 1) * 16, byteCount: 64)
    for i in stride(from: 0, to: 2 * self.r, by: 2) {
      self.blockXor(x, bin + i * 16, 64)
      self.salsa20_8_typed(x)
      UnsafeMutableRawPointer(bout + i * 8).copyMemory(from: x, byteCount: 64)
      self.blockXor(x, bin + i * 16 + 16, 64)
      self.salsa20_8_typed(x)
      UnsafeMutableRawPointer(bout + i * 8 + self.r * 16).copyMemory(from: x, byteCount: 64)
    }
  }
  @inline(__always) func salsa20_8_typed(_ block: UnsafeMutablePointer<UInt32>) {
    self.salsaBlock.copyMemory(from: UnsafeRawPointer(block), byteCount: 64)
    let salsaBlockTyped = self.salsaBlock.assumingMemoryBound(to: UInt32.self)
    for _ in stride(from: 0, to: 8, by: 2) {
      salsaBlockTyped[4] ^= rotateLeft(salsaBlockTyped[0] &+ salsaBlockTyped[12], by: 7)
      salsaBlockTyped[8] ^= rotateLeft(salsaBlockTyped[4] &+ salsaBlockTyped[0], by: 9)
      salsaBlockTyped[12] ^= rotateLeft(salsaBlockTyped[8] &+ salsaBlockTyped[4], by: 13)
      salsaBlockTyped[0] ^= rotateLeft(salsaBlockTyped[12] &+ salsaBlockTyped[8], by: 18)
      salsaBlockTyped[9] ^= rotateLeft(salsaBlockTyped[5] &+ salsaBlockTyped[1], by: 7)
      salsaBlockTyped[13] ^= rotateLeft(salsaBlockTyped[9] &+ salsaBlockTyped[5], by: 9)
      salsaBlockTyped[1] ^= rotateLeft(salsaBlockTyped[13] &+ salsaBlockTyped[9], by: 13)
      salsaBlockTyped[5] ^= rotateLeft(salsaBlockTyped[1] &+ salsaBlockTyped[13], by: 18)
      salsaBlockTyped[14] ^= rotateLeft(salsaBlockTyped[10] &+ salsaBlockTyped[6], by: 7)
      salsaBlockTyped[2] ^= rotateLeft(salsaBlockTyped[14] &+ salsaBlockTyped[10], by: 9)
      salsaBlockTyped[6] ^= rotateLeft(salsaBlockTyped[2] &+ salsaBlockTyped[14], by: 13)
      salsaBlockTyped[10] ^= rotateLeft(salsaBlockTyped[6] &+ salsaBlockTyped[2], by: 18)
      salsaBlockTyped[3] ^= rotateLeft(salsaBlockTyped[15] &+ salsaBlockTyped[11], by: 7)
      salsaBlockTyped[7] ^= rotateLeft(salsaBlockTyped[3] &+ salsaBlockTyped[15], by: 9)
      salsaBlockTyped[11] ^= rotateLeft(salsaBlockTyped[7] &+ salsaBlockTyped[3], by: 13)
      salsaBlockTyped[15] ^= rotateLeft(salsaBlockTyped[11] &+ salsaBlockTyped[7], by: 18)
      salsaBlockTyped[1] ^= rotateLeft(salsaBlockTyped[0] &+ salsaBlockTyped[3], by: 7)
      salsaBlockTyped[2] ^= rotateLeft(salsaBlockTyped[1] &+ salsaBlockTyped[0], by: 9)
      salsaBlockTyped[3] ^= rotateLeft(salsaBlockTyped[2] &+ salsaBlockTyped[1], by: 13)
      salsaBlockTyped[0] ^= rotateLeft(salsaBlockTyped[3] &+ salsaBlockTyped[2], by: 18)
      salsaBlockTyped[6] ^= rotateLeft(salsaBlockTyped[5] &+ salsaBlockTyped[4], by: 7)
      salsaBlockTyped[7] ^= rotateLeft(salsaBlockTyped[6] &+ salsaBlockTyped[5], by: 9)
      salsaBlockTyped[4] ^= rotateLeft(salsaBlockTyped[7] &+ salsaBlockTyped[6], by: 13)
      salsaBlockTyped[5] ^= rotateLeft(salsaBlockTyped[4] &+ salsaBlockTyped[7], by: 18)
      salsaBlockTyped[11] ^= rotateLeft(salsaBlockTyped[10] &+ salsaBlockTyped[9], by: 7)
      salsaBlockTyped[8] ^= rotateLeft(salsaBlockTyped[11] &+ salsaBlockTyped[10], by: 9)
      salsaBlockTyped[9] ^= rotateLeft(salsaBlockTyped[8] &+ salsaBlockTyped[11], by: 13)
      salsaBlockTyped[10] ^= rotateLeft(salsaBlockTyped[9] &+ salsaBlockTyped[8], by: 18)
      salsaBlockTyped[12] ^= rotateLeft(salsaBlockTyped[15] &+ salsaBlockTyped[14], by: 7)
      salsaBlockTyped[13] ^= rotateLeft(salsaBlockTyped[12] &+ salsaBlockTyped[15], by: 9)
      salsaBlockTyped[14] ^= rotateLeft(salsaBlockTyped[13] &+ salsaBlockTyped[12], by: 13)
      salsaBlockTyped[15] ^= rotateLeft(salsaBlockTyped[14] &+ salsaBlockTyped[13], by: 18)
    }
    for i in 0 ..< 16 {
      block[i] = block[i] &+ salsaBlockTyped[i]
    }
  }
  @inline(__always) func blockXor(_ dest: UnsafeMutableRawPointer, _ src: UnsafeRawPointer, _ len: Int) {
    let D = dest.assumingMemoryBound(to: UInt64.self)
    let S = src.assumingMemoryBound(to: UInt64.self)
    let L = len / MemoryLayout<UInt64>.size
    for i in 0 ..< L {
      D[i] ^= S[i]
    }
  }
}