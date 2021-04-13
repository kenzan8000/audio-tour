import XCTest
@testable import voice_guidance

// MARK: - VGMapZoomTests
class VGMapZoomTests: XCTestCase {

  // MARK: property
  
  var sut: VGMapZoom!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    sut = VGMapZoom(
      level: VGARMap.minimumZoomLevel,
      maxLevel: VGARMap.maximumZoomLevel,
      minLevel: VGARMap.minimumZoomLevel
    )
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test

  func testVGMapZoom_whenInitialState_shouldBeMin() throws {
    XCTAssertEqual(sut.state, .min)
    XCTAssertEqual(sut.level, VGARMap.minimumZoomLevel, accuracy: 0.001)
  }
  
  func testVGMapZoom_whenZoomingIn_shouldChangeValueProperly() throws {
    XCTAssertEqual(sut.state, .min)
    XCTAssertEqual(sut.level, VGARMap.minimumZoomLevel, accuracy: 0.001)
    sut.level += VGARMap.maximumZoomLevel - VGARMap.minimumZoomLevel + 0.1
    XCTAssertEqual(sut.state, .max)
    XCTAssertEqual(sut.level, VGARMap.maximumZoomLevel, accuracy: 0.001)
    sut.level += (VGARMap.maximumZoomLevel - VGARMap.minimumZoomLevel) / 2.0
    XCTAssertEqual(sut.state, .max)
    XCTAssertEqual(sut.level, VGARMap.maximumZoomLevel, accuracy: 0.001)
    sut.level -= (VGARMap.maximumZoomLevel - VGARMap.minimumZoomLevel) / 2.0
    XCTAssertEqual(sut.state, .none)
    XCTAssertEqual(sut.level, VGARMap.minimumZoomLevel + 1.0, accuracy: 0.001)
  }
}
