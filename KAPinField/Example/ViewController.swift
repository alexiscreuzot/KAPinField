//
//  ViewController.swift
//  KAPinCode
//
//  Created by Alexis Creuzot on 15/10/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pinField: KAPinField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -- Public properties --
        pinField.pinDelegate = self
        pinField.token = "◉" // Default to "•"
        pinField.numberOfCharacters = 5 // Default to 4
        pinField.validCharacters = "0123456789+#?" // Default to "0123456789"
        pinField.pinText = "123" // You can set part or all of the pin text
        
        // -- Styling --
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes : [NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraph,
            .font : UIFont(name: "Menlo-Regular", size: 40)!,
            .kern : 14,
            .foregroundColor : UIColor.white]
        pinField.defaultTextAttributes = attributes
    }
}

// Mark: - KAPinFieldDelegate
extension ViewController : KAPinFieldDelegate {
    func pinfField(_ field: KAPinField, didFinishWith code: String) {
        print("didFinishWith : \(code)")
        
        // Randomly show success or failure
        if Int.random(in: 0...1) == 0 {
            field.animateFailure() {
                print("Failure")
            }
        } else {
            field.animateSuccess(with: "👍") {
                print("Success")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.pinField.pinText = ""
                }
            }
        }
    }
}

