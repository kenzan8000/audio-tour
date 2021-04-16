import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGMainViewControllerTests
class VGMainViewControllerTests: XCTestCase {

  // MARK: property
  
  var sut: VGMainViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let mapDependencyContainer = VGMapDependencyContainer()
    let arDependencyContainer = VGARDependencyContainer()
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGMainViewControllerTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let userDefaults = VGMockUserDefaults()
    let locationManagerFactory = { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) }
    sut = VGMainViewController(viewControllers: [
      VGMapViewController(
        viewModel: VGMapViewModel(storageProvider: storageProvider),
        userDefaults: userDefaults,
        mapViewFactory: { view in mapDependencyContainer.makeMapView(on: view) },
        searchViewFactory: { view in mapDependencyContainer.makeSearchView(on: view) }
      ),
      VGARViewController(
        viewModel: VGARViewModel(storageProvider: storageProvider, locationManager: locationManagerFactory()),
        userDefaults: userDefaults,
        locationManagerFactory: locationManagerFactory,
        mapViewFactory: { view in arDependencyContainer.makeMapView(on: view) },
        searchViewFactory: { view in arDependencyContainer.makeSearchView(on: view) }
      )
    ])
    sut.loadViewIfNeeded()
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test

  func testVGMainViewController_whenInitialState_snapshotTest() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhoneX, precision: 0.98, traits: .iPhoneX(.portrait)),
        named: named
      )
    }
  }
  
}
