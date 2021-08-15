import RxSwift
import UIKit

// MARK: - VGTutorialSlide
enum VGTutorialSlide: Int {
  case intro = 0
  case map = 1
  case ar = 2
  case last = 3
  case end = 4
  
  var currentPage: Int { rawValue }
  
  var next: VGTutorialSlide {
    switch self {
    case .intro:
      return .map
    case .map:
      return .ar
    case .ar:
      return .last
    case .last:
      return .end
    default:
      return .end
    }
  }
}
