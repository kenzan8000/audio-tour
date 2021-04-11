import Mapbox
import RxCocoa
import RxSwift

// MARK: - VGMapView
class VGMapView: MGLMapView {
  
  // MARK: property
  
  var spotForAnnotation: VGSpot?
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect, styleURL: URL?) {
    if let path = Bundle.main.path(forResource: "Mapbox-Info", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: path),
       let accessToken = plist["MGLMapboxAccessToken"] {
      MGLAccountManager.accessToken = "\(accessToken)"
    }
    super.init(frame: frame, styleURL: styleURL)
  }
  
  // MARK: destruction
  
  deinit {
  }
  
  // MARK: life cycle
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    styleURL = traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL(withVersion: 9) : MGLStyle.lightStyleURL(withVersion: 9)
  }
  
  // MARK: public api
  
  /// Updates spots on map
  /// - Parameter spots: array of VGSpot
  func resetSpots(_ spots: [VGSpot]) {
    if let annotations = annotations {
      removeAnnotations(annotations)
    }
    var newAnnotations: [VGMapAnnotation] = []
    for spot in spots {
      newAnnotations.append(VGMapAnnotation(id: spot.id, coordinate: spot.coordinate))
    }
    addAnnotations(newAnnotations)
  }
  
  /// Deselects selected annotations
  func delesectSelectedAnnotations() {
    for annotation in selectedAnnotations {
      deselectAnnotation(annotation, animated: false)
    }
  }
}

// MARK: - VGMapViewDelegateProxy
class VGMapViewDelegateProxy: DelegateProxy<VGMapView, MGLMapViewDelegate>, DelegateProxyType, MGLMapViewDelegate {

  // MARK: - property
  
  private weak var parentObject: VGMapView?
  let didSelectAnnotationObserver = PublishSubject<VGMapAnnotation>()
  let didUpdateLocationObserver = PublishSubject<MGLUserLocation>()
  let didFailToLocateUserObserver = PublishSubject<Error>()
  let spotIdForAnnotationObserver = PublishSubject<Int>()
    
  // MARK: - initialization
  
  init(parentObject: VGMapView) {
    super.init(parentObject: parentObject, delegateProxy: VGMapViewDelegateProxy.self)
    self.parentObject = parentObject
  }
    
  // MARK: - destruction
    
  deinit {
    didSelectAnnotationObserver.on(.completed)
    didUpdateLocationObserver.on(.completed)
    didFailToLocateUserObserver.on(.completed)
    spotIdForAnnotationObserver.on(.completed)
  }
 
  // MARK: - public api
    
  static func registerKnownImplementations() {
    register { VGMapViewDelegateProxy(parentObject: $0) }
  }
    
  static func currentDelegate(for object: ParentObject) -> MGLMapViewDelegate? {
    object.delegate
  }
    
  static func setCurrentDelegate(_ delegate: MGLMapViewDelegate?, to object: ParentObject) {
    object.delegate = delegate
  }
    
  // MARK: - MGLMapViewDelegate
  
  func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
    guard let annotation = annotation as? VGMapAnnotation,
          let mapView = mapView as? VGMapView else {
      return nil
    }
    spotIdForAnnotationObserver.on(.next(annotation.id))
    guard let image = mapView.spotForAnnotation?.image,
          let imageName = mapView.spotForAnnotation?.imageId else {
      return nil
    }
    mapView.spotForAnnotation = nil
    return MGLAnnotationImage(image: image, reuseIdentifier: "\(imageName)")
  }
  
  func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    false
  }

  func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
    guard let annotation = annotation as? VGMapAnnotation else {
      return
    }
    didSelectAnnotationObserver.on(.next(annotation))
  }
  
  func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
    guard let userLocation = userLocation else {
      return
    }
    didUpdateLocationObserver.on(.next(userLocation))
  }
  
  func mapView(_ mapView: MGLMapView, didFailToLocateUserWithError error: Error) {
    didFailToLocateUserObserver.on(.next(error))
  }
  
}

// MARK: - Reactive Extension
extension Reactive where Base: VGMapView {
  // MARK: property
  
  var delegateProxy: VGMapViewDelegateProxy {
    VGMapViewDelegateProxy.proxy(for: base)
  }
  
  var didSelectAnnotation: ControlEvent<VGMapAnnotation> {
    ControlEvent(events: delegateProxy.didSelectAnnotationObserver)
  }
  
  var didUpdateLocation: ControlEvent<MGLUserLocation> {
    ControlEvent(events: delegateProxy.didUpdateLocationObserver)
  }
  
  var didFailToLocateUser: ControlEvent<Error> {
    ControlEvent(events: delegateProxy.didFailToLocateUserObserver)
  }
  
  var spotIdForAnnotation: ControlEvent<Int> {
    ControlEvent(events: delegateProxy.spotIdForAnnotationObserver)
  }
}

// MARK: - VGMapViewFactory
typealias VGMapViewFactory = (_ view: UIView) -> VGMapView
