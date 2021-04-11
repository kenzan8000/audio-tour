import CoreLocation
@testable import voice_guidance

// MARK: - VGMockLocationManager
struct VGMockLocationManager: VGLocationManager {
  var delegate: CLLocationManagerDelegate?
  var authorizationStatus: CLAuthorizationStatus
  func requestWhenInUseAuthorization() { }
  func startUpdatingLocation() { }
  func startUpdatingHeading() { }
  func stopUpdatingLocation() { }
  func stopUpdatingHeading() { }
}
