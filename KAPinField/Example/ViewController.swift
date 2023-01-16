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
        
        // -- Properties --
        self.setupPinfield()
        
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
    
    @IBAction func setupPinfield() {
        
        // Random numberOfCharacters
        pinField.text = ""
        
        pinField.updateProperties { properties in
            properties.numberOfCharacters = [4,5].randomElement()!
            properties.delegate = self
        }
        
        // Random target code
        targetCode = self.randomCode(numDigits: pinField.properties.numberOfCharacters)
        targetCodeLabel.text = "Code : \(targetCode)"
        UIPasteboard.general.string = targetCode
        
        self.refresh()
    }
    
    @IBAction func toggleSecure() {
        self.refresh()
        self.pinField.becomeFirstResponder()
    }
    
    func refresh() {
                
        self.targetCodeLabel.textColor = UIColor.label.withAlphaComponent(0.8)
        
        pinField.updateProperties { properties in
            properties.isSecure = self.secureSwitch.isOn
            properties.token = "•"
            properties.animateFocus = false
            properties.isUppercased = false
            properties.validCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        }
        
        pinField.updateAppearence { appearance in
            appearance.tokenColor = UIColor.clear
            appearance.tokenFocusColor = UIColor.clear
            appearance.textColor = UIColor.label
            appearance.font = .menlo(40)
            appearance.kerning = 24
            appearance.backOffset = 8
            appearance.backColor = UIColor.clear
            appearance.backBorderWidth = 1
            appearance.backBorderColor = UIColor.label.withAlphaComponent(0.2)
            appearance.backCornerRadius = 4
            appearance.backFocusColor = UIColor.clear
            appearance.backBorderFocusColor = UIColor.systemBlue
            appearance.backActiveColor = UIColor.clear
            appearance.backBorderActiveColor = UIColor.label
            appearance.backRounded = false
        }
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
                self.setupPinfield()
            }
            
        }
    }
}

