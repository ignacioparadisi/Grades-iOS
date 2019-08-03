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
    /// - Returns: Terms stored
    func fetchTerms(completion: @escaping (Result<[Term], NetworkError>) -> Void)
    
    func createTerm(_ term: Term, completion: @escaping (Result<Term, NetworkError>) -> Void)
    
    func deleteTerms(_ terms: [Term], completion: @escaping (Result<Int, NetworkError>) -> Void)
    
    func deleteTerm(_ term: Term, completion: @escaping (Result<Int, NetworkError>) -> Void)
    
    func updateTerms(_ terms: [Term], completion: @escaping (Result<[Term], NetworkError>) -> Void)
    
    func updateTerm(_ term: Term, completion: @escaping (Result<Term, NetworkError>) -> Void)
    
}
