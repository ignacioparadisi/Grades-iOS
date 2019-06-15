//
//  Term.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import RealmSwift

//class Term: Object {
//
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

class Term {
    
    var name: String
    var qualification: Float
    var maxQualification: Float
    var minQualification: Float
    
    init() {
        name = ""
        qualification = 0.0
        maxQualification = 0.0
        minQualification = 0.0
    }
    
    init(name: String, qualification: Float, maxQualification: Float, minQualification: Float) {
        self.name = name
        self.qualification = qualification
        self.maxQualification = maxQualification
        self.minQualification = minQualification
    }
    
}

