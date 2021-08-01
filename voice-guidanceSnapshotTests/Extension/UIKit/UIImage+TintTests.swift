import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - UIImage+TintTests
class UIImageTintTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGImageTint_whenInitialState_snapshotTest() throws {
    let sut = try XCTUnwrap((try XCTUnwrap(UIImage(named: "annotation_1"))).tint(color: UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)))
    let imageView = UIImageView(image: sut)
    imageView.frame = CGRect(x: 0, y: 0, width: sut.size.width * sut.scale, height:  sut.size.height * sut.scale)
    assertSnapshot(
      matching: imageView,
      as: .img(precision: 0.98),
      named: model.name
    )
  }
}
