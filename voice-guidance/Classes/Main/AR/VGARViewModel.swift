import ARKit_CoreLocation
import CoreLocation
import RxSwift
import SceneKit

// MARK: - VGARViewModel
class VGARViewModel: NSObject, CLLocationManagerDelegate {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  private let storageProvider: VGStorageProvider
  private var locationManager: VGLocationManager
  
  private var latestLocation: CLLocation? {
    didSet {
      if let location = latestLocation {
        latestLocationSubject.onNext(location)
      }
    }
  }
  private var latestLocationSubject: BehaviorSubject<CLLocation>
  var latestLocationEvent: Observable<CLLocation> { latestLocationSubject }
  
  private var heading = VGMapHeading()
  private var latestHeadingSubject: BehaviorSubject<CLLocationDirection>
  var latestHeadingEvent: Observable<CLLocationDirection> { latestHeadingSubject }
  
  private var zoom = VGMapZoom(
    level: VGARMap.minimumZoomLevel,
    maxLevel: VGARMap.maximumZoomLevel,
    minLevel: VGARMap.minimumZoomLevel
  )
  private var zoomLevelSubject: BehaviorSubject<Double>
  var zoomLevelEvent: Observable<Double> { zoomLevelSubject }
  private var zoomStateSubject: BehaviorSubject<VGMapZoom.State>
  var zoomStateEvent: Observable<VGMapZoom.State> { zoomStateSubject }
  
  var spots: [VGSpot] = [] {
    didSet {
      spotNodes = []
      for spot in spots {
        if let arImage = spot.arImage {
          let locationNode = VGARLocationAnnotationNode(
            location: CLLocation(coordinate: spot.coordinate, altitude: spot.altitude),
            annotationImage: arImage,
            text: spot.name,
            textColor: spot.arColor
          )
          spotNodes.append(locationNode)
        }
      }
      spotsWereUpdatedSubject.onNext(spots)
    }
  }
  var spotNodes: [LocationNode] = []
  private var spotsWereUpdatedSubject: BehaviorSubject<[VGSpot]>
  var spotsWereUpdatedEvent: Observable<[VGSpot]> { spotsWereUpdatedSubject }
  
  var searchResult: [VGSpot] = [] {
    didSet {
      searchResultWasUpdatedSubject.onNext(searchResult)
    }
  }
  private var searchResultWasUpdatedSubject: BehaviorSubject<[VGSpot]>
  var searchResultWasUpdatedEvent: Observable<[VGSpot]> { searchResultWasUpdatedSubject }
  
  // MARK: initializer
  
  /// Inits view model
  init(storageProvider: VGStorageProvider, locationManager: VGLocationManager) {
    self.storageProvider = storageProvider
    self.locationManager = locationManager
    latestLocationSubject = BehaviorSubject(value: CLLocation(coordinate: VGARMap.defaultCoordinate, altitude: 0))
    latestHeadingSubject = BehaviorSubject(value: heading.calculatedHeading)
    zoom.state = .min
    zoomLevelSubject = BehaviorSubject(value: zoom.level)
    zoomStateSubject = BehaviorSubject(value: zoom.state)
    spotsWereUpdatedSubject = BehaviorSubject(value: spots)
    searchResultWasUpdatedSubject = BehaviorSubject(value: searchResult)
  }
  
  // MARK: CLLocationManagerDelegate
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateHeading newHeading: CLHeading
  ) {
    heading.append(heading: newHeading.trueHeading)
    let headingInRadian = Float(heading.calculatedHeading).degreesToRadians
    for spotNode in spotNodes {
      spotNode.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: -headingInRadian)
    }
    latestHeadingSubject.onNext(heading.calculatedHeading)
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = manager.location else {
      return
    }
    updateLocation(location)
  }
  
  // MARK: public api
  
  /// Resumes process
  func resume() {
    locationManager.delegate = self
    latestLocation = nil
    heading.reset()
    spots = []
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  /// Pauses process
  func pause() {
    latestLocation = nil
    heading.reset()
    spots = []
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
  }
  
  /// Zooms in
  /// - Parameter value: zoom in valuel
  func zoomIn(value: Double) {
    zoom.level += value
    zoomLevelSubject.onNext(zoom.level)
    zoomStateSubject.onNext(zoom.state)
  }
  
  /// Zooms out
  /// - Parameter value: zoom out value
  func zoomOut(value: Double) {
    zoom.level -= value
    zoomLevelSubject.onNext(zoom.level)
    zoomStateSubject.onNext(zoom.state)
  }
  
  /// Searches spots by text
  /// - Parameter text: search text
  func search(text: String) {
    if text.isEmpty {
      searchResult = spots
    } else {
      searchResult = spots.filter { $0.name.contains(text) }
    }
  }
  
  /// Updates location
  /// - Parameter location: CLLocation
  func updateLocation(_ location: CLLocation) {
    var shouldUpdate = false
    let previousLocation = latestLocation
    latestLocation = location
    if let previousLocation = previousLocation, let latestLocation = latestLocation {
      shouldUpdate = latestLocation.distance(from: previousLocation) > VGARMap.updateSpotAnnotationDistance
    } else {
      shouldUpdate = true
    }
    if shouldUpdate {
      updateSpots()
    }
  }
  
  // MARK: private api
  
  /// Updates spots
  private func updateSpots() {
    guard let location = latestLocation else {
      return
    }
    let sw = location.coordinate.coordinateWithBearing(bearing: 225.0, distanceMeters: VGARMap.spotDistance)
    let ne = location.coordinate.coordinateWithBearing(bearing: 45.0, distanceMeters: VGARMap.spotDistance)
    var spots = storageProvider.fetch(language: .current, sw: sw, ne: ne)
    if let latestLocation = latestLocation {
      spots.sort { a, b in
        latestLocation.distance(from: a.location) > latestLocation.distance(from: b.location)
      }
    }
    self.spots = spots
  }
}
