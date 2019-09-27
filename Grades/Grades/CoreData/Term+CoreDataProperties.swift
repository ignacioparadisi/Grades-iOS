//
//  Term+CoreDataProperties.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/27/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Term {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Term> {
        return NSFetchRequest<Term>(entityName: "Term")
    }

    @NSManaged public var endDate: Date
    @NSManaged public var startDate: Date
    @NSManaged public var subjects: NSSet?

}

// MARK: Generated accessors for subjects
extension Term {

    @objc(addSubjectsObject:)
    @NSManaged public func addToSubjects(_ value: Subject)

    @objc(removeSubjectsObject:)
    @NSManaged public func removeFromSubjects(_ value: Subject)

    @objc(addSubjects:)
    @NSManaged public func addToSubjects(_ values: NSSet)

    @objc(removeSubjects:)
    @NSManaged public func removeFromSubjects(_ values: NSSet)

}
