//
//  Subject+CoreDataProperties.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/19/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var name: String
    @NSManaged public var grade: Float
    @NSManaged public var maxGrade: Float
    @NSManaged public var minGrade: Float
    @NSManaged public var dateCreated: Date?
    @NSManaged public var term: Term?
    @NSManaged public var assignments: NSSet?

}

// MARK: Generated accessors for assignments
extension Subject {

    @objc(addAssignmentsObject:)
    @NSManaged public func addToAssignments(_ value: Assignment)

    @objc(removeAssignmentsObject:)
    @NSManaged public func removeFromAssignments(_ value: Assignment)

    @objc(addAssignments:)
    @NSManaged public func addToAssignments(_ values: NSSet)

    @objc(removeAssignments:)
    @NSManaged public func removeFromAssignments(_ values: NSSet)

}
