import Foundation
import RxSwift

// MARK: - VGSideMenuViewModel
class VGSideMenuViewModel {
  
  // MARK: static constant
  
  static let map = VGSideMenuViewModel(sideMenus: [.map0])
  static let ar = VGSideMenuViewModel(sideMenus: [.ar0, .ar1])
  
  // MARK: property
  
  var sideMenus: [VGSideMenu]
  private var sideMenuWasUpdatedSubject: BehaviorSubject<[VGSideMenu]>
  var sideMenuWasUpdatedEvent: Observable<[VGSideMenu]> { sideMenuWasUpdatedSubject }
  
  // MARK: initializer
  
  /// Inits view model
  /// - Parameter sideMenus: array of VGSideMenu
  init(sideMenus: [VGSideMenu]) {
    self.sideMenus = sideMenus
    sideMenuWasUpdatedSubject = BehaviorSubject(value: sideMenus)
  }
  
  // MARK: destruction
  
  deinit {
  }
  
  // MARK: public api
}

// MARK: - VGSideMenu
struct VGSideMenu {
  // MARK: static constant
  
  static let map0 = VGSideMenu(title: NSLocalizedString("map_sidemenu_0", comment: ""))
  static let ar0 = VGSideMenu(title: NSLocalizedString("ar_sidemenu_0", comment: ""))
  static let ar1 = VGSideMenu(title: NSLocalizedString("ar_sidemenu_1", comment: ""))
  
  // MARK: property
  let title: String
}
