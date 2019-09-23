//
//  Assignment+CoreDataClass.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/22/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Assignment)
public class Assignment: Gradable {
    
    static func create(name: String, grade: Float = 0.0, maxGrade: Float, minGrade: Float, percentage: Float = 100, deadline: Date, subject: Subject) -> Assignment {
        let assignment = Assignment(context: CoreDataManager.shared.context)
        assignment.name = name
        assignment.grade = grade
        assignment.maxGrade = maxGrade
        assignment.minGrade = minGrade
        assignment.percentage = percentage * 0.01
        assignment.deadline = deadline
        assignment.subject = subject
        assignment.dateCreated = Date()
        subject.calculateGrade()
        return assignment
    }

    func delete() {
        CoreDataManager.shared.context.delete(self)
        subject?.calculateGrade()
    }
    
}
