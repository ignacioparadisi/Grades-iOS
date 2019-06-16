//
//  Calculator.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Calculator {
    
    static func getAverageQualification(for items: [Qualificationable]) -> Float {
        var total: Float = 0.0
        for item in items {
            total += item.qualification
        }
        return total / Float(items.count)
    }
    
    static func getQualification(for assignments: [Assignment]) -> Float {
        var total: Float = 0.0
        for assignment in assignments {
            total += assignment.qualification * assignment.percentage
        }
        return total
    }
}
