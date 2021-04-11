import XCTest
@testable import voice_guidance

// MARK: - VGSearchViewTests
class VGSearchViewTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSearchView_whenInitialState_outletsShouldBeConnected() throws {
    let parentView = UIView(frame: UIScreen.main.bounds)
    let sut = VGSearchView(on: parentView)
    XCTAssertNotNil(sut.textFieldBackgroundView)
    XCTAssertNotNil(sut.textField)
    XCTAssertNotNil(sut.activeButton)
    XCTAssertNotNil(sut.menuButton)
    XCTAssertNotNil(sut.backButton)
    XCTAssertNotNil(sut.clearButton)
    XCTAssertNotNil(sut.spotImageView)
  }
}
