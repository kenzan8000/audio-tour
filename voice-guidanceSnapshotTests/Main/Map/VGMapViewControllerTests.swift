import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGMapViewControllerTests
class VGMapViewControllerTests: XCTestCase {

  // MARK: property
  
  var sut: VGMapViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let mapDependencyContainer = VGMapDependencyContainer()
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGMapViewControllerTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceVGStorageProviderTests")
    sut = VGMapViewController(
      viewModel: VGMapViewModel(storageProvider: storageProvider),
      userDefaults: VGMockUserDefaults(),
      mapViewFactory: { view in mapDependencyContainer.makeMapView(on: view) },
      searchViewFactory: { view in mapDependencyContainer.makeSearchView(on: view) }
    )
    sut.loadViewIfNeeded()
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test

  func testVGMapViewController_whenInitialState_snapshotTest() throws {
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
