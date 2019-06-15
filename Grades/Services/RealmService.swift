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
        let subjects = RealmManager.shared.getArray(ofType: Subject.self, filter: "term.id == 'term.id'") as! [Subject]
        return subjects
    }
    
    func createTerm(_ term: Term) {
        RealmManager.shared.create(term)
    }
}
