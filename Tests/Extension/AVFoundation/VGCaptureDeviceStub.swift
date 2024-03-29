import AVFoundation
@testable import voice_guidance

// MARK: - VGCaptureDeviceStub
struct VGCaptureDeviceStub: VGCaptureDevice {
  let authorizationStatus: AVAuthorizationStatus
  
  func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
    authorizationStatus
  }
  
  func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void) {
    AVCaptureDevice.requestAccess(for: mediaType, completionHandler: handler)
  }
}
