[![Language](https://img.shields.io/badge/swift-5.0-blue.svg)](http://swift.org)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/KAPinField.svg)](https://img.shields.io/cocoapods/v/KAPinField.svg)
[![Build Status](https://travis-ci.org/kirualex/KAPinField.svg?branch=master)](https://travis-ci.org/kirualex/KAPinField)
[![Pod License](http://img.shields.io/cocoapods/l/SDWebImage.svg?style=flat)](https://raw.githubusercontent.com/kirualex/SwiftyGif/master/LICENSE)

# KAPinField
Lightweight pin code field library for iOS, written in Swift.
This library also plays well with the all new iOS 12 one time password autofill.

<table>
  <tr>
    <td>
      <img src="https://github.com/kirualex/KAPinField/blob/backviews/preview1.gif"  width="360"  />
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
        pinField.ka_delegate = self
        ...
}
```

One simple method will be called on your delegate
```swift
extension MyController : KAPinFieldDelegate {
  func ka_pinField(_ field: KAPinField, didFinishWith code: String) {
    print("didFinishWith : \(code)")
  }
}
```

### Properties
All the properties you need for KAPinField are previxed with `ka_`.

##### Logic
```swift
pinField.ka_token = "-" // Default to "•"
pinField.ka_numberOfCharacters = 5 // Default to 4
pinField.ka_validCharacters = "0123456789+#?" // Default to only numbers, "0123456789"
pinField.ka_text = "123" // You can set part or all of the text
```

##### Styling
```swift
pinField.ka_textColor = UIColor.white.withAlphaComponent(1.0) // Default to nib color or black if initialized programmatically.
pinField.ka_tokenColor = UIColor.black.withAlphaComponent(0.3) // token color, default to text color
pinField.ka_font = .menloBold(40) // Default to KA_MonospacedFont.menlo(40)
pinField.ka_kerning = 20 // Space between characters, default to 16

// Back views
pinField.ka_backOffset = 8
pinField.ka_backColor = UIColor.clear
pinField.ka_backBorderWidth = 1
pinField.ka_backBorderColor = UIColor.white.withAlphaComponent(0.2)
pinField.ka_backCornerRadius = 4
pinField.ka_backFocusColor = UIColor.clear
pinField.ka_backBorderFocusColor = UIColor.white.withAlphaComponent(0.8)
pinField.ka_backActiveColor = UIColor.clear
pinField.ka_backBorderActiveColor = UIColor.white
```

### Font
A [monospaced font](https://en.wikipedia.org/wiki/Monospaced_font) is highly recommended in order to avoid horizontal offsetting during typing. For this purpose, a handy helper is available to allow you to access native iOS monospaced fonts.
To use it, just set `ka_font` with a enum value from `KA_MonospacedFont`.
You can of course still use your own font by setting the default `font` property on KAPinField.

### Animation
`KAPinField` also provide some eye-candy for failure and success. As for properties, those methods are prefixed with `ka_`.

##### Success
```swift
field.ka_animateSuccess(with: "👍") {
    print("Success")
}
```

##### Failure
```swift
field.ka_animateFailure() {
   print("Failure")
}
```
