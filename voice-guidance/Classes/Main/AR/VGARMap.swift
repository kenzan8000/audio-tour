import CoreLocation

// MARK: - VGARMap
enum VGARMap {
  /// default map coordinate
  static let defaultCoordinate = CLLocationCoordinate2DMake(37.7749, -122.4194)
  /// zoom level
  static let defaultZoomLevel = 12.9
  static let minimumZoomLevel = 13.0
  static let maximumZoomLevel = 15.0
  static let spotDistance = 1000.0
  static let currentLocationZoomLevel = 15.0
  // distance threshold
  static let updateSpotAnnotationDistance = 15.0
}
