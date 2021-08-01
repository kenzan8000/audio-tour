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
  
  func testVGSearchTableViewCell_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGSearchTableViewCell(image: try XCTUnwrap(UIImage(systemName: "plus")), title: "title")
    XCTAssertNotNil(sut.iconImageView)
    XCTAssertNotNil(sut.titleLabel)
  }
}
