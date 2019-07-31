//
//  ServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol ServiceFactory {
    
    var termService: TermService { get }
    var subjectService: SubjectService { get }
    var assignmentService: AssignmentService { get }
    
}
