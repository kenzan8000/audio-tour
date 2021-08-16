import Combine
import Foundation
import RxSwift

// MARK: - VGRootViewModel
class VGRootViewModel {

  // MARK: property
  
  private var view: Observable<VGRootView> { viewSubject.asObservable() }
  let viewSubject: BehaviorSubject<VGRootView>
  private var cancellable = Set<AnyCancellable>()

  // MARK: initializer
  
  init(userDefaults: VGUserDefaults) {
    let initialView: VGRootView = userDefaults.bool(forKey: VGUserDefaultsKey.doneTutorial) ? .main : .tutorial
    viewSubject = BehaviorSubject<VGRootView>(value: initialView)
    
    NotificationCenter.default.publisher(for: .startMain)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.viewSubject.onNext(.main)
      }
      .store(in: &cancellable)
    NotificationCenter.default.publisher(for: .startTutorial)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.viewSubject.onNext(.tutorial)
      }
      .store(in: &cancellable)
  }
}
