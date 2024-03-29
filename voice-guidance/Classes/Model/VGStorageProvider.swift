import CoreData

// MARK: - VGStorageProvider
class VGStorageProvider {
  
  // MARK: - enum
  enum StoreType {
    case inMemory
    case persisted
  }

  // MARK: property
  let persistentContainer: NSPersistentContainer
  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - storeType: StoreType
  init(storeType: StoreType = .persisted) {
    persistentContainer = NSPersistentContainer(name: "VGCoreData")
    if storeType == .inMemory {
      persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    persistentContainer.loadPersistentStores { _, error in
      if let error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }
  
  /// Inits from an existing sqlite file
  /// - Parameters:
  ///   - source: bundle of source sqlite file
  ///   - name: CoreData file name
  ///   - group: App Group name
  init(source: Bundle, name: String, group: String) {
    persistentContainer = NSPersistentContainer(name: name)
    guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) else {
      fatalError("Could not find coredata share group url.")
    }
    if !FileManager.default.fileExists(atPath: url.appendingPathComponent("\(name).sqlite").path) {
      ["sqlite", "sqlite-wal", "sqlite-shm"]
        .forEach {
          try? FileManager.default.copyItem(
            at: source.url(forResource: name, withExtension: $0) ?? URL(fileURLWithPath: ""),
            to: url.appendingPathComponent("\(name)." + $0)
          )
        }
    }
    persistentContainer.persistentStoreDescriptions.first?.url = url.appendingPathComponent("\(name).sqlite")
    persistentContainer.loadPersistentStores { _, error in
      if let error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }
}
