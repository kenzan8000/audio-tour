import Mapbox
import MapKit
import RxSwift
import SideMenu
import UIKit

// MARK: - VGARViewController
class VGARViewController: VGTabViewController {
  
  // MARK: enum
  
  enum LeftMenu: Int {
    case tutorial = 0
    case arTutorial = 1
  }

  // MARK: VGTabViewControllerProtocol
  
  override var tabBarImage: UIImage? { UIImage(systemName: "camera.fill") }
  override var tabBarTitle: String? { NSLocalizedString("ar", comment: "") }
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  private let viewModel: VGARViewModel
  private let userDefaults: VGUserDefaults
  private let locationManagerFactory: VGLocationManagerFactory
  private let mapViewFactory: VGMapViewFactory
  private let searchViewFactory: VGSearchViewFactory
  let sceneLocationView = VGARSceneLocationView()
  @IBOutlet private(set) weak var mapBackgroundView: UIView!
  private lazy var mapView: VGMapView = mapViewFactory(mapBackgroundView)
  private lazy var searchView: VGSearchView = searchViewFactory(view)
  private lazy var zoomOutButton: VGMapZoomButton = { VGMapZoomButton(zoomType: .zoomOut) }()
  private lazy var zoomInButton: VGMapZoomButton = { VGMapZoomButton(zoomType: .zoomIn) }()
  var guideViewController: VGGuideViewController? {
    willSet {
      if let oldGuideViewController = guideViewController {
        removePullUpController(oldGuideViewController, animated: false)
      }
    }
    didSet {
      guideViewController?.rx.alertWillAppear
        .subscribe { [weak self] alert in self?.present(alert, animated: true, completion: nil) }
        .disposed(by: disposeBag)
      guideViewController?.presentGuideViewController(on: self, animated: true)
      mapView.delesectSelectedAnnotations()
      searchView.endSearch()
    }
  }
  var permissionView: VGPermissionView?
  var permissionViewWillDisappearDisposable: Disposable?
  var tutorialView: VGARTutorialView?
  var tutorialViewWillDisappearDisposable: Disposable?
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits view controller
  /// - Parameter
  ///   - viewModel: viewModel
  ///   - userDefaults: VGUserDefaults
  ///   - locationManager: VGLocationManager
  ///   - mapViewFactory: mapViewFactory
  ///   - searchViewFactory: VGSearchViewFactory   
  init(
    viewModel: VGARViewModel,
    userDefaults: VGUserDefaults,
    locationManagerFactory: @escaping VGLocationManagerFactory,
    mapViewFactory: @escaping VGMapViewFactory,
    searchViewFactory: @escaping VGSearchViewFactory
  ) {
    self.viewModel = viewModel
    self.userDefaults = userDefaults
    self.locationManagerFactory = locationManagerFactory
    self.mapViewFactory = mapViewFactory
    self.searchViewFactory = searchViewFactory
    super.init(nibName: nil, bundle: nil)
  }
  
   // MARK: destruction
  
