//
//  RealmSubjectService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmSubjectService: SubjectRepository {
        
    /// Gets all subjects
    ///
    /// - Returns: Stored subjects in the database
    func fetchSubjects(for term: TermRealm, completion: @escaping (Result<[SubjectRealm], DatabaseError>) -> Void) {
        let subjects = RealmManager.shared.getArray(ofType: SubjectRealm.self, filter: "term.id == '\(term.id)'") as! [SubjectRealm]
        for subject in subjects {
            let service = AbstractServiceFactory.getServiceFactory(for: .realm)
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
        completion(.success(subjects))
    }
    
    /// Creates a subject in Realm
    ///
    /// - Parameters:
    ///   - subject: Subject to be created
    ///   - completion: Code to be executed after the completion or failure
    func createSubject(_ subject: SubjectRealm, completion: @escaping (Result<SubjectRealm, DatabaseError>) -> Void) {
        if let createdSubject = RealmManager.shared.create(subject) as? SubjectRealm {
            updateGradeForParent(of: subject)
            completion(.success(createdSubject))
        }
    }
    
    
    /// Deletes a subject from Realm
    ///
    /// - Parameters:
    ///   - subject: Subject to be deleted
    ///   - completion: Code to be executed after the deletion of failure
    func deleteSubject(_ subject: SubjectRealm, completion: @escaping (Result<Int, DatabaseError>) -> Void) {
        deleteCascade(subject)
        completion(.success(0))
    }
    
    
    /// Deletes an array of subjects from Realm
    ///
    /// - Parameters:
    ///   - subjects: Array of subjects to be deleted
    ///   - completion: Code to be executed after the deletion of failure
    func deleteSubjects(_ subjects: [SubjectRealm], completion: ServiceResult<Int>?) {
        for subject in subjects {
            deleteCascade(subject)
        }
        completion?(.success(0))
    }
    
    
    /// Deletes all childs of a subject and the subject
    ///
    /// - Parameter subject: Subject to be deleted
    private func deleteCascade(_ subject: SubjectRealm) {
        updateGradeForParent(of: subject, exclude: true)
        let assignments = RealmManager.shared.getArray(ofType: AssignmentRealm.self, filter: "subject.id == '\(subject.id)'") as! [AssignmentRealm]
        let service = AbstractServiceFactory.getServiceFactory(for: .realm).assignmentService
        service.deleteAssignments(assignments, completion: nil)
        RealmManager.shared.delete(subject)
    }
    
    /// Updates the grade of the parent of the subject passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the subject in Realm.
    ///
    /// - Parameter subject: Subject that was created or updated.
    func updateGradeForParent(of subject: SubjectRealm, exclude: Bool = false) {
        if let term = subject.term {
            fetchSubjects(for: term) { result in
                switch result {
                case .success(let subjects):
                    var subjectsToCalculate = subjects
                    if exclude {
                        subjectsToCalculate = subjects.filter { $0.id != subject.id }
                    }
                    let grade = Calculator.getAverageGrade(for: subjectsToCalculate)
                    print("Grade: \(grade)")
                    RealmManager.shared.updateGrade(term, grade: grade)
                    print("Term grade: \(term.grade)")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
