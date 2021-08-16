import XCTest
@testable import voice_guidance

// MARK: - VGGuideViewModelTests
class VGGuideViewModelTests: XCTestCase {
  
  // MARK: property
  
  private var sut: VGGuideViewModel!

  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGGuideViewModelTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let spot = try XCTUnwrap(storageProvider.fetch(language: .en, text: "The Golden Gate Bridge").first)
    sut = VGGuideViewModel(spot: spot, rate: ._10X, userDefaults: VGUserDefaultsStub())
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGGuideViewModel_whenInitialState_shouldToggleTtsRateProperly() throws {
    XCTAssertEqual(sut.ttsRate, ._10X)
    sut.toggleTtsRate()
    XCTAssertEqual(sut.ttsRate, ._20X)
    sut.toggleTtsRate()
    XCTAssertEqual(sut.ttsRate, ._05X)
    sut.toggleTtsRate()
    XCTAssertEqual(sut.ttsRate, ._10X)
  }
  
  func testVGGuideViewModel_whenInitialState_shouldUpdateUpdateTtsProgressProperly() throws {
    XCTAssertEqual(sut.ttsProgress, 0, accuracy: 0.001)
    sut.updateTtsProgress(0.1)
    XCTAssertEqual(sut.ttsProgress, 0.1, accuracy: 0.001)
  }
  
  func testVGGuideViewModel_whenTtsStartedSpeaking_ttsShouldBeSpeaking() throws {
    let exp = expectation(description: #function)
    sut.playTts()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { exp.fulfill() }
    wait(for: [exp], timeout: 5.0)
    XCTAssertTrue(sut.ttsIsSpeaking)
  }
  
  func testVGGuideViewModel_whenTtsPausedSpeaking_ttsShouldNotBeSpeaking() throws {
    let exp1 = expectation(description: #function)
    sut.playTts()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { exp1.fulfill() }
    wait(for: [exp1], timeout: 5.0)
    let exp2 = expectation(description: #function)
    sut.pauseTts()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { exp2.fulfill() }
    wait(for: [exp2], timeout: 5.0)
    XCTAssertFalse(sut.ttsIsSpeaking)
  }
  
  func testVGGuideViewModel_whenTtsStoppedSpeaking_ttsShouldNotBeSpeaking() throws {
    let exp1 = expectation(description: #function)
    sut.playTts()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { exp1.fulfill() }
    wait(for: [exp1], timeout: 5.0)
    let exp2 = expectation(description: #function)
    sut.stopTts()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { exp2.fulfill() }
    wait(for: [exp2], timeout: 5.0)
    XCTAssertFalse(sut.ttsIsSpeaking)
  }
}
