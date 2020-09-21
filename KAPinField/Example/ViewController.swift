//
//  ViewController.swift
//  KAPinCode
//
//  Created by Alexis Creuzot on 15/10/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var secureSwitch: UISwitch!
    @IBOutlet var secureLabel: UILabel!
    @IBOutlet var targetCodeLabel: UILabel!
    @IBOutlet var pinField: KAPinField!
    @IBOutlet var refreshButton: UIButton!
    
    @IBOutlet var keyboardheightConstraint: NSLayoutConstraint!
    
    private var targetCode = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -- Appearance --
        self.updateStyle()
        
        // -- Properties --
        pinField.properties.delegate = self
        self.refreshPinField()
        
        // Get focus
        pinField.becomeFirstResponder()
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
        pinField.text = ""
        pinField.properties.numberOfCharacters = [4,5].randomElement()!
        
        // Random target code
        targetCode = self.randomCode(numDigits: pinField.properties.numberOfCharacters)
        targetCodeLabel.text = "Code : \(targetCode)"
        UIPasteboard.general.string = targetCode
        
        self.updateStyle()
    }
    
    func updateStyle() {
        
        pinField.properties.isSecure = self.secureSwitch.isOn
        
        self.targetCodeLabel.textColor = UIColor.label.withAlphaComponent(0.8)
        
        pinField.properties.token = "-"
        pinField.properties.animateFocus = false
        pinField.properties.isUppercased = false
        pinField.properties.validCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        
        //        let startIndex = self.targetCode.index(self.targetCode.startIndex, offsetBy: 0)
        //        let endIndex = self.targetCode.index(self.targetCode.startIndex, offsetBy: 1)
        //        pinField.text = String(self.targetCode[startIndex...endIndex])
        
        pinField.appearance.tokenColor = UIColor.label.withAlphaComponent(0.2)
        pinField.appearance.tokenFocusColor = UIColor.label.withAlphaComponent(0.2)
        pinField.appearance.textColor = UIColor.label
        pinField.appearance.font = .courierBold(40)
        pinField.appearance.kerning = 24
        pinField.appearance.backOffset = 5
        pinField.appearance.backColor = UIColor.clear
        pinField.appearance.backBorderWidth = 1
        pinField.appearance.backBorderColor = UIColor.label.withAlphaComponent(0.2)
        pinField.appearance.backCornerRadius = 4
        pinField.appearance.backFocusColor = UIColor.clear
        pinField.appearance.backBorderFocusColor = UIColor.label.withAlphaComponent(0.8)
        pinField.appearance.backActiveColor = UIColor.clear
        pinField.appearance.backBorderActiveColor = UIColor.label
        pinField.appearance.backRounded = false
    }
}

// Mark: - KAPinFieldDelegate
extension ViewController : KAPinFieldDelegate {
    func pinField(_ field: KAPinField, didChangeTo string: String, isValid: Bool) {
        if isValid {
            print("Valid input: \(string) ")
        } else {
            print("Invalid input: \(string) ")
            self.pinField.animateFailure()
        }
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        print("didFinishWith : \(code)")
        
        // Randomly show success or failure
        if code != targetCode {
            print("Failure")
            field.animateFailure()
        } else {
            print("Success")
            field.animateSuccess(with: "👍") {
                self.refreshPinField()
            }
            
        }
    }
}

