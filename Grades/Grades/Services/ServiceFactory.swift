//
//  ServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol ServiceFactory {
    
    /// Term Respository
    var termService: TermService { get }
    /// Subject Repository
    var subjectService: SubjectService { get }
    /// Assignment Repository
    var assignmentService: AssignmentService { get }
    
}
