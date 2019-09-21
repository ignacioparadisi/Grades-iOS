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
    func fetchAssignments(for subject: SubjectRealm, completion: @escaping (Result<[AssignmentRealm], DatabaseError>) -> Void)
    
    /// Gets all assignments from an assignment
    ///
    /// - Parameters:
    ///   - assignment: Parent assignment of assignments to be fetched
    ///   - completion: Code to be executed after fecth or failure
    func fetchAssignments(for assignment: AssignmentRealm, completion: @escaping (Result<[AssignmentRealm], DatabaseError>) -> Void)
    
    /// Creates a new assignment
    ///
    /// - Parameters:
    ///   - assignment: Assignment to be created
    ///   - completion: Code to be executed after creation or failure
    func createAssignment(_ assignment: AssignmentRealm, completion: @escaping (Result<AssignmentRealm, DatabaseError>) -> Void)
    
    // TODO: Update assignment in another way
    func updateAssignment(old oldAssignment: AssignmentRealm, new newAssignment: AssignmentRealm, completion: @escaping (Result<AssignmentRealm, DatabaseError>) -> Void)
    
    /// Deletes an assignment
    ///
    /// - Parameters:
    ///   - assignment: Assignment to be deleted
    ///   - completion: Code to be executed after deletion or failure
    func deleteAssignment(_ assignment: AssignmentRealm, completion: @escaping (Result<Int, DatabaseError>) -> Void)
    
    // TODO: Probably delete this
    func deleteAssignments(_ assignments: [AssignmentRealm], completion: ServiceResult<Int>?)
    
}
