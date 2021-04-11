import UIKit

let appDelegateClass: AnyClass = NSClassFromString("VGTestingAppDelegate") ?? AppDelegate.self
UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  nil,
  NSStringFromClass(appDelegateClass)
)
