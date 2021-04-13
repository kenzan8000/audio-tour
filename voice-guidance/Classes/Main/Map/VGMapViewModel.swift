import Foundation
import RxSwift

// MARK: - VGMapViewModel
class VGMapViewModel {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  private let storageProvider: VGStorageProvider
  
  var spots: [VGSpot] = [] {
    didSet {
      spotsWereUpdatedSubject.onNext(spots)
    }
  }
  private var spotsWereUpdatedSubject: BehaviorSubject<[VGSpot]>
  var spotsWereUpdatedEvent: Observable<[VGSpot]> { spotsWereUpdatedSubject }
  
  var searchResult: [VGSpot] = [] {
    didSet {
      searchResultWasUpdatedSubject.onNext(searchResult)
    }
  }
  private var searchResultWasUpdatedSubject: BehaviorSubject<[VGSpot]>
  var searchResultWasUpdatedEvent: Observable<[VGSpot]> { searchResultWasUpdatedSubject }
  
  // MARK: initializer
  
  /// Inits view model
  /// - Parameter storageProvider: VGStorageProvider
  init(storageProvider: VGStorageProvider) {
    self.storageProvider = storageProvider
    spotsWereUpdatedSubject = BehaviorSubject(value: spots)
    searchResultWasUpdatedSubject = BehaviorSubject(value: searchResult)
    resetSpots()
  }
  
  // MARK: public api
  
  /// Searches spots by text
  /// - Parameter text: search text
  func search(text: String) {
    if text.isEmpty {
      searchResult = storageProvider.fetch(language: .current)
    } else {
      searchResult = storageProvider.fetch(language: .current, text: text)
    }
  }
  
  // MARK: private api
  
  /// Resets spots on the map
  private func resetSpots() {
    spots = storageProvider.fetch(language: .current)
  }
}
