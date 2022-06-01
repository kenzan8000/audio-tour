// import Mapbox
import UIKit

// MARK: - VGARDependencyContainer
class VGARDependencyContainer {
  
  // MARK: VGMapViewFactory
  
  /// Factory method to make mapView on mapViewController
  /// - Parameter
  ///   - view: parent view
  ///   - delegate: delegate
  /// - Returns: mapView
  func makeMapView(on view: UIView) -> VGMapView {
    let mapView = VGMapView(
      frame: view.bounds,
      styleURI: view.traitCollection.userInterfaceStyle == .dark ? .dark : .light
    )
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.tintColor = .systemBlue
    /*
    mapView.minimumZoomLevel = VGARMap.minimumZoomLevel
    mapView.maximumZoomLevel = VGARMap.maximumZoomLevel
    mapView.isZoomEnabled = false
    mapView.isScrollEnabled = false
    mapView.isRotateEnabled = false
    mapView.isPitchEnabled = false
    mapView.showsUserLocation = true
    */
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
