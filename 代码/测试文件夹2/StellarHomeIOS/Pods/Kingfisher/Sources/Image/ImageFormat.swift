import Foundation
public enum ImageFormat {
    case unknown
    case PNG
    case JPEG
    case GIF
    struct HeaderData {
        static var PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        static var JPEG_SOI: [UInt8] = [0xFF, 0xD8]
        static var JPEG_IF: [UInt8] = [0xFF]
        static var GIF: [UInt8] = [0x47, 0x49, 0x46]
    }
    public enum JPEGMarker {
        case SOF0           
        case SOF2           
        case DHT            
        case DQT            
        case DRI            
        case SOS            
        case RSTn(UInt8)    
        case APPn           
        case COM            
        case EOI            
        var bytes: [UInt8] {
            switch self {
            case .SOF0:         return [0xFF, 0xC0]
            case .SOF2:         return [0xFF, 0xC2]
            case .DHT:          return [0xFF, 0xC4]
            case .DQT:          return [0xFF, 0xDB]
            case .DRI:          return [0xFF, 0xDD]
            case .SOS:          return [0xFF, 0xDA]
            case .RSTn(let n):  return [0xFF, 0xD0 + n]
            case .APPn:         return [0xFF, 0xE0]
            case .COM:          return [0xFF, 0xFE]
            case .EOI:          return [0xFF, 0xD9]
            }
        }
    }
}
extension Data: KingfisherCompatibleValue {}
extension KingfisherWrapper where Base == Data {
    public var imageFormat: ImageFormat {
        guard base.count > 8 else { return .unknown }
        var buffer = [UInt8](repeating: 0, count: 8)
        base.copyBytes(to: &buffer, count: 8)
        if buffer == ImageFormat.HeaderData.PNG {
            return .PNG
        } else if buffer[0] == ImageFormat.HeaderData.JPEG_SOI[0],
            buffer[1] == ImageFormat.HeaderData.JPEG_SOI[1],
            buffer[2] == ImageFormat.HeaderData.JPEG_IF[0]
        {
            return .JPEG
        } else if buffer[0] == ImageFormat.HeaderData.GIF[0],
            buffer[1] == ImageFormat.HeaderData.GIF[1],
            buffer[2] == ImageFormat.HeaderData.GIF[2]
        {
            return .GIF
        }
        return .unknown
    }
    public func contains(jpeg marker: ImageFormat.JPEGMarker) -> Bool {
        guard imageFormat == .JPEG else {
            return false
        }
        var buffer = [UInt8](repeating: 0, count: base.count)
        base.copyBytes(to: &buffer, count: base.count)
        for (index, item) in buffer.enumerated() {
            guard
                item == marker.bytes.first,
                buffer.count > index + 1,
                buffer[index + 1] == marker.bytes[1] else {
                continue
            }
            return true
        }
        return false
    }
}