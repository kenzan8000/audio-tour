import XCTest
@testable import voice_guidance

// MARK: - VGSideMenuViewControllerTests
class VGSideMenuViewControllerTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSideMenuViewController_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGSideMenuViewController(viewModel: .map)
    sut.loadViewIfNeeded()
    XCTAssertNotNil(sut.tableView)
  }
  
  func testVGSideMenuViewController_whenViewModelIsMap_menuCountShouldBeEqualtTo1() throws {
    let sut = VGSideMenuViewController(viewModel: .map)
    sut.loadViewIfNeeded()
    XCTAssertEqual(sut.viewModel.sideMenus.count, 1)
  }
  
  func testVGSideMenuViewController_whenViewModelIsAr_menuCountShouldBeEqualtTo2() throws {
    let sut = VGSideMenuViewController(viewModel: .ar)
    sut.loadViewIfNeeded()
    XCTAssertEqual(sut.viewModel.sideMenus.count, 2)
  }
}
