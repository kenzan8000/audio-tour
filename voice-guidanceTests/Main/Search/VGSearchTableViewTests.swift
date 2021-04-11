import XCTest
@testable import voice_guidance

// MARK: - VGSearchTableViewTests
class VGSearchTableViewTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSearchTableView_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGSearchTableView()
    XCTAssertNotNil(sut.tableView)
  }
}
