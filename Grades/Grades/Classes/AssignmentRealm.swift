//
//  Assignment.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Quitar Orderable
class AssignmentRealm: Object, Gradable, NSCopying {
    
    @objc dynamic var subject: SubjectRealm?
    @objc dynamic var assignment: AssignmentRealm?
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var grade: Float = 0.0
    @objc dynamic var maxGrade: Float = 0.0
    @objc dynamic var minGrade: Float = 0.0
    @objc dynamic var percentage: Float = 0.0
    @objc dynamic var deadline: Date = Date()
    @objc dynamic var dateCreated: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let assignment = AssignmentRealm()
        assignment.subject = self.subject?.copy() as? SubjectRealm
        assignment.assignment = self.assignment?.copy() as? AssignmentRealm
        assignment.id = self.id
        assignment.name = self.name
        assignment.grade = self.grade
        assignment.maxGrade = self.maxGrade
        assignment.minGrade = self.minGrade
        assignment.percentage = self.percentage
        assignment.deadline = self.deadline
        assignment.dateCreated = self.dateCreated
        return assignment
    }
    
}
