import AVFoundation
import Combine
import CoreLocation
import Foundation
import RxCocoa
import RxSwift

// MARK: - VGGuideViewModel
class VGGuideViewModel: NSObject {

  // MARK: property
  
  private let disposeBag = DisposeBag()
  private var cancellable = Set<AnyCancellable>()
  private let speechSynthesizer = AVSpeechSynthesizer()
  private let userDefaults: VGUserDefaults
  
  private var spot: VGSpot
  var spotName: String { spot.name }
  var spotBody: String { spot.body }
  var spotCoordinate: CLLocationCoordinate2D { spot.coordinate }
  
  var ttsRate: VGGuideRate {
    didSet {
      userDefaults.set(ttsRate.rawValue, forKey: VGUserDefaultsKey.guideSpeechRate)
      _ = userDefaults.synchronize()
      pauseTts()
      ttsRateSubject.onNext(ttsRate)
    }
  }
  private var ttsRateSubject: BehaviorSubject<VGGuideRate>
  var ttsRateEvent: Observable<VGGuideRate> { ttsRateSubject }
  var ttsRateTitle: String { ttsRate.title }
  
  var ttsProgress = Float(0) {
    didSet {
      setReadOutRange(at: Int(Float(spotBody.count) * ttsProgress))
      ttsSpeechText = String(
        spotBody[spotBody.index(spotBody.endIndex, offsetBy: ttsReadOutRange.location - spotBody.count)...]
      )
      ttsProgressSubject.onNext(ttsProgress)
    }
  }
  private var ttsProgressSubject: BehaviorSubject<Float>
  var ttsProgressEvent: Observable<Float> { ttsProgressSubject }
  
  var ttsIsSpeaking = false {
    didSet { ttsIsSpeakingSubject.onNext(ttsIsSpeaking) }
  }
  private var ttsIsSpeakingSubject: BehaviorSubject<Bool>
  var ttsIsSpeakingEvent: Observable<Bool> { ttsIsSpeakingSubject }
  
  private var ttsSpeechText: String
  private var ttsPausedText: String
  private var ttsReadOutRange = NSRange(location: 0, length: 0)
  private var ttsWillBePaused = false
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - spot: VGSpot
  ///   - rate: VGGuideRate
  ///   - userDefaults: VGUserDefaults
  init(spot: VGSpot, rate: VGGuideRate, userDefaults: VGUserDefaults) {
    self.spot = spot
    ttsSpeechText = spot.body
    ttsPausedText = spot.body
    self.userDefaults = userDefaults
    ttsRate = rate
    ttsRateSubject = BehaviorSubject(value: ttsRate)
    ttsProgressSubject = BehaviorSubject(value: ttsProgress)
    ttsIsSpeakingSubject = BehaviorSubject(value: ttsIsSpeaking)
    super.init()
    speechSynthesizer.delegate = self
    initNotification()
  }
  
  // MARK: destruction
  
  deinit {
    stopTts()
    deinitNotification()
  }
  
  // MARK: public api
  
  /// init notification center
  func initNotification() {
    NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in self?.pauseTts() }
      .store(in: &cancellable)
    NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in self?.pauseTts() }
      .store(in: &cancellable)
  }
  
  /// deinit notification center
  func deinitNotification() {
    cancellable.forEach { $0.cancel() }
  }
  
  /// toggle tts play rate
  func toggleTtsRate() {
    ttsRate.toggle()
  }
  
  /// Update tts progress
  /// - Parameter progress: 0 - 1 Float value
  func updateTtsProgress(_ progress: Float) {
    ttsProgress = Float(progress)
    if speechSynthesizer.isSpeaking {
      pauseTts()
    }
  }
  
  /// play tts
  func playTts() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
    } catch { }
    let utterance = AVSpeechUtterance(string: ttsSpeechText)
    ttsPausedText = ttsSpeechText
    utterance.voice = AVSpeechSynthesisVoice(language: NSLocalizedString("language_code", comment: ""))
    utterance.rate = ttsRate.utteranceRate
    utterance.pitchMultiplier = 1.0
    utterance.volume = 1.0
    speechSynthesizer.speak(utterance)
  }
  
  /// stop tts
  func stopTts() {
    if !speechSynthesizer.isSpeaking {
      return
    }
    speechSynthesizer.stopSpeaking(at: .immediate)
  }
  
  /// pause tts
  func pauseTts() {
    if !speechSynthesizer.isSpeaking {
      return
    }
    ttsWillBePaused = true
    speechSynthesizer.stopSpeaking(at: .immediate)
  }
  
  // MARK: private api

  /// Returns read out text range
  /// - Parameter index: text position
  private func setReadOutRange(at index: Int) {
    var readOutRange: NSRange?
    spotBody.enumerateLinguisticTags(
      in: (spotBody.startIndex ..< spotBody.endIndex),
      scheme: NSLinguisticTagScheme.tokenType.rawValue,
      options: [.omitWhitespace, .omitPunctuation, .joinNames],
      orthography: nil
    ) { [weak self] _, range, _, _ in
      guard readOutRange == nil, let text = self?.spotBody else {
        return
      }
      let start = text.distance(from: text.startIndex, to: range.lowerBound)
      let end = text.distance(from: text.startIndex, to: range.upperBound)
      if index >= start && index < end {
        readOutRange = NSRange(location: start, length: end - start)
      }
    }
    if let readOutRange = readOutRange {
      ttsReadOutRange = readOutRange
    } else {
      ttsReadOutRange = NSRange(location: index, length: 0)
    }
  }
}

// MARK: - AVSpeechSynthesizerDelegate
extension VGGuideViewModel: AVSpeechSynthesizerDelegate {
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    } catch { }
    ttsIsSpeaking = true
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient)
      try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    } catch { }
    ttsProgress = 0
    ttsIsSpeaking = false
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient)
      try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    } catch { }
    if !ttsWillBePaused {
      ttsProgress = 0
    }
    ttsWillBePaused = false
    ttsIsSpeaking = false
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    if !spotBody.isEmpty {
      let offset = spotBody.count - ttsPausedText.count
      ttsProgress = Float(offset + characterRange.location + characterRange.length) / Float(spotBody.count)
    } else {
      ttsProgress = 0
    }
  }

}
