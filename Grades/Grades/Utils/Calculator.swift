//
//  Calculator.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Calculator {
    
    static func getAverageGrade(for items: [Gradable]) -> Float {
        var total: Float = 0.0
        for item in items {
            total += item.grade
        }
        return total / Float(items.count)
    }
    
    static func getGrade(for assignments: [Assignment]) -> Float {
        var total: Float = 0.0
        for assignment in assignments {
            total += assignment.grade * assignment.percentage
        }
        return total
    }
}
