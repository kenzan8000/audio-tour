import XCTest
@testable import voice_guidance

// MARK: - VGMapHeadingTests
class VGMapHeadingTests: XCTestCase {

  // MARK: property
  
  var sut: VGMapHeading!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    sut = VGMapHeading()
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test

  func testVGMapHeading_whenInitialState_calculatedHeadingShouldBeZero() throws {
    XCTAssertEqual(sut.calculatedHeading, 0, accuracy: 0.001)
  }
  
  func testVGMapHeading_whenHeadingsAreAppended_calculatedHeadingShouldBeAverage() throws {
    sut.append(heading: 30)
    sut.append(heading: 60)
    sut.append(heading: 120)
    XCTAssertEqual(sut.calculatedHeading, 70, accuracy: 0.001)
  }
  
  func testVGMapHeading_whenHeadingIsReset_calculatedHeadingShouldBeZero() throws {
    sut.append(heading: 30)
    sut.append(heading: 60)
    sut.append(heading: 120)
    sut.reset()
    XCTAssertEqual(sut.calculatedHeading, 0, accuracy: 0.001)
  }
}
