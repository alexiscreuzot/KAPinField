//
//  KAPinField.swift
//  KAPinCode
//
//  Created by Alexis Creuzot on 15/10/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

// Mark: - KAPinFieldDelegate
public protocol KAPinFieldDelegate : AnyObject {
    func ka_pinField(_ field: KAPinField, didFinishWith code: String)
}

// Mark: - KAPinField Class
public class KAPinField : UITextField {
    
    // Mark: - Public vars
    public weak var ka_delegate : KAPinFieldDelegate? = nil
    
    public var isRightToLeft : Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    public var ka_numberOfCharacters: Int = 4 {
        didSet {
            precondition(ka_numberOfCharacters >= 1, "Number of character must be >= 1")
            self.setupUI()
        }
    }
    public var ka_validCharacters: String = "0123456789" {
        didSet {
            precondition(ka_validCharacters.count > 0, "There must be at least 1 valid character")
            precondition(!ka_validCharacters.contains(ka_token), "Valid characters can't contain token \"\(ka_token)\"")
            self.setupUI()
        }
    }
    public var ka_text : String {
        get { return invisibleText }
        set {
            self.invisibleField.text = newValue
            self.refreshUI()
        }
    }
    public var ka_font : KA_MonospacedFont? = .menlo(40){
        didSet{
            self.setupUI()
        }
    }
    public var ka_token: Character = "•" {
        didSet {
            precondition(!ka_validCharacters.contains(ka_token), "Valid characters can't contain token \"\(ka_token)\"")
            self.setupUI()
        }
    }
    public var ka_tokenColor : UIColor? {
        didSet {
            self.setupUI()
        }
    }
    public var ka_textColor : UIColor? {
        didSet {
            self.setupUI()
        }
    }
    public var ka_kerning : CGFloat = 20.0 {
        didSet {
            self.setupUI()
        }
    }
    public var ka_backColor : UIColor = UIColor.clear {
        didSet {
            self.setupUI()
        }
    }
    public var ka_backBorderColor : UIColor = UIColor.clear {
        didSet {
            self.setupUI()
        }
    }
    public var ka_backBorderWidth : CGFloat = 1 {
        didSet {
            self.setupUI()
        }
    }
    public var ka_backCornerRadius : CGFloat = 4 {
        didSet {
            self.setupUI()
        }
    }
    public var ka_backOffset : CGFloat = 4 {
        didSet {
            self.setupUI()
        }
    }
    public var ka_backFocusColor : UIColor? {
        didSet {
            self.refreshUI()
        }
    }
    public var ka_backBorderFocusColor : UIColor? {
        didSet {
            self.refreshUI()
        }
    }
    public var ka_backActiveColor : UIColor? {
        didSet {
            self.refreshUI()
        }
    }
    public var ka_backBorderActiveColor : UIColor? {
        didSet {
            self.refreshUI()
        }
    }
    
