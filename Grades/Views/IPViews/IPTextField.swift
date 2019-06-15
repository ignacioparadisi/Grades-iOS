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
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    
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
    
    private func initialize() {
        backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        textColor = ThemeManager.currentTheme.textColor
        layer.cornerRadius = 10
        layer.masksToBounds = false
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
        if let placeholder = string {
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.placeholderColor])
        }
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
        return true
    }
    
}
