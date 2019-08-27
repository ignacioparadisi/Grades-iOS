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
    /// - Parameters:
    ///   - completion: Code to be executed after fetch or failure
    func fetchSubjects(for term: Term, completion: @escaping (Result<[Subject], RequestError>) -> Void)
    
    /// Creates a new subject
    ///
    /// - Parameters:
    ///   - subject: Subject to be created
    ///   - completion: Code to be executed after creation or failure
    func createSubject(_ subject: Subject, completion: @escaping (Result<Subject, RequestError>) -> Void)
    
    /// Deletes a subject
    ///
    /// - Parameters:
    ///   - subject: Subject to be deleted
    ///   - completion: Code to be executed after deletion or failure
    func deleteSubject(_ subject: Subject, completion: @escaping (Result<Int, RequestError>) -> Void)
    
    // TODO: This might be deleted
    func deleteSubjects(_ subjects: [Subject], completion: ServiceResult<Int>?)
    
}
