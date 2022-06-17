import MapboxMaps

// MARK: - PointAnnotation + VGSpot
extension PointAnnotation {
  static func annotation(spot: VGSpot) -> Self {
    var annotation = Self(id: "\(spot.id)", coordinate: spot.coordinate)
    if let image = spot.image {
      annotation.image = .init(image: image, name: "\(spot.imageId)")
    }
    return annotation
  }
}
