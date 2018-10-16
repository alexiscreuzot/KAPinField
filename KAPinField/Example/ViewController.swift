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
        pinField.pinDelegate = self
        
        // -- Properties --
        self.refreshPinField()
        
        // -- Styling --
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes : [NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraph,
            .font : UIFont(name: "Menlo-Regular", size: 40)!,
            .kern : 14,
            .foregroundColor : UIColor.white]
        pinField.defaultTextAttributes = attributes
        
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
        let token: Character = ["●", "◉", "◒", "◆", "◼", "△", "▲"].randomElement()!
        let nbChars = [3,4,5,6].randomElement()!
        
        pinField.token = token
        pinField.numberOfCharacters = nbChars
        targetCode = self.randomCode(numDigits: nbChars)
        targetCodeLabel.text = "Code : \(targetCode)"
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
            field.animateSuccess(with: "👍") {
                print("Success")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.pinField.pinText = ""
                }
            }
        }
    }
}

