# LoadingIndicatorLayer

[![CI Status](http://img.shields.io/travis/Sota Yokoe/LoadingIndicatorLayer.svg?style=flat)](https://travis-ci.org/Sota Yokoe/LoadingIndicatorLayer)
[![Version](https://img.shields.io/cocoapods/v/LoadingIndicatorLayer.svg?style=flat)](http://cocoapods.org/pods/LoadingIndicatorLayer)
[![License](https://img.shields.io/cocoapods/l/LoadingIndicatorLayer.svg?style=flat)](http://cocoapods.org/pods/LoadingIndicatorLayer)
[![Platform](https://img.shields.io/cocoapods/p/LoadingIndicatorLayer.svg?style=flat)](http://cocoapods.org/pods/LoadingIndicatorLayer)

CALayer based Loading indicator with animations.

## Example

```
loadingIndicatorLayer = LoadingIndicatorLayer()
theView.layer?.addSublayer(loadingIndicatorLayer)

loadingIndicatorLayer.frame = CGRect(x: layer.bounds.midX - 40, y: layer.bounds.midY - 40, width: 80, height: 80)

@IBAction func onStatusIdle(_ sender: Any) {
    loadingIndicatorLayer.status = .idle
}

@IBAction func onStatusLoading(_ sender: Any) {
    loadingIndicatorLayer.status = .loading
}
```

## Requirements

## Installation

LoadingIndicatorLayer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LoadingIndicatorLayer"
```

## Author

Sota Yokoe, info@kreuz45.com

## License

LoadingIndicatorLayer is available under the MIT license. See the LICENSE file for more info.
