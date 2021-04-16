import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGSearchTableViewCellTests
class VGSearchTableViewCellTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSearchTableViewCell_whenInitialState_snapshotTest() throws {
    let sut = VGSearchTableViewCell(image: UIImage(named: "annotation_107")!, title: "The Golden Gate Bridge")
    
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
