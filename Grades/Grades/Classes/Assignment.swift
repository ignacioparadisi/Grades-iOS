//
//  Assignment.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object, Gradable, Orderable {
    
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
    
}
