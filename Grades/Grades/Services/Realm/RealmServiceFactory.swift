//
//  RealmServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RealmServiceFactory: NewServiceFactory {
    var termService: TermService = {
        return RealmTermService()
    }()
    var subjectService: SubjectService = {
        return RealmSubjectService()
    }()
    var assignmentService: AssignmentService = {
        return RealmAssignmentService()
    }()
}
