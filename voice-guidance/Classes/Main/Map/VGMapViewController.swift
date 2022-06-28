import MapboxMaps
import RxSwift
import SideMenu
import UIKit

// MARK: - VGMapViewController
class VGMapViewController: VGTabViewController {
  
  // MARK: VGTabViewControllerProtocol
  
  override var tabBarImage: UIImage? { UIImage(systemName: "map.fill") }
  override var tabBarTitle: String? { NSLocalizedString("map", comment: "") }
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  private let viewModel: VGMapViewModel
  private let userDefaults: VGUserDefaults
  private let mapViewFactory: VGMapViewFactory
  private let searchViewFactory: VGSearchViewFactory
  private lazy var mapView: VGMapView = mapViewFactory(view)
  private lazy var searchView: VGSearchView = searchViewFactory(view)
  private lazy var currentLocationButton: VGCircleButton = { VGCircleButton(image: UIImage(systemName: "location.fill")) }()
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
      // mapView.selectedAnnotations.forEach { [weak self] in self?.mapView.deselectAnnotation($0, animated: false) }
      searchView.endSearch()
    }
  }
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits view controller
  /// - Parameter
  ///   - viewModel: VGMapViewModel
  ///   - userDefaults: VGUserDefaults
  ///   - mapViewFactory: VGMapViewFactory
  ///   - searchViewFactory: VGSearchViewFactory
  init(
    viewModel: VGMapViewModel,
    userDefaults: VGUserDefaults,
    mapViewFactory: @escaping VGMapViewFactory,
    searchViewFactory: @escaping VGSearchViewFactory
  ) {
    self.viewModel = viewModel
    self.userDefaults = userDefaults
    self.mapViewFactory = mapViewFactory
    self.searchViewFactory = searchViewFactory
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    designView()
    bindView()
    bindViewModel()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame = UIScreen.main.bounds
    mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.bottom)
    currentLocationButton.center = CGPoint(
      x: view.frame.width - currentLocationButton.frame.width / 2 - 10,
      y: view.frame.height - currentLocationButton.frame.height / 2 - 10 - view.safeAreaInsets.bottom
    )
    searchView.frame = CGRect(
      x: 0, y: view.safeAreaInsets.top,
      width: view.frame.width, height: searchView.frame.height
    )
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
  }

  // MARK: private api
  
  /// Designs view
  private func designView() {
    view.addSubview(mapView)
    view.addSubview(currentLocationButton)
    view.addSubview(searchView)
  }
  
  /// Binds view
  private func bindView() {
    bindSearchView()
    bindMapView()
    currentLocationButton.rx.tap
      .subscribe { [weak self] _ in
        guard let self = self, let location = self.mapView.location.latestLocation else {
          return
        }
        self.mapView.mapboxMap.setCamera(to: .init(center: location.coordinate))
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds search view
  private func bindSearchView() {
    searchView.rx.tapMenu
      .subscribe { [weak self] _ in
        let vc = VGSideMenuViewController(viewModel: .map)
        let menu = VGSideMenuNavigationController(rootViewController: vc)
        self?.present(menu, animated: true, completion: nil)
        vc.rx.itemSelected
          .subscribe { _ in
            menu.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(Notification(name: .startTutorial))
          }
          .disposed(by: vc.disposeBag)
      }
      .disposed(by: disposeBag)
    searchView.rx.tapItem
      .subscribe { [weak self] event in
        guard let self = self, let indexPath = event.element else {
          return
        }
        self.mapView.mapboxMap.setCamera(to: .init(center: self.viewModel.searchResult[indexPath.row].coordinate))
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
    mapView.rx.didSelectAnnotation
      .subscribe { [weak self] event in
        if let annotation = event.element,
          let spot = self?.viewModel.spots.first(where: { "\($0.id)" == annotation.id }) {
          self?.presentGuideViewController(spot: spot)
        }
      }
      .disposed(by: disposeBag)
    mapView.rx.didUpdateLocation
      .subscribe { [weak self] _ in self?.currentLocationButton.isHidden = false }
      .disposed(by: disposeBag)
/*
    mapView.rx.didFailToLocateUser
      .subscribe { [weak self] _ in self?.currentLocationButton.isHidden = true }
      .disposed(by: disposeBag)
*/
  }

  /// Binds view model
  private func bindViewModel() {
    viewModel.spotsWereUpdatedEvent
      .subscribe { [weak self] event in
        guard let self = self, let spots = event.element else {
          return
        }
        self.mapView.removeAll()
        self.mapView.add(
          annotations: spots.map { .annotation(spot: $0) }
        )
      }
      .disposed(by: disposeBag)
    viewModel.searchResultWasUpdatedEvent
      .bind(to: searchView.rx.items) { _, _, spot in
        VGSearchTableViewCell(viewModel: .init(image: spot.image, title: spot.name))
      }
      .disposed(by: disposeBag)
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