    // Mark: - Overriden vars
    public override var font: UIFont? {
        didSet{
            self.ka_font = nil
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
    private var attributes: [NSAttributedString.Key : Any] = [:]
    
    private var backViews = [UIView]()
    
    // Mark: - Lifecycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(self.invisibleField)
        self.invisibleField.frame = self.bounds
        
        // back views
        let myText = self.text ?? ""
        let nsText = NSString(string: myText)
        let frame = nsText.boundingRect(with: self.bounds.size,
                                        options: .usesLineFragmentOrigin,
                                        attributes: self.attributes,
                                        context: nil)
        
        
        let actualWidth = frame.width
            + (self.ka_kerning * CGFloat(self.ka_numberOfCharacters))
        let digitWidth = actualWidth / CGFloat(self.ka_numberOfCharacters)
        
        let offset = (self.bounds.width - actualWidth) / 2
        
        for (index, v) in self.backViews.enumerated() {
            let x = CGFloat(index) * digitWidth + offset
            var vFrame = CGRect(x: x,
                                y: 0,
                                width: digitWidth,
                                height: frame.height)
            vFrame.origin.x += self.ka_backOffset / 2
            vFrame.size.width -= self.ka_backOffset
            v.frame = vFrame
        }
    }
    
    private func setupUI() {
        
        // Only setup if view showing
        guard self.superview != nil else {
            return
        }
        
        // Change this for easy debug
        let alpha: CGFloat = 0.0
        self.invisibleField.backgroundColor =  UIColor.white.withAlphaComponent(alpha * 0.8)
        self.invisibleField.tintColor = UIColor.black.withAlphaComponent(alpha)
        self.invisibleField.textColor = UIColor.black.withAlphaComponent(alpha)
        
        // Prepare `invisibleField`
        self.invisibleField.text = ""
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
        self.tintColor = .clear // Hide cursor
        self.contentVerticalAlignment = .center
        
        // Set back views
        for v in self.backViews {
            v.removeFromSuperview()
        }
        self.backViews.removeAll(keepingCapacity: false)
        for _ in 0..<self.ka_numberOfCharacters {
            let v = UIView()
            v.backgroundColor = self.ka_backColor
            v.layer.borderColor = self.ka_backBorderColor.cgColor
            v.layer.borderWidth = self.ka_backBorderWidth
            v.layer.cornerRadius = self.ka_backCornerRadius
            backViews.append(v)
            self.addSubview(v)
            self.sendSubviewToBack(v)
        }
        
        // Delay fixes kerning offset issue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.refreshUI()
        }
    }
    
    // Mark: - Public functions
    
    override public func becomeFirstResponder() -> Bool {
        return self.invisibleField.becomeFirstResponder()
    }
    
    public func ka_animateFailure(_ completion : (() -> Void)? = nil) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion?()
        })
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction.init(name: .linear)
        animation.duration = 0.6
        animation.values = [-14.0, 14.0, -14.0, 14.0, -8.0, 8.0, -4.0, 4.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        
        CATransaction.commit()
    }
    
    public func ka_animateSuccess(with text: String, completion : (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            
            for v in self.backViews {
                v.alpha = 0
            }
            
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
        
        self.sizeToFit()
        
        for v in self.backViews {
            v.alpha = 1.0
        }
        
        if (UIPasteboard.general.string == self.invisibleText && isRightToLeft) {
            self.invisibleField.text = String(self.invisibleText.reversed())
        }
        
        self.sanitizeText()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let font =  self.ka_font?.font() ?? self.font ?? UIFont.preferredFont(forTextStyle: .headline)
        self.attributes = [ .paragraphStyle : paragraph,
                            .font : font,
                            .kern : self.ka_kerning]
        
        // Display
        let attString = NSMutableAttributedString(string: "")
        let loopStride = isRightToLeft
                    ? stride(from: ka_numberOfCharacters-1, to: -1, by: -1)
                    : stride(from: 0, to: ka_numberOfCharacters, by: 1)
        
        for i in loopStride {
            
            var string = ""
            if i < invisibleText.count {
                let index = invisibleText.index(string.startIndex, offsetBy: i)
                string = String(invisibleText[index])
            } else {
                string = String(ka_token)
            }
            
            // Color for active / inactive
            let backIndex = self.isRightToLeft ? self.ka_numberOfCharacters-i-1 : i
            let backView = self.backViews[backIndex]
            if string == String(ka_token) {
                attributes[.foregroundColor] = self.ka_tokenColor
                
                backView.backgroundColor = self.ka_backColor
                backView.layer.borderColor = self.ka_backBorderColor.cgColor
                
            } else {
                attributes[.foregroundColor] = self.ka_textColor
                backView.backgroundColor = self.ka_backActiveColor ?? self.ka_backColor
                backView.layer.borderColor = self.ka_backBorderActiveColor?.cgColor ?? self.ka_backBorderColor.cgColor
            }
            
            // Fix kerning-centering
            let indexForKernFix = isRightToLeft ? 0 : ka_numberOfCharacters-1
            if i == indexForKernFix {
                attributes[.kern] = 0.0
            }
            
            attString.append(NSAttributedString(string: string, attributes: attributes))
        }
        
        self.attributedText = attString
        
        if #available(iOS 11.0, *) {
            self.updateCursorPosition()
        }
        
        self.checkCodeValidity()
    }
    
    private func sanitizeText() {
        var text = self.invisibleField.text ?? ""
        text = String(text.lazy.filter(ka_validCharacters.contains))
        text = String(text.prefix(self.ka_numberOfCharacters))
        self.invisibleField.text = text
    }
    
    // Always position cursor on last valid character
    private func updateCursorPosition() {
        let offset = min(self.invisibleText.count, ka_numberOfCharacters)
        // Only works with a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let position = self.invisibleField.position(from: self.invisibleField.beginningOfDocument, offset: offset) {
                self.invisibleField.selectedTextRange = self.textRange(from: position, to: position)
                
                var backIndex = self.isRightToLeft ? self.ka_numberOfCharacters-offset-1 : offset
                backIndex = min(backIndex, self.ka_numberOfCharacters-1)
                backIndex = max(backIndex, 0)
                let backView = self.backViews[backIndex]
                backView.backgroundColor = self.ka_backFocusColor ?? self.ka_backColor
                backView.layer.borderColor = self.ka_backBorderFocusColor?.cgColor ?? self.ka_backBorderColor.cgColor
            }
        }
    }
    
    private func checkCodeValidity() {
        if self.invisibleText.count == self.ka_numberOfCharacters {
            if let pindDelegate = self.ka_delegate {
                
                let result = isRightToLeft ? String(self.invisibleText.reversed()) : self.invisibleText
                
                pindDelegate.ka_pinField(self, didFinishWith: result)
            } else {
                print("warning : No pinDelegate set for KAPinField")
            }
        }
    }
}

