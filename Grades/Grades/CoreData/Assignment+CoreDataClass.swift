//
//  Assignment+CoreDataClass.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/22/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Assignment)
public class Assignment: Gradable {
    
    static func create(name: String, grade: Float = 0.0, maxGrade: Float, minGrade: Float, percentage: Float = 100, decimals: Int = 0, deadline: Date, subject: Subject) -> Assignment {
        let assignment = Assignment(context: CoreDataManager.shared.context)
        assignment.name = name
        assignment.grade = grade
        assignment.maxGrade = maxGrade
        assignment.minGrade = minGrade
        assignment.decimals = Int16(decimals)
        assignment.percentage = percentage == -1 ? percentage : percentage * 0.01
        assignment.deadline = deadline
        assignment.subject = subject
        assignment.dateCreated = Date()
        subject.calculateGrade()
        return assignment
    }
    
    func update(grade: Float? = nil, decimals: Int? = nil, deadline: Date? = nil) {
        if let grade = grade {
            self.grade = grade
        }
        if let deadline = deadline {
            self.deadline = deadline
        }
        if let decimals = decimals {
            self.decimals = Int16(decimals)
        }
        subject?.calculateGrade()
    }

    func delete() {
        CoreDataManager.shared.context.delete(self)
        subject?.calculateGrade()
    }
    
    static func fetchForCalendar() throws -> [Assignment] {
        let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sort]
        let result = try CoreDataManager.shared.context.fetch(request)
        return result
    }
    
    static func fetchToday() throws -> [Assignment] {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let today = Calendar.current.date(from: components)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return try fetchEventsForHome(startDate: today, endDate: tomorrow)
    }
    
    static func fetchThisWeek() throws -> [Assignment] {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let today = Calendar.current.date(from: components)!
        let thisSunday = getSunday(from: Date())
        let nextSunday = Calendar.current.date(byAdding: .day, value: 7, to: thisSunday)!
        return try fetchEventsForHome(startDate: today, endDate: nextSunday)
    }
    
    static func fetchNextWeek() throws -> [Assignment] {
        let thisSunday = getSunday(from: Date())
        let nextSunday = Calendar.current.date(byAdding: .day, value: 7, to: thisSunday)!
        let secondNextSunday = Calendar.current.date(byAdding: .day, value: 7, to: nextSunday)!
        return try fetchEventsForHome(startDate: nextSunday, endDate: secondNextSunday)
    }
    
    static private func fetchEventsForHome(startDate: Date, endDate: Date) throws -> [Assignment]  {
        let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let sort: NSSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        let todayFilter: NSPredicate = NSPredicate(format: "deadline >= %@", startDate as NSDate)
        let tomorrowFilter: NSPredicate = NSPredicate(format: "deadline < %@", endDate as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [todayFilter, tomorrowFilter])
        request.sortDescriptors = [sort]
        request.predicate = datePredicate
        let result = try CoreDataManager.shared.context.fetch(request)
        return result
    }
    
    static private func getSunday(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        let sunday = calendar.date(from: components)!
        return sunday
    }
    
}
