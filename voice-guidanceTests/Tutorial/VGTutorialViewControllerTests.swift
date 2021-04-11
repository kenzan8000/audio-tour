import XCTest
@testable import voice_guidance

// MARK: - VGTutorialViewControllerTests
class VGTutorialViewControllerTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGTutorialViewController_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGTutorialViewController(
      viewModel: VGTutorialViewModel(
        userDefaults: VGMockUserDefaults(),
        locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
        captureDeviceFactory: { VGMockCaptureDevice(authorizationStatus: .authorized) }
      )
    )
    sut.loadViewIfNeeded()
    XCTAssertNotNil(sut.slideBackgroundView)
    XCTAssertNotNil(sut.pageControl)
    XCTAssertNotNil(sut.doneButton)
  }
}
