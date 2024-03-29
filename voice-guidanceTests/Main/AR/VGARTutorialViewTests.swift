import XCTest
@testable import voice_guidance

// MARK: - VGARTutorialViewTests
class VGARTutorialViewTests: XCTestCase {

  // MARK: property
  
  var sut: VGARTutorialView!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGARTutorialViewTests())), name: "VGCoreData", group: "group.org.kenzan8000.voice-guidanceTests")
    let arDependencyContainer = VGARDependencyContainer()
    let parentViewController = VGARViewController(
      viewModel: VGARViewModel(
        storageProvider: storageProvider,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse)
      ),
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      mapViewFactory: { view in arDependencyContainer.makeMapView(on: view) },
      searchViewFactory: { view in arDependencyContainer.makeSearchView(on: view) }
    )
    parentViewController.loadViewIfNeeded()
    sut = VGARTutorialView(parentViewController: parentViewController, mapView: parentViewController.mapBackgroundView)
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test

  func testVGARTutorialView_whenInitialState_outletsShouldBeConnected() throws {
    XCTAssertNotNil(sut.imageView)
  }
}
