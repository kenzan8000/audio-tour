import Foundation
import RxSwift

// MARK: - VGTutorialViewModel
class VGTutorialViewModel {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  private let userDefaults: VGUserDefaults
  private let locationManagerFactory: VGLocationManagerFactory
  private let captureDeviceFactory: VGCaptureDeviceFactory
  private(set) var tutorial: VGTutorial {
    didSet {
      if tutorial == .end {
        userDefaults.set(true, forKey: VGUserDefaultsKey.doneTutorial)
      }
      tutorialSubject.onNext(tutorial)
    }
  }
  private let tutorialSubject: BehaviorSubject<VGTutorial>
  var tutorialEvent: Observable<VGTutorial> { tutorialSubject.asObservable() }
  private var locationPermissionModel: VGPermissionViewModel?
  private var videoPermissionModel: VGPermissionViewModel?
  
  // MARK: initializer
  
  /// Inits view model
  /// - Parameters:
  ///   - userDefaults: VGUserDefaults
  ///   - locationManagerFactory: VGLocationManagerFactory
  ///   - captureDeviceFactory: VGCaptureDeviceFactory
  init(
    userDefaults: VGUserDefaults,
    locationManagerFactory: @escaping VGLocationManagerFactory,
    captureDeviceFactory: @escaping VGCaptureDeviceFactory
  ) {
    self.userDefaults = userDefaults
    self.locationManagerFactory = locationManagerFactory
    self.captureDeviceFactory = captureDeviceFactory
    tutorial = .intro
    tutorialSubject = BehaviorSubject<VGTutorial>(value: tutorial)
  }
  
  // MARK: pubilc api
  
  /// Moves to next VGTutorialView
  func nextView() {
    if !canGoToNextView() {
      return
    }
    tutorial.next()
  }
  
  // MARK: private api
  
  /// Calls when ending the current view and returns if you can go to next view
  /// - Returns: Bool
  private func canGoToNextView() -> Bool {
    switch tutorial {
    case .intro, .last, .end:
      break
    case .map:
      return canGoToMapView()
    case .ar:
      return canGoToArView()
    }
    return true
  }
  
  /// Calls when map view and returns if you can go to next view
  /// - Returns: Bool
  private func canGoToMapView() -> Bool {
    if VGPermissionViewModel.determined(permissionType: .location, locationManager: locationManagerFactory(), captureDevice: captureDeviceFactory()) {
      return true
    }
    locationPermissionModel = VGPermissionViewModel(permissionType: .location, locationManager: locationManagerFactory(), captureDevice: captureDeviceFactory())
    locationPermissionModel?.locationAuthorizationStatusEvent.subscribe { [weak self] event in
      if let status = event.element, status != .notDetermined {
        DispatchQueue.main.async { [weak self] in self?.nextView() }
      }
    }
    .disposed(by: disposeBag)
    locationPermissionModel?.requestLocationAuthorization()
    return false
  }
  
  /// Calls when ar view and returns if you can go to next view
  /// - Returns: Bool
  private func canGoToArView() -> Bool {
    if VGPermissionViewModel.determined(permissionType: .video, locationManager: locationManagerFactory(), captureDevice: captureDeviceFactory()) {
      return true
    }
    videoPermissionModel = VGPermissionViewModel(permissionType: .locationAndVideo, locationManager: locationManagerFactory(), captureDevice: captureDeviceFactory())
    videoPermissionModel?.cameraAuthorizationStatusEvent.subscribe { [weak self] event in
      if let status = event.element, status != .notDetermined {
        DispatchQueue.main.async { [weak self] in self?.nextView() }
      }
    }
    .disposed(by: disposeBag)
    videoPermissionModel?.requestCameraAuthorization()
    return false
  }
}
