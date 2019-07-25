//
//  Factory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum ServiceType {
    case realm
}

class Factory {
    
    static func getServiceFactory(for type: ServiceType) -> NewServiceFactory {
        switch type {
        case .realm:
            return RealmServiceFactory()
        }
    }
    
}
