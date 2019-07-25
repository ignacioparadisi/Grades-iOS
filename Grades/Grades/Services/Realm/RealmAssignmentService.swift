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
        updateQualificationForParent(of: assignment)
    }
    
    func updateAssignment(old oldAssignment: Assignment, new newAssignment: Assignment) {
        RealmManager.shared.updateAssignment(oldAssignment, newAssignment)
        // Now the old assignment is updated
        updateQualificationForParent(of: oldAssignment)
    }
    
    /// Updates the qualification of the parent of the assignment passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the assignment in Realm.
    ///
    /// - Parameter assignment: Assignment that was created or updated.
    private func updateQualificationForParent(of assignment: Assignment) {
        if let subject = assignment.subject {
            let assignments = fetchAssignments(for: subject)
            let qualification = Calculator.getQualification(for: assignments)
            RealmManager.shared.updateQualification(subject, qualification: qualification)
            updateQualificationForParent(of: subject)
        } else if let parentAssignment = assignment.assignment {
            let assignments = fetchAssignments(for: parentAssignment)
            let qualification = Calculator.getAverageQualification(for: assignments)
            RealmManager.shared.updateQualification(parentAssignment, qualification: qualification)
            updateQualificationForParent(of: assignment)
        }
    }
    
    /// Updates the qualification of the parent of the subject passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the subject in Realm.
    ///
    /// - Parameter subject: Subject that was created or updated.
    func updateQualificationForParent(of subject: Subject) {
        if let term = subject.term {
            let factory = Factory.getServiceFactory(for: .realm)
            let subjects = factory.subjectService.fetchSubjects(for: term)
            let qualification = Calculator.getAverageQualification(for: subjects)
            RealmManager.shared.updateQualification(term, qualification: qualification)
        }
    }
}
