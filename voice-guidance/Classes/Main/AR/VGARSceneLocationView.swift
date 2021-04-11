import ARKit_CoreLocation
import UIKit

// MARK: - VGARSceneLocationView
class VGARSceneLocationView: SceneLocationView {
  
  // MARK: public api
  
  /// Resets location nodes
  /// - Parameter nodes: nodes to display
  func resetLocationNodes(_ nodes: [LocationNode]) {
    for node in locationNodes {
      removeLocationNode(locationNode: node)
    }
    for node in nodes {
      addLocationNodeWithConfirmedLocation(locationNode: node)
    }
  }
  
  /// Returns index of touched locationNode
  /// - Parameter touch: UITouch
  /// - Returns: index of touched location node or -1 when 
  func getTouchedLocationNodeIndex(touch: UITouch) -> Int? {
    guard let collision = hitTest(touch.location(in: self), options: nil).first else {
      return nil
    }
    for (index, locationNode) in locationNodes.enumerated() {
      if locationNode.contains(collision.node) {
        return index
      }
    }
    return nil
  }
}
