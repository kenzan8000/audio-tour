import XCTest
@testable import voice_guidance

// MARK: - VGUserDefaultsTests
class VGUserDefaultsTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGUserDefaults_whenSettingLaunchArgumentsFalse_userDefaultsShouldBeEqualToFalse() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key = "VGUserDefaults.doneTutorial"
    sut.setLaunchArguments(["-VGUserDefaults", key, "Bool", "false"])
    XCTAssertFalse(sut.bool(forKey: key))
  }
  
  func testVGUserDefaults_whenSettingLaunchArgumentsTrue_userDefaultsShouldBeEqualToTrue() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key = "VGUserDefaults.doneTutorial"
    sut.setLaunchArguments(["-VGUserDefaults", key, "Bool", "true"])
    XCTAssertTrue(sut.bool(forKey: key))
  }
  
  func testVGUserDefaults_whenSettingLaunchArguments1_userDefaultsShouldBeEqualTo1() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key = "VGUserDefaults.guideSpeechRate"
    sut.setLaunchArguments(["-VGUserDefaults", key, "Int", "1"])
    XCTAssertEqual(sut.integer(forKey: key), 1)
  }
  
  func testVGUserDefaults_whenSettingLaunchArgumentsFalseAnd1_userDefaultsShouldBeEqualToFalseAnd1() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key1 = "VGUserDefaults.doneTutorial"
    let key2 = "VGUserDefaults.guideSpeechRate"
    sut.setLaunchArguments(["-VGUserDefaults", key1, "Bool", "false", "-VGUserDefaults", key2, "Int", "1"])
    XCTAssertFalse(sut.bool(forKey: key1))
    XCTAssertEqual(sut.integer(forKey: key2), 1)
  }
  
  func testVGUserDefaults_whenNumberOfArgumentsIsInvalid_userDefaultsShouldNotBeChanged() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key = "VGUserDefaults.doneTutorial"
    let before = sut.bool(forKey: key)
    XCTAssertFalse(before)
    sut.setLaunchArguments(["-VGUserDefaults", key, "Bool", "-VGUserDefaults", "1"])
    let after = sut.bool(forKey: key)
    XCTAssertEqual(before, after)
  }
  
  func testVGUserDefaults_whenValueTypeIsBoool_userDefaultsShouldNotBeChanged() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key = "VGUserDefaults.doneTutorial"
    let before = sut.bool(forKey: key)
    XCTAssertFalse(before)
    sut.setLaunchArguments(["-VGUserDefaults", key, "Boool", "true"])
    let after = sut.bool(forKey: key)
    XCTAssertEqual(before, after)
  }
  
  func testVGUserDefaults_whenSettingLaunchArgumentsTru_userDefaultsShouldNotBeChanged() throws {
    let sut: VGUserDefaults = VGUserDefaultsStub()
    let key = "VGUserDefaults.doneTutorial"
    let before = sut.bool(forKey: key)
    XCTAssertFalse(before)
    sut.setLaunchArguments(["-VGUserDefaults", key, "Bool", "tru"])
    let after = sut.bool(forKey: key)
    XCTAssertEqual(before, after)
  }
}
