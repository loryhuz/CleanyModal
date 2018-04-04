# CleanyModal

[![Version](https://img.shields.io/cocoapods/v/CleanyModal.svg?style=flat)](http://cocoapods.org/pods/CleanyModal)
[![License](https://img.shields.io/cocoapods/l/CleanyModal.svg?style=flat)](http://cocoapods.org/pods/CleanyModal)
[![Platform](https://img.shields.io/cocoapods/p/CleanyModal.svg?style=flat)](http://cocoapods.org/pods/CleanyModal)

## Features

- [x] Present some kind of clean alerts (With same API as UIAlertViewController)
- [x] Add easily Textfields or Custom views as an Alert contains content UIStackView
- [x] Dismiss modal/alert from interaction gesture 
- [x] Present full-custom components as modal from a container view

## Demo

Present customizable and clean alert from provided built-in methods

<img src="https://user-images.githubusercontent.com/3198863/38334727-7820f070-385c-11e8-9aa3-d49bf9262a39.png" width="250" height="445" /> <img src="https://user-images.githubusercontent.com/3198863/38334725-77f10d24-385c-11e8-9e94-89d653628748.png" width="250" height="445" /> <img src="https://user-images.githubusercontent.com/3198863/38334726-780677b8-385c-11e8-9d69-ca5950520252.png" width="250" height="445" /> <img src="https://user-images.githubusercontent.com/3198863/44787753-4c670a00-ab98-11e8-869e-a219c82633c0.jpeg" width="250" height="542" />

Use root modal system to present your custom components and use only the navigation/interaction stuff

<img src="https://user-images.githubusercontent.com/3198863/38334728-783ae638-385c-11e8-82bf-b6fa65e528ce.jpeg" width="250" height="445" />

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Notes

As you can see in example projet, to get custom ViewController transition with pan gesture you need to manually add a TransitionInteractor instance in your view controller (I didn't found other better way to do it actually). If you want to be able to use modal everywhere you could inherit all of your view-controllers from one UIViewController class (ex: a class named BaseViewController) where you implement this stuff :

```swift
class BaseViewController: UIViewController {
    
    lazy var modalTransition = {
        return CleanyModalTransition()
    }()

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let alert = viewControllerToPresent as? CleanyModalViewController {
            alert.transitionInteractor = modalTransition.interactor
            alert.transitioningDelegate = modalTransition
        }

        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
```

## Requirements

- iOS 9.0+

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
