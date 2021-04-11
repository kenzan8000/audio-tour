import CoreLocation

// MARK: - VGLocationManager
protocol VGLocationManager {
  var delegate: CLLocationManagerDelegate? { get set }
  var authorizationStatus: CLAuthorizationStatus { get }
  func requestWhenInUseAuthorization()
  func startUpdatingLocation()
  func startUpdatingHeading()
  func stopUpdatingLocation()
  func stopUpdatingHeading()
}

// MARK: - VGLocationManagerFactory
typealias VGLocationManagerFactory = () -> VGLocationManager

// MARK: - CLLocationManager + VGLocationManager
extension CLLocationManager: VGLocationManager {
}
