<p align="center">
  <img src="https://user-images.githubusercontent.com/225808/114387422-60d36600-9bcd-11eb-8a9d-b221192008d0.png" width="120" alt="App Icon" />
</p>

# Audio Tour

[![CircleCI](https://circleci.com/gh/kenzan8000/audio-tour/tree/main.svg?style=svg)](https://circleci.com/gh/kenzan8000/audio-tour/tree/main)

[Audio Tour](https://apps.apple.com/us/app/audio-tour-san-francisco/id1182851195) offers an audio guide of the spots, similar to how a museum audio guide helps you understand the works of art at a deeper level.
There are two modes to assist with your sight-seeing.

![audio-tour](https://user-images.githubusercontent.com/225808/118213027-200a8d80-b4a8-11eb-9cff-6e192f4cf8da.jpg)

### Map Guide

The map view gives you a birds-eye view of the city. You can plan places to visit before going out or check them out during your trip.

### AR Guide

The live camera view displays the names of spots on top of the image from the camera at your location. Launch this function in the city, and face your camera to the spots.

## Installation

### Embedded Frameworks

As of April 2021, [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios) hasn't done the [Swift Package Manager](https://github.com/apple/swift-package-manager) support yet.
Therefore, [download the SDK manually](https://docs.mapbox.com/ios/maps/guides/install/).
Then drag the frameworks into `Frameworks/` folder.

### Plist Settings

Audio Tour depends on [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios/tree/main/platform/ios).
To use Mapbox API, you need to set Mapbox's access token in `Mapbox-Info.plist`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>MGLMapboxAccessToken</key>
    <string>YOUR_ACCESS_TOKEN</string>
</dict>
</plist>
```
