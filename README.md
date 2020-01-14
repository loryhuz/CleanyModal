<p align="center">
<img src="https://user-images.githubusercontent.com/3198863/51546931-839ac800-1e65-11e9-89a0-aa0d79e25e61.png" />
</p>
<br />
<p align="center">
<a href="http://cocoapods.org/pods/CleanyModal"><img src="https://img.shields.io/cocoapods/v/CleanyModal.svg?style=flat"/></a>
<a href="http://cocoapods.org/pods/CleanyModal"><img src="https://img.shields.io/cocoapods/l/CleanyModal.svg?style=flat"/></a>
<a href="http://cocoapods.org/pods/CleanyModal"><img src="https://img.shields.io/cocoapods/p/CleanyModal.svg?style=flat"/></a>
<a href="https://swift.org/"><img src="https://img.shields.io/badge/Swift-5-orange.svg?style=flat"/></a>
</p>

<p align="center"><strong>CleanyModal</strong> is a good way to use UI-Customised alerts with ease</p>

## Features

- [x] Present some kind of clean alerts (With same API as UIAlertViewController)
- [x] Add easily Textfields or Custom views as an Alert contains content UIStackView
- [x] Action Sheets
- [x] Present full-custom components as modal from a container view
- [x] iOS 13 compatible with dark/light mode implemented by default

## Demo

<img src="https://user-images.githubusercontent.com/3198863/51548417-91058180-1e68-11e9-955b-2a7238a09afb.gif" width="250" height="542" />

Present highly customizable and clean alert from provided built-in methods:

<img src="https://user-images.githubusercontent.com/3198863/44787753-4c670a00-ab98-11e8-869e-a219c82633c0.jpeg" width="250" height="542" />

Use root modal system to present your custom components and use only the navigation/interaction stuff:

<img src="https://user-images.githubusercontent.com/3198863/38334728-783ae638-385c-11e8-82bf-b6fa65e528ce.jpeg" width="250" height="445" />

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Preview

Present a clean Alert with default style:

```swift
let alert = MyAlertViewController(
    title: "Hello world",
    message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo",
    imageName: "warning_icon")

alert.addAction(title: "OK", style: .default)
alert.addAction(title: "Cancel", style: .cancel)

present(alert, animated: true, completion: nil)
```

Apply your own style/theme easily :

```swift
class MyAlertViewController: CleanyAlertViewController {
    init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert) {
        let styleSettings = CleanyAlertConfig.getDefaultStyleSettings()
        styleSettings[.tintColor] = .yellow
        styleSettings[.destructiveColor] = .pink
        super.init(title: title, message: message, imageName: imageName, preferredStyle: preferredStyle, styleSettings: styleSettings)
    }
}
```
Need to push customization of your Alerts further ? 

Extend styles settings keys :

```swift
public extension CleanyAlertConfig.StyleKeys {
  public static let shadowOffset = CleanyAlertConfig.StyleKey<CGSize>("shadowOffset")
}
```
Then apply these news keys in viewDidLoad() implementation of your custom alert.
If you only want to present a custom component (not an alert) as a modal, inherit directly form *CleanyModalViewController*

See example project to see all abilities to customize, enjoy !

## Requirements

- iOS 9.0+
- Swift 4.2+

## Installation

CleanyModal is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CleanyModal'
```

## Author

lory huz, lory.huz@gmail.com

## License

CleanyModal is available under the MIT license. See the LICENSE file for more info.
