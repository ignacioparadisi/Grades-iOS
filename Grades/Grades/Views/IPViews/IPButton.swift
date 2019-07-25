//
//  IPButton.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IPButton: UIButton {
    
    private var wasInitialized = false
    private let padding = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    var highlightDarknessPercentage: CGFloat = 10
    var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = self.isHighlighted ? self.color?.darker(by: self.highlightDarknessPercentage) : self.color
            }
            shrink(down: isHighlighted)
        }
    }
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled ? self.color : ThemeManager.currentTheme.disabledButtonBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    private func initialize() {
        layer.cornerRadius = 10.0
        setTitleColor(ThemeManager.currentTheme.textColor, for: .normal)
        setTitleColor(ThemeManager.currentTheme.disabledButtonTextColor, for: .disabled)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel?.adjustsFontForContentSizeCategory = true
        contentEdgeInsets = padding
    }
    
}
