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
    func fetchTerms(completion: @escaping (Result<[Term], NetworkError>) -> Void) {
        let terms = RealmManager.shared.getArray(ofType: Term.self) as! [Term]
        
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
    
    func createTerm(_ term: Term, completion: @escaping (Result<Term, NetworkError>) -> Void) {
        if let savedTerm = RealmManager.shared.create(term) as? Term {
            completion(.success(savedTerm))
            return
        }
        completion(.failure(.badRequest))
    }
    
    func deleteTerm(_ term: Term, completion: @escaping (Result<Int, NetworkError>) -> Void) {
        RealmManager.shared.delete(term)
        completion(.success(0))
    }
    
    func deleteTerms(_ terms: [Term], completion: @escaping (Result<Int, NetworkError>) -> Void) {
        RealmManager.shared.delete(terms)
        completion(.success(0))
    }
    
    func updateTerms(_ terms: [Term], completion: @escaping (Result<[Term], NetworkError>) -> Void) {
        for term in terms {
            RealmManager.shared.update(term)
        }
        completion(.success(terms))
    }
    
    func updateTerm(_ term: Term, completion: @escaping (Result<Term, NetworkError>) -> Void) {
        RealmManager.shared.update(term)
        completion(.success(term))
    }
    
}
