import UIKit

// MARK: - VGMapDependencyContainer
class VGMapDependencyContainer {
  
  // MARK: VGMapViewFactory
  
  /// Factory method to make mapView on mapViewController
  /// - Parameter
  ///   - view: parent view
  /// - Returns: mapView
  func makeMapView(on view: UIView) -> VGMapView {
    let mapView = VGMapView(
      frame: view.bounds // ,
      // styleURL: view.traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL(withVersion: 9) : MGLStyle.lightStyleURL(withVersion: 9)
    )
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.tintColor = .systemBlue
    /*
    mapView.setCenter(VGMap.defaultCoordinate, zoomLevel: VGMap.defaultZoomLevel, animated: false)
    mapView.maximumZoomLevel = VGMap.maximumZoomLevel
    mapView.showsUserLocation = true
    mapView.compassView.isHidden = true
    */
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
