import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGGuideViewControllerTests
class VGGuideViewControllerTests: XCTestCase {

  // MARK: property
  
  private var sut: VGGuideViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGGuideViewControllerTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
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
  
  func testVGGuideViewController_whenInitialState_snapshotTest() throws {
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
