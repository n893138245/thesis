@usableFromInline
final class StreamEncryptor: Cryptor, Updatable {
  @usableFromInline
  internal let blockSize: Int
  @usableFromInline
  internal var worker: CipherModeWorker
  @usableFromInline
  internal let padding: Padding
  @usableFromInline
  internal var lastBlockRemainder = 0
  @usableFromInline
  init(blockSize: Int, padding: Padding, _ worker: CipherModeWorker) throws {
    self.blockSize = blockSize
    self.padding = padding
    self.worker = worker
  }
  @inlinable
  public func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool) throws -> Array<UInt8> {
    var accumulated = Array(bytes)
    if isLast {
      accumulated = self.padding.add(to: accumulated, blockSize: self.blockSize - self.lastBlockRemainder)
    }
    var encrypted = Array<UInt8>(reserveCapacity: bytes.count)
    for chunk in accumulated.batched(by: self.blockSize) {
      encrypted += self.worker.encrypt(block: chunk)
    }
    if self.padding != .noPadding {
      self.lastBlockRemainder = encrypted.count.quotientAndRemainder(dividingBy: self.blockSize).remainder
    }
    if var finalizingWorker = worker as? FinalizingEncryptModeWorker, isLast == true {
      encrypted = Array(try finalizingWorker.finalize(encrypt: encrypted.slice))
    }
    return encrypted
  }
  @usableFromInline
  func seek(to: Int) throws {
    fatalError("Not supported")
  }
}