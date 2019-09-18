//
//  UIFont+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

enum FontStyle: String {
    case light = "-Light"
    case regular = ""
    case medium = "-Medium"
    case bold = "-Bold"
}

extension UIFont {
    
    convenience init(name: String, style: FontStyle, size: CGFloat) {
        self.init(name: name + "\(style.rawValue)", size: size)!
    }
    
    static func metrics(style: FontStyle, size: CGFloat, forTextSyle: UIFont.TextStyle) -> UIFont {
        let font = UIFont(name: "HelveticaNeue", style: style, size: size)
        return UIFontMetrics(forTextStyle: forTextSyle).scaledFont(for: font)
    }
    
}
