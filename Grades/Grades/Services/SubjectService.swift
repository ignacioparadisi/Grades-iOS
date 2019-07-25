//
//  SubjectService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol SubjectService {
    
    /// Gets all the subjects
    ///
    /// - Returns: Subjects stored
    func fetchSubjects(for term: Term) -> [Subject]
    
    func createSubject(_ subject: Subject)
    
}
