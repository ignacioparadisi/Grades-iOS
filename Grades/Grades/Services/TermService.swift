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
    func fetchTerms() -> [Term]
    
    func createTerm(_ term: Term)
    
    func deleteTerms(_ terms: [Term])
    
    func updateTerm(_ terms: [Term])
    
}
