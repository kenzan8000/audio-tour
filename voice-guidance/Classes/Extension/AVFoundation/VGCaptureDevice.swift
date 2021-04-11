import AVFoundation

// MARK: - VGCaptureDevice
protocol VGCaptureDevice {
  func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
  func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void)
}

// MARK: - VGCaptureDeviceFactory
typealias VGCaptureDeviceFactory = () -> VGCaptureDevice

// MARK: - VGAVCaptureDevice
class VGAVCaptureDevice: VGCaptureDevice {
  func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
    AVCaptureDevice.authorizationStatus(for: mediaType)
  }
  func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void) {
    AVCaptureDevice.requestAccess(for: mediaType, completionHandler: handler)
  }
}
