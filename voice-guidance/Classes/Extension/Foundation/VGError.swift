import Foundation

// MARK: - VGError
enum VGError: Error {
  case convertingDataIntoImageFailed
  case convertingImageIntoPngFailed
  case savingImageFailed
}
