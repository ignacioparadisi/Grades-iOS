//
//  SubjectService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol SubjectRepository {
    
    /// Gets all the subjects
    ///
    /// - Parameters:
    ///   - completion: Code to be executed after fetch or failure
    func fetchSubjects(for term: TermRealm, completion: @escaping (Result<[SubjectRealm], DatabaseError>) -> Void)
    
    /// Creates a new subject
    ///
    /// - Parameters:
    ///   - subject: Subject to be created
    ///   - completion: Code to be executed after creation or failure
    func createSubject(_ subject: SubjectRealm, completion: @escaping (Result<SubjectRealm, DatabaseError>) -> Void)
    
    /// Deletes a subject
    ///
    /// - Parameters:
    ///   - subject: Subject to be deleted
    ///   - completion: Code to be executed after deletion or failure
    func deleteSubject(_ subject: SubjectRealm, completion: @escaping (Result<Int, DatabaseError>) -> Void)
    
    // TODO: This might be deleted
    func deleteSubjects(_ subjects: [SubjectRealm], completion: ServiceResult<Int>?)
    
}
