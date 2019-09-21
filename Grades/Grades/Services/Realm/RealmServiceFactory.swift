//
//  RealmServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmServiceFactory: RepositoryFactory {
    
    /// Term Repository
    var termService: TermRepository = {
        return RealmTermService()
    }()
    
    /// Subject Repository
    var subjectService: SubjectRepository = {
        return RealmSubjectService()
    }()
    
    /// Assignment Respository
    var assignmentService: AssignmentService = {
        return RealmAssignmentService()
    }()
}
