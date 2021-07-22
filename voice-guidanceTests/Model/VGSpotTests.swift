import CoreLocation
import XCTest
@testable import voice_guidance

// MARK: - VGSpotTests
class VGSpotTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testVGSpot_whenFetchingLocalCoreData_shouldBeSpotsInDB() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGSpotTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let locales: [VGLocale] = [.en, .es, .ja, .zh_Hans]
    locales.forEach {
      let spots = storageProvider.fetch(language: $0)
      XCTAssertGreaterThan(spots.count, 0)
    }
  }
  
  func testVGSpot_whenFetchingLocalCoreDataAroundNorthPole_shouldNotBeSpotsInDB() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGSpotTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let locales: [VGLocale] = [.en, .es, .ja, .zh_Hans]
    locales.forEach {
      let spots = storageProvider.fetch(language: $0, sw: CLLocationCoordinate2D(latitude: 1, longitude: 89), ne: CLLocationCoordinate2D(latitude: 2, longitude: 90))
      XCTAssertEqual(spots.count, 0)
    }
  }
  
  func testVGSpot_whenFetchingLocalCoreDataAroundSanFrancisco_shouldBeSpotsInDB() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGSpotTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let locales: [VGLocale] = [.en, .es, .ja, .zh_Hans]
    locales.forEach {
      let spots = storageProvider.fetch(language: $0, sw: CLLocationCoordinate2D(latitude: 37.647897, longitude: -122.639933), ne: CLLocationCoordinate2D(latitude: 37.937154, longitude: -122.296055))
      XCTAssertGreaterThan(spots.count, 0)
    }
  }
  
  func testVGSpot_whenFetchingLocalCoreDataByGoldenGateBridge_shouldBeASpotInDB() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGSpotTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    let locales: [VGLocale] = [.en, .es, .ja, .zh_Hans]
    locales.forEach {
      let spots = storageProvider.fetch(language: $0, text: "The Golden Gate Bridge")
      XCTAssertEqual(spots.count, 1)
    }
  }
  
  func testVGSpot_whenInitialState_shouldBeAbleToSaveInitialSpots() throws {
    let storageProvider = VGStorageProvider(storeType: .inMemory)
    storageProvider.saveInitialSpots(userDefaults: VGUserDefaultsStub())
    let spots = storageProvider.fetch(language: .en)
    XCTAssertGreaterThan(spots.count, 0)
  }
}
