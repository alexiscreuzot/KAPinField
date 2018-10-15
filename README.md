[![Language](https://img.shields.io/badge/swift-4.2-blue.svg)](http://swift.org)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/KAPinField.svg)](https://img.shields.io/cocoapods/v/KAPinField.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/kirualex/KAPinField.svg?branch=master)](https://travis-ci.org/kirualex/KAPinField)
[![Pod License](http://img.shields.io/cocoapods/l/SDWebImage.svg?style=flat)](https://raw.githubusercontent.com/kirualex/SwiftyGif/master/LICENSE)

# KAPinField
Lightweight Pin Code Field library for iOS, written in Swift

## Install
Using Cocoapods
`pod 'KAPinField'`

## Usage
### Delegation
One simple delegate method called when the pin code is filled
```swift
        protocol KAPinFieldDelegate {
          func pinfField(_ field: KAPinField, didFinishWith code: String)
        }
```
### Properties
```swift
        pinField.token = "◉" // Default to "•"
        pinField.numberOfCharacters = 5 // Default to 4
        pinField.validCharacters = "0123456789+#?" // Default to "0123456789"
        pinField.pinText = "123" // You can set part or all of the pin text
```
### Styling
You can use the native `defaultTextAttributes` to style `KAPinField`.
It's highly recommended to use one of [iOS monospaced fonts](https://stackoverflow.com/a/22620172/421786) to avoid weird text offset while editting the field.
```swift
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes : [NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraph,
            .font : UIFont(name: "Menlo-Regular", size: 40)!,
            .kern : 14,
            .foregroundColor : UIColor.white]
        pinField.defaultTextAttributes = attributes
```
### Animation
`KAPinField` also provide some eye-candy for failure and success.
##### Success
```swift
        field.animateSuccess(with: "👍") {
            print("Success")
        }
```
##### Failure
```swift
        field.animateFailure() {
           print("Failure")
        }
```
