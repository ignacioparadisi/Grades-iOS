//
//  TermService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol TermService {
    
    /// Gets all the terms
    ///
    /// - Parameters:
    ///   - completion: Code to be executed after fetch or failure
    func fetchTerms(completion: @escaping (Result<[Term], RequestError>) -> Void)
    
    /// Creates a new Term
    ///
    /// - Parameters:
    ///   - term: Term to be created
    ///   - completion: Code to be executed after creation of failure
    func createTerm(_ term: Term, completion: @escaping (Result<Term, RequestError>) -> Void)
    
    // TODO: Delete this
    func deleteTerms(_ terms: [Term], completion: @escaping (Result<Int, RequestError>) -> Void)
    
    /// Deletes a Term
    ///
    /// - Parameters:
    ///   - term: Term to be deleted
    ///   - completion: Code to be executed after deletion or failure
    func deleteTerm(_ term: Term, completion: @escaping (Result<Int, RequestError>) -> Void)
    
    // TODO: Delete this
    func updateTerms(_ terms: [Term], completion: @escaping (Result<[Term], RequestError>) -> Void)
    
    /// Updates a term
    ///
    /// - Parameters:
    ///   - term: Term with updated information
    ///   - completion: Code to be executed after update or failure
    func updateTerm(_ term: Term, completion: @escaping (Result<Term, RequestError>) -> Void)
    
}
