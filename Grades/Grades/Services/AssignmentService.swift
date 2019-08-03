//
//  AssignmentService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol AssignmentService {
    
    func fetchAssignments(for subject: Subject, completion: @escaping (Result<[Assignment], NetworkError>) -> Void)
    
    func fetchAssignments(for assignment: Assignment, completion: @escaping (Result<[Assignment], NetworkError>) -> Void)
    
    func createAssignment(_ assignment: Assignment, completion: @escaping (Result<Assignment, NetworkError>) -> Void)
    
    func updateAssignment(old oldAssignment: Assignment, new newAssignment: Assignment, completion: @escaping (Result<Assignment, NetworkError>) -> Void)
    
}