// Mark: - KA_MonospacedFont
// Helper to provide monospaced fonts via literal
public enum KA_MonospacedFont {
    
    case courier(CGFloat)
    case courierBold(CGFloat)
    case courierBoldOblique(CGFloat)
    case courierOblique(CGFloat)
    case courierNewBoldItalic(CGFloat)
    case courierNewBold(CGFloat)
    case courierNewItalic(CGFloat)
    case courierNew(CGFloat)
    case menloBold(CGFloat)
    case menloBoldItalic(CGFloat)
    case menloItalic(CGFloat)
    case menlo(CGFloat)
    
    func font() -> UIFont {
        switch self {
        case .courier(let size) :
            return UIFont(name: "Courier", size: size)!
        case .courierBold(let size) :
            return UIFont(name: "Courier-Bold", size: size)!
        case .courierBoldOblique(let size) :
            return UIFont(name: "Courier-BoldOblique", size: size)!
        case .courierOblique(let size) :
            return UIFont(name: "Courier-Oblique", size: size)!
        case .courierNewBoldItalic(let size) :
            return UIFont(name: "CourierNewPS-BoldItalicMT", size: size)!
        case .courierNewBold(let size) :
            return UIFont(name: "CourierNewPS-BoldMT", size: size)!
        case .courierNewItalic(let size) :
            return UIFont(name: "CourierNewPS-ItalicMT", size: size)!
        case .courierNew(let size) :
            return UIFont(name: "CourierNewPSMT", size: size)!
        case .menloBold(let size) :
            return UIFont(name: "Menlo-Bold", size: size)!
        case .menloBoldItalic(let size) :
            return UIFont(name: "Menlo-BoldItalic", size: size)!
        case .menloItalic(let size) :
            return UIFont(name: "Menlo-Italic", size: size)!
        case .menlo(let size) :
            return UIFont(name: "Menlo-Regular", size: size)!
        }
    }
}
