//
//  RealmServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmServiceFactory: ServiceFactory {
    
    /// Term Repository
    var termService: TermService = {
        return RealmTermService()
    }()
    
    /// Subject Repository
    var subjectService: SubjectService = {
        return RealmSubjectService()
    }()
    
    /// Assignment Respository
    var assignmentService: AssignmentService = {
        return RealmAssignmentService()
    }()
}
