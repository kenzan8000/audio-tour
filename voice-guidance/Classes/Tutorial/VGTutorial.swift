// MARK: - VGTutorial
enum VGTutorial: Int {
  case intro = 0
  case map = 1
  case ar = 2
  case last = 3
  case end = 4
  
  var currentPage: Int { rawValue }
  
  mutating func next() {
    switch self {
    case .intro:
      self = .map
    case .map:
      self = .ar
    case .ar:
      self = .last
    case .last:
      self = .end
    case .end:
      return
    }
  }
}
