import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGCircleButtonTests
class VGCircleButtonTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGCircleButton_whenInitialState_snapshotTest() throws {
    let sut = VGCircleButton(image: UIImage(systemName: "location.fill"))
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhoneX(.portrait)),
        named: named
      )
    }
  }
}