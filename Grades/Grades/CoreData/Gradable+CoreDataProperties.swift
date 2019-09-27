//
//  Gradable+CoreDataProperties.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/27/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Gradable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gradable> {
        return NSFetchRequest<Gradable>(entityName: "Gradable")
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var decimals: Int16
    @NSManaged public var grade: Float
    @NSManaged public var maxGrade: Float
    @NSManaged public var minGrade: Float
    @NSManaged public var name: String
    @NSManaged public var maxObtainedGrade: Float

}
