//
//  RealmSubjectService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmSubjectService: SubjectService {
        
    /// Gets all subjects
    ///
    /// - Returns: Stored subjects in the database
    func fetchSubjects(for term: Term, completion: @escaping (Result<[Subject], NetworkError>) -> Void) {
        let subjects = RealmManager.shared.getArray(ofType: Subject.self, filter: "term.id == '\(term.id)'") as! [Subject]
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
    
    func createSubject(_ subject: Subject, completion: @escaping (Result<Subject, NetworkError>) -> Void) {
        if let createdSubject = RealmManager.shared.create(subject) as? Subject {
            updateGradeForParent(of: subject)
            completion(.success(createdSubject))
        }
    }
    
    func deleteSubject(_ subject: Subject, completion: @escaping (Result<Int, NetworkError>) -> Void) {
        deleteCascade(subject)
    }
    
    func deleteSubjects(_ subjects: [Subject], completion: ServiceResult<Int>?) {
        for subject in subjects {
            deleteCascade(subject)
        }
        completion?(.success(0))
    }
    
    private func deleteCascade(_ subject: Subject) {
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "subject.id == '\(subject.id)'") as! [Assignment]
        let service = AbstractServiceFactory.getServiceFactory(for: .realm).assignmentService
        service.deleteAssignments(assignments, completion: nil)
        RealmManager.shared.delete(subject)
    }
    
    /// Updates the grade of the parent of the subject passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the subject in Realm.
    ///
    /// - Parameter subject: Subject that was created or updated.
    func updateGradeForParent(of subject: Subject) {
        if let term = subject.term {
            fetchSubjects(for: term) { result in
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
