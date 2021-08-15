import XCTest
@testable import voice_guidance

// MARK: - VGTutorialViewModelTests
class VGTutorialViewModelTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGTutorialViewModel_whenInitialState_tutorialShouldBeIntro() throws {
    let sut = VGTutorialViewModel(
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .authorized) }
    )
    XCTAssertEqual(sut.slide, .intro)
  }
  
  func testVGTutorialViewModel_whenLocationAndCameraAreAuthorized_shouldBeAbleToSeeAllTutorial() throws {
    let userDefaults = VGUserDefaultsStub()
    let sut = VGTutorialViewModel(
      userDefaults: userDefaults,
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .authorized) }
    )
    XCTAssertFalse(userDefaults.bool(forKey: VGUserDefaultsKey.doneTutorial))
    XCTAssertEqual(sut.slide, .intro)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .map)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .ar)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .last)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .end)
    XCTAssertTrue(userDefaults.bool(forKey: VGUserDefaultsKey.doneTutorial))
  }
  
  func testVGTutorialViewModel_whenLocationIsNotDetermined_shouldStopAtMap() throws {
    let sut = VGTutorialViewModel(
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .notDetermined) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .authorized) }
    )
    XCTAssertEqual(sut.slide, .intro)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .map)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .map)
  }
  
  func testVGTutorialViewModel_whenCameraIsNotDetermined_shouldStopAtAr() throws {
    let sut = VGTutorialViewModel(
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .notDetermined) }
    )
    XCTAssertEqual(sut.slide, .intro)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .map)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .ar)
    sut.presentNextView()
    XCTAssertEqual(sut.slide, .ar)
  }
  
}
