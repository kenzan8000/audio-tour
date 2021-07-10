fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios unit_tests
```
fastlane ios unit_tests
```
Unit testing
### ios snapshot_tests_on_iphone12promax
```
fastlane ios snapshot_tests_on_iphone12promax
```
Snapshot testing on iPhone 12 Pro Max
### ios snapshot_tests_on_ipodtouch7thgeneration
```
fastlane ios snapshot_tests_on_ipodtouch7thgeneration
```
Snapshot testing
### ios beta_upload
```
fastlane ios beta_upload
```
Upload beta build

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
