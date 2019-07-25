//
//  ServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

class ServiceFactory {
    
    static func createService(_ type: ServiceType) -> Service {
        switch type {
        case .realm:
            return RealmService.shared
        }
    }
    
}
