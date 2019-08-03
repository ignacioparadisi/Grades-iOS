//
//  IPTextField.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IPTextField: UITextField {
    
    private var wasInitialized = false
    private let padding = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    override var placeholder: String? {
        didSet {
            setPlaceholder(placeholder)
        }
    }
    var borderColor: UIColor = ThemeManager.currentTheme.redColor
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    var isRequired: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    internal func initialize() {
        backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        textColor = ThemeManager.currentTheme.textColor
        keyboardAppearance = .dark
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.borderWidth = 2
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setPlaceholder(_ string: String?) {
        if var placeholder = string {
            if isRequired {
                placeholder += "*"
            }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.placeholderColor])
        }
    }
    
    func showErrorBorder() {
        let color = CABasicAnimation(keyPath: "borderColor")
        color.toValue = borderColor.cgColor
        color.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        color.isRemovedOnCompletion = false
        color.fillMode = .forwards
        self.layer.add(color, forKey: "color")
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor.darker(by: 4)
        }
        
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        }
        
        let color = CABasicAnimation(keyPath: "borderColor")
        if self.isRequired, self.isEmpty {
            color.toValue = borderColor.cgColor
        } else {
            color.toValue = UIColor.clear.cgColor
        }
        color.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        color.isRemovedOnCompletion = false
        color.fillMode = .forwards
        self.layer.add(color, forKey: "color")
        return true
    }
    
}
