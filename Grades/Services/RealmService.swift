//
//  RealmService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmService: Service {
    
    /// RealmService instance for the Singleton
    static var shared = RealmService()
    
    private init() {}
    
    /// Gets all Terms
    ///
    /// - Returns: Stored terms in the database
    func fetchTerms() -> [Term] {
        let terms = RealmManager.shared.getArray(ofType: Term.self) as! [Term]
        
        for term in terms {
            let subjects = fetchSubjects(for: term)
            term.subjects = subjects
        }
        return terms
    }
    
    /// Gets all subjects
    ///
    /// - Returns: Stored subjects in the database
    func fetchSubjects(for term: Term) -> [Subject] {
        let subjects = RealmManager.shared.getArray(ofType: Subject.self, filter: "term.id == '\(term.id)'") as! [Subject]
        return subjects
    }
    
    func fetchAssignments(for subject: Subject) -> [Assignment] {
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "subject.id == '\(subject.id)'") as! [Assignment]
        return assignments
    }
    
    func fetchAssignments(for assignment: Assignment) -> [Assignment] {
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "assignment.id == '\(assignment.id)'") as! [Assignment]
        return assignments
    }
    
    func createTerm(_ term: Term) {
        RealmManager.shared.create(term)
    }
    
    func createSubject(_ subject: Subject) {
        if let term = subject.term {
            var subjects = fetchSubjects(for: term)
            subjects.append(subject)
            let qualification = Calculator.getAverageQualification(for: subjects)
            RealmManager.shared.updateQualification(term, qualification: qualification)
        }
        RealmManager.shared.create(subject)
    }
    
    func createAssignment(_ assignment: Assignment) {
        if let subject = assignment.subject {
            var assignments = fetchAssignments(for: subject)
            assignments.append(assignment)
            let qualification = Calculator.getQualification(for: assignments)
            RealmManager.shared.updateQualification(subject, qualification: qualification)
            
            if let term = subject.term {
                let subjects = fetchSubjects(for: term)
                let qualification = Calculator.getAverageQualification(for: subjects)
                RealmManager.shared.updateQualification(term, qualification: qualification)
            }
            
        } else if let parentAssignment = assignment.assignment {
            var assignments = fetchAssignments(for: parentAssignment)
            assignments.append(assignment)
            let qualification = Calculator.getAverageQualification(for: assignments)
            RealmManager.shared.updateQualification(parentAssignment, qualification: qualification)
            
            // TODO: Update term and subject after updating parent assignment
        }
        RealmManager.shared.create(assignment)
    }
}
