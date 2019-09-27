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
    
    static func create(name: String, grade: Float = 0.0, maxGrade: Float, minGrade: Float, percentage: Float = 100, decimals: Int = 0, deadline: Date, subject: Subject) -> Assignment {
        let assignment = Assignment(context: CoreDataManager.shared.context)
        assignment.name = name
        assignment.grade = grade
        assignment.maxGrade = maxGrade
        assignment.minGrade = minGrade
        assignment.decimals = Int16(decimals)
        assignment.percentage = percentage == -1 ? percentage : percentage * 0.01
        assignment.deadline = deadline
        assignment.subject = subject
        assignment.dateCreated = Date()
        subject.calculateGrade()
        return assignment
    }
    
    func update(grade: Float? = nil, decimals: Int? = nil, deadline: Date? = nil) {
        if let grade = grade {
            self.grade = grade
        }
        if let deadline = deadline {
            self.deadline = deadline
        }
        if let decimals = decimals {
            self.decimals = Int16(decimals)
        }
        subject?.calculateGrade()
    }

    func delete() {
        CoreDataManager.shared.context.delete(self)
        subject?.calculateGrade()
    }
    
    static func fetchForCalendar() throws -> [Assignment] {
        let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sort]
        let result = try CoreDataManager.shared.context.fetch(request)
        return result
    }
    
}
