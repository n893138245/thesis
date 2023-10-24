public typealias CipherOperationOnBlock = (_ block: ArraySlice<UInt8>) -> Array<UInt8>?
public protocol BlockMode {
  var options: BlockModeOption { get }
  @inlinable func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker
  var customBlockSize: Int? { get }
}
typealias StreamMode = BlockMode