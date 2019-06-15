//
//  Subject.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import RealmSwift

//class Subject: Object {
//
//    @objc dynamic var term: Term?
//    @objc dynamic var id: String = UUID().uuidString
//    @objc dynamic var name: String = ""
//    @objc dynamic var qualification: Float = 0.0
//    @objc dynamic var maxQualification: Float = 0.0
//    @objc dynamic var minQualification: Float = 0.0
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//
//}

struct Subject {
    var name: String
    var qualification: Float
    var maxQualification: Float
    var minQualification: Float
}