  deinit {
    cleanUpPermissionView()
    cleanUpTutorialView()
  }

  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame = UIScreen.main.bounds
    designView()
    bindViewModel()
    bindView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame = UIScreen.main.bounds
    sceneLocationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.bottom)
    mapBackgroundView.center = CGPoint(x: view.center.x, y: view.frame.height - view.safeAreaInsets.bottom)
    zoomOutButton.center = CGPoint(
      x: view.frame.width - zoomOutButton.frame.width / 2 - 10,
      y: view.frame.height - zoomOutButton.frame.height / 2 - 10 - view.safeAreaInsets.bottom
    )
    zoomInButton.center = CGPoint(
      x: zoomOutButton.center.x,
      y: zoomOutButton.center.y - zoomOutButton.frame.height / 2 - zoomInButton.frame.height / 2 - 10
    )
    searchView.frame = CGRect(
      x: 0, y: view.safeAreaInsets.top,
      width: view.frame.width, height: searchView.frame.height
    )
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.resume()
    sceneLocationView.run()
    
    cleanUpPermissionView()
    if !VGPermissionViewModel.authorized(permissionType: .locationAndVideo, locationManager: locationManagerFactory(), captureDevice: VGAVCaptureDevice()) {
      permissionView = VGPermissionView(
        viewModel: VGPermissionViewModel(permissionType: .locationAndVideo, locationManager: locationManagerFactory(), captureDevice: VGAVCaptureDevice())
      )
      if let permissionView = permissionView {
        permissionView.frame = view.frame
        view.addSubview(permissionView)
        permissionViewWillDisappearDisposable = permissionView.rx.willDisappear
          .subscribe { [weak self] _ in self?.cleanUpPermissionView() }
      }
      return
    }
    
    if !userDefaults.bool(forKey: VGUserDefaultsKey.doneARTutorial) {
      showTutorialView()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.pause()
    sceneLocationView.pause()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    zoomInButton.changeTraitCollection()
    zoomOutButton.changeTraitCollection()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else {
      return
    }
    if guideViewController?.view.frame.contains(touch.location(in: view)) ?? false {
      return
    }
    if let index = sceneLocationView.getTouchedLocationNodeIndex(touch: touch) ?? nil {
    let spot = viewModel.spots[index]
      presentGuideViewController(spot: spot)
    }
  }
  
  // MARK: private api

  /// Binds view model
  private func bindViewModel() {
    bindZoom()
    bindLocation()
    bindSpots()
    viewModel.searchResultWasUpdatedEvent
      .bind(to: searchView.rx.items) { _, _, spot in
        VGSearchTableViewCell(image: spot.image ?? UIImage(), title: spot.name)
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds zoom settings in view model
  private func bindZoom() {
    viewModel.zoomLevelEvent
      .subscribe { [weak self] event in
        if let self = self, let zoomLevel = event.element {
          self.mapView.setZoomLevel(zoomLevel, animated: false)
        }
      }
      .disposed(by: disposeBag)
    viewModel.zoomStateEvent
      .subscribe { [weak self] event in
        guard let self = self, let zoomState = event.element else {
          return
        }
        self.zoomInButton.alpha = zoomState == .max ? 0.5 : 1.0
        self.zoomOutButton.alpha = zoomState == .min ? 0.5 : 1.0
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds location settings in view model
  private func bindLocation() {
    viewModel.latestHeadingEvent
      .subscribe { [weak self] event in
        guard let self = self, let heading = event.element else {
          return
        }
        self.mapView.setDirection(heading, animated: false)
      }
      .disposed(by: disposeBag)
    viewModel.latestLocationEvent
      .subscribe { [weak self] event in
        guard let self = self, let location = event.element else {
          return
        }
        self.mapView.setCenter(location.coordinate, animated: false)
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds spots settings in view model
  private func bindSpots() {
    viewModel.spotsWereUpdatedEvent
      .subscribe { [weak self] event in
        guard let self = self, let spots = event.element else {
          return
        }
        self.mapView.resetSpots(spots)
        self.sceneLocationView.resetLocationNodes(self.viewModel.spotNodes)
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds view
  private func bindView() {
    bindZoomButtons()
    bindSearchView()
    bindMapView()
  }
  
  /// Binds zoom buttons
  private func bindZoomButtons() {
    zoomOutButton.rx.tap
      .subscribe { [weak self] _ in self?.viewModel.zoomOut(value: 0.5) }
      .disposed(by: disposeBag)
    zoomInButton.rx.tap
      .subscribe { [weak self] _ in self?.viewModel.zoomIn(value: 0.5) }
      .disposed(by: disposeBag)
  }
  
  /// Binds search view
  private func bindSearchView() {
    searchView.rx.tapMenu
      .subscribe { [weak self] _ in
        let vc = VGSideMenuViewController(viewModel: VGSideMenuViewModel(sideMenus: [VGSideMenu(title: NSLocalizedString("ar_sidemenu_0", comment: "")), VGSideMenu(title: NSLocalizedString("ar_sidemenu_1", comment: ""))]))
        let menu = VGSideMenuNavigationController(rootViewController: vc)
        self?.present(menu, animated: true, completion: nil)
        vc.rx.itemSelected
          .subscribe { [weak self] event in
            menu.dismiss(animated: true, completion: nil)
            guard let self = self,
                  let index = event.element?.row,
                  let tap = LeftMenu(rawValue: index) else {
              return
            }
            switch tap {
            case .tutorial:
              NotificationCenter.default.post(Notification(name: .startTutorial))
            case .arTutorial:
              self.showTutorialView()
            }
          }
          .disposed(by: vc.disposeBag)
      }
      .disposed(by: disposeBag)
    searchView.rx.tapItem
      .subscribe { [weak self] event in
        guard let self = self, let indexPath = event.element else {
          return
        }
        self.presentGuideViewController(spot: self.viewModel.searchResult[indexPath.row])
      }
      .disposed(by: disposeBag)
    searchView.rx.text
      .subscribe { [weak self] event in
        guard let self = self, let text = event.element else {
          return
        }
        self.viewModel.search(text: text)
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds map view
  private func bindMapView() {
    mapView.rx.spotIdForAnnotation
      .subscribe { [weak self] event in
        self?.mapView.spotForAnnotation = self?.viewModel.spots.first { $0.id == event.element }
      }
      .disposed(by: disposeBag)
    mapView.rx.didSelectAnnotation
      .subscribe { [weak self] event in
        if let annotation = event.element,
          let spot = self?.viewModel.spots.first(where: { $0.id == annotation.id }) {
          self?.presentGuideViewController(spot: spot)
        }
      }
      .disposed(by: disposeBag)
  }
  
  /// Designs view
  private func designView() {
    view.addSubview(sceneLocationView)
    sceneLocationView.frame = view.bounds
    mapBackgroundView.addSubview(mapView)
    mapBackgroundView.center = CGPoint(x: view.center.x, y: view.frame.height)
    view.bringSubviewToFront(mapBackgroundView)
    view.addSubview(zoomOutButton)
    view.bringSubviewToFront(zoomOutButton)
    view.addSubview(zoomInButton)
    view.bringSubviewToFront(zoomInButton)
    view.addSubview(searchView)
  }
  
  /// Calls when deiniting permission view
  private func cleanUpPermissionView() {
    permissionView?.removeFromSuperview()
    permissionViewWillDisappearDisposable?.dispose()
    permissionView = nil
    permissionViewWillDisappearDisposable = nil
  }
  
  /// Calls when deiniting tutorial view
  private func cleanUpTutorialView() {
    tutorialView?.removeFromSuperview()
    tutorialViewWillDisappearDisposable?.dispose()
    tutorialView = nil
    tutorialViewWillDisappearDisposable = nil
    userDefaults.set(true, forKey: VGUserDefaultsKey.doneARTutorial)
    _ = userDefaults.synchronize()
  }
  
  /// Shows tutorial view
  private func showTutorialView() {
    cleanUpTutorialView()
    tutorialView = VGARTutorialView(
      parentViewController: self,
      mapView: mapBackgroundView
    )
    if let tutorialView = tutorialView {
      view.addSubview(tutorialView)
      tutorialViewWillDisappearDisposable = tutorialView.rx.active
        .subscribe { [weak self] event in
          let active = event.element ?? true
          if !active {
            self?.cleanUpTutorialView()
          }
        }
    }
  }
  
  /// Presents guide view controller
  /// - Parameter spot: spot to guide
  private func presentGuideViewController(spot: VGSpot) {
    guideViewController = VGGuideViewController(
      viewModel: VGGuideViewModel(spot: spot, rate: .current(userDeafults: userDefaults), userDefaults: userDefaults),
      pullUpModel: VGGuidePullUpModel(bottomSafeAreaInset: 0, peekY: UIScreen.main.bounds.height)
    )
  }
}
