import Foundation

// MARK: - VGLocale
enum VGLocale: Int {
  case en = 1
  case ja = 2
  case es = 3
  case zh_Hans = 4
  
  static var current: VGLocale {
    let locale = NSLocalizedString("locale", comment: "")
    if locale.starts(with: "ja") {
      return .ja
    } else if locale.starts(with: "es") {
      return .es
    } else if locale.starts(with: "zh") {
      return .zh_Hans
    }
    return .en
  }
}
