//
//  UIColor+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let accentColor = UIColor.systemBlue
    
    /// Creates a UIColor from RGB
    ///
    /// - Parameters:
    ///   - red: Red quantity
    ///   - green: Green quantity
    ///   - blue: Blue quantity
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
    
    /// Creates a UIColor from an hexadecimal value
    ///
    /// - Parameter hex: Hexadecimal value (0xFFFFFF)
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
    
    /// Get color depending on grade
    /// Green if is a good grade
    /// Yellow if is a normal grade
    /// Red if is a bad grade
    ///
    /// - Parameter gradable: Gradable to evaluate
    /// - Returns: UIColor depending on grade
    static func getColor(for gradable: Gradable) -> UIColor {
        return getColor(for: gradable.grade, maxGrade: gradable.maxGrade, minGrade: gradable.minGrade)
    }
    
    static func getColor(for grade: Float, maxGrade: Float, minGrade: Float) -> UIColor {
        let roundedGrade = grade.rounded()
        let minGreenGrade = maxGrade - ((maxGrade - minGrade) / 3)
        if roundedGrade <= maxGrade, roundedGrade >= minGreenGrade {
            return .systemGreen
        } else if roundedGrade < minGreenGrade, roundedGrade >= minGrade {
            return .systemYellow
        } else {
            return .systemRed
        }
    }
    
    /// Darkests a color
    ///
    /// - Parameter percentage: Percentage of darkness
    /// - Returns: A darker shade of same color
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
