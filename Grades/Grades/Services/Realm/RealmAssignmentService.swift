//
//  RealmAssignmentService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmAssignmentService: AssignmentService {
    
    func fetchAssignments(for subject: Subject) -> [Assignment] {
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "subject.id == '\(subject.id)'") as! [Assignment]
        return assignments
    }
    
    func fetchAssignments(for assignment: Assignment) -> [Assignment] {
        let assignments = RealmManager.shared.getArray(ofType: Assignment.self, filter: "assignment.id == '\(assignment.id)'") as! [Assignment]
        return assignments
    }
    
    func createAssignment(_ assignment: Assignment) {
        RealmManager.shared.create(assignment)
        updateGradeForParent(of: assignment)
    }
    
    func updateAssignment(old oldAssignment: Assignment, new newAssignment: Assignment) {
        RealmManager.shared.updateAssignment(oldAssignment, newAssignment)
        // Now the old assignment is updated
        updateGradeForParent(of: oldAssignment)
    }
    
    /// Updates the grade of the parent of the assignment passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the assignment in Realm.
    ///
    /// - Parameter assignment: Assignment that was created or updated.
    private func updateGradeForParent(of assignment: Assignment) {
        if let subject = assignment.subject {
            let assignments = fetchAssignments(for: subject)
            let grade = Calculator.getGrade(for: assignments)
            RealmManager.shared.updateGrade(subject, grade: grade)
            updateGradeForParent(of: subject)
        } else if let parentAssignment = assignment.assignment {
            let assignments = fetchAssignments(for: parentAssignment)
            let grade = Calculator.getAverageGrade(for: assignments)
            RealmManager.shared.updateGrade(parentAssignment, grade: grade)
            updateGradeForParent(of: assignment)
        }
    }
    
    /// Updates the grade of the parent of the subject passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the subject in Realm.
    ///
    /// - Parameter subject: Subject that was created or updated.
    func updateGradeForParent(of subject: Subject) {
        if let term = subject.term {
            let factory = AbstractServiceFactory.getServiceFactory(for: .realm)
            let subjects = factory.subjectService.fetchSubjects(for: term)
            let grade = Calculator.getAverageGrade(for: subjects)
            RealmManager.shared.updateGrade(term, grade: grade)
        }
    }
}
