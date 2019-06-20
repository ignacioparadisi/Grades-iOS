//
//  UIColor+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
    
    static func getColor(for qualificationable: Qualificationable) -> UIColor {
        let roundedQualification = qualificationable.qualification.rounded()
        let minGreenQualification = qualificationable.maxQualification - ((qualificationable.maxQualification - qualificationable.minQualification) / 3)
        if roundedQualification <= qualificationable.maxQualification, roundedQualification >= minGreenQualification {
            return ThemeManager.currentTheme.greenColor
        } else if roundedQualification < minGreenQualification, roundedQualification >= qualificationable.minQualification {
            return ThemeManager.currentTheme.yellowColor
        } else {
            return ThemeManager.currentTheme.redColor
        }
    }
    
    func darker(by percentage: CGFloat = 10.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 10.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
