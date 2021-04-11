import Foundation
import RxSwift

// MARK: - VGSideMenuViewModel
class VGSideMenuViewModel {
  
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
  let title: String
}
