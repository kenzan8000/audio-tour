import MapboxMaps
import RxCocoa
import RxSwift

// MARK: - VGMapView
class VGMapView: MapView {
  
  // MARK: property
  
  var spotForAnnotation: VGSpot?
  weak var delegate: VGMapViewDelegate?
  
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
    
    setup()
  }
  
  // MARK: life cycle
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    mapboxMap.loadStyleURI(
      traitCollection.userInterfaceStyle == .dark ? .dark : .light,
      completion: nil
    )
  }
  
  // MARK: private api
  private func setup() {
    mapboxMap.onNext(.mapLoaded) { [weak self] _ in
      self?.location.addLocationConsumer(newConsumer: VGMapViewLocationConsumer(delegate: self))
    }
  }
}

// MARK: - VGMapViewDelegate
protocol VGMapViewDelegate: AnyObject {
  func mapView(_ mapView: VGMapView, didUpdate location: Location)
}
  
// MARK: - VGMapView + Delegates
extension VGMapView: VGMapViewLocationConsumerDelegate {
  // MARK: VGMapViewLocationConsumerDelegate
  func locationUpdate(newLocation: Location) {
    delegate?.mapView(self, didUpdate: newLocation)
  }
}
  
// MARK: - VGMapViewLocationConsumer
class VGMapViewLocationConsumer: LocationConsumer {
  
  // MARK: property
  weak var delegate: VGMapViewLocationConsumerDelegate?
  
  // MARK: initialization
  init(delegate: VGMapViewLocationConsumerDelegate?) {
    self.delegate = delegate
  }
  
  func locationUpdate(newLocation: Location) {
    delegate?.locationUpdate(newLocation: newLocation)
  }
}

// MARK: - VGMapViewLocationConsumerDelegate
protocol VGMapViewLocationConsumerDelegate: AnyObject {
  func locationUpdate(newLocation: Location)
}

// MARK: - VGMapViewDelegateProxy
class VGMapViewDelegateProxy: DelegateProxy<VGMapView, VGMapViewDelegate>, DelegateProxyType, VGMapViewDelegate {

  // MARK: property
  
  private weak var parentObject: VGMapView?
  let didUpdateLocationObserver = PublishSubject<Location>()
/*
  let didSelectAnnotationObserver = PublishSubject<VGMapAnnotation>()
  let spotIdForAnnotationObserver = PublishSubject<Int>()
*/
  
  // MARK: initialization
  
  init(parentObject: VGMapView) {
    super.init(parentObject: parentObject, delegateProxy: VGMapViewDelegateProxy.self)
    self.parentObject = parentObject
  }
    
  // MARK: destruction
    
  deinit {
    didUpdateLocationObserver.on(.completed)
/*
    didSelectAnnotationObserver.on(.completed)
    spotIdForAnnotationObserver.on(.completed)
*/
  }
 
  // MARK: public api
    
  static func registerKnownImplementations() {
    register { VGMapViewDelegateProxy(parentObject: $0) }
  }
    
  static func currentDelegate(for object: ParentObject) -> VGMapViewDelegate? {
    object.delegate
  }
    
  static func setCurrentDelegate(_ delegate: VGMapViewDelegate?, to object: ParentObject) {
    object.delegate = delegate
  }
  
  // MARK: VGMapViewDelegate
  
  func mapView(_ mapView: VGMapView, didUpdate location: Location) {
    didUpdateLocationObserver.on(.next(location))
  }
  
/*
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
*/
}

// MARK: - Reactive Extension
extension Reactive where Base: VGMapView {
  // MARK: property
  
  var delegateProxy: VGMapViewDelegateProxy {
    VGMapViewDelegateProxy.proxy(for: base)
  }
  
  var didUpdateLocation: ControlEvent<Location> {
    ControlEvent(events: delegateProxy.didUpdateLocationObserver)
  }
/*
  var didSelectAnnotation: ControlEvent<VGMapAnnotation> {
    ControlEvent(events: delegateProxy.didSelectAnnotationObserver)
  }
*/
/*
  var spotIdForAnnotation: ControlEvent<Int> {
    ControlEvent(events: delegateProxy.spotIdForAnnotationObserver)
  }
*/
}

// MARK: - VGMapViewFactory
typealias VGMapViewFactory = (_ view: UIView) -> VGMapView
