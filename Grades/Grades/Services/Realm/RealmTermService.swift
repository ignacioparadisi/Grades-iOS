//
//  RealmTermService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmTermService: TermRepository {
    
    /// Gets all Terms
    ///
    /// - Returns: Stored terms in the database
    func fetchTerms(completion: @escaping (Result<[TermRealm], DatabaseError>) -> Void) {
        let terms = RealmManager.shared.getArray(ofType: TermRealm.self) as! [TermRealm]
        print(terms)
        
        for term in terms {
            let service = AbstractServiceFactory.getServiceFactory(for: .realm)
            service.subjectService.fetchSubjects(for: term) { result in
                switch result {
                case .success(let subjects):
                    for subject in subjects {
                        service.assignmentService.fetchAssignments(for: subject) { result in
                            switch result {
                            case .success(let assignments):
                                subject.lowerGrade = Calculator.getGradesForAssignment(assignments, type: .lower)
                                subject.greaterGrade = Calculator.getGradesForAssignment(assignments, type: .greater)
                            case .failure(let error):
                                completion(.failure(error))
                                break
                            }
                        }
                    }
                    term.greaterGrade = Calculator.getGradesForSubjects(subjects, type: .greater)
                    term.lowerGrade = Calculator.getGradesForSubjects(subjects, type: .lower)
                    term.subjects = subjects
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        }
        completion(.success(terms))
    }
    
    /// Creates a term in Realm
    ///
    /// - Parameters:
    ///   - term: Term to be created
    ///   - completion: Code to be executed after the creation or failure
    func createTerm(_ term: TermRealm, completion: @escaping (Result<TermRealm, DatabaseError>) -> Void) {
        if let savedTerm = RealmManager.shared.create(term) as? TermRealm {
            completion(.success(savedTerm))
            return
        }
        completion(.failure(.onSave))
    }
    
    
    /// Deletes a term from Realm
    ///
    /// - Parameters:
    ///   - term: Term to be deleted
    ///   - completion: Code to be executed after the deletion or failure
    func deleteTerm(_ term: TermRealm, completion: @escaping (Result<Int, DatabaseError>) -> Void) {
        deleteCascade(term)
        completion(.success(0))
    }
    
    // TODO: Quitar este método
    func deleteTerms(_ terms: [TermRealm], completion: @escaping (Result<Int, DatabaseError>) -> Void) {
        for term in terms {
            deleteCascade(term)
        }
        completion(.success(0))
    }
    
    // TODO: Quitar este método
    func updateTerms(_ terms: [TermRealm], completion: @escaping (Result<[TermRealm], DatabaseError>) -> Void) {
        for term in terms {
            RealmManager.shared.update(term)
        }
        completion(.success(terms))
    }
    
    
    /// Updates a term in Realm
    ///
    /// - Parameters:
    ///   - term: Term with the updated information
    ///   - completion: Code to be executed after the update of failure
    func updateTerm(_ term: TermRealm, completion: @escaping (Result<TermRealm, DatabaseError>) -> Void) {
        RealmManager.shared.update(term)
        completion(.success(term))
    }
    
    
    /// Deletes all childs of the term
    ///
    /// - Parameter term: Term to be deleted
    private func deleteCascade(_ term: TermRealm) {
        let subjects = RealmManager.shared.getArray(ofType: SubjectRealm.self, filter: "term.id == '\(term.id)'") as! [SubjectRealm]
        let service = AbstractServiceFactory.getServiceFactory(for: .realm).subjectService
        service.deleteSubjects(subjects, completion: nil)
        RealmManager.shared.delete(term)
    }
    
}
