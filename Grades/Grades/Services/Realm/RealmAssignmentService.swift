//
//  RealmAssignmentService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmAssignmentService: AssignmentService {
    
    func fetchAssignments(for subject: SubjectRealm, completion: @escaping (Result<[AssignmentRealm], DatabaseError>) -> Void){
        let assignments = RealmManager.shared.getArray(ofType: AssignmentRealm.self, filter: "subject.id == '\(subject.id)'") as! [AssignmentRealm]
        completion(.success(assignments))
    }
    
    func fetchAssignments(for assignment: AssignmentRealm, completion: @escaping (Result<[AssignmentRealm], DatabaseError>) -> Void) {
        let assignments = RealmManager.shared.getArray(ofType: AssignmentRealm.self, filter: "assignment.id == '\(assignment.id)'") as! [AssignmentRealm]
        completion(.success(assignments))
    }
    
    func createAssignment(_ assignment: AssignmentRealm, completion: @escaping (Result<AssignmentRealm, DatabaseError>) -> Void) {
        let createdAssignment = RealmManager.shared.create(assignment) as! AssignmentRealm
        updateGradeForParent(of: createdAssignment)
        completion(.success(createdAssignment))
    }
    
    func updateAssignment(old oldAssignment: AssignmentRealm, new newAssignment: AssignmentRealm, completion: @escaping (Result<AssignmentRealm, DatabaseError>) -> Void) {
        RealmManager.shared.updateAssignment(oldAssignment, newAssignment)
        // Now the old assignment is updated
        updateGradeForParent(of: oldAssignment)
        completion(.success(newAssignment))
    }
    
    func deleteAssignment(_ assignment: AssignmentRealm, completion: @escaping (Result<Int, DatabaseError>) -> Void) {
        deleteCascade(assignment)
        completion(.success(0))
    }
    
    func deleteAssignments(_ assignments: [AssignmentRealm], completion: ServiceResult<Int>?) {
        for assignment in assignments {
            deleteCascade(assignment, excludeSubject: true)
        }
        completion?(.success(0))
    }
    
    private func deleteCascade(_ assignment: AssignmentRealm, excludeSubject: Bool = false) {
        updateGradeForParent(of: assignment, exclude: true, excludeSubject: excludeSubject)
        let childAssignments = RealmManager.shared.getArray(ofType: AssignmentRealm.self, filter: "assignment.id == '\(assignment.id)'") as! [AssignmentRealm]
        if !childAssignments.isEmpty {
            RealmManager.shared.delete(childAssignments)
        }
        RealmManager.shared.delete(assignment)
    }
    
    /// Updates the grade of the parent of the assignment passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the assignment in Realm.
    ///
    /// - Parameter assignment: Assignment that was created or updated.
    private func updateGradeForParent(of assignment: AssignmentRealm, exclude: Bool = false, excludeSubject: Bool = false) {
        if let subject = assignment.subject {
            fetchAssignments(for: subject) { result in
                switch result {
                case .success(let assignments):
                    var assignmentsToCalculate = assignments
                    if exclude {
                        assignmentsToCalculate = assignments.filter { $0.id != assignment.id }
                    }
                    let grade = Calculator.getGrade(for: assignmentsToCalculate)
                    RealmManager.shared.updateGrade(subject, grade: grade)
                    if !excludeSubject {
                        self.updateGradeForParent(of: subject)
                    }
                case .failure(let error):
                    print(error)
                    break
                }
            }
        } else if let parentAssignment = assignment.assignment {
            fetchAssignments(for: parentAssignment) { result in
                switch result {
                case .success(let assignments):
                    var assignmentsToCalculate = assignments
                    if exclude {
                        assignmentsToCalculate = assignments.filter { $0.id != assignment.id }
                    }
                    let grade = Calculator.getGrade(for: assignmentsToCalculate)
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
    func updateGradeForParent(of subject: SubjectRealm) {
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
