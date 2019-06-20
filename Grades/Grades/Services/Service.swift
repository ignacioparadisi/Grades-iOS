//
//  Service.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol Service {
    
    /// Gets all the terms
    ///
    /// - Returns: Terms stored
    func fetchTerms() -> [Term]
    
    /// Gets all the subjects
    ///
    /// - Returns: Subjects stored
    func fetchSubjects(for term: Term) -> [Subject]
    
    func fetchAssignments(for subject: Subject) -> [Assignment]
    
    func fetchAssignments(for assignment: Assignment) -> [Assignment]
    
    func createTerm(_ term: Term)
    
    func createSubject(_ subject: Subject)
    
    func createAssignment(_ assignment: Assignment)
}