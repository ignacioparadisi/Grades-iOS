//
//  Term.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import RealmSwift

class Term: Object, CalculableGradable, Orderable, NSCopying {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var grade: Float = 0.0
    @objc dynamic var maxGrade: Float = 0.0
    @objc dynamic var minGrade: Float = 0.0
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var position: Int = 0
    @objc dynamic var dateCreated: Date = Date()
    var subjects: [Subject] = []
    var greaterGrade: Float = 0.0
    var lowerGrade: Float = 0.0

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let term = Term()
        term.id = id
        term.name = name
        term.grade = grade
        term.maxGrade = maxGrade
        term.minGrade = minGrade
        term.startDate = startDate
        term.endDate = endDate
        term.position = position
        term.dateCreated = dateCreated
        term.subjects = subjects
        return term
    }

}

