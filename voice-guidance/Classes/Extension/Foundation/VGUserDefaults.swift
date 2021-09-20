import Foundation

// MARK: - VGUserDefaults
protocol VGUserDefaults {
  func set(_ value: Bool, forKey defaultName: String)
  func bool(forKey defaultName: String) -> Bool
  func set(_ value: Int, forKey defaultName: String)
  func integer(forKey defaultName: String) -> Int
  func synchronize() -> Bool
  
  func setLaunchArguments(_ arguments: [String])
}

// MARK: - UserDefaults + VG
extension UserDefaults: VGUserDefaults {
}

// MARK: - VGUserDefaultsKey
enum VGUserDefaultsKey {
  // initial assets
  static let doneLoadingInitialCoreData = "VGUserDefaults.doneLoadingInitialCoreData"
  // tutorial
  static let doneTutorial = "VGUserDefaults.doneTutorial"
  static let doneARTutorial = "VGUserDefaults.doneARTutorial"
  // tts speech rate
  static let guideSpeechRate = "VGUserDefaults.guideSpeechRate"
}
