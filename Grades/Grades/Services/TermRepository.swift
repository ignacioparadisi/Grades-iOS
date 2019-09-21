//
//  TermService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol TermRepository {
    
    /// Gets all the terms
    ///
    /// - Parameters:
    ///   - completion: Code to be executed after fetch or failure
    func fetchTerms(completion: @escaping (Result<[TermRealm], DatabaseError>) -> Void)
    
    /// Creates a new Term
    ///
    /// - Parameters:
    ///   - term: Term to be created
    ///   - completion: Code to be executed after creation of failure
    func createTerm(_ term: TermRealm, completion: @escaping (Result<TermRealm, DatabaseError>) -> Void)
    
    // TODO: Delete this
    func deleteTerms(_ terms: [TermRealm], completion: @escaping (Result<Int, DatabaseError>) -> Void)
    
    /// Deletes a Term
    ///
    /// - Parameters:
    ///   - term: Term to be deleted
    ///   - completion: Code to be executed after deletion or failure
    func deleteTerm(_ term: TermRealm, completion: @escaping (Result<Int, DatabaseError>) -> Void)
    
    // TODO: Delete this
    func updateTerms(_ terms: [TermRealm], completion: @escaping (Result<[TermRealm], DatabaseError>) -> Void)
    
    /// Updates a term
    ///
    /// - Parameters:
    ///   - term: Term with updated information
    ///   - completion: Code to be executed after update or failure
    func updateTerm(_ term: TermRealm, completion: @escaping (Result<TermRealm, DatabaseError>) -> Void)
    
}
