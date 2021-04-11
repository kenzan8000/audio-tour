import CoreData
import CoreLocation
import UIKit

// MARK: - VGSpot
class VGSpot: NSManagedObject {
  
  // MARK: property
  
  @NSManaged var id: Int
  @NSManaged var languageId: Int
  @NSManaged var imageId: Int
  @NSManaged var name: String
  @NSManaged var lat: Double
  @NSManaged var lng: Double
  @NSManaged var altitude: Double
  @NSManaged var body: String
  
  var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lng) }
  var location: CLLocation { CLLocation(coordinate: coordinate, altitude: altitude) }
  var image: UIImage? { UIImage(named: "annotation_\(imageId)") }
}

// MARK: - VGSpotJSON
struct VGSpotJSON: Decodable {
  let spots: [VGSpotItemJSON]
}

// MARK: - VGSpotItemJSON
struct VGSpotItemJSON: Decodable {
  let id: Int
  let languageId: Int
  let imageId: Int
  let name: String
  let lat: Double
  let lng: Double
  let altitude: Double
  let body: String
}

// MARK: - VGStorageProvider + VGSpot
extension VGStorageProvider {
  
  // MARK: public api
  
  /// Returns fixed type NSFetchRequest
  @nonobjc
  func fetchRequest() -> NSFetchRequest<VGSpot> {
    NSFetchRequest<VGSpot>(entityName: "VGSpot")
  }
  
  /// Fetches all spots
  /// - Parameters:
  ///   - language: language
  /// - Returns: all spots
  func fetch(language: VGLocale) -> [VGSpot] {
    fetch(predicates: [
      NSPredicate(format: "(%K = %@)", #keyPath(VGSpot.languageId), NSNumber(value: language.rawValue)),
    ])
  }
  
  /// Fetches spots by the bound
  /// - Parameters:
  ///   - language: language
  ///   - sw: south west bound
  ///   - ne: north east bound
  /// - Returns: spots
  func fetch(language: VGLocale, sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D) -> [VGSpot] {
    fetch(predicates: [
      NSPredicate(
        format: "(%K <= %@) AND (%K >= %@)",
        #keyPath(VGSpot.lat),
        NSNumber(value: ne.latitude),
        #keyPath(VGSpot.lat),
        NSNumber(value: sw.latitude)
      ),
      NSPredicate(
        format: "(%K <= %@) AND (%K >= %@)",
        #keyPath(VGSpot.lng),
        NSNumber(value: ne.longitude),
        #keyPath(VGSpot.lng),
        NSNumber(value: sw.longitude)
      ),
      NSPredicate(
        format: "(%K = %@)",
        #keyPath(VGSpot.languageId),
        NSNumber(value: language.rawValue)
      ),
    ])
  }
  
  /// Fetches spots by search text
  /// - Parameters:
  ///   - language: language
  ///   - text: search text
  /// - Returns: spots
  func fetch(language: VGLocale, text: String) -> [VGSpot] {
    fetch(predicates: [
      NSPredicate(
        format: "%K CONTAINS[cd] %@",
        #keyPath(VGSpot.name),
        text
      ),
      NSPredicate(
        format: "(%K = %@)",
        #keyPath(VGSpot.languageId),
        NSNumber(value: language.rawValue)
      ),
    ])
  }
  
  /// Saves initial spots
  /// - Parameter userDefaults: VGUserDefaults
  func saveInitialSpots(userDefaults: VGUserDefaults) {
    if userDefaults.bool(forKey: VGUserDefaultsKey.doneLoadingInitialCoreData) {
      return
    }
    guard let asset = NSDataAsset(name: "data", bundle: Bundle.main) else {
      return
    }
    let decoder = JSONDecoder()
    var json: VGSpotJSON
    do {
      json = try decoder.decode(VGSpotJSON.self, from: asset.data)
      try save(by: json)
    } catch {
      return
    }
    userDefaults.set(true, forKey: VGUserDefaultsKey.doneLoadingInitialCoreData)
    _ = userDefaults.synchronize()
  }
  
  // MARK: private api
  
  /// Fetches spots
  /// - Parameters:
  ///   - predicates: [NSPredicate] to search
  /// - Returns: spots
  private func fetch(predicates: [NSPredicate]) -> [VGSpot] {
    let fetchRequest: NSFetchRequest<VGSpot> = self.fetchRequest()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try viewContext.fetch(fetchRequest)
    } catch {
      return []
    }
  }
  
  /// Save a spot
  /// - Parameters:
  ///   - json: VGSpotJSON
  private func save(by json: VGSpotJSON) throws {
    json.spots.forEach {
      let spot = VGSpot(context: viewContext)
      spot.id = $0.id
      spot.languageId = $0.languageId
      spot.imageId = $0.imageId
      spot.name = $0.name
      spot.lat = $0.lat
      spot.lng = $0.lng
      spot.altitude = $0.altitude
      spot.body = $0.body
    }
    try viewContext.save()
  }
}
