//
//  TestDataService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class TestDataService: Service {
    
    static var shared = TestDataService()
    
    private init() {}
    
    func fetchTerms() -> [Term] {
        let terms: [Term] = []
        return terms
    }
    
    func fetchSubjects(for term: Term) -> [Subject] {
        let subjects: [Subject] = []
        return subjects
    }
    
    func createTerm(_ term: Term) {
    }
    
    func createSubject(_ subject: Subject) {}
}
