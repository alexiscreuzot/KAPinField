//
//  ViewController.swift
//  KAPinCode
//
//  Created by Alexis Creuzot on 15/10/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

enum Style : String, CaseIterable {
    case blue
    case light
    case dark
}

class ViewController: UIViewController {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var targetCodeLabel: UILabel!
    @IBOutlet var pinField: KAPinField!
    @IBOutlet var refreshButton: UIButton!
    
    private let blueColor = UIColor(red: 34/255, green: 151/255, blue: 248/255, alpha: 1.0)
    private var targetCode = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl.removeAllSegments()
        for (index, style) in Style.allCases.enumerated() {
            self.segmentControl.insertSegment(withTitle: style.rawValue.capitalized, at: index, animated: false)
        }
        self.segmentControl.selectedSegmentIndex = 0
        
        // -- Appearance --
        self.updateStyle()
        
        // -- Properties --
        pinField.properties.delegate = self
        self.refreshPinField()
        
        // Get focus
        _ = pinField.becomeFirstResponder()
    }
    
    func randomCode(numDigits: Int) -> String {
        var string = ""
        for _ in 0..<numDigits {
            string += String(Int.random(in: 0...9))
        }
        return string
    }
    
    @IBAction func refreshPinField() {
        
        // Random numberOfCharacters
        pinField.properties.numberOfCharacters = [4, 5].randomElement()!
        
        // Random target code
        targetCode = self.randomCode(numDigits: pinField.properties.numberOfCharacters)
        targetCodeLabel.text = "Code : \(targetCode)"
        UIPasteboard.general.string = targetCode
        
        self.updateStyle()
    }
    
    @IBAction func updateStyle() {
        let style = Style.allCases[self.segmentControl.selectedSegmentIndex]
        UIView.animate(withDuration: 0.3) {
            self.setStyle(style)
        }
    }
    
    func setStyle(_ style: Style) {
        switch style {
        case .blue:
            self.view.backgroundColor = self.blueColor
            self.segmentControl.tintColor = UIColor.white
            self.targetCodeLabel.textColor = UIColor.white.withAlphaComponent(0.8)
            
            pinField.properties.token = "•"
            
            pinField.appearance.tokenColor = UIColor.white.withAlphaComponent(0.2)
            pinField.appearance.tokenFocusColor = UIColor.white
            pinField.appearance.textColor = UIColor.white
            pinField.appearance.font = .courier(50)
            pinField.appearance.kerning = 18
            pinField.appearance.backOffset = 8
            pinField.appearance.backColor = UIColor.clear
            pinField.appearance.backBorderColor = UIColor.clear
            pinField.appearance.backFocusColor = UIColor.clear
            pinField.appearance.backBorderFocusColor = UIColor.clear
            pinField.appearance.backActiveColor = UIColor.clear
            pinField.appearance.backBorderActiveColor = UIColor.clear
            pinField.appearance.backRounded = false
            
            self.refreshButton.setTitleColor(UIColor.white, for: .normal)
            self.refreshButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            break
        case .light:
            self.view.backgroundColor = UIColor.white
            self.segmentControl.tintColor = self.blueColor
            self.targetCodeLabel.textColor = self.blueColor.withAlphaComponent(0.8)
            
            pinField.properties.token = "-"
            
            let startIndex = self.targetCode.index(self.targetCode.startIndex, offsetBy: 0)
            let endIndex = self.targetCode.index(self.targetCode.startIndex, offsetBy: 1)
            pinField.text = String(self.targetCode[startIndex...endIndex])
            
            pinField.appearance.tokenColor = self.blueColor.withAlphaComponent(0.2)
            pinField.appearance.tokenFocusColor = self.blueColor.withAlphaComponent(0.2)
            pinField.appearance.textColor = self.blueColor
            pinField.appearance.font = .menlo(40)
            pinField.appearance.kerning = 24
            pinField.appearance.backOffset = 5
            pinField.appearance.backColor = UIColor.clear
            pinField.appearance.backBorderWidth = 1
            pinField.appearance.backBorderColor = self.blueColor.withAlphaComponent(0.2)
            pinField.appearance.backCornerRadius = 4
            pinField.appearance.backFocusColor = UIColor.clear
            pinField.appearance.backBorderFocusColor = self.blueColor.withAlphaComponent(0.8)
            pinField.appearance.backActiveColor = UIColor.clear
            pinField.appearance.backBorderActiveColor = self.blueColor
            pinField.appearance.backRounded = false
            
            self.refreshButton.setTitleColor(self.blueColor, for: .normal)
            self.refreshButton.backgroundColor = UIColor.clear
            break
        case .dark:
            self.view.backgroundColor = self.blueColor.withAlphaComponent(0.06)
            self.segmentControl.tintColor = UIColor.white
            self.targetCodeLabel.textColor = UIColor.white.withAlphaComponent(0.8)
            
            pinField.properties.token = "-"
            
            pinField.appearance.tokenColor = UIColor.clear
            pinField.appearance.tokenFocusColor = UIColor.clear
            pinField.appearance.textColor = UIColor.white
            pinField.appearance.font = .menlo(40)
            pinField.appearance.kerning = 36
            pinField.appearance.backOffset = 2
            pinField.appearance.backColor = self.blueColor.withAlphaComponent(0.4)
            pinField.appearance.backBorderWidth = 0
            pinField.appearance.backFocusColor = self.blueColor.withAlphaComponent(0.4)
            pinField.appearance.backActiveColor = self.blueColor
            pinField.appearance.backRounded = true
            
            self.refreshButton.setTitleColor(UIColor.white, for: .normal)
            self.refreshButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            break
        }
        
        self.refreshButton.layer.cornerRadius = 5
    }
}

// Mark: - KAPinFieldDelegate
extension ViewController : KAPinFieldDelegate {
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        print("didFinishWith : \(code)")
        
        // Randomly show success or failure
        if code != targetCode {
            field.animateFailure() {
                print("Failure")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                field.animateSuccess(with: "👍") {
                    print("Success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.refreshPinField()
                    }
                }
            }
        }
    }
}

