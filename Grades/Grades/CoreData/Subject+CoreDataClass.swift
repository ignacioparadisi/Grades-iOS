//
//  Subject+CoreDataClass.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/19/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


public class Subject: NSManagedObject, Identifiable, Gradable {
    
    /// Creates a new subject for Core Data
    /// - Parameter name: Name of the subjects
    /// - Parameter maxGrade: Maximum grade of the subject
    /// - Parameter minGrade: Minimum grade to pass the subject
    static func create(name: String, maxGrade: Float, minGrade: Float, term: Term) {
        let subject = Subject(context: CoreDataManager.shared.context)
        subject.term = term
        subject.name = name
        subject.maxGrade = maxGrade
        subject.minGrade = minGrade
        subject.grade = 0.0
        subject.dateCreated = Date()
        term.calculateGrade()
    }
    
    /// Deletes subject from Core Data
    func delete() {
        CoreDataManager.shared.context.delete(self)
        term?.calculateGrade()
    }
    
    func getAssignments() -> [Assignment] {
        if let assignmentsSet = assignments, let assignments = assignmentsSet.allObjects as? [Assignment] {
            return assignments.sorted {
                $0.dateCreated.compare($1.dateCreated) == .orderedAscending
            }
        }
        return []
    }
    
    func calculateGrade() {
        grade = Calculator.getGrade(for: getAssignments(), parent: self)
        term?.calculateGrade()
    }
}
