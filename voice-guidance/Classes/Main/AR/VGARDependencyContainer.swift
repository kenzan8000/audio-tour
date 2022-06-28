import MapboxMaps
import UIKit

// MARK: - VGARDependencyContainer
class VGARDependencyContainer {
  
  // MARK: VGMapViewFactory
  
  /// Factory method to make mapView on mapViewController
  /// - Parameter
  ///   - view: parent view
  /// - Returns: mapView
  func makeMapView(on view: UIView) -> VGMapView {
    let mapView = VGMapView(frame: view.bounds)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.tintColor = .systemBlue
    mapView.mapboxMap.setCamera(to: .init(
      center: mapView.location.latestLocation?.coordinate ?? VGMap.defaultCoordinate,
      zoom: VGARMap.minimumZoomLevel
    ))
    mapView.gestures.options.doubleTapToZoomInEnabled = false
    mapView.gestures.options.doubleTouchToZoomOutEnabled = false
    mapView.gestures.options.panEnabled = false
    mapView.gestures.options.pinchEnabled = false
    mapView.gestures.options.pinchRotateEnabled = false
    mapView.gestures.options.pinchZoomEnabled = false
    mapView.gestures.options.pitchEnabled = false
    mapView.gestures.options.pinchPanEnabled = false
    mapView.gestures.options.quickZoomEnabled = false
    mapView.location.options.puckType = .puck2D()
    mapView.layer.cornerRadius = mapView.frame.width / 2
    mapView.layer.borderColor = UIColor.darkGray.cgColor
    mapView.layer.borderWidth = 4.0
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
