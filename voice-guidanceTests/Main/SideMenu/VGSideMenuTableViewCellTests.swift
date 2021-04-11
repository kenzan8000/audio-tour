import XCTest
@testable import voice_guidance

// MARK: - VGSideMenuTableViewCellTests
class VGSideMenuTableViewCellTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSideMenuTableViewCell_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGSideMenuTableViewCell(title: "title")
    XCTAssertNotNil(sut.titleLabel)
  }
}
