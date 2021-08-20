import Foundation
import os

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "org.kenzan8000.san-francisco", category: "audio-tour")

// MARK: - Logger + VG
extension Logger {
  func prefix(_ file: String = #fileID, _ function: String = #function, _ line: Int = #line) -> String {
    """
    
    
    -----------------------------------------------------
    [\(file):\(line)] \(function)
    
    """
  }
}
