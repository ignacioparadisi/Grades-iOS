//
//  Term+CoreDataClass.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/19/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import UIKit
import CoreData

enum TermError: Error {
    case invalidMinGradeOrMaxGrade
    case invalidStartDateOrEndDate
    case invalidName
}


public class Term: NSManagedObject, Identifiable, Gradable {
    
    /// Creates a new Term for Core Data
    /// - Parameter name: Name of the Term
    /// - Parameter maxGrade: Maximum grade of the Term
    /// - Parameter minGrade: Minimum grade to pass the Term
    /// - Parameter startDate: Start date of the Term
    /// - Parameter endDate: Final date of the Term
    static func create(name: String, maxGrade: Float, minGrade: Float, startDate: Date, endDate: Date) throws -> Term {
        if maxGrade < minGrade {
            throw TermError.invalidMinGradeOrMaxGrade
        }
        if endDate < startDate {
            throw TermError.invalidStartDateOrEndDate
        }
        if name == "" {
            throw TermError.invalidName
        }
        let term = Term(context: CoreDataManager.shared.context)
        term.name = name
        term.grade = 0.0
        term.maxGrade = maxGrade
        term.minGrade = minGrade
        term.startDate = startDate
        term.endDate = endDate
        term.dateCreated = Date()
        return term
    }
    
    /// Fetches all Term stored in Core Data
    static func fetchAll() throws -> [Term] {
        let request: NSFetchRequest<Term> = Term.fetchRequest()
        let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sort]
        let result = try CoreDataManager.shared.context.fetch(request)
        return result
    }
    
    /// Deletes a term from Core Data
    func delete() {
        CoreDataManager.shared.context.delete(self)
    }
    
    /// Updates a Term in Core Data
    /// - Parameter name: Name of the Term
    /// - Parameter startDate: Start date of the Term
    /// - Parameter endDate: Final date of the Term
    func update(name: String, startDate: Date, endDate: Date) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    /// Converts the NSSet of subjects into an Array of Subjects
    func getSubjects() -> [Subject] {
        if let subjectsSet = subjects, let subjects = subjectsSet.allObjects as? [Subject] {
            return subjects.sorted {
                $0.dateCreated.compare($1.dateCreated) == .orderedAscending
            }
        }
        return []
    }
    
    /// Calculate Term grade by calculating the average of Subjects
    func calculateGrade() {
        grade = Calculator.getAverageGrade(for: getSubjects(), parent: self)
    }
    
}
