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
  
  func testVGCircleButton_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGCircleButton(image: UIImage(systemName: "location.fill"))
    XCTAssertNotNil(sut.button)
    XCTAssertNotNil(sut.buttonBackgroundView)
  }
}
