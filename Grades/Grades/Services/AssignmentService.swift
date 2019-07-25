//
//  AssignmentService.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol AssignmentService {
    
    func fetchAssignments(for subject: Subject) -> [Assignment]
    
    func fetchAssignments(for assignment: Assignment) -> [Assignment]
    
    func createAssignment(_ assignment: Assignment)
    
    func updateAssignment(old oldAssignment: Assignment, new newAssignment: Assignment)
    
}
