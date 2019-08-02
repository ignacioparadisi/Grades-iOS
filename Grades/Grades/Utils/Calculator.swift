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
    
    static func getGradesForAssignment(_ assignments: [Assignment], type: GradeType) -> Float {
        var grade: Float = 0.0
        let now = Date()
        for assignment in assignments {
            if assignment.date > now, type == .greater {
                grade += assignment.maxGrade * assignment.percentage
            } else {
                grade += assignment.grade * assignment.percentage
            }
        }
        return grade
    }
    
    static func getGradesForSubjects(_ subjects: [Subject], type: GradeType) -> Float {
        var grade: Float = 0.0
        for subject in subjects {
            if type == .greater {
                grade += subject.maxGrade
            } else {
                grade += subject.grade
            }
        }
        return grade / Float(subjects.count)
    }
}
