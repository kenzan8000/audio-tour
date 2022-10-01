import XCTest
@testable import voice_guidance

// MARK: - VGMapViewModelTests
class VGMapViewModelTests: XCTestCase {

  // MARK: property
  
  var sut: VGMapViewModel!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGMapViewModelTests())), name: "VGCoreData", group: "group.org.kenzan8000.voice-guidanceTests")
    sut = VGMapViewModel(storageProvider: storageProvider)
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test

  func testVGMapViewModel_whenInitialState_shouldBeZeroSearchSpots() throws {
    XCTAssertGreaterThan(sut.spots.count, 0)
  }
  
  func testVGMapViewModel_whenSearchingGoldenGateBridge_shouldBeOneSearchSpot() throws {
    sut.search(text: "The Golden Gate Bridge")
    XCTAssertEqual(sut.searchResult.count, 1)
  }
  
}
