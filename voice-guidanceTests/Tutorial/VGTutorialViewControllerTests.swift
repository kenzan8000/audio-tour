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
        userDefaults: VGUserDefaultsStub(),
        locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
        captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .authorized) }
      )
    )
    sut.loadViewIfNeeded()
    XCTAssertNotNil(sut.slideBackgroundView)
    XCTAssertNotNil(sut.pageControl)
    XCTAssertNotNil(sut.doneButton)
  }
}
