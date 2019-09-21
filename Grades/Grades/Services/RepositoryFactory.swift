//
//  ServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol RepositoryFactory {
    
    /// Term Respository
    var termService: TermRepository { get }
    /// Subject Repository
    var subjectService: SubjectRepository { get }
    /// Assignment Repository
    var assignmentService: AssignmentService { get }
    
}

typealias ServiceResult<T> = (Result<T, DatabaseError>) -> Void

/// Types of services
///
/// - realm: Realm Database service
enum ServiceType {
    case realm
}

extension RepositoryFactory {
    // Gets a service for the specified type
    ///
    /// - Parameter type: Type of service to be created
    /// - Returns: A new instance of the service specified
    static func getServiceFactory(for type: ServiceType) -> RepositoryFactory {
        switch type {
        case .realm:
            return RealmServiceFactory()
        }
    }
}
