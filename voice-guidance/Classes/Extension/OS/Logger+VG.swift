import Foundation
import os

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "org.kenzan8000.san-francisco", category: "audio-tour")

// MARK: - Logger + LDR
extension Logger {
  func prefix(_ instance: String = #file, _ function: String = #function) -> String {
    """
    
    [file] \(String(describing: type(of: instance)))
    [func] \(function)
    --------------------------------------------------
    
    """
  }
}
