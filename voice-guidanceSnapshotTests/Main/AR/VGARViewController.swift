import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGARViewControllerTests
class VGARViewControllerTests: XCTestCase {

  // MARK: property
  
  var sut: VGARViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGARViewControllerTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let arDependencyContainer = VGARDependencyContainer()
    sut = VGARViewController(
      viewModel: VGARViewModel(
        storageProvider: storageProvider,
        locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse)
      ),
      userDefaults: VGMockUserDefaults(),
      locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      mapViewFactory: { view in arDependencyContainer.makeMapView(on: view) },
      searchViewFactory: { view in arDependencyContainer.makeSearchView(on: view) }
    )
    sut.loadViewIfNeeded()
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGARViewController_whenInitialState_snapshotTest() throws {
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
