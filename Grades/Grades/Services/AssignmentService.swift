//
//  AssignmentService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol AssignmentService {
    
    
    /// Gets all assignments from a subject
    ///
    /// - Parameters:
    ///   - subject: Parent subject of assignments to be fetched
    ///   - completion: Code to be executed after fecth or failure
    func fetchAssignments(for subject: Subject, completion: @escaping (Result<[Assignment], RequestError>) -> Void)
    
    /// Gets all assignments from an assignment
    ///
    /// - Parameters:
    ///   - assignment: Parent assignment of assignments to be fetched
    ///   - completion: Code to be executed after fecth or failure
    func fetchAssignments(for assignment: Assignment, completion: @escaping (Result<[Assignment], RequestError>) -> Void)
    
    /// Creates a new assignment
    ///
    /// - Parameters:
    ///   - assignment: Assignment to be created
    ///   - completion: Code to be executed after creation or failure
    func createAssignment(_ assignment: Assignment, completion: @escaping (Result<Assignment, RequestError>) -> Void)
    
    // TODO: Update assignment in another way
    func updateAssignment(old oldAssignment: Assignment, new newAssignment: Assignment, completion: @escaping (Result<Assignment, RequestError>) -> Void)
    
    /// Deletes an assignment
    ///
    /// - Parameters:
    ///   - assignment: Assignment to be deleted
    ///   - completion: Code to be executed after deletion or failure
    func deleteAssignment(_ assignment: Assignment, completion: @escaping (Result<Int, RequestError>) -> Void)
    
    // TODO: Probably delete this
    func deleteAssignments(_ assignments: [Assignment], completion: ServiceResult<Int>?)
    
}
