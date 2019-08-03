//
//  AbstractServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

typealias ServiceResult<T> = (Result<T, NetworkError>) -> Void

enum ServiceType {
    case realm
}

class AbstractServiceFactory {
    
    static func getServiceFactory(for type: ServiceType) -> ServiceFactory {
        switch type {
        case .realm:
            return RealmServiceFactory()
        }
    }
    
}
