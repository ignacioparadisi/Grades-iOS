//
//  RealmTermService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmTermService: TermService {
    
    /// Gets all Terms
    ///
    /// - Returns: Stored terms in the database
    func fetchTerms() -> [Term] {
        let terms = RealmManager.shared.getArray(ofType: Term.self) as! [Term]
        
        for term in terms {
            let factory = AbstractServiceFactory.getServiceFactory(for: .realm)
            let subjects = factory.subjectService.fetchSubjects(for: term)
            for subject in subjects {
                let assignments = AbstractServiceFactory.getServiceFactory(for: .realm).assignmentService.fetchAssignments(for: subject)
                subject.lowerGrade = Calculator.getGradesForAssignment(assignments, type: .lower)
                subject.greaterGrade = Calculator.getGradesForAssignment(assignments, type: .greater)
            }
            term.greaterGrade = Calculator.getGradesForSubjects(subjects, type: .greater)
            term.lowerGrade = Calculator.getGradesForSubjects(subjects, type: .lower)
            term.subjects = subjects
        }
        return terms
    }
    
    func createTerm(_ term: Term) {
        RealmManager.shared.create(term)
    }
    
    func deleteTerm(_ term: Term) {
        RealmManager.shared.delete(term)
    }
    
    func deleteTerms(_ terms: [Term]) {
        RealmManager.shared.delete(terms)
    }
    
    func updateTerms(_ terms: [Term]) {
        for term in terms {
            RealmManager.shared.update(term)
        }
    }
    
    func updateTerm(_ term: Term) {
        RealmManager.shared.update(term)
    }
    
}
