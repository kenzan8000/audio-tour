import MapboxMaps
// import RxCocoa
// import RxSwift

// MARK: - VGMapView
class VGMapView: MapView {
  
  // MARK: property
  
  var spotForAnnotation: VGSpot?
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(frame: CGRect) {
    if let path = Bundle.main.path(forResource: "Mapbox-Info", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: path),
       let accessToken = plist["MGLMapboxAccessToken"] {
      ResourceOptionsManager.default.resourceOptions.accessToken = "\(accessToken)"
    }
    
    super.init(
      frame: frame,
      mapInitOptions: .init(
        styleURI: UIApplication.shared.windows.first?.traitCollection.userInterfaceStyle == .dark ? .dark : .light
      )
    )
  }
  
  // MARK: life cycle
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    mapboxMap.loadStyleURI(
      traitCollection.userInterfaceStyle == .dark ? .dark : .light,
      completion: nil
    )
  }
  
}
/*
// MARK: - VGMapViewDelegateProxy
class VGMapViewDelegateProxy: DelegateProxy<VGMapView, AnnotationInteractionDelegate>, DelegateProxyType, AnnotationInteractionDelegate {

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
    
  // MARK: - AnnotationInteractionDelegate
  
  func annotationManager(
    _ manager: AnnotationManager,
    didDetectTappedAnnotations annotations: [Annotation]
  ) {
    
  }
  
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
*/

// MARK: - VGMapViewFactory
typealias VGMapViewFactory = (_ view: UIView) -> VGMapView
