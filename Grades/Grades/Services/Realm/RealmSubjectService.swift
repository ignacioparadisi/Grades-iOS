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
    func fetchSubjects(for term: Term) -> [Subject] {
        let subjects = RealmManager.shared.getArray(ofType: Subject.self, filter: "term.id == '\(term.id)'") as! [Subject]
        return subjects
    }
    
    func createSubject(_ subject: Subject) {
        RealmManager.shared.create(subject)
        updateGradeForParent(of: subject)
    }
    
    /// Updates the grade of the parent of the subject passed as a parameter.
    /// IMPORTANT: To use this method you first need to save the subject in Realm.
    ///
    /// - Parameter subject: Subject that was created or updated.
    func updateGradeForParent(of subject: Subject) {
        if let term = subject.term {
            let subjects = fetchSubjects(for: term)
            let grade = Calculator.getAverageGrade(for: subjects)
            RealmManager.shared.updateGrade(term, grade: grade)
        }
    }
    
}
