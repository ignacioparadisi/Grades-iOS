//
//  Subject.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import RealmSwift

class Subject: Object, Gradable, Orderable {

    @objc dynamic var term: Term?
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var grade: Float = 0.0
    @objc dynamic var maxGrade: Float = 0.0
    @objc dynamic var minGrade: Float = 0.0
    @objc dynamic var position: Int = 0
    @objc dynamic var dateCreated: Date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }

}
