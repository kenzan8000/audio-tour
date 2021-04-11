import ARKit_CoreLocation
import CoreLocation
import SceneKit

// MARK: - VGARLocationAnnotationNode
open class VGARLocationAnnotationNode: LocationNode {
  
  // MARK: property
  
  public let annotationNode: SCNNode
  public let textNode: SCNNode

  // MARK: initializer
  
  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - location: location of ar node
  ///   - image: image of annotation node
  ///   - text: string of text node
  ///   - textColor: color of text node
  public init(location: CLLocation?, annotationImage: UIImage, text: String, textColor: UIColor) {
    let plane = SCNPlane(
      width: annotationImage.size.width / UIScreen.main.scale,
      height: annotationImage.size.height / UIScreen.main.scale
    )
    if let firstMaterial = plane.firstMaterial {
      firstMaterial.diffuse.contents = annotationImage
      firstMaterial.lightingModel = .constant
    }
      
    // annotation node
    annotationNode = SCNNode()
    annotationNode.geometry = plane
      
    // text node
    let sceneText = SCNText(string: text, extrusionDepth: 0)
    sceneText.font = UIFont.systemFont(ofSize: 10)
    let material = SCNMaterial()
    material.diffuse.contents = textColor
    sceneText.materials = [material]
    textNode = SCNNode(geometry: sceneText)
    let (min, max) = textNode.boundingBox
    textNode.position = SCNVector3(-CGFloat(max.x - min.x) / 2, CGFloat(max.y - min.y) * 3 / 2, 0.001)
    
    super.init(location: location)
      
    addChildNode(annotationNode)
    addChildNode(textNode)
  }
  
}
