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
    func fetchTerms(completion: @escaping (Result<[Term], RequestError>) -> Void) {
        let terms = RealmManager.shared.getArray(ofType: Term.self) as! [Term]
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
    func createTerm(_ term: Term, completion: @escaping (Result<Term, RequestError>) -> Void) {
        if let savedTerm = RealmManager.shared.create(term) as? Term {
            completion(.success(savedTerm))
            return
        }
        completion(.failure(.badRequest))
    }
    
    
    /// Deletes a term from Realm
    ///
    /// - Parameters:
    ///   - term: Term to be deleted
    ///   - completion: Code to be executed after the deletion or failure
    func deleteTerm(_ term: Term, completion: @escaping (Result<Int, RequestError>) -> Void) {
        deleteCascade(term)
        completion(.success(0))
    }
    
    // TODO: Quitar este método
    func deleteTerms(_ terms: [Term], completion: @escaping (Result<Int, RequestError>) -> Void) {
        for term in terms {
            deleteCascade(term)
        }
        completion(.success(0))
    }
    
    // TODO: Quitar este método
    func updateTerms(_ terms: [Term], completion: @escaping (Result<[Term], RequestError>) -> Void) {
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
    func updateTerm(_ term: Term, completion: @escaping (Result<Term, RequestError>) -> Void) {
        RealmManager.shared.update(term)
        completion(.success(term))
    }
    
    
    /// Deletes all childs of the term
    ///
    /// - Parameter term: Term to be deleted
    private func deleteCascade(_ term: Term) {
        let subjects = RealmManager.shared.getArray(ofType: Subject.self, filter: "term.id == '\(term.id)'") as! [Subject]
        let service = AbstractServiceFactory.getServiceFactory(for: .realm).subjectService
        service.deleteSubjects(subjects, completion: nil)
        RealmManager.shared.delete(term)
    }
    
}
