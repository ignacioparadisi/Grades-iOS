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
class Assignment: Object, Gradable, Orderable, NSCopying {
    
    @objc dynamic var subject: Subject?
    @objc dynamic var assignment: Assignment?
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var grade: Float = 0.0
    @objc dynamic var maxGrade: Float = 0.0
    @objc dynamic var minGrade: Float = 0.0
    @objc dynamic var percentage: Float = 0.0
    @objc dynamic var position: Int = 0
    @objc dynamic var date: Date = Date()
    @objc dynamic var dateCreated: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let assignment = Assignment()
        assignment.subject = self.subject?.copy() as? Subject
        assignment.assignment = self.assignment?.copy() as? Assignment
        assignment.id = self.id
        assignment.name = self.name
        assignment.grade = self.grade
        assignment.maxGrade = self.maxGrade
        assignment.minGrade = self.minGrade
        assignment.percentage = self.percentage
        assignment.position = self.position
        assignment.date = self.date
        assignment.dateCreated = self.dateCreated
        return assignment
    }
    
}
