import CoreLocation
@testable import voice_guidance

// MARK: - VGLocationManagerDummy
struct VGLocationManagerDummy: VGLocationManager {
  var delegate: CLLocationManagerDelegate?
  var authorizationStatus: CLAuthorizationStatus
  func requestWhenInUseAuthorization() { }
  func startUpdatingLocation() { }
  func startUpdatingHeading() { }
  func stopUpdatingLocation() { }
  func stopUpdatingHeading() { }
}
