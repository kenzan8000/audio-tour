import AVFoundation
import CoreLocation
import RxSwift
import UIKit

// MARK: - VGPermssionType
enum VGPermssionType {
  case location
  case locationAndVideo
  case video
  case notNeeded
}

// MARK: - VGPermissionViewModel
class VGPermissionViewModel: NSObject, CLLocationManagerDelegate {

  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  private var permissionType: VGPermssionType
  private let permissionTypeSubject: BehaviorSubject<VGPermssionType>
  var permissionTypeEvent: Observable<VGPermssionType> { permissionTypeSubject }
  
  private var locationManager: VGLocationManager
  private let locationAuthorizationStatusSubject: BehaviorSubject<CLAuthorizationStatus>
  var locationAuthorizationStatusEvent: Observable<CLAuthorizationStatus> { locationAuthorizationStatusSubject }
  
  private let captureDevice: VGCaptureDevice
  private let cameraAuthorizationStatusSubject: BehaviorSubject<AVAuthorizationStatus>
  var cameraAuthorizationStatusEvent: Observable<AVAuthorizationStatus> { cameraAuthorizationStatusSubject }

  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - permissionType: VGPermissionType
  ///   - locationManager: CLLocationManager
  ///   - captureDevice: VGCaptureDevice
  init(permissionType: VGPermssionType, locationManager: VGLocationManager, captureDevice: VGCaptureDevice) {
    self.permissionType = permissionType
    self.locationManager = locationManager
    self.captureDevice = captureDevice
    locationAuthorizationStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: locationManager.authorizationStatus)
    cameraAuthorizationStatusSubject = BehaviorSubject<AVAuthorizationStatus>(value: captureDevice.authorizationStatus(for: .video))
    permissionTypeSubject = BehaviorSubject<VGPermssionType>(value: self.permissionType)
    super.init()
    self.locationManager.delegate = self
  }
  
  // MARK: class method
  
  /// Checks if already having the permission
  /// - Parameters:
  ///   - permissionType: VGPermissionType
  ///   - locationManager: VGLocationManager
  ///   - captureDevice: VGCaptureDevice
  /// - Returns: true or false
  class func authorized(permissionType: VGPermssionType, locationManager: VGLocationManager, captureDevice: VGCaptureDevice) -> Bool {
    switch permissionType {
    case .location:
      return locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways
    case .locationAndVideo:
      return (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways) && captureDevice.authorizationStatus(for: .video) == .authorized
    case .video:
      return captureDevice.authorizationStatus(for: .video) == .authorized
    case .notNeeded:
      return true
    }
  }
  
  /// Checks if the permission is determined
  /// - Parameters:
  ///   - permissionType: VGPermissionType
  ///   - locationManager: VGLocationManager
  ///   - captureDevice: VGCaptureDevice   
  /// - Returns: true or false
  class func determined(permissionType: VGPermssionType, locationManager: VGLocationManager, captureDevice: VGCaptureDevice) -> Bool {
    switch permissionType {
    case .location:
      return locationManager.authorizationStatus != .notDetermined
    case .locationAndVideo:
      return locationManager.authorizationStatus != .notDetermined && captureDevice.authorizationStatus(for: .video) != .notDetermined
    case .video:
      return captureDevice.authorizationStatus(for: .video) != .notDetermined
    case .notNeeded:
      return true
    }
  }
  
  // MARK: CLLocationManagerDelegate
  
  private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    handleLocationAuthorization()
  }
  
  internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    handleLocationAuthorization()
  }
  
  // MARK: public api
  
  /// Requests location permission
  func requestLocationAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  /// Requests camera permission
  func requestCameraAuthorization() {
    captureDevice.requestAccess(for: .video) { [weak self] _ in
      DispatchQueue.main.async { [weak self] in self?.handleCameraAuthorization() }
    }
  }
  
  /// Opens settings.app
  func openSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    if !UIApplication.shared.canOpenURL(settingsURL) {
      return
    }
    UIApplication.shared.open(settingsURL)
  }
  
  // MARK: private api
  
  /// Handles permission type
  private func handlePermissionType() {
    switch permissionType {
    case .location:
      if locationManager.authorizationStatus != .denied {
        permissionType = .notNeeded
      }
    case .locationAndVideo:
      if locationManager.authorizationStatus != .denied &&
          captureDevice.authorizationStatus(for: .video) != .denied {
        permissionType = .notNeeded
      }
    default:
      break
    }
    permissionTypeSubject.onNext(permissionType)
  }
  
  /// Handles location permission
  private func handleLocationAuthorization() {
    locationAuthorizationStatusSubject.onNext(locationManager.authorizationStatus)
    handlePermissionType()
  }
  
  /// Handles cameara permission
  private func handleCameraAuthorization() {
    switch permissionType {
    case .locationAndVideo, .video:
      cameraAuthorizationStatusSubject.onNext(captureDevice.authorizationStatus(for: .video))
    default:
      break
    }
    handlePermissionType()
  }
}
