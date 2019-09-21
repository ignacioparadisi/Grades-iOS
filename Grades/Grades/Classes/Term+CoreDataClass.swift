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


public class Term: NSManagedObject, Identifiable, Gradable {
    
    static func create(name: String, maxGrade: Float, minGrade: Float, startDate: Date, endDate: Date) {
        let term = Term(context: CoreDataManager.shared.context)
        term.name = name
        term.grade = 0.0
        term.maxGrade = maxGrade
        term.minGrade = minGrade
        term.startDate = startDate
        term.endDate = endDate
        term.dateCreated = Date()
    }
    
    static func fetchAll() throws -> [Term] {
        let request: NSFetchRequest<Term> = Term.fetchRequest()
        let result = try CoreDataManager.shared.context.fetch(request)
        return result
    }
    
    func delete() {
        CoreDataManager.shared.context.delete(self)
    }
    
    func update(name: String, startDate: Date, endDate: Date) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func getSubjects() -> [Subject] {
        if let subjectsSet = subjects, let subjects = subjectsSet.allObjects as? [Subject] {
            return subjects
        }
        return []
    }
    
}
