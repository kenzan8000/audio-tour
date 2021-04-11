@testable import voice_guidance

// MARK: - VGMockCaptureDevice
class VGMockUserDefaults: VGUserDefaults {
  var boolValues = [String: Bool]()
  var intValues = [String: Int]()
  
  func set(_ value: Bool, forKey defaultName: String) {
    boolValues[defaultName] = value
  }
  
  func bool(forKey defaultName: String) -> Bool {
    boolValues[defaultName] ?? false
  }
  
  func set(_ value: Int, forKey defaultName: String) {
    intValues[defaultName] = value
  }
  
  func integer(forKey defaultName: String) -> Int {
    intValues[defaultName] ?? 0
  }
  
  func synchronize() -> Bool { true }
}
