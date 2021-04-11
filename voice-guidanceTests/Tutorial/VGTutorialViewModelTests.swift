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
      userDefaults: VGMockUserDefaults(),
      locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGMockCaptureDevice(authorizationStatus: .authorized) }
    )
    XCTAssertEqual(sut.tutorial, .intro)
  }
  
  func testVGTutorialViewModel_whenLocationAndCameraAreAuthorized_shouldBeAbleToSeeAllTutorial() throws {
    let userDefaults = VGMockUserDefaults()
    let sut = VGTutorialViewModel(
      userDefaults: userDefaults,
      locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGMockCaptureDevice(authorizationStatus: .authorized) }
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
      userDefaults: VGMockUserDefaults(),
      locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .notDetermined) },
      captureDeviceFactory: { VGMockCaptureDevice(authorizationStatus: .authorized) }
    )
    XCTAssertEqual(sut.tutorial, .intro)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .map)
    sut.nextView()
    XCTAssertEqual(sut.tutorial, .map)
  }
  
  func testVGTutorialViewModel_whenCameraIsNotDetermined_shouldStopAtAr() throws {
    let sut = VGTutorialViewModel(
      userDefaults: VGMockUserDefaults(),
      locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
      captureDeviceFactory: { VGMockCaptureDevice(authorizationStatus: .notDetermined) }
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
