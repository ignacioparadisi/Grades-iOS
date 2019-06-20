//
//  Term.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import RealmSwift

class Term: Object, Qualificationable {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var qualification: Float = 0.0
    @objc dynamic var maxQualification: Float = 0.0
    @objc dynamic var minQualification: Float = 0.0
    var subjects: [Subject] = []

    override static func primaryKey() -> String? {
        return "id"
    }

}
