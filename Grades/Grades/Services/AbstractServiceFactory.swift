//
//  AbstractServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

typealias ServiceResult<T> = (Result<T, RequestError>) -> Void

/// Types of services
///
/// - realm: Realm Database service
enum ServiceType {
    case realm
}

class AbstractServiceFactory {
    
    /// Gets a service for the specified type
    ///
    /// - Parameter type: Type of service to be created
    /// - Returns: A new instance of the service specified
    static func getServiceFactory(for type: ServiceType) -> ServiceFactory {
        switch type {
        case .realm:
            return RealmServiceFactory()
        }
    }
    
}
