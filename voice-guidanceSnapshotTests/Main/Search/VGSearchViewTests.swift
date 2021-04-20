import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGSearchViewTests
class VGSearchViewTests: XCTestCase {

  // MARK: property
  
  var sut: VGSearchView!
  var window: UIWindow!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    window = UIWindow(frame: UIScreen.main.bounds)
    sut = VGSearchView(on: window)
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    window = nil
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSearchView_whenInitialState_snapshotTest() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
  
  func testVGSearchView_whenTextEqualsToGoldenGateBridge_snapshotTest() throws {
    sut.textField.text = "The Golden Gate Bridge"
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
}
