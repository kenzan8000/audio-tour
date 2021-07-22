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
    XCTAssertEqual(sut.tutorial, .intro)
  }
  
  func testVGTutorialViewModel_whenLocationAndCameraAreAuthorized_shouldBeAbleToSeeAllTutorial() throws {
    let userDefaults = VGUserDefaultsStub()
    let sut = VGTutorialViewModel(
      userDefaults: userDefaults,
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .authorized) }
    )
    XCTAssertFalse(userDefaults.bool(forKey: VGUserDefaultsKey.doneTutorial))
    XCTAssertEqual(sut.tutorial, .intro)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .map)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .ar)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .last)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .end)
    XCTAssertTrue(userDefaults.bool(forKey: VGUserDefaultsKey.doneTutorial))
  }
  
  func testVGTutorialViewModel_whenLocationIsNotDetermined_shouldStopAtMap() throws {
    let sut = VGTutorialViewModel(
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .notDetermined) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .authorized) }
    )
    XCTAssertEqual(sut.tutorial, .intro)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .map)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .map)
  }
  
  func testVGTutorialViewModel_whenCameraIsNotDetermined_shouldStopAtAr() throws {
    let sut = VGTutorialViewModel(
      userDefaults: VGUserDefaultsStub(),
      locationManagerFactory: { VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGCaptureDeviceStub(authorizationStatus: .notDetermined) }
    )
    XCTAssertEqual(sut.tutorial, .intro)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .map)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .ar)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .ar)
  }
  
}
