//
//  Term.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import RealmSwift

class Term: Object, Qualificationable, Orderable {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var qualification: Float = 0.0
    @objc dynamic var maxQualification: Float = 0.0
    @objc dynamic var minQualification: Float = 0.0
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var position: Int = 0
    @objc dynamic var dateCreated: Date = Date()
    var subjects: [Subject] = []

    override static func primaryKey() -> String? {
        return "id"
    }

}

