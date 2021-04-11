import AVFoundation

// MARK: - VGGuideRate
enum VGGuideRate: Int {
  case _10X = 0
  case _05X
  case _20X
  
  /// AVSpeechUtterance.rate
  var utteranceRate: Float {
    switch self {
    case ._05X:
      return (AVSpeechUtteranceMinimumSpeechRate + AVSpeechUtteranceDefaultSpeechRate) * 2.0 / 3.0
    case ._10X:
      return AVSpeechUtteranceDefaultSpeechRate
    case ._20X:
      return (AVSpeechUtteranceDefaultSpeechRate * 8.5 + AVSpeechUtteranceMaximumSpeechRate * 1.5) / 10.0
    }
  }
  
  /// title string
  var title: String {
    switch self {
    case ._10X:
      return NSLocalizedString("guide_speech_rate_10x", comment: "")
    case ._20X:
      return NSLocalizedString("guide_speech_rate_20x", comment: "")
    case ._05X:
      return NSLocalizedString("guide_speech_rate_05x", comment: "")
    }
  }
  
  /// Returns current rate
  /// - Parameter userDeafults: VGUserDefaults
  /// - Returns: current VGGuideRate
  static func current(userDeafults: VGUserDefaults) -> VGGuideRate {
    VGGuideRate(
      rawValue: userDeafults.integer(forKey: VGUserDefaultsKey.guideSpeechRate)
    ) ?? ._10X
  }
  
  /// Toggles the next rate
  mutating func toggle() {
    switch self {
    case ._05X:
      self = ._10X
    case ._10X:
      self = ._20X
    case ._20X:
      self = ._05X
    }
  }
}
