//
//  Subject.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import RealmSwift

class Subject: Object, CalculableGradable, NSCopying {

    @objc dynamic var term: Term?
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var grade: Float = 0.0
    @objc dynamic var maxGrade: Float = 0.0
    @objc dynamic var minGrade: Float = 0.0
    // @objc dynamic var percentage: Float = 0.0
    @objc dynamic var dateCreated: Date = Date()
    var greaterGrade: Float = 0.0
    var lowerGrade: Float = 0.0

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let subject = Subject()
        subject.term = self.term?.copy() as? Term
        subject.id = self.id
        subject.name = self.name
        subject.maxGrade = self.maxGrade
        subject.minGrade = self.minGrade
        subject.dateCreated = self.dateCreated
        subject.greaterGrade = self.greaterGrade
        subject.lowerGrade = self.lowerGrade
        return subject
    }

}
