//
//  KAPinField.swift
//  KAPinCode
//
//  Created by Alexis Creuzot on 15/10/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

protocol KAPinFieldDelegate {
    func pinField(_ field: KAPinField, didFinishWith code: String)
}

class KAPinField : UITextField {
    
    // Mark: - Public vars
    
    public var token: Character = "•" {
        didSet {
            precondition(!validCharacters.contains(token), "Valid characters can't contain token \"\(token)\"")
            self.setupUI()
        }
    }
    public var numberOfCharacters: Int = 4 {
        didSet {
            precondition(numberOfCharacters >= 1, "Number of character must be >= 1")
            self.setupUI()
        }
    }
    public var validCharacters: String = "0123456789" {
        didSet {
            precondition(validCharacters.count > 0, "There must be at least 1 valid character")
            precondition(!validCharacters.contains(token), "Valid characters can't contain token \"\(token)\"")
            self.setupUI()
        }
    }
    public var pinDelegate : KAPinFieldDelegate? = nil
    public var pinText : String {
        get { return invisibleText }
        set {
            self.invisibleField.text = newValue
            self.refreshUI()
        }
    }
    
    // Mark: - Private vars
    
    // Uses an invisible UITextField to handle text
    // this is necessary for iOS12 .oneTimePassword feature
    private var invisibleField = UITextField()
    private var invisibleText : String {
        get {
            return invisibleField.text ?? ""
        }
        set {
            self.refreshUI()
        }
    }
    
    // Mark: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(self.invisibleField)
        self.invisibleField.frame = self.bounds
    }
    
    private func setupUI() {
        
        // Change this for easy debug
        let alpha: CGFloat = 0.0
        self.invisibleField.backgroundColor =  UIColor.white.withAlphaComponent(alpha * 0.8)
        self.invisibleField.tintColor = UIColor.black.withAlphaComponent(alpha)
        self.invisibleField.textColor = UIColor.black.withAlphaComponent(alpha)
        
        // Prepare `invisibleField`
        self.invisibleField.keyboardType = .numberPad
        self.invisibleField.textAlignment = .center
        if #available(iOS 12.0, *) {
            // Show possible prediction on iOS >= 12
            self.invisibleField.textContentType = .oneTimeCode
            self.invisibleField.autocorrectionType = .yes
        }
        self.addSubview(self.invisibleField)
        self.invisibleField.addTarget(self, action: #selector(refreshUI), for: .allTouchEvents)
        self.invisibleField.addTarget(self, action: #selector(refreshUI), for: .editingChanged)
        
        // Prepare visible field
        self.tintColor = .white // Hide cursor
        
        self.refreshUI()
    }
    
    // Mark: - Public functions
    
    override func becomeFirstResponder() -> Bool {
        return self.invisibleField.becomeFirstResponder()
    }
    
    func animateFailure(_ completion : (() -> Void)? = nil) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion?()
        })
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = 3
        animation.duration = CFTimeInterval(0.2 / animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        
        CATransaction.commit()
    }
    
    func animateSuccess(with text: String, completion : (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.alpha = 0
        }) { _ in
            self.text = text
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
                self.alpha = 1.0
            }) { _ in
                completion?()
            }
        }
    }
    
    // Mark: - Private function
    
    // Updates textfield content
    @objc private func refreshUI() {
        
        self.sanitizeText()
        
        // Display
        var txt = ""
        for i in 0..<numberOfCharacters {
            if i < invisibleText.count {
                let index = invisibleText.index(txt.startIndex, offsetBy: i)
                txt += String(invisibleText[index])
            } else {
                txt += String(token)
            }
        }
        
        self.text = txt
        
        self.updatePosition()
        
        // Check
        self.checkCodeValidity()
    }
    
    func sanitizeText() {
        var text = self.invisibleField.text ?? ""
        text = String(text.lazy.filter(validCharacters.contains))
        text = String(text.prefix(self.numberOfCharacters))
        self.invisibleField.text = text
    }
    
    // Always position cursor on last valid character
    private func updatePosition() {
        let offset = min(self.invisibleText.count, numberOfCharacters)
        // Only works with a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let position = self.invisibleField.position(from: self.invisibleField.beginningOfDocument, offset: offset) {
                self.invisibleField.selectedTextRange = self.textRange(from: position, to: position)
            }
        }
    }
    
    func checkCodeValidity() {
        if self.invisibleText.count == self.numberOfCharacters {
            if let pindDelegate = self.pinDelegate {
                pindDelegate.pinField(self, didFinishWith: self.invisibleText)
            } else {
                print("warning : No pinDelegate set for KAPinField")
            }
        }
    }
}
