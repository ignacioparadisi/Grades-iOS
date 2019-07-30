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
            let factory = Factory.getServiceFactory(for: .realm)
            let subjects = factory.subjectService.fetchSubjects(for: term)
            term.subjects = subjects
        }
        return terms
    }
    
    func createTerm(_ term: Term) {
        RealmManager.shared.create(term)
    }
    
    func deleteTerms(_ terms: [Term]) {
        RealmManager.shared.delete(terms)
    }
    
    func updateTerm(_ terms: [Term]) {
        for term in terms {
            RealmManager.shared.update(term)
        }
    }
}
