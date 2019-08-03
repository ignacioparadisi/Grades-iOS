//
//  RealmAssignmentService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmAssignmentService: AssignmentService {
    
    func fetchAssignments(for subject: Subject, completion: @escaping (Result<[Assignment], NetworkError>) -> Void){
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "subject.id == '\(subject.id)'") as! [Assignment]
        completion(.success(assignments))
    }
    
    func fetchAssignments(for assignment: Assignment, completion: @escaping (Result<[Assignment], NetworkError>) -> Void) {
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "assignment.id == '\(assignment.id)'") as! [Assignment]
        completion(.success(assignments))
    }
    
    func createAssignment(_ assignment: Assignment, completion: @escaping (Result<Assignment, NetworkError>) -> Void) {
        let createdAssignment = RealmManager.shared.create(assignment) as! Assignment
        updateGradeForParent(of: createdAssignment)
        completion(.success(createdAssignment))
    }
    
    func updateAssignment(old oldAssignment: Assignment, new newAssignment: Assignment, completion: @escaping (Result<Assignment, NetworkError>) -> Void) {
        RealmManager.shared.updateAssignment(oldAssignment, newAssignment)
        // Now the old assignment is updated
        updateGradeForParent(of: oldAssignment)
        completion(.success(newAssignment))
    }
    
    func deleteAssignment(_ assignment: Assignment, completion: @escaping (Result<Int, NetworkError>) -> Void) {
        deleteCascade(assignment)
        completion(.success(0))
    }
    
    func deleteAssignments(_ assignments: [Assignment], completion: ServiceResult<Int>?) {
        for assignment in assignments {
            deleteCascade(assignment)
        }
        completion?(.success(0))
    }
    
    private func deleteCascade(_ assignment: Assignment) {
        let childAssignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "assignment.id == '\(assignment.id)'") as! [Assignment]
        if !childAssignments.isEmpty {
            RealmManager.shared.delete(childAssignments)
        }
        RealmManager.shared.delete(assignment)
    }
    
    /// Updates the grade of the parent of the assignment passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the assignment in Realm.
    ///
    /// - Parameter assignment: Assignment that was created or updated.
    private func updateGradeForParent(of assignment: Assignment) {
        if let subject = assignment.subject {
            fetchAssignments(for: subject) { result in
                switch result {
                case .success(let assignments):
                    let grade = Calculator.getGrade(for: assignments)
                    RealmManager.shared.updateGrade(subject, grade: grade)
                    self.updateGradeForParent(of: subject)
                case .failure(let error):
                    print(error)
                    break
                }
            }
        } else if let parentAssignment = assignment.assignment {
            fetchAssignments(for: parentAssignment) { result in
                switch result {
                case .success(let assignments):
                    let grade = Calculator.getAverageGrade(for: assignments)
                    RealmManager.shared.updateGrade(parentAssignment, grade: grade)
                    self.updateGradeForParent(of: assignment)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    /// Updates the grade of the parent of the subject passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the subject in Realm.
    ///
    /// - Parameter subject: Subject that was created or updated.
    func updateGradeForParent(of subject: Subject) {
        if let term = subject.term {
            let service = AbstractServiceFactory.getServiceFactory(for: .realm)
            service.subjectService.fetchSubjects(for: term) { result in
                switch result {
                case .success(let subjects):
                    let grade = Calculator.getAverageGrade(for: subjects)
                    RealmManager.shared.updateGrade(term, grade: grade)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}
