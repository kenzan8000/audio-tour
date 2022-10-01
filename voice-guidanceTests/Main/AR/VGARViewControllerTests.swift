import XCTest
@testable import voice_guidance

// MARK: - VGARViewControllerTests
class VGARViewControllerTests: XCTestCase {

  // MARK: property
  
  var sut: VGARViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGARViewControllerTests())), name: "VGCoreData", group: "group.org.kenzan8000.voice-guidanceTests")
    let arDependencyContainer = VGARDependencyContainer()
    sut = VGARViewController(
      viewModel: VGARViewModel(
        storageProvider: storageProvider,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse)
      ),
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
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
  
  func testVGARViewController_whenInitialState_outletsShouldBeConnected() throws {
    XCTAssertNotNil(sut.mapBackgroundView)
  }
}
