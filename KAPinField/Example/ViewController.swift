//
//  ViewController.swift
//  KAPinCode
//
//  Created by Alexis Creuzot on 15/10/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var targetCodeLabel: UILabel!
    @IBOutlet var pinField: KAPinField!
    var targetCode = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -- Delegation --
        pinField.ka_delegate = self
        
        // -- Properties --
        self.refreshPinField()
        
        // -- Styling --
        pinField.ka_tokenColor = UIColor.black.withAlphaComponent(0.3)
        pinField.ka_textColor = UIColor.white.withAlphaComponent(1.0)
        pinField.ka_font = .menlo(40)
        pinField.ka_kerning = 20
        
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
        // Random ka_token and ka_numberOfCharacters
        let randomSeparator = ["●", "*", "—"].randomElement()!
        pinField.ka_token = Character(randomSeparator)
        pinField.ka_numberOfCharacters = [4, 5].randomElement()!
        
        // Random target code
        targetCode = self.randomCode(numDigits: pinField.ka_numberOfCharacters)
        targetCodeLabel.text = "Code : \(targetCode)"
        UIPasteboard.general.string = targetCode
    }
}

// Mark: - KAPinFieldDelegate
extension ViewController : KAPinFieldDelegate {
    func ka_pinField(_ field: KAPinField, didFinishWith code: String) {
        print("didFinishWith : \(code)")
        
        // Randomly show success or failure
        if code != targetCode {
            field.ka_animateFailure() {
                print("Failure")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                field.ka_animateSuccess(with: "👍") {
                    print("Success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.refreshPinField()
                    }
                }
            }
        }
    }
}

