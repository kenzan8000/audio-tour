// MARK: - VGMapZoom
class VGMapZoom {
  // MARK: enum
  
  enum State {
    case none
    case max
    case min
  }
  
  // MARK: property
  
  private let maxLevel: Double
  private let minLevel: Double
  
  var level: Double {
    didSet {
      if level > maxLevel {
        level = maxLevel
        state = .max
      } else if level < minLevel {
        level = minLevel
        state = .min
      } else {
        state = .none
      }
    }
  }
  var state: State = .none
  
  // MARK: initializer
  
  /// Init
  /// - Parameters:
  ///   - level: initial zoom level
  ///   - maxLevel: max zoom level
  ///   - minLevel: min zoom level
  init(level: Double, maxLevel: Double, minLevel: Double) {
    self.level = level
    self.maxLevel = maxLevel
    self.minLevel = minLevel
  }
}
