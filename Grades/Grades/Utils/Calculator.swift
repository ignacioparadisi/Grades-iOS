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
    static func getAverageGrade(for items: [Gradable]) -> Float {
        var total: Float = 0.0
        for item in items {
            total += item.grade
        }
        return total / Float(items.count)
    }
    
    // TODO: This might change
    /// Get average grade for assignments
    /// It multiplies the grade times the percentage to get the actual grade
    ///
    /// - Parameter assignments: Assignments to be averaged
    /// - Returns: Average grade
    static func getGrade(for assignments: [AssignmentRealm]) -> Float {
        var total: Float = 0.0
        for assignment in assignments {
            total += assignment.grade * assignment.percentage
        }
        return total
    }
    
    // TODO: Probably delete this
    static func getGradesForAssignment(_ assignments: [AssignmentRealm], type: GradeType) -> Float {
        var grade: Float = 0.0
        let now = Date()
        for assignment in assignments {
            if assignment.deadline > now, type == .greater {
                grade += assignment.maxGrade * assignment.percentage
            } else {
                grade += assignment.grade * assignment.percentage
            }
        }
        return grade
    }
    
    // TODO: Probably delete this
    static func getGradesForSubjects(_ subjects: [SubjectRealm], type: GradeType) -> Float {
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
