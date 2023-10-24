#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(ucrt)
import ucrt
#endif
extension FixedWidthInteger {
  @inlinable
  func bytes(totalBytes: Int = MemoryLayout<Self>.size) -> Array<UInt8> {
    arrayOfBytes(value: self.littleEndian, length: totalBytes)
  }
}