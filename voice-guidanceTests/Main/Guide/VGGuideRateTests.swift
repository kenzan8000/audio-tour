import XCTest
@testable import voice_guidance

// MARK: - VGGuideRateTests
class VGGuideRateTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGGuideRate_whenInitialState_shouldBe10X() throws {
    XCTAssertEqual(VGGuideRate.current(userDeafults: VGUserDefaultsStub()), ._10X)
  }
  
  func testVGGuideRate_whenThereIsUserDefaultsValue_shouldEqualToCurrent() throws {
    let userDefaults = VGUserDefaultsStub()
    let values: [VGGuideRate] = [._10X, ._05X, ._20X]
    values.forEach {
      userDefaults.set($0.rawValue, forKey: VGUserDefaultsKey.guideSpeechRate)
      XCTAssertEqual(VGGuideRate.current(userDeafults: userDefaults), $0)
    }
  }
  
  func testVGGuideRate_whenInitialState_shouldToggleProperly() throws {
    var sut = VGGuideRate.current(userDeafults: VGUserDefaultsStub())
    XCTAssertEqual(sut, ._10X)
    sut.toggle()
    XCTAssertEqual(sut, ._20X)
    sut.toggle()
    XCTAssertEqual(sut, ._05X)
    sut.toggle()
    XCTAssertEqual(sut, ._10X)
  }
}
