[![Platform](https://img.shields.io/cocoapods/p/KAPinField.svg?style=flat)](https://alamofire.github.io/KAPinField)
[![Language](https://img.shields.io/badge/swift-5.0-blue.svg)](http://swift.org)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/KAPinField.svg)](https://img.shields.io/cocoapods/v/KAPinField.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-blue.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/kirualex/KAPinField.svg?branch=master)](https://travis-ci.org/kirualex/KAPinField)
[![Pod License](http://img.shields.io/cocoapods/l/SDWebImage.svg?style=flat)](https://raw.githubusercontent.com/kirualex/SwiftyGif/master/LICENSE)

# KAPinField
Lightweight pin code field library for iOS, written in Swift.
This library also plays well with the all new iOS 12 one time password autofill.

<table>
  <tr>
    <td>
      <img src="https://github.com/kirualex/KAPinField/blob/4.0.0/preview1.gif"  width="400"  />
    </td>
  </tr>
  <tr>
  <td align=center>
      Example
    </td>
   </tr>
 </table>

## Install
With Cocoapods
`pod 'KAPinField'`

## Usage
```swift
import KAPinField

class MyController : UIVIewController {
  ...
}
```

### Storyboard
You can add an UITextField directly in your Storyboard scene and declare it as `KAPinField`. It will automagically become a pin field. You can then customize it from the inspector view to suit your needs.

### Delegation
Don't forget to set the delegate likeso :
```swift

@IBOutlet var pinField: KAPinField!

override func viewDidLoad() {
        super.viewDidLoad()
        pinField.properties.delegate = self
        ...
}
```

One simple method will be called on your delegate
```swift
extension MyController : KAPinFieldDelegate {
  func pinField(_ field: KAPinField, didFinishWith code: String) {
    print("didFinishWith : \(code)")
  }
}
```

### Properties
All the logic properties are available in the `KAPinFieldProperties` struct named `properties`.

##### Logic
```swift
pinField.properties.token = "-" // Default to "•"
pinField.properties.numberOfCharacters = 5 // Default to 4
pinField.properties.validCharacters = "0123456789+#?" // Default to only numbers, "0123456789"
pinField.properties.text = "123" // You can set part or all of the text
pinField.properties.animateFocus = true // Animate the currently focused token
pinField.properties.isSecure = false // Secure pinField will hide actual input
pinField.properties.secureToken = "*" // Token used to hide actual character input when using isSecure = true
```

##### Styling
All the styling can be done via the `KAPinFieldAppearance` struct named `appearance`.

```swift
pinField.appearance.font = .menloBold(40) // Default to appearance.MonospacedFont.menlo(40)
pinField.appearance.kerning = 20 // Space between characters, default to 16
pinField.appearance.textColor = UIColor.white.withAlphaComponent(1.0) // Default to nib color or black if initialized programmatically.
pinField.appearance.tokenColor = UIColor.black.withAlphaComponent(0.3) // token color, default to text color
pinField.appearance.tokenFocusColor = UIColor.black.withAlphaComponent(0.3)  // token focus color, default to token color
pinField.appearance.backOffset = 8 // Backviews spacing between each other
pinField.appearance.backColor = UIColor.clear
pinField.appearance.backBorderWidth = 1
pinField.appearance.backBorderColor = UIColor.white.withAlphaComponent(0.2)
pinField.appearance.backCornerRadius = 4
pinField.appearance.backFocusColor = UIColor.clear
pinField.appearance.backBorderFocusColor = UIColor.white.withAlphaComponent(0.8)
pinField.appearance.backActiveColor = UIColor.clear
pinField.appearance.backBorderActiveColor = UIColor.white
```

### Font
A [monospaced font](https://en.wikipedia.org/wiki/Monospaced_font) is highly recommended in order to avoid horizontal offsetting during typing. For this purpose, a handy helper is available to allow you to access native iOS monospaced fonts.
To use it, just set `appearance.font` with a enum value from `appearance.MonospacedFont`.
You can of course still use your own font by setting the default `font` property on KAPinField.

### Animation
`KAPinField` also provide some eye-candy for failure and success.

##### Success
```swift
pinfield.animateSuccess(with: "👍") {
    print("Success")
}
```

##### Failure
```swift
pinfield.animateFailure() {
   print("Failure")
}
```
