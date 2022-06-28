import CoreLocation

class VGMapHeading {
  // MARK: property
  
  private let count = 1
  
  private var latestHeadings: [CLLocationDirection] = []
  
  var calculatedHeading: CLLocationDirection {
    if latestHeadings.isEmpty {
      return 0
    }
    var degree: CLLocationDirection = 0
    for heading in latestHeadings { degree += heading }
    degree /= CLLocationDirection(latestHeadings.count)
    return degree
  }
  
  // MARK: public api
  
  /// Appends heading
  /// - Parameter heading: CLLocationDirection
  func append(heading: CLLocationDirection) {
    latestHeadings.append(heading)
    if latestHeadings.count > count {
      latestHeadings.removeFirst()
    }
  }
  
  /// Resets heading
  func reset() {
    latestHeadings = []
  }
}
