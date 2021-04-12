import XCTest
@testable import voice_guidance

// MARK: - VGGuideViewControllerTests
class VGGuideViewControllerTests: XCTestCase {

  // MARK: property
  
  private var sut: VGGuideViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGSpotTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let spot = storageProvider.fetch(language: .en, text: "The Golden Gate Bridge").first!
    sut = VGGuideViewController(
      viewModel: VGGuideViewModel(spot: spot, rate: ._10X, userDefaults: VGMockUserDefaults()),
      pullUpModel: VGGuidePullUpModel(bottomSafeAreaInset: 0, peekY: UIScreen.main.bounds.height)
    )
    sut.loadViewIfNeeded()
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGGuideViewController_whenInitialState_outletsShouldBeConnected() throws {
    XCTAssertNotNil(sut.guideView)
    XCTAssertNotNil(sut.visualEffectView)
    XCTAssertNotNil(sut.titleLabel)
    XCTAssertNotNil(sut.playIndicatorView)
    XCTAssertNotNil(sut.guideControlView)
    XCTAssertNotNil(sut.progressSlider)
    XCTAssertNotNil(sut.rateButton)
    XCTAssertNotNil(sut.playButton)
    XCTAssertNotNil(sut.openButton)
    XCTAssertNotNil(sut.volumeImageView)
    XCTAssertNotNil(sut.volumeBackgroundView)
  }
}
