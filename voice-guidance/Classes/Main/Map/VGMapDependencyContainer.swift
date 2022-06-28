import MapboxMaps
import UIKit

// MARK: - VGMapDependencyContainer
class VGMapDependencyContainer {
  
  // MARK: VGMapViewFactory
  
  /// Factory method to make mapView on mapViewController
  /// - Parameter
  ///   - view: parent view
  /// - Returns: mapView
  func makeMapView(on view: UIView) -> VGMapView {
    let mapView = VGMapView(frame: view.bounds)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.mapboxMap.setCamera(to: .init(center: VGMap.defaultCoordinate, zoom: VGMap.defaultZoomLevel))
    mapView.location.options.puckType = .puck2D()
    mapView.ornaments.options.compass.visibility = .hidden
    mapView.ornaments.options.scaleBar.visibility = .hidden
    mapView.tintColor = .systemBlue
    return mapView
  }
  
  // MARK: VGSearchViewFactory
  
  /// Factory method to make searvh view
  /// - Parameter
  ///   - view: parent view
  /// - Returns: VGSearchView
  func makeSearchView(on view: UIView) -> VGSearchView {
    VGSearchView(on: view)
  }
}
