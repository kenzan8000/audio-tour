import Foundation

// MARK: - VGUserDefaultsLaunchArgument
struct VGUserDefaultsLaunchArgument {
  // MARK: enum
  
  enum ValueType {
    case bool
    case int
  }
  
  enum ParseError: Error {
    case invalidValueType
    case invalidValue
  }
  
  // MARK: property
  
  let key: String
  let valueType: ValueType
  private let rawValue: String
  
  var boolValue: Bool {
    switch rawValue.lowercased() {
    case "true":
      return true
    default:
      return false
    }
  }
  var intValue: Int {
    Int(rawValue) ?? 0
  }
  
  // MARK: initializer
  
  init(key: String, valueType: String, rawValue: String) throws {
    self.key = key
    
    switch valueType.lowercased() {
    case "bool", "boolean":
      self.valueType = .bool
    case "int", "integer":
      self.valueType = .int
    default:
      logger.error("\(logger.prefix(), privacy: .private)\("Failed to parse launch arguments -VGUserDefaults, \(key), \(valueType), \(rawValue)", privacy: .private)")
      throw ParseError.invalidValueType
    }
    
    switch self.valueType {
    case .bool:
      switch rawValue.lowercased() {
      case "true", "false":
        break
      default:
        logger.error("\(logger.prefix(), privacy: .private)\("Failed to parse launch arguments -VGUserDefaults, \(key), \(valueType), \(rawValue)", privacy: .private)")
        throw ParseError.invalidValue
      }
    case .int:
      if Int(rawValue) == nil {
        logger.error("\(logger.prefix(), privacy: .private)\("Failed to parse launch arguments -VGUserDefaults, \(key), \(valueType), \(rawValue)", privacy: .private)")
        throw ParseError.invalidValue
      }
    }
    self.rawValue = rawValue
  }
}

// MARK: - VGUserDefaults + LaunchArguments
extension VGUserDefaults {
  func setLaunchArguments(_ arguments: [String]) {
    let keyIndex = 1
    let valueTypeIndex = 2
    let valueIndex = 3
    arguments.indices.filter { arguments[$0] == "-VGUserDefaults" }
      .compactMap {
        let valid = $0 + valueIndex < arguments.count
        if !valid {
          logger.error("\(logger.prefix(), privacy: .private)\("Failed to parse launch arguments -VGUserDefaults (index: \($0)", privacy: .private)")
          return nil
        }
        return $0
      }
      .compactMap {
        try? VGUserDefaultsLaunchArgument(
          key: arguments[$0 + keyIndex],
          valueType: arguments[$0 + valueTypeIndex],
          rawValue: arguments[$0 + valueIndex]
        )
      }
      .forEach {
        switch $0.valueType {
        case .bool:
          set($0.boolValue, forKey: $0.key)
        case .int:
          set($0.intValue, forKey: $0.key)
        }
      }
    _ = synchronize()
  }
}
