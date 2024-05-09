//
//  Calculator.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Calculator {
    
    enum GradeType {
        case greater
        case lower
    }
    
    
    /// Gets average grade from an array of gradables
    ///
    /// - Parameter items: Gradables to be averaged
    /// - Returns: Average grade
    static func getAverageGrade(for items: [Gradable], parent: Gradable) -> Float {
        var total: Float = 0.0
        for item in items where !item.isDeleted {
            total += (item.grade * parent.maxGrade) / item.maxGrade
        }
        return total / Float(items.count)
    }
    
    static func getAverage(for terms: [Term]) -> Float {
        var total: Float = 0.0
        for term in terms where !term.isDeleted {
            total += (term.grade * 20.0) / term.maxGrade
        }
        return total / Float(terms.count)
    }
    
    /// Get average grade for assignments
    /// It multiplies the grade times the percentage to get the actual grade
    ///
    /// - Parameter assignments: Assignments to be averaged
    /// - Returns: Average grade
    static func getGrade(for assignments: [Assignment], parent: Gradable) -> Float {
        var total: Float = 0.0
        for assignment in assignments where !assignment.isDeleted {
            if assignment.percentage == -1 {
                total += ((assignment.grade * parent.maxGrade) / assignment.maxGrade)
            } else {
                total += ((assignment.grade * parent.maxGrade) / assignment.maxGrade) * assignment.percentage
            }
        }
        return total
    }
}
