//
//  DateFormatter+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/25/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case dashed = "yyyy-MM-dd"
    case monthAndYear = "MMMM yyyy"
    case dateAndTime = "MMM d, yyyy h:mma"
    case weekday = "EEEE"
}

extension DateFormatter {
    
    func string(from date: Date, format: DateFormat) -> String {
        self.dateFormat = format.rawValue
        return self.string(from: date)
    }
    
}
